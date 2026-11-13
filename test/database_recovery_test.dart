import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:typing_master/core/database/app_database.dart';
import 'package:typing_master/core/database/database_recovery.dart';
import 'package:typing_master/core/services/data_refresh_service.dart';
import 'package:typing_master/features/history/controller/history_controller.dart';
import 'package:typing_master/features/history/model/typing_test_record.dart';
import 'package:typing_master/features/history/view/history_view.dart';
import 'package:typing_master/features/home/controller/home_controller.dart';
import 'package:typing_master/features/home/view/home_view.dart';
import 'package:typing_master/features/progress/model/progress_models.dart';
import 'package:typing_master/features/progress/service/progress_repository.dart';
import 'package:typing_master/features/typing_test/model/typing_language.dart';
import 'package:typing_master/features/typing_test/model/typing_test_kind.dart';

/// Tests for the Drift DB-open hang fix (P0-5): when the web database open
/// hangs (slow WASM fetch), the stuck AppDatabase must be abandoned and
/// replaced — never awaited on, never deleted — so the next fetch reaches
/// a fresh instance. No real database is involved in the recovery tests:
/// the factory and probe are injected fakes. The LazyDatabase poisoning
/// itself is reproduced with a real LazyDatabase + a minimal
/// GeneratedDatabase (see the last group).

const Duration _shortProbe = Duration(milliseconds: 50);
const List<Duration> _shortDelays = <Duration>[
  Duration(milliseconds: 10),
  Duration(milliseconds: 10),
  Duration(milliseconds: 10),
];

TypingTestRecord _record({required int id}) => TypingTestRecord(
      id: id,
      language: TypingLanguage.english,
      testType: TypingTestKind.normal,
      durationSeconds: 60,
      actualDurationSeconds: 60,
      grossWpm: 30,
      netWpm: 30,
      accuracy: 90,
      correctCharacters: 100,
      wrongCharacters: 10,
      correctWords: 20,
      wrongWords: 2,
      skippedWords: 1,
      backspaces: 5,
      totalErrors: 5,
      completedAt: DateTime(2026, 1, 1),
    );

// --- Fakes ---------------------------------------------------------------

enum _ProbeBehavior { hang, throwError, ok }

/// A probe whose behaviour is scripted per call: hang / throw / succeed.
/// Records every instance it was called on, so tests can assert the
/// abandoned instance is never touched again after replacement.
class _ScriptedProbe {
  _ScriptedProbe(this._script);

  final List<_ProbeBehavior> _script;
  final List<AppDatabase> probed = <AppDatabase>[];

  Future<void> call(AppDatabase db) {
    probed.add(db);
    final _ProbeBehavior behavior = probed.length <= _script.length
        ? _script[probed.length - 1]
        : _ProbeBehavior.ok;
    switch (behavior) {
      case _ProbeBehavior.hang:
        return Completer<void>().future;
      case _ProbeBehavior.throwError:
        return Future<void>.error(StateError('db down'));
      case _ProbeBehavior.ok:
        return Future<void>.value();
    }
  }
}

/// Factory counting every AppDatabase it creates. Creating one is cheap:
/// the LazyDatabase opener is lazy, so no file/WASM is ever touched —
/// the injected probe decides health, never the real database.
class _CountingFactory {
  final List<AppDatabase> created = <AppDatabase>[];

  AppDatabase call() {
    final AppDatabase db = AppDatabase();
    created.add(db);
    return db;
  }
}

DatabaseRecovery _recovery(
  _CountingFactory factory,
  _ScriptedProbe probe,
) =>
    DatabaseRecovery(
      databaseFactory: factory.call,
      probe: probe.call,
      probeTimeout: _shortProbe,
      // Short first-probe budget in tests: the default is 30s, which
      // would make the bounded give-up test take 30s.
      firstProbeTimeout: _shortProbe,
      retryDelays: _shortDelays,
    );

/// Probe that hangs on the first call and answers after [delay] on
/// later calls — a fresh replacement whose WASM open is slow but
/// progressing.
class _HangThenSlowProbe {
  _HangThenSlowProbe(this._delay);

