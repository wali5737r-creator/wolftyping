import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/database/app_database.dart';
import 'package:typing_master/core/database/database_recovery.dart';
import 'package:typing_master/core/services/data_refresh_service.dart';
import 'package:typing_master/core/services/db_change_broadcast.dart';
import 'package:typing_master/features/history/model/typing_test_record.dart';
import 'package:typing_master/features/history/service/history_backup.dart';
import 'package:typing_master/features/history/service/history_backup_repository.dart';
import 'package:typing_master/features/history/service/history_repository.dart';
import 'package:typing_master/features/home/controller/home_controller.dart';
import 'package:typing_master/features/home/view/home_view.dart';
import 'package:typing_master/features/progress/model/progress_models.dart';
import 'package:typing_master/features/progress/service/progress_repository.dart';
import 'package:typing_master/features/settings/model/app_settings.dart';
import 'package:typing_master/features/settings/service/settings_repository.dart';
import 'package:typing_master/features/typing_test/model/mistake_record.dart';
import 'package:typing_master/features/typing_test/model/typing_language.dart';
import 'package:typing_master/features/typing_test/model/typing_snapshot.dart';
import 'package:typing_master/features/typing_test/model/typing_test_kind.dart';
import 'package:typing_master/features/typing_test/model/typing_test_status.dart';
import 'package:typing_master/features/typing_test/service/typing_result_repository.dart';

/// Tests for Fix 1 (cross-tab history invisibility) and its companion
/// fixes: the BroadcastChannel broadcast, the cross-tab listener's
/// database replacement, and the transaction-flush hole.
///
/// The repository tests run against a REAL AppDatabase on the VM: the
/// path_provider channel is mocked to a temp dir, so the lazy
/// connection opens a real SQLite file there (no WASM/IndexedDB on
/// the VM — the broadcast itself is observed through
/// [DbChangeBroadcast.testNotifyOverride], since BroadcastChannel is
/// web-only). The web flush behaviour is guaranteed by construction
/// and asserted structurally below: every writer either writes
/// outside any transaction (each write flushes, per drift 2.35.0's
/// `_WasmDelegate`) or calls `flushAfterTransaction()` before
/// broadcasting.

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

const AppSettings _settings = AppSettings(
  themeMode: ThemeMode.system,
  showLiveWpm: true,
  showLiveAccuracy: true,
  showErrors: true,
  autoScroll: true,
  countBackspaces: true,
  strictSkipDetection: true,
  defaultDurationSeconds: 120,
  defaultLanguage: 'en',
  defaultTestType: 'normal',
  autoFocus: true,
  showTimer: true,
  allowBackspace: true,
  urduRtl: true,
  practiceDifficulty: 'beginner',
  dailyGoalSeconds: 1200,
);

HistoryBackup _backup() {
  return HistoryBackup(
    app: HistoryBackup.expectedApp,
    formatVersion: HistoryBackup.currentFormatVersion,
    exportedAt: DateTime(2026, 11, 13, 11, 0),
    dailyGoalSeconds: 600,
    tests: <BackupTest>[
      BackupTest(
        language: 'en',
        testType: 'test',
        paragraphId: null,
        durationSeconds: 60,
        actualDurationSeconds: 60,
        grossWpm: 45.0,
        netWpm: 42.5,
        accuracy: 91.0,
        keystrokeAccuracy: 89.5,
        correctCharacters: 200,
        wrongCharacters: 18,
        correctWords: 40,
        wrongWords: 4,
        skippedWords: 1,
        backspaces: 7,
        correctedMistakes: 5,
        uncorrectedMistakes: 2,
        totalErrors: 19,
        completedAt: DateTime(2026, 11, 13, 10, 30),
        mistakes: const <BackupMistake>[
          BackupMistake(
            expectedCharacter: 'a',
            typedCharacter: 's',
            count: 2,
            position: 12,
            wordIndex: 3,
            isSkippedWord: false,
            isWrongWord: false,
          ),
        ],
      ),
    ],
    lessons: const <BackupLesson>[],
  );
}

