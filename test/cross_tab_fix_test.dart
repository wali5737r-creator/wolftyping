import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/database/app_database.dart';
import 'package:typing_master/core/services/data_refresh_service.dart';
import 'package:typing_master/core/services/db_change_broadcast.dart';
import 'package:typing_master/features/history/controller/history_controller.dart';
import 'package:typing_master/features/history/model/typing_test_record.dart';
import 'package:typing_master/features/home/controller/home_controller.dart';
import 'package:typing_master/features/ppsc/controller/ppsc_typing_controller.dart';
import 'package:typing_master/features/ppsc/model/mock_attempt.dart';
import 'package:typing_master/features/progress/model/progress_models.dart';
import 'package:typing_master/features/progress/service/progress_repository.dart';
import 'package:typing_master/features/typing_test/controller/typing_controller.dart';
import 'package:typing_master/features/typing_test/controller/urdu_typing_controller.dart';
import 'package:typing_master/features/typing_test/model/mistake_record.dart';
import 'package:typing_master/features/typing_test/model/typing_language.dart';
import 'package:typing_master/features/typing_test/model/typing_snapshot.dart';
import 'package:typing_master/features/typing_test/model/typing_test_kind.dart';
import 'package:typing_master/features/typing_test/model/typing_test_status.dart';
import 'package:typing_master/features/typing_test/service/typing_result_repository.dart';

/// Tests for the follow-up fixes to the failed BroadcastChannel
/// cross-tab work (commit ade44e8, live re-check 2026-11-13
/// ~15:01–15:05 PKT: a test completed in tab 1 never appeared in
/// tab 2):
///
/// Fix A — the mistakes batch runs inside an implicit transaction
/// whose writes the web delegate never flushes, so
/// [TypingResultRepository.saveCompletedTest] now calls
/// `flushAfterTransaction()` before broadcasting. The test the suite
/// previously lacked: a SECOND AppDatabase over the same store must
/// read the saved row AND its mistake rows (every existing read-back
/// asserted against the SAME instance).
///
/// Fix B — a revision bump arriving while a load is in flight used to
/// be swallowed (both controllers joined the in-flight load and
/// returned it). The bump is now recorded and runs exactly one extra
/// reload when the load finishes.
///
/// Fix C — the typing duration is now persisted (SharedPreferences,
/// key `wolftyping_typing_duration_seconds`) and restored on the
/// setup page, mirroring the mock-duration pattern.

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

const TypingSnapshot _snapshot = TypingSnapshot(
  status: TypingTestStatus.completed,
  elapsed: Duration(seconds: 60),
  remaining: Duration.zero,
  correctCharacters: 100,
  wrongCharacters: 10,
  totalTypedCharacters: 110,
  correctWords: 20,
  wrongWords: 2,
  skippedWords: 1,
  backspaces: 5,
  correctedMistakes: 3,
  totalErrors: 11,
  grossWpm: 32.5,
  netWpm: 30.0,
  accuracy: 90.0,
  progress: 100.0,
  currentWordIndex: 20,
);