  final Duration _delay;
  int calls = 0;

  Future<void> call(AppDatabase db) {
    calls++;
    if (calls == 1) return Completer<void>().future;
    return Future<void>.delayed(_delay);
  }
}

/// Close hook that records every instance it was asked to terminate.
class _RecordingClose {
  final List<AppDatabase> closed = <AppDatabase>[];

  Future<void> call(AppDatabase db) async {
    closed.add(db);
  }
}
/// A probe that answers after a fixed delay — a slow-but-progressing
/// open (cold WASM fetch), as opposed to a hang.
class _SlowProbe {
  _SlowProbe(this._delay);

  final Duration _delay;
  final List<AppDatabase> probed = <AppDatabase>[];

  Future<void> call(AppDatabase db) async {
    probed.add(db);
    await Future<void>.delayed(_delay);
  }
}

/// Recovery that returns a canned answer without touching any database.
class _CannedRecovery extends DatabaseRecovery {
  _CannedRecovery(this._result);

  final bool _result;
  int calls = 0;

  @override
  Future<bool> ensureHealthy({
    Duration? probeTimeout,
    Duration? firstProbeTimeout,
    List<Duration>? retryDelays,
    bool forceFresh = false,
  }) async {
    calls++;
    return _result;
  }
}

class _NeverProgressRepository implements ProgressRepository {
  @override
  Future<List<TypingTestRecord>> fetchAllTests() =>
      Completer<List<TypingTestRecord>>().future;

  @override
  Future<int> fetchDailyGoalSeconds() => Completer<int>().future;

  @override
  Future<LessonProgressSummary> fetchLessonProgressSummary() =>
      Completer<LessonProgressSummary>().future;
}

/// Hangs while [broken] is true, answers once it is cleared — so a test
/// can fail the first load, then flip the flag and succeed on retryLoad.
/// A hanging fetch waits on [_pending], which [unbreak] completes: a
/// fetch already in flight unblocks too, like a query on a recovered
/// database would.
class _FlakyProgressRepository implements ProgressRepository {
  bool broken = true;
  int fetchCalls = 0;
  Completer<List<TypingTestRecord>>? _pending;

  @override
  Future<List<TypingTestRecord>> fetchAllTests() {
    fetchCalls++;
    if (!broken) {
      return Future<List<TypingTestRecord>>.value(<TypingTestRecord>[
        _record(id: 1),
      ]);
    }
    _pending ??= Completer<List<TypingTestRecord>>();
    return _pending!.future;
  }

  /// Clears the hang and completes any fetch already waiting on it.
  void unbreak() {
    broken = false;
    _pending?.complete(<TypingTestRecord>[_record(id: 1)]);
    _pending = null;
  }

  @override
  Future<int> fetchDailyGoalSeconds() async => 900;

  @override
  Future<LessonProgressSummary> fetchLessonProgressSummary() async =>
      LessonProgressSummary.empty;
}

/// Recovery that succeeds after a short delay and notifies, mimicking
/// the real DatabaseRecovery._notifyRecovered() path (replace + notify
/// -> DataRefreshService -> the controller's ever() worker reloads).
class _NotifyingRecovery extends DatabaseRecovery {
  int calls = 0;

  @override
  Future<bool> ensureHealthy({
    Duration? probeTimeout,
    Duration? firstProbeTimeout,
    List<Duration>? retryDelays,
    bool forceFresh = false,
  }) async {
    calls++;
    await Future<void>.delayed(const Duration(milliseconds: 10));
    DataRefreshService.notifyChanged();
    return true;
  }
}

/// Hangs on the FIRST fetchAllTests call only, then answers — what a
/// recovered database looks like to the next fetch.
class _FirstHangThenOkRepository implements ProgressRepository {
  int fetchCalls = 0;

  @override
  Future<List<TypingTestRecord>> fetchAllTests() {
    fetchCalls++;
    if (fetchCalls == 1) {
      return Completer<List<TypingTestRecord>>().future;
    }
    return Future<List<TypingTestRecord>>.value(<TypingTestRecord>[
      _record(id: 1),
    ]);
  }

