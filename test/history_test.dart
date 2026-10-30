import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/features/history/controller/history_controller.dart';
import 'package:typing_master/features/history/model/history_filters.dart';
import 'package:typing_master/features/history/model/typing_test_record.dart';
import 'package:typing_master/features/typing_test/model/typing_language.dart';
import 'package:typing_master/features/typing_test/model/typing_test_kind.dart';

TypingTestRecord _t({
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

void main() {
  final DateTime now = DateTime(2026, 1, 20, 12);

  group('Language filtering', () {
    final list = [
      _t(id: 1, language: TypingLanguage.english),
      _t(id: 2, language: TypingLanguage.urdu),
    ];

    test('English filter keeps only English tests', () {
      final result = HistoryController.applyFilters(
        list,
        language: HistoryLanguageFilter.english,
        testType: HistoryTestTypeFilter.all,
        duration: HistoryDurationFilter.all,
        date: HistoryDateFilter.allTime,
        sort: HistorySort.newestFirst,
        query: '',
        now: now,
      );
      expect(result.length, 1);
      expect(result.first.language, TypingLanguage.english);
    });
  });

  group('Test type filtering', () {
    final list = [
      _t(id: 1, testType: TypingTestKind.normal),
      _t(id: 2, testType: TypingTestKind.ppsc, language: TypingLanguage.urdu),
    ];

    test('PPSC filter keeps only PPSC tests', () {
      final result = HistoryController.applyFilters(
        list,
        language: HistoryLanguageFilter.all,
        testType: HistoryTestTypeFilter.ppsc,
        duration: HistoryDurationFilter.all,
        date: HistoryDateFilter.allTime,
        sort: HistorySort.newestFirst,
        query: '',
        now: now,
      );
      expect(result.length, 1);
      expect(result.first.testType, TypingTestKind.ppsc);
    });
  });

  group('Duration filtering', () {
    final list = [
      _t(id: 1, durationSeconds: 60),
      _t(id: 2, durationSeconds: 300),
      _t(id: 3, durationSeconds: 45), // not a preset
    ];

    test('exact preset duration matches only that duration', () {
      final result = HistoryController.applyFilters(
        list,
        language: HistoryLanguageFilter.all,
        testType: HistoryTestTypeFilter.all,
        duration: HistoryDurationFilter.minute1,
        date: HistoryDateFilter.allTime,
        sort: HistorySort.newestFirst,
        query: '',
        now: now,
      );
      expect(result.length, 1);
      expect(result.first.durationSeconds, 60);
    });

    test('custom duration matches only non-preset durations', () {
      final result = HistoryController.applyFilters(
        list,
        language: HistoryLanguageFilter.all,
        testType: HistoryTestTypeFilter.all,
        duration: HistoryDurationFilter.custom,
        date: HistoryDateFilter.allTime,
        sort: HistorySort.newestFirst,
        query: '',
        now: now,
      );
      expect(result.length, 1);
      expect(result.first.durationSeconds, 45);
    });
  });

  group('Date filtering', () {
    final list = [
      _t(id: 1, completedAt: DateTime(2026, 1, 20, 8)), // today
      _t(id: 2, completedAt: DateTime(2026, 1, 15)), // 5 days ago
      _t(id: 3, completedAt: DateTime(2025, 12, 1)), // way older
    ];

    test('Today keeps only tests completed today', () {
      final result = HistoryController.applyFilters(
        list,
        language: HistoryLanguageFilter.all,
        testType: HistoryTestTypeFilter.all,
        duration: HistoryDurationFilter.all,
        date: HistoryDateFilter.today,
        sort: HistorySort.newestFirst,
        query: '',
        now: now,
      );
      expect(result.length, 1);
      expect(result.first.id, 1);
    });

    test('Last 7 Days includes today and 5-days-ago but not the old one', () {
      final result = HistoryController.applyFilters(
        list,
        language: HistoryLanguageFilter.all,
        testType: HistoryTestTypeFilter.all,
        duration: HistoryDurationFilter.all,
        date: HistoryDateFilter.last7Days,
        sort: HistorySort.newestFirst,
        query: '',
        now: now,
      );
      expect(result.length, 2);
    });

    test('All Time includes everything', () {
      final result = HistoryController.applyFilters(
        list,
        language: HistoryLanguageFilter.all,
        testType: HistoryTestTypeFilter.all,
        duration: HistoryDurationFilter.all,
        date: HistoryDateFilter.allTime,
        sort: HistorySort.newestFirst,
        query: '',
        now: now,
      );
      expect(result.length, 3);
    });
  });

  group('Sorting', () {
    final list = [
      _t(id: 1, netWpm: 30, accuracy: 90, completedAt: DateTime(2026, 1, 5)),
      _t(id: 2, netWpm: 50, accuracy: 80, completedAt: DateTime(2026, 1, 15)),
      _t(id: 3, netWpm: 40, accuracy: 95, completedAt: DateTime(2026, 1, 10)),
    ];

    test('newest first', () {
      final result = HistoryController.applyFilters(
        list,
        language: HistoryLanguageFilter.all,
        testType: HistoryTestTypeFilter.all,
        duration: HistoryDurationFilter.all,
        date: HistoryDateFilter.allTime,
        sort: HistorySort.newestFirst,
        query: '',
        now: now,
      );
      expect(result.map((t) => t.id).toList(), [2, 3, 1]);
    });

    test('highest WPM first', () {
      final result = HistoryController.applyFilters(
        list,
        language: HistoryLanguageFilter.all,
        testType: HistoryTestTypeFilter.all,
        duration: HistoryDurationFilter.all,
        date: HistoryDateFilter.allTime,
        sort: HistorySort.highestWpm,
        query: '',
        now: now,
      );
      expect(result.map((t) => t.id).toList(), [2, 3, 1]);
    });

    test('highest accuracy first', () {
      final result = HistoryController.applyFilters(
        list,
        language: HistoryLanguageFilter.all,
        testType: HistoryTestTypeFilter.all,
        duration: HistoryDurationFilter.all,
        date: HistoryDateFilter.allTime,
        sort: HistorySort.highestAccuracy,
        query: '',
        now: now,
      );
      expect(result.map((t) => t.id).toList(), [3, 1, 2]);
    });
  });
}
