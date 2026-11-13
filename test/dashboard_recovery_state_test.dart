import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:typing_master/core/database/database_recovery.dart';
import 'package:typing_master/features/history/controller/history_controller.dart';
import 'package:typing_master/features/history/model/typing_test_record.dart';
import 'package:typing_master/features/history/view/history_view.dart';
import 'package:typing_master/features/home/controller/home_controller.dart';
import 'package:typing_master/features/home/view/home_view.dart';
import 'package:typing_master/features/ppsc/model/mock_attempt.dart';
import 'package:typing_master/features/progress/model/progress_models.dart';
import 'package:typing_master/features/progress/service/progress_repository.dart';
import 'package:typing_master/features/typing_test/model/typing_language.dart';
import 'package:typing_master/features/typing_test/model/typing_test_kind.dart';

/// Regression tests for the Dashboard/History timeout states:
/// a timed-out load must show a *recovering* state (never the
/// "No completed tests yet" headline — the database may well have
/// tests), a failed recovery must show a *failed* state with no
/// auto-reload promise, and a recovery that succeeds must reload the
/// screen on its own (direct reload + bounded re-check timer), never
/// leaving the user on the timeout banner.

const Duration _shortTimeout = Duration(milliseconds: 50);
const Duration _shortRecheck = Duration(milliseconds: 50);

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

/// Recovery that never answers — the "still recovering" state.
class _HangingRecovery extends DatabaseRecovery {
  @override
  Future<bool> ensureHealthy({
    Duration? probeTimeout,
    Duration? firstProbeTimeout,
    List<Duration>? retryDelays,
    bool forceFresh = false,
  }) =>
      Completer<bool>().future;
}

/// Recovery that succeeds after [delay].
class _DelayedOkRecovery extends DatabaseRecovery {
  _DelayedOkRecovery(this.delay);

  final Duration delay;

  @override
  Future<bool> ensureHealthy({
    Duration? probeTimeout,
    Duration? firstProbeTimeout,
    List<Duration>? retryDelays,
    bool forceFresh = false,
  }) async {
    await Future<void>.delayed(delay);
    return true;
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

/// First history fetch hangs, later ones answer: the re-check timer
/// and the direct reload after recovery both get a second chance.
class _FlakyProgressRepository implements ProgressRepository {
  int _calls = 0;

  @override
  Future<List<TypingTestRecord>> fetchAllTests() {
    _calls++;
    if (_calls == 1) return Completer<List<TypingTestRecord>>().future;
    return Future<List<TypingTestRecord>>.value([_record(id: 1)]);
  }

  @override
  Future<int> fetchDailyGoalSeconds() async => 600;

  @override
  Future<LessonProgressSummary> fetchLessonProgressSummary() async =>
      LessonProgressSummary.empty;
}

class _EmptyProgressRepository implements ProgressRepository {
  @override
  Future<List<TypingTestRecord>> fetchAllTests() async =>
      <TypingTestRecord>[];

  @override
  Future<int> fetchDailyGoalSeconds() async => 600;

  @override
  Future<LessonProgressSummary> fetchLessonProgressSummary() async =>
      LessonProgressSummary.empty;
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });
  tearDown(() {
    Get.reset();
  });