  @override
  Future<int> fetchDailyGoalSeconds() async => 900;

  @override
  Future<LessonProgressSummary> fetchLessonProgressSummary() async =>
      LessonProgressSummary.empty;
}

/// History fetch that hangs while [broken] is true and answers once it
/// is cleared.
class _FlakyHistoryFetch {
  bool broken = true;
  int calls = 0;

  Future<List<TypingTestRecord>> call() {
    calls++;
    if (!broken) {
      return Future<List<TypingTestRecord>>.value(<TypingTestRecord>[
        _record(id: 1),
      ]);
    }
    return Completer<List<TypingTestRecord>>().future;
  }

  void unbreak() {
    broken = false;
  }
}

/// Minimal GeneratedDatabase over an injected executor, used only to
/// reproduce the LazyDatabase poisoning with a real LazyDatabase.
class _ProbeDb extends GeneratedDatabase {
  _ProbeDb(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  Iterable<TableInfo> get allTables => const <TableInfo>[];
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  });
  tearDown(() {
    Get.reset();
  });

  group('DatabaseRecovery', () {
    test('probe succeeds: no replacement, returns true', () async {
      final _CountingFactory factory = _CountingFactory();
      final AppDatabase original = AppDatabase();
      Get.put<AppDatabase>(original);
      final _ScriptedProbe probe = _ScriptedProbe(<_ProbeBehavior>[
        _ProbeBehavior.ok,
      ]);

      final bool healthy = await _recovery(factory, probe).ensureHealthy();

      expect(healthy, isTrue);
      expect(identical(Get.find<AppDatabase>(), original), isTrue);
      expect(factory.created, isEmpty);
      expect(probe.probed, <AppDatabase>[original]);
    });

    test('probe hangs: stuck instance replaced, new instance healthy',
        () async {
      final _CountingFactory factory = _CountingFactory();
      final AppDatabase stuck = AppDatabase();
      Get.put<AppDatabase>(stuck);
      final _ScriptedProbe probe = _ScriptedProbe(<_ProbeBehavior>[
        _ProbeBehavior.hang,
        _ProbeBehavior.ok,
      ]);

      final bool healthy = await _recovery(factory, probe).ensureHealthy();

      expect(healthy, isTrue);
      expect(factory.created.length, 1);
      final AppDatabase fresh = factory.created.single;
      // The Get registration now points at the fresh instance, and a
      // repository-style lazy getter reaches it too.
      expect(identical(Get.find<AppDatabase>(), fresh), isTrue);
      final AppDatabase viaLazyGetter = Get.find<AppDatabase>();
      expect(identical(viaLazyGetter, fresh), isTrue);
      // The abandoned instance was probed exactly once and never again:
      // no query, delete, or drop ever touched it after abandonment.
      expect(probe.probed, <AppDatabase>[stuck, fresh]);
      expect(probe.probed.where((AppDatabase d) => identical(d, stuck)),
          hasLength(1));
    });

    test('probe throws: replacement + retry, returns true', () async {
      final _CountingFactory factory = _CountingFactory();
      final AppDatabase broken = AppDatabase();
      Get.put<AppDatabase>(broken);
      final _ScriptedProbe probe = _ScriptedProbe(<_ProbeBehavior>[
        _ProbeBehavior.throwError,
        _ProbeBehavior.ok,
      ]);

      final bool healthy = await _recovery(factory, probe).ensureHealthy();

      expect(healthy, isTrue);
      expect(factory.created.length, 1);
      expect(identical(Get.find<AppDatabase>(), factory.created.single),
          isTrue);
    });

    test('slow-but-completing opener: long first probe succeeds, no replacement',
        () async {
      // The case the old code failed: the open answers after 120ms —
      // past the 50ms short budget, inside the 200ms first-probe budget.
      // It must succeed on attempt 1 WITHOUT restarting the open.
      final _CountingFactory factory = _CountingFactory();
      final AppDatabase original = AppDatabase();
      Get.put<AppDatabase>(original);
      final _SlowProbe probe =
          _SlowProbe(const Duration(milliseconds: 120));
      final DatabaseRecovery recovery = DatabaseRecovery(
        databaseFactory: factory.call,
        probe: probe.call,
        probeTimeout: _shortProbe,
        firstProbeTimeout: const Duration(milliseconds: 200),
        retryDelays: _shortDelays,
      );

      final bool healthy = await recovery.ensureHealthy();

      expect(healthy, isTrue);
      expect(factory.created, isEmpty);
      expect(identical(Get.find<AppDatabase>(), original), isTrue);
      expect(probe.probed, <AppDatabase>[original]);
    });

    test('racing recoveries share one in-flight: exactly one probe sequence',
        () async {
      // Two DIFFERENT instances (boot path + Dashboard path) calling
      // ensureHealthy() concurrently must join one recovery, not run
      // two probe sequences / replacements.
      final _CountingFactory factory1 = _CountingFactory();
      final _CountingFactory factory2 = _CountingFactory();
      final AppDatabase original = AppDatabase();
      Get.put<AppDatabase>(original);
      final _ScriptedProbe probe1 = _ScriptedProbe(<_ProbeBehavior>[
        _ProbeBehavior.hang,
        _ProbeBehavior.ok,
      ]);
      final _ScriptedProbe probe2 = _ScriptedProbe(<_ProbeBehavior>[
        _ProbeBehavior.ok,
      ]);
      final DatabaseRecovery recovery1 = _recovery(factory1, probe1);
      final DatabaseRecovery recovery2 = _recovery(factory2, probe2);

      final List<bool> results = await Future.wait<bool>(<Future<bool>>[
        recovery1.ensureHealthy(),
        recovery2.ensureHealthy(),
      ]);

      expect(results, <bool>[true, true]);
      // Exactly one probe sequence ran (the first caller's): one hang,
      // one replacement, one success — the second instance never
      // probed and never created a database.
      expect(probe1.probed.length, 2);
      expect(factory1.created.length, 1);
      expect(probe2.probed, isEmpty);
      expect(factory2.created, isEmpty);
      expect(identical(Get.find<AppDatabase>(), factory1.created.single),
          isTrue);
    });

    test('new instance also hangs: gives up bounded, returns false',
        timeout: const Timeout(Duration(seconds: 5)), () async {
      final _CountingFactory factory = _CountingFactory();
      Get.put<AppDatabase>(AppDatabase());
      final _ScriptedProbe probe = _ScriptedProbe(<_ProbeBehavior>[
        _ProbeBehavior.hang,
        _ProbeBehavior.hang,
        _ProbeBehavior.hang,
      ]);

      final bool healthy = await _recovery(factory, probe).ensureHealthy();

      expect(healthy, isFalse);
      // Exactly 3 probe attempts total (initial + 2 replacements),
      // then it stops — no infinite loop.
      expect(probe.probed.length, DatabaseRecovery.maxAttempts);
      expect(factory.created.length, DatabaseRecovery.maxAttempts - 1);
    });

    test('replacement probe gets the long budget, not the short one',
        () async {
      // The old rule gave replacements only the short (8s) budget, so
      // a fresh WASM open that legitimately needs ~30s could never
      // succeed: attempt 2 answers after 120ms — past the 50ms short
      // budget, inside the 200ms long one — and must now succeed.
      final _CountingFactory factory = _CountingFactory();
      Get.put<AppDatabase>(AppDatabase());
      final _HangThenSlowProbe probe =
          _HangThenSlowProbe(const Duration(milliseconds: 120));
      final DatabaseRecovery recovery = DatabaseRecovery(
        databaseFactory: factory.call,
        probe: probe.call,
        probeTimeout: _shortProbe,
        firstProbeTimeout: const Duration(milliseconds: 200),
        retryDelays: _shortDelays,
      );

      final bool healthy = await recovery.ensureHealthy();

      expect(healthy, isTrue);
      expect(probe.calls, 2);
      expect(factory.created.length, 1);
      expect(identical(Get.find<AppDatabase>(), factory.created.single),
          isTrue);
    });

    test('abandoned instance is closed, not just dropped', () async {
      final _CountingFactory factory = _CountingFactory();
      final AppDatabase stuck = AppDatabase();
      Get.put<AppDatabase>(stuck);
      final _ScriptedProbe probe = _ScriptedProbe(<_ProbeBehavior>[
        _ProbeBehavior.hang,
        _ProbeBehavior.ok,
      ]);
      final _RecordingClose close = _RecordingClose();
      final DatabaseRecovery recovery = DatabaseRecovery(
        databaseFactory: factory.call,
        probe: probe.call,
        closeInstance: close.call,
        probeTimeout: _shortProbe,
        firstProbeTimeout: _shortProbe,
        retryDelays: _shortDelays,
      );

      final bool healthy = await recovery.ensureHealthy();
      // The close is kicked off unawaited: give the event loop a turn.
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(healthy, isTrue);
      expect(close.closed, <AppDatabase>[stuck]);
      expect(factory.created.length, 1);
    });

    test('probe succeeds without replacement: listeners still notified',
        () async {
      // A slow open that finally answers must still reload the
      // controllers waiting on it — previously _notifyRecovered ran
      // only `if (replaced)`, so a success without replacement never
      // triggered a reload and the timeout banner stayed up.
      Get.put<DataRefreshService>(DataRefreshService());
      final DataRefreshService service = Get.find<DataRefreshService>();
      final int before = service.revision.value;
      final _CountingFactory factory = _CountingFactory();
      final AppDatabase original = AppDatabase();
      Get.put<AppDatabase>(original);
      final _ScriptedProbe probe = _ScriptedProbe(<_ProbeBehavior>[
        _ProbeBehavior.ok,
      ]);

      final bool healthy = await _recovery(factory, probe).ensureHealthy();

      expect(healthy, isTrue);
      expect(factory.created, isEmpty);
      expect(identical(Get.find<AppDatabase>(), original), isTrue);
      expect(service.revision.value, greaterThan(before));
    });

    test('forceFresh starts a fresh probe sequence instead of joining '
        'in-flight', () async {
      // Retry path: the first run is already doomed (its first probe
      // hangs), so joining it would just wait for its failure. A
      // forced-fresh call must run its own probe sequence and return
      // its own future.
      final _CountingFactory factory = _CountingFactory();
      Get.put<AppDatabase>(AppDatabase());
      final _ScriptedProbe probe = _ScriptedProbe(<_ProbeBehavior>[
        _ProbeBehavior.hang,
        _ProbeBehavior.hang,
        _ProbeBehavior.ok,
        _ProbeBehavior.ok,
      ]);
      final DatabaseRecovery recovery = _recovery(factory, probe);

      final Future<bool> first = recovery.ensureHealthy();
      final Future<bool> fresh =
          recovery.ensureHealthy(forceFresh: true);
      expect(identical(first, fresh), isFalse);

      final List<bool> results = await Future.wait<bool>(<Future<bool>>[
        first,
        fresh,
      ]);
      expect(results, <bool>[true, true]);
      // Two independent sequences ran: two hangs, two successes.
      expect(probe.probed.length, 4);
      expect(factory.created.length, 2);
    });

    test('recovery never issues a delete/drop/reset (by construction)',
        () async {
      final String source = await File(
        'lib/core/database/database_recovery.dart',
      ).readAsString();
      // The only "delete" allowed is Get.delete<AppDatabase> (dropping the
      // Get registration of the abandoned instance, not data).
      expect(source, isNot(contains('.delete(')));
      expect(source, isNot(contains('dropTable')));
      expect(source, isNot(contains('DROP ')));
      expect(source, isNot(contains('reset(')));
      expect(source, isNot(contains('clear(')));
    });
  });

  group('HomeController with recovery', () {
    test('hang then recover: load finishes promptly, retry succeeds',
        () async {
      final _FlakyProgressRepository repository = _FlakyProgressRepository();
      final _CannedRecovery recovery = _CannedRecovery(true);
      final HomeController controller = HomeController(
        repository: repository,
        loadTimeout: const Duration(milliseconds: 50),
        databaseRecovery: recovery,
      );

      // First fetch hangs; load() gives up after 50ms and finishes
      // promptly with the empty state — recovery runs in the BACKGROUND
      // (no in-load retry any more). The canned recovery reports
      // success, so loadFailed stays false; the canned fake does not
      // notify, so no auto-reload happens here (the real recovery
      // notifies via DataRefreshService — covered by the next test).
      await controller.load();
      expect(controller.loadTimedOut.value, isTrue);
      expect(controller.loadFailed.value, isFalse);
      expect(controller.isLoading.value, isFalse);
      expect(recovery.calls, 1);

      // ...then the repository recovers and retryLoad() succeeds.
      repository.unbreak();
      await controller.retryLoad();
      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isFalse);
      expect(controller.loadFailed.value, isFalse);
      expect(controller.allTests.length, 1);
      expect(controller.dailyGoalSeconds.value, 900);
    });

    test('background recovery reloads the dashboard without a manual retry',
        () async {
      // Repository hangs on the FIRST fetch only, then answers: this is
      // what a recovered database looks like to the next fetch.
      final _FirstHangThenOkRepository repository =
          _FirstHangThenOkRepository();
      final _NotifyingRecovery recovery = _NotifyingRecovery();
      Get.put<DataRefreshService>(DataRefreshService());
      final HomeController controller = Get.put<HomeController>(
        HomeController(
          repository: repository,
          loadTimeout: const Duration(milliseconds: 50),
          databaseRecovery: recovery,
        ),
      );

      // onInit kicked off load(): the first fetch times out at ~50ms,
      // the load finishes with the empty state, the background recovery
      // notifies, and the ever() worker reloads — the second fetch
      // answers, with no retryLoad() call anywhere.
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isFalse);
      expect(controller.loadFailed.value, isFalse);
      expect(controller.allTests.length, 1);
      expect(controller.dailyGoalSeconds.value, 900);
      expect(recovery.calls, 1);
    });

    test('never-answering repository: load finishes promptly, no 41.5s wait',
        () async {
      final Stopwatch stopwatch = Stopwatch()..start();
      final HomeController controller = HomeController(
        repository: _NeverProgressRepository(),
        loadTimeout: const Duration(milliseconds: 50),
        databaseRecovery: _CannedRecovery(false),
      );

      await controller.load();
      stopwatch.stop();

      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isTrue);
      expect(controller.allTests, isEmpty);
      // Two 50ms fetch timeouts and nothing else: the old in-load
      // recovery + retry cost up to ~41.5s of spinner. The load must
      // finish in ~100ms.
      expect(stopwatch.elapsed, lessThan(const Duration(seconds: 5)));
    });

    test('permanent failure: loadTimedOut + loadFailed, not spinning',
        () async {
      final HomeController controller = HomeController(
        repository: _NeverProgressRepository(),
        loadTimeout: const Duration(milliseconds: 50),
        databaseRecovery: _CannedRecovery(false),
      );

      await controller.load();

      // The background recovery is fire-and-forget: give it a turn to
      // report before asserting loadFailed (the two fetches now run
      // concurrently, so load() no longer outlasts it by a fetch).
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isTrue);
      expect(controller.loadFailed.value, isTrue);
      expect(controller.allTests, isEmpty);
    });
  });

  group('HistoryController with recovery', () {
    test('never-answering fetch: load finishes promptly, not spinning',
        () async {
      final Stopwatch stopwatch = Stopwatch()..start();
      final HistoryController controller = HistoryController(
        fetchAll: () => Completer<List<TypingTestRecord>>().future,
        loadTimeout: const Duration(milliseconds: 50),
        databaseRecovery: _CannedRecovery(false),
      );

      await controller.load();
      stopwatch.stop();

      // The old load awaited fetchAll() with NO timeout at all — it
      // spun forever on a stuck database. Now it returns in ~50ms.
      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isTrue);
      expect(controller.allTests, isEmpty);
      expect(stopwatch.elapsed, lessThan(const Duration(seconds: 5)));
    });

    test('retryLoad succeeds once the fetch answers', () async {
      final _FlakyHistoryFetch fetch = _FlakyHistoryFetch();
      final HistoryController controller = HistoryController(
        fetchAll: fetch.call,
        loadTimeout: const Duration(milliseconds: 50),
        databaseRecovery: _CannedRecovery(false),
      );

      await controller.load();
      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isTrue);
      expect(controller.allTests, isEmpty);

      fetch.unbreak();
      await controller.retryLoad();
      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isFalse);
      expect(controller.loadFailed.value, isFalse);
      expect(controller.allTests.length, 1);
    });
  });

  group('LazyDatabase poisoning, reproduced', () {
    test('a hung opener poisons every later query; a fresh handle works',
        timeout: const Timeout(Duration(seconds: 5)), () async {
      // A LazyDatabase whose opener never completes — the web case when
      // sqlite3.wasm / drift_worker.js never finish downloading.
      final LazyDatabase stuck = LazyDatabase(
        () => Completer<QueryExecutor>().future,
      );
      final _ProbeDb stuckDb = _ProbeDb(stuck);

      // The first query hangs behind the cached opener future...
      await expectLater(
        stuckDb.customSelect('SELECT 1').get().timeout(
              const Duration(milliseconds: 50),
            ),
        throwsA(isA<TimeoutException>()),
      );
      // ...and so does the next one: LazyDatabase caches the opener
      // future (_awaitOpened), there is no retry.
      await expectLater(
        stuckDb.customSelect('SELECT 1').get().timeout(
              const Duration(milliseconds: 50),
            ),
        throwsA(isA<TimeoutException>()),
      );

      // Recovery's move — abandon the handle, open a fresh one — unblocks.
      final _ProbeDb freshDb = _ProbeDb(NativeDatabase.memory());
      final List<QueryRow> rows = await freshDb
          .customSelect('SELECT 1 AS one')
          .get()
          .timeout(const Duration(seconds: 1));
      expect(rows.single.read<int>('one'), 1);
      await freshDb.close();
      // NOTE: stuckDb.close() is deliberately never called here: drift
      // 2.35.0 LazyDatabase.close() awaits the stuck opener future, so
      // closing the hung instance would hang too. That is exactly why
      // DatabaseRecovery abandons without closing.
    });
  });

  testWidgets('HomeView timeout state offers Retry and the fixed copy',
      (WidgetTester tester) async {
    final _CannedRecovery recovery = _CannedRecovery(false);
    Get.put<HomeController>(
      HomeController(
        repository: _NeverProgressRepository(),
        loadTimeout: const Duration(milliseconds: 50),
        databaseRecovery: recovery,
      ),
    );
    await tester.pumpWidget(
      const GetMaterialApp(home: HomeView()),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    // Recovery failed: the failed state, not the "No completed tests
    // yet" headline — the database may well have tests, it just
    // could not be read.
    expect(find.text('No completed tests yet'), findsNothing);
    expect(find.text("History couldn't be loaded"), findsOneWidget);
    expect(find.text('Retry loading history'), findsOneWidget);
    expect(
      find.text('Your data is safe — tap Retry to try again.'),
      findsOneWidget,
    );
    expect(find.textContaining('try reopening this page'), findsNothing);
  });

  testWidgets('HistoryView timeout state offers Retry; tapping it reloads',
      (WidgetTester tester) async {
    final _FlakyHistoryFetch fetch = _FlakyHistoryFetch();
    final HistoryController controller = Get.put<HistoryController>(
      HistoryController(
        fetchAll: fetch.call,
        loadTimeout: const Duration(milliseconds: 50),
        databaseRecovery: _CannedRecovery(false),
      ),
    );
    await tester.pumpWidget(
      const GetMaterialApp(home: HistoryView()),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    // Recovery failed: the failed state, not the "No completed tests
    // yet" headline.
    expect(find.text('No completed tests yet'), findsNothing);
    expect(find.text("History couldn't be loaded"), findsOneWidget);
    expect(find.text('Retry loading history'), findsOneWidget);
    expect(
      find.text('Your data is safe — tap Retry to try again.'),
      findsOneWidget,
    );

    fetch.unbreak();
    await tester.ensureVisible(find.text('Retry loading history'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Retry loading history'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(controller.allTests.length, 1);
    expect(find.text('Retry loading history'), findsNothing);
  });
}
