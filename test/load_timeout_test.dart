import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:typing_master/core/database/database_recovery.dart';
import 'package:typing_master/features/history/model/typing_test_record.dart';
import 'package:typing_master/features/home/controller/home_controller.dart';
import 'package:typing_master/features/home/view/home_view.dart';
import 'package:typing_master/features/profile/controller/profile_controller.dart';
import 'package:typing_master/features/profile/model/profile_stats.dart';
import 'package:typing_master/features/profile/service/profile_repository.dart';
import 'package:typing_master/features/progress/controller/progress_controller.dart';
import 'package:typing_master/features/progress/model/progress_models.dart';
import 'package:typing_master/features/progress/service/progress_repository.dart';
import 'package:typing_master/features/typing_test/model/typing_language.dart';
import 'package:typing_master/features/typing_test/model/typing_test_kind.dart';

/// Regression tests for the reload spinner that never released: when the
/// database read hangs (or throws), the Dashboard / Progress / Profile
/// loads must give up after a timeout, release their loading flag, and
/// show empty data — never spin forever. No real database is involved;
/// the repositories are faked via `implements`.

const Duration _shortTimeout = Duration(milliseconds: 50);

/// Recovery that always fails fast, so the timeout tests exercise the
/// controller/view behaviour without running the real recovery (which
/// would probe a real database). Recovery itself is covered in
/// database_recovery_test.dart.
class _FailingRecovery extends DatabaseRecovery {
  @override
  Future<bool> ensureHealthy({
    Duration? probeTimeout,
    Duration? firstProbeTimeout,
    List<Duration>? retryDelays,
    bool forceFresh = false,
  }) async =>
      false;
}

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

// --- ProgressRepository fakes ---------------------------------------------

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

class _ThrowingProgressRepository implements ProgressRepository {
  @override
  Future<List<TypingTestRecord>> fetchAllTests() =>
      Future<List<TypingTestRecord>>.error(StateError('db down'));

  @override
  Future<int> fetchDailyGoalSeconds() => Future<int>.value(600);

  @override
  Future<LessonProgressSummary> fetchLessonProgressSummary() =>
      Future<LessonProgressSummary>.value(LessonProgressSummary.empty);
}

class _OkProgressRepository implements ProgressRepository {
  @override
  Future<List<TypingTestRecord>> fetchAllTests() async => [_record(id: 1)];

  @override
  Future<int> fetchDailyGoalSeconds() async => 900;

  @override
  Future<LessonProgressSummary> fetchLessonProgressSummary() async =>
      LessonProgressSummary.empty;
}

// --- ProfileRepository fakes ----------------------------------------------

class _NeverProfileRepository implements ProfileRepository {
  @override
  Future<int> ensureUser() => Completer<int>().future;

  @override
  Future<ProfileStats> load() => Completer<ProfileStats>().future;

  @override
  Future<void> updateName(String name) => Completer<void>().future;

  @override
  Future<List<TypingTestRecord>> bestScores({int limit = 10}) =>
      Completer<List<TypingTestRecord>>().future;
}

class _ThrowingProfileRepository implements ProfileRepository {
  @override
  Future<int> ensureUser() => Future<int>.value(1);

  @override
  Future<ProfileStats> load() =>
      Future<ProfileStats>.error(StateError('db down'));

  @override
  Future<void> updateName(String name) async {}

  @override
  Future<List<TypingTestRecord>> bestScores({int limit = 10}) async => [];
}

class _OkProfileRepository implements ProfileRepository {
  @override
  Future<int> ensureUser() async => 1;

  @override
  Future<ProfileStats> load() async => ProfileStats(
        name: 'Tester',
        createdAt: DateTime(2026, 1, 1),
        totalTests: 1,
        totalPracticeSeconds: 60,
        bestWpm: 30,
        averageWpm: 30,
        bestAccuracy: 90,
        averageAccuracy: 90,
        currentStreak: 1,
        longestStreak: 1,
        englishTests: 1,
        urduTests: 0,
        ppscTests: 0,
        completedLessons: 0,
      );

  @override
  Future<void> updateName(String name) async {}