/// Polls [condition] until it holds (async persistence and the
/// coalesced reload are both fire-and-forget). Fails instead of
/// hanging the test when the condition never becomes true. No timers
/// are left running: this is a bounded delay loop, not a periodic.
Future<void> _waitFor(bool Function() condition, {required String what}) async {
  for (int i = 0; i < 100; i++) {
    if (condition()) return;
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
  fail('Timed out waiting for $what');
}

/// ProgressRepository whose first history fetch waits on [firstGate]
/// (a controllable slow load) and whose later fetches return [later].
class _SlowThenFixedProgressRepository implements ProgressRepository {
  _SlowThenFixedProgressRepository(this.firstGate, this.later);

  final Completer<List<TypingTestRecord>> firstGate;
  final List<TypingTestRecord> later;
  int fetchCalls = 0;

  @override
  Future<List<TypingTestRecord>> fetchAllTests() async {
    fetchCalls++;
    if (fetchCalls == 1) return firstGate.future;
    return later;
  }

  @override
  Future<int> fetchDailyGoalSeconds() async => 600;

  @override
  Future<LessonProgressSummary> fetchLessonProgressSummary() async =>
      LessonProgressSummary.empty;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late AppDatabase db;

  setUp(() async {
    Get.testMode = true;
    Get.reset();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    SharedPreferences.setMockInitialValues(<String, Object>{});

    tempDir = await Directory.systemTemp.createTemp('wolftyping-ct-fix');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall call) async {
        if (call.method == 'getApplicationSupportDirectory') {
          return tempDir.path;
        }
        return null;
      },
    );

    DbChangeBroadcast.testNotifyOverride = () {};
    Get.put<DataRefreshService>(DataRefreshService());
    db = AppDatabase();
    Get.put<AppDatabase>(db);
  });

  tearDown(() async {
    DbChangeBroadcast.testNotifyOverride = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      null,
    );
    if (Get.isRegistered<AppDatabase>()) {
      try {
        await Get.find<AppDatabase>().close();
      } catch (_) {
        // Already closed by the test under run.
      }
    }
    Get.reset();
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  group('Fix A — save is readable from a fresh instance', () {
    test('a second AppDatabase reads the row AND its mistake rows',
        () async {
      final bool saved =
          await TypingResultRepository.instance.saveCompletedTest(
        snapshot: _snapshot,
        language: TypingLanguage.english,
        kind: TypingTestKind.normal,
        plannedDuration: const Duration(seconds: 60),
        mistakes: const <MistakeRecord>[
          MistakeRecord(
            expectedCharacter: 'a',
            typedCharacter: 's',
            position: 12,
            wordIndex: 3,
          ),
          MistakeRecord(
            expectedCharacter: 'e',
            typedCharacter: 'r',
            position: 25,
            wordIndex: 5,
          ),
        ],
      );
      expect(saved, isTrue);

      // A fresh instance over the same store — the tab-2 scenario:
      // nothing here shares the first instance's in-memory state.
      final AppDatabase second = AppDatabase();
      try {
        final List<TypingTest> rows =
            await second.select(second.typingTests).get();
        expect(rows.length, 1);
        expect(rows.single.netWpm, 30.0);
        final List<Mistake> mistakeRows =
            await (second.select(second.mistakes)
                  ..where((m) => m.testId.equals(rows.single.id)))
                .get();
        expect(mistakeRows.length, 2);
        expect(
          mistakeRows.map((m) => m.typedCharacter),
          containsAll(<String>['s', 'r']),
        );
      } finally {
        await second.close();
      }
    });
  });

  group('Fix B — revision bump during a load is not lost', () {
    test('HomeController reloads after the in-flight load and shows '
        'the new data (two bumps coalesce into one extra reload)',
        () async {
      final Completer<List<TypingTestRecord>> gate =
          Completer<List<TypingTestRecord>>();
      final _SlowThenFixedProgressRepository repo =
          _SlowThenFixedProgressRepository(gate, <TypingTestRecord>[
        _record(id: 7),
      ]);
      final HomeController controller = HomeController(
        repository: repo,
        loadTimeout: const Duration(seconds: 5),
      );
      Get.put<HomeController>(controller);
      // onInit started the first load; its history fetch is gated.
      await _waitFor(() => repo.fetchCalls == 1, what: 'first fetch');
      expect(controller.allTests, isEmpty);

      // Two bumps while the load is in flight.
      DataRefreshService.notifyChanged();
      DataRefreshService.notifyChanged();
      // Let the ever() worker run so the bumps land mid-load.
      await Future<void>.delayed(const Duration(milliseconds: 50));

      gate.complete(<TypingTestRecord>[]);
      await _waitFor(() => controller.allTests.length == 1,
          what: 'reloaded history with the new row');
      expect(controller.allTests.single.id, 7);
      expect(repo.fetchCalls, 2);
      Get.delete<HomeController>(force: true);
    });

    test('HistoryController reloads after the in-flight load and shows '
        'the new data', () async {
      final Completer<List<TypingTestRecord>> gate =
          Completer<List<TypingTestRecord>>();
      int fetchCalls = 0;
      Future<List<TypingTestRecord>> fetchTyping() async {
        fetchCalls++;
        if (fetchCalls == 1) return gate.future;
        return <TypingTestRecord>[_record(id: 9)];
      }

      final HistoryController controller = HistoryController(
        fetchTyping: fetchTyping,
        fetchMockAttempts: () async => <MockAttempt>[],
        loadTimeout: const Duration(seconds: 5),
      );
      Get.put<HistoryController>(controller);
      await _waitFor(() => fetchCalls == 1, what: 'first fetch');
      expect(controller.allTests, isEmpty);

      DataRefreshService.notifyChanged();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      gate.complete(<TypingTestRecord>[]);
      await _waitFor(() => controller.allTests.length == 1,
          what: 'reloaded history with the new row');
      expect(controller.allTests.single.id, 9);
      expect(fetchCalls, 2);
      Get.delete<HistoryController>(force: true);
    });
  });

  group('Fix C — typing duration persists', () {
    test('English: select 30s → recreate the controller → 30s restored',
        () async {
      final TypingController first = TypingController();
      Get.put<TypingController>(first);
      first.selectDuration(const Duration(seconds: 30));
      final SharedPreferences prefs =
          await SharedPreferences.getInstance();
      await _waitFor(
        () =>
            prefs.getInt(TypingController.typingDurationStorageKey) == 30,
        what: '30s persisted',
      );

      Get.delete<TypingController>(force: true);
      final TypingController second = TypingController();
      Get.put<TypingController>(second);
      await _waitFor(
        () => second.selectedDuration.value == const Duration(seconds: 30),
        what: '30s restored in the recreated controller',
      );
      expect(second.selectedDuration.value, const Duration(seconds: 30));
    });

    test('English: a stored 30s choice is restored on init', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        TypingController.typingDurationStorageKey: 30,
      });
      final TypingController controller = TypingController();
      Get.put<TypingController>(controller);
      await _waitFor(
        () => controller.selectedDuration.value == const Duration(seconds: 30),
        what: 'stored 30s restored',
      );
      expect(controller.selectedDuration.value, const Duration(seconds: 30));
    });

    test('English: no stored choice keeps the 1-minute default', () async {
      final TypingController controller = TypingController();
      Get.put<TypingController>(controller);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(controller.selectedDuration.value, const Duration(minutes: 1));
    });

    test('English: a stored duration that is not a preset is ignored',
        () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        TypingController.typingDurationStorageKey: 45,
      });
      final TypingController controller = TypingController();
      Get.put<TypingController>(controller);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(controller.selectedDuration.value, const Duration(minutes: 1));
    });

    test('Urdu: select 30s → recreate the controller → 30s restored',
        () async {
      final UrduTypingController first = UrduTypingController();
      Get.put<UrduTypingController>(first);
      first.selectDuration(const Duration(seconds: 30));
      final SharedPreferences prefs =
          await SharedPreferences.getInstance();
      await _waitFor(
        () =>
            prefs.getInt(UrduTypingController.typingDurationStorageKey) ==
            30,
        what: '30s persisted',
      );

      Get.delete<UrduTypingController>(force: true);
      final UrduTypingController second = UrduTypingController();
      Get.put<UrduTypingController>(second);
      await _waitFor(
        () => second.selectedDuration.value == const Duration(seconds: 30),
        what: '30s restored in the recreated controller',
      );
      expect(second.selectedDuration.value, const Duration(seconds: 30));
    });

    test('PPSC: select 5 minutes → recreate → 5 minutes restored',
        () async {
      final PpscTypingController first = PpscTypingController();
      Get.put<PpscTypingController>(first);
      first.selectDuration(const Duration(minutes: 5));
      final SharedPreferences prefs =
          await SharedPreferences.getInstance();
      await _waitFor(
        () =>
            prefs.getInt(PpscTypingController.typingDurationStorageKey) ==
            300,
        what: '5 minutes persisted',
      );

      Get.delete<PpscTypingController>(force: true);
      final PpscTypingController second = PpscTypingController();
      Get.put<PpscTypingController>(second);
      await _waitFor(
        () => second.selectedDuration.value == const Duration(minutes: 5),
        what: '5 minutes restored in the recreated controller',
      );
      expect(second.selectedDuration.value, const Duration(minutes: 5));
    });

    test('PPSC: a stored 30s choice is ignored (not a PPSC preset)',
        () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        PpscTypingController.typingDurationStorageKey: 30,
      });
      final PpscTypingController controller = PpscTypingController();
      Get.put<PpscTypingController>(controller);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(controller.selectedDuration.value, const Duration(minutes: 2));
    });
  });
}