/// Factory counting every AppDatabase it creates. Creating one is
/// cheap: the LazyDatabase opener is lazy, so no file is ever touched.
class _CountingFactory {
  final List<AppDatabase> created = <AppDatabase>[];

  AppDatabase call() {
    final AppDatabase db = AppDatabase();
    created.add(db);
    return db;
  }
}

/// Close hook that records every instance it was asked to terminate.
class _RecordingClose {
  final List<AppDatabase> closed = <AppDatabase>[];

  Future<void> call(AppDatabase db) async {
    closed.add(db);
  }
}

/// ProgressRepository returning a fixed test list, for the Dashboard
/// stat-cards test.
class _FixedProgressRepository implements ProgressRepository {
  _FixedProgressRepository(this.tests);

  final List<TypingTestRecord> tests;

  @override
  Future<List<TypingTestRecord>> fetchAllTests() async => tests;

  @override
  Future<int> fetchDailyGoalSeconds() async => 900;

  @override
  Future<LessonProgressSummary> fetchLessonProgressSummary() async =>
      LessonProgressSummary.empty;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late AppDatabase db;
  late int broadcastCount;

  setUp(() async {
    Get.testMode = true;
    Get.reset();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    SharedPreferences.setMockInitialValues(<String, Object>{});

    tempDir = await Directory.systemTemp.createTemp('wolftyping-bc-test');
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

    broadcastCount = 0;
    DbChangeBroadcast.testNotifyOverride = () => broadcastCount++;
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
        // Already replaced/closed by the test under run.
      }
    }
    Get.reset();
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  Future<void> seedOneTest() async {
    final bool saved = await TypingResultRepository.instance
        .saveCompletedTest(
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
      ],
    );
    expect(saved, isTrue);
    broadcastCount = 0;
  }

  group('DbChangeBroadcast', () {
    test('notify() posts on the channel (observed via the test seam)',
        () {
      expect(DbChangeBroadcast.channelName, 'wolftyping-db-changed');
      DbChangeBroadcast.notify();
      expect(broadcastCount, 1);
      DbChangeBroadcast.notify();
      expect(broadcastCount, 2);
    });

    test('notify() with no override is a safe no-op off the web', () {
      DbChangeBroadcast.testNotifyOverride = null;
      expect(() => DbChangeBroadcast.notify(), returnsNormally);
      expect(() => DbChangeBroadcast.listen(() {}), returnsNormally);
    });
  });

  group('broadcast on every Drift writer', () {
    test('saveCompletedTest saves the row AND posts the broadcast',
        () async {
      final bool saved = await TypingResultRepository.instance
          .saveCompletedTest(
        snapshot: _snapshot,
        language: TypingLanguage.english,
        kind: TypingTestKind.normal,
        plannedDuration: const Duration(seconds: 60),
      );
      expect(saved, isTrue);
      expect(broadcastCount, 1);
      final List<TypingTestRecord> rows =
          await HistoryRepository.instance.fetchAll();
      expect(rows.length, 1);
      expect(rows.single.netWpm, 30.0);
    });

    test('deleteTest removes the test and its mistakes AND broadcasts',
        () async {
      await seedOneTest();
      final List<TypingTestRecord> before =
          await HistoryRepository.instance.fetchAll();
      expect(before.length, 1);
      final int testId = before.single.id;
      expect(
        await HistoryRepository.instance.fetchMistakeLines(testId),
        isNotEmpty,
      );

      await HistoryRepository.instance.deleteTest(testId);
      expect(broadcastCount, 1);
      expect(await HistoryRepository.instance.fetchAll(), isEmpty);
      expect(
        await HistoryRepository.instance.fetchMistakeLines(testId),
        isEmpty,
      );
    });

    test('backup restore imports AND broadcasts (after the flush)',
        () async {
      final HistoryImportResult result =
          await HistoryBackupRepository.instance.restore(_backup());
      expect(result.importedTests, 1);
      expect(result.importedMistakes, 1);
      expect(broadcastCount, 1);
      expect(
        (await HistoryRepository.instance.fetchAll()).length,
        1,
      );
    });

    test('clearHistory empties history AND broadcasts', () async {
      await seedOneTest();
      expect(
        (await HistoryRepository.instance.fetchAll()).length,
        1,
      );
      await SettingsRepository.instance.clearHistory();
      expect(broadcastCount, 1);
      expect(await HistoryRepository.instance.fetchAll(), isEmpty);
    });

    test('settings save (the reset path) broadcasts', () async {
      await SettingsRepository.instance.save(_settings);
      expect(broadcastCount, 1);
    });
  });

  group('flushAfterTransaction', () {
    test('is a no-op write that succeeds and changes no rows', () async {
      await seedOneTest();
      await db.flushAfterTransaction();
      expect(
        (await HistoryRepository.instance.fetchAll()).length,
        1,
      );
      final List<TypingTestRecord> rows =
          await HistoryRepository.instance.fetchAll();
      expect(rows.single.netWpm, 30.0);
    });
  });

  group('DatabaseRecovery.handleExternalChange', () {
    test('replaces the registered DB, closes the old one, notifies',
        () async {
      final _CountingFactory factory = _CountingFactory();
      final _RecordingClose close = _RecordingClose();
      final AppDatabase original = factory.call();
      Get.delete<AppDatabase>(force: true);
      Get.put<AppDatabase>(original);
      final int before =
          Get.find<DataRefreshService>().revision.value;

      DatabaseRecovery(
        databaseFactory: factory.call,
        closeInstance: close.call,
      ).handleExternalChange();

      final AppDatabase current = Get.find<AppDatabase>();
      expect(current, isNot(original));
      expect(factory.created.length, 2);
      expect(identical(factory.created.last, current), isTrue);
      expect(
        Get.find<DataRefreshService>().revision.value,
        greaterThan(before),
      );
      // The bounded close is kicked off unawaited — give it a turn.
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(close.closed, contains(original));
    });

    test('no-op when no database is registered yet', () {
      Get.delete<AppDatabase>(force: true);
      expect(
        () => DatabaseRecovery().handleExternalChange(),
        returnsNormally,
      );
      expect(Get.isRegistered<AppDatabase>(), isFalse);
    });
  });

  group('Dashboard stat cards (Fix 1: same stale-snapshot cause)', () {
    testWidgets('zero history: empty state, no stat cards',
        (tester) async {
      Get.put<HomeController>(
        HomeController(
          repository: _FixedProgressRepository(<TypingTestRecord>[]),
          loadTimeout: const Duration(seconds: 5),
        ),
      );
      await tester.pumpWidget(
        const GetMaterialApp(home: HomeView()),
      );
      await tester.pumpAndSettle();
      expect(find.text('No completed tests yet'), findsOneWidget);
      expect(find.text('Average WPM'), findsNothing);
      expect(find.text('Tests completed'), findsNothing);
    });

    testWidgets('non-zero history: stat cards render, no empty state',
        (tester) async {
      Get.put<HomeController>(
        HomeController(
          repository: _FixedProgressRepository(
            <TypingTestRecord>[_record(id: 1)],
          ),
          loadTimeout: const Duration(seconds: 5),
        ),
      );
      await tester.pumpWidget(
        const GetMaterialApp(home: HomeView()),
      );
      await tester.pumpAndSettle();
      expect(find.text('No completed tests yet'), findsNothing);
      expect(find.text('Average WPM'), findsOneWidget);
      expect(find.text('Average accuracy'), findsOneWidget);
      expect(find.text('Tests completed'), findsOneWidget);
      expect(find.text('Best WPM'), findsOneWidget);
      expect(find.text('Overall average WPM'), findsOneWidget);
      expect(find.text('Practice time'), findsOneWidget);
    });
  });
}