  @override
  Future<List<TypingTestRecord>> bestScores({int limit = 10}) async =>
      [_record(id: 1)];
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });
  tearDown(() {
    Get.reset();
  });

  group('HomeController load timeout', () {
    test('hanging repository releases loading and shows empty state', () async {
      final controller = HomeController(
        repository: _NeverProgressRepository(),
        loadTimeout: _shortTimeout,
        databaseRecovery: _FailingRecovery(),
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
      expect(controller.dailyGoalSeconds.value, 600);
    });

    test('successful load is unchanged', () async {
      final controller = HomeController(
        repository: _OkProgressRepository(),
        loadTimeout: _shortTimeout,
      );
      await controller.load();
      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isFalse);
      expect(controller.allTests.length, 1);
      expect(controller.dailyGoalSeconds.value, 900);
    });

    test('throwing repository is caught: empty state + Retry, no throw',
        () async {
      // History parity: a throw is a read failure like a timeout, not
      // a crash — load() must finish, release loading, and offer
      // Retry instead of propagating the throw (which used to leave
      // the screen with no way back).
      final controller = HomeController(
        repository: _ThrowingProgressRepository(),
        loadTimeout: _shortTimeout,
        databaseRecovery: _FailingRecovery(),
      );
      await controller.load();
      // The background recovery is fire-and-forget: give it a turn to
      // report before asserting loadFailed.
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isTrue);
      expect(controller.loadFailed.value, isTrue);
      expect(controller.allTests, isEmpty);
      expect(controller.dailyGoalSeconds.value, 600);
    });
  });

  group('ProgressController load timeout', () {
    test('hanging repository releases loading and shows empty data', () async {
      final controller = ProgressController(
        repository: _NeverProgressRepository(),
        loadTimeout: _shortTimeout,
      );
      await controller.load();
      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isTrue);
      expect(controller.allTests, isEmpty);
      expect(controller.dailyGoalSeconds.value, 600);
      expect(controller.lessonSummary.value.completedCount, 0);
    });

    test('successful load is unchanged', () async {
      final controller = ProgressController(
        repository: _OkProgressRepository(),
        loadTimeout: _shortTimeout,
      );
      await controller.load();
      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isFalse);
      expect(controller.allTests.length, 1);
      expect(controller.dailyGoalSeconds.value, 900);
    });

    test('throwing repository still releases loading', () async {
      final controller = ProgressController(
        repository: _ThrowingProgressRepository(),
        loadTimeout: _shortTimeout,
      );
      try {
        await controller.load();
        fail('expected load to throw');
      } catch (_) {
        // Expected.
      }
      expect(controller.isLoading.value, isFalse);
    });
  });

  group('ProfileController load timeout', () {
    test('hanging repository releases loading and shows empty data', () async {
      final controller = ProfileController(
        repository: _NeverProfileRepository(),
        loadTimeout: _shortTimeout,
      );
      await controller.load();
      expect(controller.loading.value, isFalse);
      expect(controller.loadTimedOut.value, isTrue);
      expect(controller.stats.value.totalTests, 0);
      expect(controller.bestScores, isEmpty);
    });

    test('successful load is unchanged', () async {
      final controller = ProfileController(
        repository: _OkProfileRepository(),
        loadTimeout: _shortTimeout,
      );
      await controller.load();
      expect(controller.loading.value, isFalse);
      expect(controller.loadTimedOut.value, isFalse);
      expect(controller.stats.value.name, 'Tester');
      expect(controller.bestScores.length, 1);
    });

    test('throwing repository still releases loading', () async {
      final controller = ProfileController(
        repository: _ThrowingProfileRepository(),
        loadTimeout: _shortTimeout,
      );
      try {
        await controller.load();
        fail('expected load to throw');
      } catch (_) {
        // Expected: the throw propagates, the flag must still release.
      }
      expect(controller.loading.value, isFalse);
    });
  });

  testWidgets('HomeView shows the timeout notice when the load times out',
      (tester) async {
    Get.put<HomeController>(
      HomeController(
        repository: _NeverProgressRepository(),
        loadTimeout: _shortTimeout,
        databaseRecovery: _FailingRecovery(),
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
  });
}
