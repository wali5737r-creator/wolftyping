import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:typing_master/core/database/app_database.dart';
import 'package:typing_master/core/database/database_recovery.dart';
import 'package:typing_master/features/history/model/typing_test_record.dart';
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
      retryDelays: _shortDelays,
    );

/// Recovery that returns a canned answer without touching any database.
class _CannedRecovery extends DatabaseRecovery {
  _CannedRecovery(this._result);

  final bool _result;
  int calls = 0;

  @override
  Future<bool> ensureHealthy({
    Duration? probeTimeout,
    List<Duration>? retryDelays,
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
    test('hang then recover: dashboard shows the tests', () async {
      final _FlakyProgressRepository repository = _FlakyProgressRepository();
      final _CannedRecovery recovery = _CannedRecovery(true);
      final HomeController controller = HomeController(
        repository: repository,
        loadTimeout: const Duration(milliseconds: 50),
        databaseRecovery: recovery,
      );

      // First fetch hangs; recovery reports healthy; the retry still
      // hangs (repository still broken) — so this load fails...
      await controller.load();
      expect(controller.loadTimedOut.value, isTrue);
      expect(controller.loadFailed.value, isTrue);
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

    test('hang then recover on the retry itself: tests appear', () async {
      // Repository hangs exactly once, then answers: the load's own
      // recovery + retry must be enough, with no manual retryLoad().
      final _FlakyProgressRepository repository = _FlakyProgressRepository()
        ..broken = true;
      final _CannedRecovery recovery = _CannedRecovery(true);
      final HomeController controller = HomeController(
        repository: repository,
        loadTimeout: const Duration(milliseconds: 50),
        databaseRecovery: recovery,
      );

      // Flip the flag mid-load: after the first (hanging) fetch times
      // out and recovery runs, the retry fetch is still waiting on the
      // same pending future, which unbreak() completes in time.
      unawaited(
        Future<void>.delayed(const Duration(milliseconds: 70), () {
          repository.unbreak();
        }),
      );
      await controller.load();

      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isFalse);
      expect(controller.loadFailed.value, isFalse);
      expect(controller.allTests.length, 1);
      expect(recovery.calls, 1);
    });

    test('permanent failure: loadTimedOut + loadFailed, not spinning',
        () async {
      final HomeController controller = HomeController(
        repository: _NeverProgressRepository(),
        loadTimeout: const Duration(milliseconds: 50),
        databaseRecovery: _CannedRecovery(false),
      );

      await controller.load();

      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isTrue);
      expect(controller.loadFailed.value, isTrue);
      expect(controller.allTests, isEmpty);
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
    expect(find.text('No completed tests yet'), findsOneWidget);
    expect(find.text('Retry loading history'), findsOneWidget);
    expect(
      find.text(
        'History could not be loaded. Your data is safe — '
        'tap Retry to try again.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('try reopening this page'), findsNothing);
  });
}
