import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/history/controller/history_controller.dart';
import 'package:typing_master/features/history/model/history_filters.dart';
import 'package:typing_master/features/history/model/typing_test_record.dart';
import 'package:typing_master/features/history/view/widgets/history_row.dart';
import 'package:typing_master/features/ppsc/controller/mock_test_controller.dart';
import 'package:typing_master/features/ppsc/model/custom_set.dart';
import 'package:typing_master/features/ppsc/model/mock_attempt.dart';
import 'package:typing_master/features/ppsc/model/mock_question.dart';
import 'package:typing_master/features/ppsc/service/mock_progress_repository.dart';
import 'package:typing_master/features/typing_test/model/typing_language.dart';
import 'package:typing_master/features/typing_test/model/typing_test_kind.dart';

TypingTestRecord _typing({
  required int id,
  TypingLanguage language = TypingLanguage.english,
  TypingTestKind testType = TypingTestKind.normal,
  int? durationSeconds = 60,
  int actualDurationSeconds = 60,
  double netWpm = 30,
  double accuracy = 90,
  DateTime? completedAt,
}) {
  return TypingTestRecord(
    id: id,
    language: language,
    testType: testType,
    durationSeconds: durationSeconds,
    actualDurationSeconds: actualDurationSeconds,
    grossWpm: netWpm,
    netWpm: netWpm,
    accuracy: accuracy,
    correctCharacters: 100,
    wrongCharacters: 10,
    correctWords: 20,
    wrongWords: 2,
    skippedWords: 1,
    backspaces: 5,
    totalErrors: 11,
    completedAt: completedAt ?? DateTime(2026, 1, 1),
  );
}

MockAttempt _mock({
  String id = 'attempt-1',
  String sourceKind = 'full',
  String sourceId = 'full',
  String sourceLabel = 'Full mock test',
  int totalQuestions = 100,
  int correct = 2,
  int wrong = 90,
  int skipped = 8,
  double score = 2,
  DateTime? attemptedAt,
  int? durationSeconds = 300,
  int? actualDurationSeconds = 300,
}) {
  return MockAttempt(
    id: id,
    sourceKind: sourceKind,
    sourceId: sourceId,
    sourceLabel: sourceLabel,
    totalQuestions: totalQuestions,
    correct: correct,
    wrong: wrong,
    skipped: skipped,
    score: score,
    attemptedAt: attemptedAt ?? DateTime(2026, 1, 10, 9, 30),
    durationSeconds: durationSeconds,
    actualDurationSeconds: actualDurationSeconds,
  );
}

List<TypingTestRecord> _filter(
  List<TypingTestRecord> list, {
  HistoryLanguageFilter language = HistoryLanguageFilter.all,
  HistoryTestTypeFilter testType = HistoryTestTypeFilter.all,
  HistoryDurationFilter duration = HistoryDurationFilter.all,
  HistoryDateFilter date = HistoryDateFilter.allTime,
  HistorySort sort = HistorySort.newestFirst,
  String query = '',
  DateTime? now,
}) {
  return HistoryController.applyFilters(
    list,
    language: language,
    testType: testType,
    duration: duration,
    date: date,
    sort: sort,
    query: query,
    now: now ?? DateTime(2026, 1, 20, 12),
  );
}

