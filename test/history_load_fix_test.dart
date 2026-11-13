import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/database/database_recovery.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/services/data_refresh_service.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/history/controller/history_controller.dart';
import 'package:typing_master/features/history/model/typing_test_record.dart';
import 'package:typing_master/features/history/view/history_view.dart';
import 'package:typing_master/features/home/controller/home_controller.dart';
import 'package:typing_master/features/ppsc/model/mock_attempt.dart';
import 'package:typing_master/features/ppsc/service/mock_progress_repository.dart';
import 'package:typing_master/features/progress/model/progress_models.dart';
import 'package:typing_master/features/progress/service/progress_repository.dart';
import 'package:typing_master/features/typing_test/model/typing_language.dart';
import 'package:typing_master/features/typing_test/model/typing_test_kind.dart';

/// Tests for the History load failure fix: the Drift typing history
/// and the mock attempts load independently, so a hung Drift read can
/// never discard the mock rows already in memory (and vice versa);
/// Retry re-reads only the failed part and forces a fresh recovery
/// attempt; throws show the banner + Retry like timeouts do; and a
/// Recent Attempts row opens its result (with its certificate flow).

const Duration _shortTimeout = Duration(milliseconds: 50);

TypingTestRecord _typing({required int id}) => TypingTestRecord(
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

MockAttempt _mock({String id = 'attempt-1'}) => MockAttempt(
      id: id,
      sourceKind: 'full',
      sourceId: 'full',
      sourceLabel: 'Full mock test',
      totalQuestions: 100,
      correct: 2,
      wrong: 90,
      skipped: 8,
      score: 2,
      attemptedAt: DateTime(2026, 1, 2, 10, 30),
      durationSeconds: 300,
      actualDurationSeconds: 240,
    );

/// Recovery that returns a canned answer and records every call,
/// including whether it was asked for a fresh attempt.
class _RecordingRecovery extends DatabaseRecovery {
  _RecordingRecovery(this._result);

  final bool _result;
  int calls = 0;
  final List<bool> forceFreshCalls = <bool>[];

  @override
  Future<bool> ensureHealthy({
    Duration? probeTimeout,
    Duration? firstProbeTimeout,
    List<Duration>? retryDelays,
    bool forceFresh = false,
  }) async {
    calls++;
    forceFreshCalls.add(forceFresh);
    return _result;
  }
}

/// Recovery that succeeds after a short delay and notifies, mimicking
/// the real DatabaseRecovery notify path (replace + notify ->
/// DataRefreshService -> the controller's ever() worker reloads).
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

/// Typing fetch that hangs while [broken] is true and answers once it
/// is cleared.
class _FlakyTypingFetch {
  bool broken = true;
  int calls = 0;

  Future<List<TypingTestRecord>> call() {
    calls++;
    if (!broken) {
      return Future<List<TypingTestRecord>>.value(
          <TypingTestRecord>[_typing(id: 1)]);
    }
    return Completer<List<TypingTestRecord>>().future;
  }

  void unbreak() {
    broken = false;
  }
}

/// Typing fetch that hangs on the FIRST call only, then answers — what
/// a recovered database looks like to the next fetch.
class _FirstHangThenOkTypingFetch {
  int calls = 0;

  Future<List<TypingTestRecord>> call() {
    calls++;
    if (calls == 1) {
      return Completer<List<TypingTestRecord>>().future;
    }
    return Future<List<TypingTestRecord>>.value(
        <TypingTestRecord>[_typing(id: 1)]);
  }
}

class _CountingMockFetch {
  int calls = 0;
  final List<MockAttempt> attempts;

  _CountingMockFetch(this.attempts);

  Future<List<MockAttempt>> call() async {
    calls++;
    return attempts;
  }
}

class _FakeProgressRepository implements ProgressRepository {
  _FakeProgressRepository({
    Future<List<TypingTestRecord>> Function()? fetchAllTests,
    Future<int> Function()? fetchDailyGoalSeconds,
  })  : _fetchAllTests = fetchAllTests ?? _hangTests,
        _fetchDailyGoalSeconds =
            fetchDailyGoalSeconds ?? _hangGoal;

  final Future<List<TypingTestRecord>> Function() _fetchAllTests;
  final Future<int> Function() _fetchDailyGoalSeconds;

  static Future<List<TypingTestRecord>> _hangTests() =>
      Completer<List<TypingTestRecord>>().future;

  static Future<int> _hangGoal() => Completer<int>().future;

  @override
  Future<List<TypingTestRecord>> fetchAllTests() => _fetchAllTests();

  @override
  Future<int> fetchDailyGoalSeconds() => _fetchDailyGoalSeconds();

  @override
  Future<LessonProgressSummary> fetchLessonProgressSummary() async =>
      LessonProgressSummary.empty;
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
    MockProgressRepository.instance.resetForTest();
  });
  tearDown(() {
    Get.reset();
    MockProgressRepository.instance.resetForTest();
  });

  group('HistoryController decoupled loads', () {
    test('Drift hangs: mock attempts still render', () async {
      final HistoryController controller = HistoryController(
        fetchTyping: () => Completer<List<TypingTestRecord>>().future,
        fetchMockAttempts: () async => <MockAttempt>[_mock()],
        loadTimeout: _shortTimeout,
        databaseRecovery: _RecordingRecovery(false),
      );

      final Stopwatch stopwatch = Stopwatch()..start();
      await controller.load();
      stopwatch.stop();

      expect(controller.isLoading.value, isFalse);
      // The load gives up after the short timeout, not after the
      // ~47s a background recovery needs.
      expect(stopwatch.elapsed, lessThan(const Duration(seconds: 5)));
      expect(controller.loadTimedOut.value, isTrue);
      expect(controller.typingUnavailable.value, isTrue);
      expect(controller.mockUnavailable.value, isFalse);
      expect(controller.allTests.length, 1);
      expect(controller.allTests.single.isMock, isTrue);
      expect(controller.hasPartialData, isTrue);
      expect(controller.partialDataNote, contains('Typing history'));
      expect(controller.partialDataNote, contains('mock attempts'));
    });

    test('mock read throws: typing entries still render', () async {
      final HistoryController controller = HistoryController(
        fetchTyping: () async => <TypingTestRecord>[_typing(id: 1)],
        fetchMockAttempts: () =>
            Future<List<MockAttempt>>.error(StateError('prefs down')),
        loadTimeout: _shortTimeout,
        databaseRecovery: _RecordingRecovery(false),
      );

      await controller.load();

      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isTrue);
      expect(controller.typingUnavailable.value, isFalse);
      expect(controller.mockUnavailable.value, isTrue);
      expect(controller.allTests.length, 1);
      expect(controller.allTests.single.isMock, isFalse);
      expect(controller.hasPartialData, isTrue);
      expect(controller.partialDataNote, contains('Mock attempts'));
    });

    test('typing read throws: banner + Retry state, mock rows kept',
        () async {
      // A throw used to fall through to a plain "No completed tests
      // yet" with no Retry at all — a read failure disguised as an
      // empty history. Now it shows the same banner + Retry as a
      // timeout, and the mock rows stay on screen.
      final HistoryController controller = HistoryController(
        fetchTyping: () =>
            Future<List<TypingTestRecord>>.error(StateError('db down')),
        fetchMockAttempts: () async => <MockAttempt>[_mock()],
        loadTimeout: _shortTimeout,
        databaseRecovery: _RecordingRecovery(false),
      );

      await controller.load();

      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isTrue);
      expect(controller.typingUnavailable.value, isTrue);
      expect(controller.allTests.length, 1);
      expect(controller.allTests.single.isMock, isTrue);
      expect(controller.hasPartialData, isTrue);
    });

    test('retry retries only the failed part and can succeed', () async {
      final _FlakyTypingFetch typing = _FlakyTypingFetch();
      final _CountingMockFetch mock =
          _CountingMockFetch(<MockAttempt>[_mock()]);
      final _RecordingRecovery recovery = _RecordingRecovery(false);
      final HistoryController controller = HistoryController(
        fetchTyping: typing.call,
        fetchMockAttempts: mock.call,
        loadTimeout: _shortTimeout,
        databaseRecovery: recovery,
      );

      await controller.load();
      expect(typing.calls, 1);
      expect(mock.calls, 1);
      expect(controller.allTests.length, 1);
      expect(controller.typingUnavailable.value, isTrue);
      // The first load's background recovery joined the shared
      // in-flight run (no forced fresh).
      expect(recovery.forceFreshCalls, <bool>[false]);

      // The database recovers; Retry must re-read ONLY the typing
      // part (the mock part already succeeded) and force a genuinely
      // fresh recovery attempt instead of rejoining the stale one.
      typing.unbreak();
      await controller.retryLoad();

      expect(typing.calls, 2);
      expect(mock.calls, 1);
      expect(recovery.forceFreshCalls, <bool>[false, true]);
      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isFalse);
      expect(controller.loadFailed.value, isFalse);
      expect(controller.typingUnavailable.value, isFalse);
      expect(controller.mockUnavailable.value, isFalse);
      expect(controller.allTests.length, 2);
    });

    test('background recovery success reloads history without a manual '
        'retry', () async {
      Get.put<DataRefreshService>(DataRefreshService());
      final _FirstHangThenOkTypingFetch typing =
          _FirstHangThenOkTypingFetch();
      final _NotifyingRecovery recovery = _NotifyingRecovery();
      final HistoryController controller = Get.put<HistoryController>(
        HistoryController(
          fetchTyping: typing.call,
          fetchMockAttempts: () async => <MockAttempt>[_mock()],
          loadTimeout: _shortTimeout,
          databaseRecovery: recovery,
        ),
      );

      // onInit kicked off load(): the typing fetch times out at
      // ~50ms, the load finishes with the mock rows, the background
      // recovery notifies, and the ever() worker reloads — the
      // second typing fetch answers, with no retryLoad() call.
      await Future<void>.delayed(const Duration(milliseconds: 400));

      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isFalse);
      expect(controller.loadFailed.value, isFalse);
      expect(controller.allTests.length, 2);
      expect(recovery.calls, 1);
    });
  });

  group('HistoryView decoupled loads', () {
    testWidgets('Drift hangs: mock rows render with partial note + Retry',
        (WidgetTester tester) async {
      Get.put<HistoryController>(
        HistoryController(
          fetchTyping: () => Completer<List<TypingTestRecord>>().future,
          fetchMockAttempts: () async => <MockAttempt>[_mock()],
          loadTimeout: _shortTimeout,
          databaseRecovery: _RecordingRecovery(false),
        ),
      );
      await tester.pumpWidget(
        const GetMaterialApp(home: HistoryView()),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('No completed tests yet'), findsNothing);
      expect(
        find.textContaining('Full mock test · 5 minutes'),
        findsOneWidget,
      );
      expect(find.text('2 / 100'), findsOneWidget);
      expect(
        find.textContaining('Typing history could not be loaded'),
        findsOneWidget,
      );
      expect(find.text('Retry loading history'), findsOneWidget);
    });

    testWidgets('typing throws: mock rows render with banner + Retry',
        (WidgetTester tester) async {
      Get.put<HistoryController>(
        HistoryController(
          fetchTyping: () =>
              Future<List<TypingTestRecord>>.error(StateError('db down')),
          fetchMockAttempts: () async => <MockAttempt>[_mock()],
          loadTimeout: _shortTimeout,
          databaseRecovery: _RecordingRecovery(false),
        ),
      );
      await tester.pumpWidget(
        const GetMaterialApp(home: HistoryView()),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('No completed tests yet'), findsNothing);
      expect(
        find.textContaining('Full mock test · 5 minutes'),
        findsOneWidget,
      );
      expect(find.text('Retry loading history'), findsOneWidget);
    });

    testWidgets('both sources fail: empty state with Retry and failed '
        'copy', (WidgetTester tester) async {
      Get.put<HistoryController>(
        HistoryController(
          fetchTyping: () => Completer<List<TypingTestRecord>>().future,
          fetchMockAttempts: () =>
              Future<List<MockAttempt>>.error(StateError('prefs down')),
          loadTimeout: _shortTimeout,
          databaseRecovery: _RecordingRecovery(false),
        ),
      );
      await tester.pumpWidget(
        const GetMaterialApp(home: HistoryView()),
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
  });

  group('HomeController independent loads', () {
    test('goal fetch throwing does not hide the history rows', () async {
      final HomeController controller = HomeController(
        repository: _FakeProgressRepository(
          fetchAllTests: () async => <TypingTestRecord>[_typing(id: 1)],
          fetchDailyGoalSeconds: () =>
              Future<int>.error(StateError('db down')),
        ),
        loadTimeout: _shortTimeout,
        databaseRecovery: _RecordingRecovery(false),
      );

      await controller.load();

      expect(controller.isLoading.value, isFalse);
      expect(controller.allTests.length, 1);
      // The goal falls back to its default; the history is unaffected.
      expect(controller.dailyGoalSeconds.value, 600);
    });

    test('history fetch throwing does not hide the daily goal', () async {
      final HomeController controller = HomeController(
        repository: _FakeProgressRepository(
          fetchAllTests: () =>
              Future<List<TypingTestRecord>>.error(StateError('db down')),
          fetchDailyGoalSeconds: () async => 900,
        ),
        loadTimeout: _shortTimeout,
        databaseRecovery: _RecordingRecovery(false),
      );

      await controller.load();

      expect(controller.isLoading.value, isFalse);
      expect(controller.loadTimedOut.value, isTrue);
      expect(controller.allTests, isEmpty);
      expect(controller.dailyGoalSeconds.value, 900);
    });
  });

  group('Recent Attempts rows open their result', () {
    setUp(() {
      MockProgressRepository.instance.resetForTest();
    });

    testWidgets('tapping a row opens its result with the certificate '
        'flow', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        MockProgressRepository.attemptsKey:
            jsonEncode(<Map<String, dynamic>>[_mock().toJson()]),
      });
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          initialRoute: AppRoutes.ppscMockTest,
          getPages: AppPages.pages,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Your Recent Attempts'), findsOneWidget);
      expect(
        find.textContaining('Full mock test · 5 minutes'),
        findsOneWidget,
      );

      // The row is a link: tapping it opens that attempt's result.
      // It sits below the fold on the setup page, so scroll it into
      // view first — otherwise the tap misses the row entirely.
      await tester.ensureVisible(
        find.textContaining('Full mock test · 5 minutes'),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Full mock test · 5 minutes'));
      await tester.pumpAndSettle();

      expect(find.text('Review'), findsOneWidget);
      expect(find.text('Score'), findsOneWidget);
      expect(find.text('2 / 100'), findsOneWidget);
      // The result reaches the certificate flow even though no
      // certificate was ever generated for it (nothing stored).
      expect(find.text('Get Practice Certificate'), findsOneWidget);

      await tester.tap(find.text('Get Practice Certificate'));
      await tester.pumpAndSettle();

      expect(Get.currentRoute, AppRoutes.certificate);
      expect(find.text('Name on the certificate'), findsOneWidget);
    });
  });
}