  group('HomeController recovering state', () {
    test('timeout + recovery still running: timed out, not failed', () async {
      final controller = HomeController(
        repository: _NeverProgressRepository(),
        loadTimeout: _shortTimeout,
        // Default 10s re-check interval on purpose: the timer must not
        // fire inside this test, or the state would oscillate between
        // loads and the assertions would be racy.
        databaseRecovery: _HangingRecovery(),
      );
      await controller.load();
      await Future<void>.delayed(const Duration(milliseconds: 150));
      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isTrue);
      expect(controller.loadFailed.value, isFalse);
      expect(controller.allTests, isEmpty);
      controller.onClose();
    });

    test('re-check timer reloads on its own once the fetch answers',
        () async {
      final controller = HomeController(
        repository: _FlakyProgressRepository(),
        loadTimeout: _shortTimeout,
        recheckInterval: _shortRecheck,
        databaseRecovery: _HangingRecovery(),
      );
      await controller.load();
      // The first fetch timed out; the recovery never answers, so no
      // direct reload and no revision bump can help — only the timer.
      expect(controller.loadTimedOut.value, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(controller.allTests.length, 1);
      expect(controller.loadTimedOut.value, isFalse);
      expect(controller.loadFailed.value, isFalse);
      controller.onClose();
    });

    test('direct reload on recovery success, no manual Retry needed',
        () async {
      final controller = HomeController(
        repository: _FlakyProgressRepository(),
        loadTimeout: _shortTimeout,
        recheckInterval: _shortRecheck,
        databaseRecovery: _DelayedOkRecovery(
          const Duration(milliseconds: 100),
        ),
      );
      await controller.load();
      expect(controller.loadTimedOut.value, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(controller.allTests.length, 1);
      expect(controller.loadTimedOut.value, isFalse);
      expect(controller.loadFailed.value, isFalse);
      controller.onClose();
    });
  });

  group('HistoryController re-check timer', () {
    test('typing part re-read on its own once the fetch answers', () async {
      int calls = 0;
      final controller = HistoryController(
        fetchTyping: () {
          calls++;
          if (calls == 1) {
            return Completer<List<TypingTestRecord>>().future;
          }
          return Future<List<TypingTestRecord>>.value([_record(id: 1)]);
        },
        fetchMockAttempts: () async => <MockAttempt>[],
        loadTimeout: _shortTimeout,
        recheckInterval: _shortRecheck,
        databaseRecovery: _HangingRecovery(),
      );
      await controller.load();
      expect(controller.loadTimedOut.value, isTrue);
      expect(controller.typingUnavailable.value, isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 400));
      expect(controller.allTests.length, 1);
      expect(controller.typingUnavailable.value, isFalse);
      expect(controller.loadTimedOut.value, isFalse);
      controller.onClose();
    });
  });

  group('HomeView timeout states', () {
    testWidgets('recovering: spinner copy, never "No completed tests yet"',
        (WidgetTester tester) async {
      final HomeController controller = Get.put<HomeController>(
        HomeController(
          repository: _NeverProgressRepository(),
          loadTimeout: _shortTimeout,
          // Default 10s re-check interval: the timer must not fire
          // inside the 300ms pump, or a re-check load would be in
          // flight and the view would show the plain spinner.
          databaseRecovery: _HangingRecovery(),
        ),
      );
      await tester.pumpWidget(const GetMaterialApp(home: HomeView()));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();
      expect(find.text('Still loading your history'), findsOneWidget);
      expect(find.text('No completed tests yet'), findsNothing);
      expect(find.text('Retry loading history'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // The re-check timer is still pending (recovery never answers):
      // stop it, or the test binding fails on a pending Timer.
      controller.onClose();
    });

    testWidgets('genuine empty: headline only after a completed load',
        (WidgetTester tester) async {
      Get.put<HomeController>(
        HomeController(
          repository: _EmptyProgressRepository(),
          loadTimeout: _shortTimeout,
        ),
      );
      await tester.pumpWidget(const GetMaterialApp(home: HomeView()));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();
      expect(find.text('No completed tests yet'), findsOneWidget);
      expect(find.text('Retry loading history'), findsNothing);
      expect(find.text('Still loading your history'), findsNothing);
    });
  });

  group('HistoryView timeout states', () {
    testWidgets('recovering: spinner copy, never "No completed tests yet"',
        (WidgetTester tester) async {
      final HistoryController controller = Get.put<HistoryController>(
        HistoryController(
          fetchTyping: () => Completer<List<TypingTestRecord>>().future,
          fetchMockAttempts: () =>
              Future<List<MockAttempt>>.error(StateError('prefs down')),
          loadTimeout: _shortTimeout,
          // Default 10s re-check interval: the timer must not fire
          // inside the 300ms pump (see the HomeView test above).
          databaseRecovery: _HangingRecovery(),
        ),
      );
      await tester.pumpWidget(const GetMaterialApp(home: HistoryView()));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();
      expect(find.text('Still loading your history'), findsOneWidget);
      expect(find.text('No completed tests yet'), findsNothing);
      expect(find.text('Retry loading history'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // The re-check timer is still pending (recovery never answers):
      // stop it, or the test binding fails on a pending Timer.
      controller.onClose();
    });
  });
}