void main() {
  group('MockAttempt duration storage', () {
    test('round-trips planned and actual duration', () {
      final MockAttempt attempt = _mock();
      final MockAttempt restored =
          MockAttempt.fromJson(Map<String, dynamic>.from(attempt.toJson()));
      expect(restored.durationSeconds, 300);
      expect(restored.actualDurationSeconds, 300);
      expect(restored.displayLabel, 'Full mock test · 5 minutes');
    });

    test('legacy JSON without durations parses with null durations', () {
      final Map<String, dynamic> legacy = {
        'id': 'attempt-old',
        'sourceKind': 'full',
        'sourceId': 'full',
        'sourceLabel': 'Full mock test',
        'totalQuestions': 100,
        'correct': 2,
        'wrong': 90,
        'skipped': 8,
        'score': 2,
        'attemptedAt': '2026-01-10T09:30:00.000',
        'perSubjectCorrect': <String, int>{},
        'perSubjectTotal': <String, int>{},
      };
      final MockAttempt restored = MockAttempt.fromJson(legacy);
      expect(restored.durationSeconds, isNull);
      expect(restored.actualDurationSeconds, isNull);
      // No duration is invented for an old attempt.
      expect(restored.displayLabel, 'Full mock test');
    });

    test('paper label carries the planned duration', () {
      final MockAttempt attempt = _mock(
        sourceKind: 'paper',
        sourceId: '2026-246',
        sourceLabel: 'Practice Paper 246',
        durationSeconds: 5400,
        actualDurationSeconds: 5000,
      );
      expect(attempt.displayLabel, 'Practice Paper 246 · 90 minutes');
    });
  });

  group('TypingTestRecord.fromMockAttempt', () {
    test('maps score, counts, duration and date', () {
      final TypingTestRecord record =
          TypingTestRecord.fromMockAttempt(_mock());
      expect(record.isMock, isTrue);
      expect(record.testType, TypingTestKind.mock);
      expect(record.mockAttemptId, 'attempt-1');
      expect(record.mockLabel, 'Full mock test · 5 minutes');
      expect(record.mockScoreLabel, '2 / 100');
      expect(record.mockCorrect, 2);
      expect(record.mockWrong, 90);
      expect(record.mockSkipped, 8);
      expect(record.mockScore, 2);
      expect(record.accuracy, 2);
      expect(record.netWpm, 0);
      expect(record.grossWpm, 0);
      expect(record.durationSeconds, 300);
      expect(record.actualDurationSeconds, 300);
      expect(record.completedAt, DateTime(2026, 1, 10, 9, 30));
      expect(record.languageAndTypeLabel, 'Mock test');
    });

    test('mock id is negative so it can never match a database row', () {
      final TypingTestRecord record =
          TypingTestRecord.fromMockAttempt(_mock());
      expect(record.id, isNegative);
    });

    test('old attempt without durations maps with no duration', () {
      final TypingTestRecord record = TypingTestRecord.fromMockAttempt(
        _mock(durationSeconds: null, actualDurationSeconds: null),
      );
      expect(record.durationSeconds, isNull);
      expect(record.mockDurationText, isEmpty);
      expect(record.mockLabel, 'Full mock test');
    });

    test('typing records are not mocks', () {
      expect(_typing(id: 1).isMock, isFalse);
      expect(_typing(id: 1).mockLabel, isNull);
    });
  });

  group('HistoryController.mergeWithMockAttempts', () {
    test('typing records pass through untouched and mocks are appended',
        () {
      final TypingTestRecord typing = _typing(id: 7);
      final List<TypingTestRecord> merged =
          HistoryController.mergeWithMockAttempts([typing], [_mock()]);
      expect(merged.length, 2);
      expect(identical(merged.first, typing), isTrue);
      expect(merged.last.isMock, isTrue);
    });

    test('empty on both sides stays empty', () {
      expect(HistoryController.mergeWithMockAttempts([], []), isEmpty);
    });
  });

  group('History filters with mock entries', () {
    final List<TypingTestRecord> list = [
      _typing(id: 1, completedAt: DateTime(2026, 1, 5)),
      _typing(
        id: 2,
        testType: TypingTestKind.ppsc,
        language: TypingLanguage.urdu,
        completedAt: DateTime(2026, 1, 6),
      ),
      TypingTestRecord.fromMockAttempt(_mock()),
    ];

    test('Mock test filter keeps only mock entries', () {
      final result = _filter(list, testType: HistoryTestTypeFilter.mock);
      expect(result.length, 1);
      expect(result.first.isMock, isTrue);
    });

    test('Normal filter excludes mock entries', () {
      final result = _filter(list, testType: HistoryTestTypeFilter.normal);
      expect(result.length, 1);
      expect(result.first.id, 1);
    });

    test('PPSC filter keeps only PPSC typing tests, not mocks', () {
      final result = _filter(list, testType: HistoryTestTypeFilter.ppsc);
      expect(result.length, 1);
      expect(result.first.id, 2);
    });

    test('All keeps typing and mock entries together', () {
      expect(_filter(list).length, 3);
    });

    test('language filters never hide mock entries', () {
      final english = _filter(
        list,
        language: HistoryLanguageFilter.english,
      );
      expect(english.map((t) => t.id).toList(),
          contains(list.last.id));
      expect(english.any((t) => t.id == 2), isFalse);

      final urdu = _filter(list, language: HistoryLanguageFilter.urdu);
      expect(urdu.map((t) => t.id).toList(), contains(list.last.id));
      expect(urdu.any((t) => t.id == 1), isFalse);
    });

    test('search matches the mock label and score', () {
      expect(_filter(list, query: 'paper 246').length, 0);
      final byLabel = _filter(list, query: 'full mock');
      expect(byLabel.length, 1);
      expect(byLabel.first.isMock, isTrue);

      final byScore = _filter(list, query: '2 / 100');
      expect(byScore.length, 1);
      expect(byScore.first.isMock, isTrue);

      final byType = _filter(list, query: 'mock');
      expect(byType.length, 1);
      expect(byType.first.isMock, isTrue);
    });

    test('5-minute duration preset matches a 5-minute mock', () {
      final result =
          _filter(list, duration: HistoryDurationFilter.minutes5);
      expect(result.length, 1);
      expect(result.first.isMock, isTrue);
    });

    test('a mock without a duration is not matched by a preset', () {
      final List<TypingTestRecord> withOld = [
        TypingTestRecord.fromMockAttempt(
          _mock(durationSeconds: null, actualDurationSeconds: null),
        ),
      ];
      expect(
        _filter(withOld, duration: HistoryDurationFilter.minutes5),
        isEmpty,
      );
    });

    test('date filter applies to mock entries', () {
      final today = _filter(list, date: HistoryDateFilter.today);
      expect(today, isEmpty);
      final last30 = _filter(list, date: HistoryDateFilter.last30Days);
      expect(last30.length, 3);
    });

    test('newest-first sort interleaves mocks and typing by date', () {
      final result = _filter(list);
      expect(result.first.isMock, isTrue); // 2026-01-10 is newest
      expect(result.last.id, 1); // 2026-01-05 is oldest
    });

    test('highest-accuracy sort uses the mock percentage', () {
      final high = TypingTestRecord.fromMockAttempt(
        _mock(
          id: 'attempt-high',
          correct: 95,
          wrong: 3,
          skipped: 2,
          score: 95,
          attemptedAt: DateTime(2026, 1, 4),
        ),
      );
      final result = _filter([_typing(id: 1), high],
          sort: HistorySort.highestAccuracy);
      expect(result.first.isMock, isTrue);
    });
  });

  group('MockTestController submit records exactly once', () {
    setUp(() {
      Get.testMode = true;
      SharedPreferences.setMockInitialValues(<String, Object>{});
      MockProgressRepository.instance.resetForTest();
    });

    tearDown(() {
      Get.reset();
      MockProgressRepository.instance.resetForTest();
    });

    CustomSet smallSet() {
      return CustomSet(
        id: 'custom-1',
        name: 'Test Set',
        questions: [
          const MockQuestion(
            id: 'q1',
            subject: MockSubject.english,
            question: 'First question?',
            options: ['A', 'B', 'C', 'D'],
            correctIndex: 0,
          ),
          const MockQuestion(
            id: 'q2',
            subject: MockSubject.english,
            question: 'Second question?',
            options: ['A', 'B', 'C', 'D'],
            correctIndex: 1,
          ),
        ],
      );
    }

    test('submit twice records one attempt, with its durations',
        () async {
      final MockTestController controller = MockTestController();
      controller.selectCustomSet(smallSet());
      controller.selectDuration(const Duration(minutes: 20));
      controller.startTest();
      controller.selectOption(
        controller.engine.questions.first.correctIndex,
      );
      controller.submit();
      // Re-visiting the result screen / pressing submit again must
      // not record a second attempt: submit is guarded by phase.
      controller.submit();
      await controller.flushProgress();

      final List<MockAttempt> attempts =
          MockProgressRepository.instance.attempts;
      expect(attempts.length, 1);
      final MockAttempt attempt = attempts.single;
      expect(attempt.sourceKind, 'custom');
      expect(attempt.sourceLabel, 'Test Set');
      expect(attempt.correct, 1);
      expect(attempt.skipped, 1);
      expect(attempt.score, 1);
      expect(attempt.durationSeconds, 20 * 60);
      expect(attempt.actualDurationSeconds, isNotNull);
      expect(attempt.actualDurationSeconds!, lessThanOrEqualTo(20 * 60));
      expect(attempt.actualDurationSeconds!, greaterThanOrEqualTo(0));
      controller.onClose();
    });

    test('removeAttempt deletes only that attempt', () async {
      final MockProgressRepository repo = MockProgressRepository.instance;
      await repo.recordAttempt(_mock(id: 'attempt-a'));
      await repo.recordAttempt(_mock(id: 'attempt-b'));
      expect(repo.attempts.length, 2);
      await repo.removeAttempt('attempt-a');
      expect(repo.attempts.length, 1);
      expect(repo.attempts.single.id, 'attempt-b');
      // Unknown id is a no-op.
      await repo.removeAttempt('attempt-nope');
      expect(repo.attempts.length, 1);
    });
  });

  group('HistoryRow', () {
    testWidgets('mock row shows score and breakdown, never WPM',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryRow(
              record: TypingTestRecord.fromMockAttempt(_mock()),
              onTap: () {},
              onDelete: () {},
            ),
          ),
        ),
      );
      expect(find.text('Mock test'), findsOneWidget);
      expect(find.text('2 / 100'), findsOneWidget);
      expect(find.text('2% correct'), findsOneWidget);
      expect(
        find.textContaining('Full mock test · 5 minutes'),
        findsOneWidget,
      );
      expect(find.textContaining('2 correct'), findsOneWidget);
      expect(find.textContaining('90 wrong'), findsOneWidget);
      expect(find.textContaining('8 skipped'), findsOneWidget);
      expect(find.textContaining('WPM'), findsNothing);
    });

    testWidgets('typing row is unchanged', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryRow(
              record: _typing(id: 1),
              onTap: () {},
              onDelete: () {},
            ),
          ),
        ),
      );
      expect(find.text('30 WPM'), findsOneWidget);
      expect(find.text('90% acc'), findsOneWidget);
      expect(find.textContaining('11 errors'), findsOneWidget);
    });
  });

  group('Mock setup page recent attempts', () {
    setUp(() {
      MockProgressRepository.instance.resetForTest();
    });

    tearDown(() {
      Get.reset();
      MockProgressRepository.instance.resetForTest();
    });

    testWidgets('shows the latest finished attempt', (tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        MockProgressRepository.attemptsKey:
            jsonEncode([_mock().toJson()]),
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
      expect(find.text('2 / 100'), findsOneWidget);
      expect(find.text('View all in History'), findsOneWidget);
    });

    testWidgets('empty state says nothing is recorded yet', (tester) async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          initialRoute: AppRoutes.ppscMockTest,
          getPages: AppPages.pages,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Your Recent Attempts'), findsOneWidget);
      expect(find.textContaining('No mock attempts yet'), findsOneWidget);
    });
  });
}
