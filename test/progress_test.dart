import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/features/history/model/typing_test_record.dart';
import 'package:typing_master/features/progress/service/progress_calculations.dart';
import 'package:typing_master/features/typing_test/model/typing_language.dart';
import 'package:typing_master/features/typing_test/model/typing_test_kind.dart';

TypingTestRecord _t({
  required int id,
  double netWpm = 30,
  double accuracy = 90,
  int actualDurationSeconds = 60,
  int totalErrors = 5,
  DateTime? completedAt,
}) {
  return TypingTestRecord(
    id: id,
    language: TypingLanguage.english,
    testType: TypingTestKind.normal,
    durationSeconds: 60,
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
    totalErrors: totalErrors,
    completedAt: completedAt ?? DateTime(2026, 1, 1),
  );
}

void main() {
  group('Average / Best WPM and Accuracy', () {
    test('statsFor computes correct best and average values', () {
      final tests = [
        _t(id: 1, netWpm: 20, accuracy: 80),
        _t(id: 2, netWpm: 40, accuracy: 90),
        _t(id: 3, netWpm: 30, accuracy: 100),
      ];
      final stats = ProgressCalculations.statsFor(tests);
      expect(stats.tests, 3);
      expect(stats.bestWpm, 40);
      expect(stats.averageWpm, 30); // (20+40+30)/3
      expect(stats.bestAccuracy, 100);
      expect(stats.averageAccuracy, closeTo(90, 0.01)); // (80+90+100)/3
    });

    test('statsFor on an empty list returns LanguageStats.empty', () {
      final stats = ProgressCalculations.statsFor(const []);
      expect(stats.tests, 0);
      expect(stats.bestWpm, 0);
      expect(stats.averageWpm, 0);
    });
  });

  group('Practice time formatting', () {
    test('formats hours and minutes', () {
      expect(ProgressCalculations.formatPracticeTime(9300), '2h 35m');
      expect(ProgressCalculations.formatPracticeTime(2700), '45m');
      expect(ProgressCalculations.formatPracticeTime(0), '0m');
    });

    test('does not drop seconds: under a minute shows seconds', () {
      expect(ProgressCalculations.formatPracticeTime(30), '30s');
      expect(ProgressCalculations.formatPracticeTime(90), '1m 30s');
      expect(ProgressCalculations.formatPracticeTime(3661), '1h 1m 1s');
    });
  });

  group('Improvement calculation', () {
    test('compares first vs latest chronologically, not by list order', () {
      final tests = [
        _t(id: 2, netWpm: 41, accuracy: 94, completedAt: DateTime(2026, 1, 10)),
        _t(id: 1, netWpm: 32, accuracy: 88, completedAt: DateTime(2026, 1, 1)),
      ];
      final imp = ProgressCalculations.improvement(tests);
      expect(imp.hasEnoughData, isTrue);
      expect(imp.firstWpm, 32);
      expect(imp.latestWpm, 41);
      expect(imp.wpmChange, 9);
      expect(imp.firstAccuracy, 88);
      expect(imp.latestAccuracy, 94);
      expect(imp.accuracyChange, closeTo(6, 0.01));
    });

    test('fewer than 2 tests means not enough data', () {
      final imp = ProgressCalculations.improvement([_t(id: 1)]);
      expect(imp.hasEnoughData, isFalse);
    });
  });

  group('Streak calculation', () {
    test('three consecutive practice days ending today gives streak 3', () {
      final now = DateTime(2026, 1, 3, 18);
      final tests = [
        _t(id: 1, completedAt: DateTime(2026, 1, 1, 9)),
        _t(id: 2, completedAt: DateTime(2026, 1, 2, 9)),
        _t(id: 3, completedAt: DateTime(2026, 1, 3, 9)),
      ];
      final streak = ProgressCalculations.streak(tests, now);
      expect(streak.currentStreak, 3);
      expect(streak.longestStreak, 3);
      expect(streak.practiceDays, 3);
    });

    test('a missing day breaks the current streak', () {
      final now = DateTime(2026, 1, 5, 18);
      final tests = [
        _t(id: 1, completedAt: DateTime(2026, 1, 1)),
        _t(id: 2, completedAt: DateTime(2026, 1, 2)),
        // Jan 3 missing
        _t(id: 3, completedAt: DateTime(2026, 1, 4)),
      ];
      final streak = ProgressCalculations.streak(tests, now);
      // Last practiced Jan 4, "now" is Jan 5 -> current streak counts back
      // from Jan 4 (yesterday relative to now): just Jan 4 itself (Jan 3
      // missing breaks it further back).
      expect(streak.currentStreak, 1);
      expect(streak.longestStreak, 2); // Jan 1-2
    });

    test('no practice today or yesterday means current streak is 0', () {
      final now = DateTime(2026, 1, 10);
      final tests = [_t(id: 1, completedAt: DateTime(2026, 1, 1))];
      final streak = ProgressCalculations.streak(tests, now);
      expect(streak.currentStreak, 0);
    });

    test('multiple tests on the same day count as one practice day', () {
      final now = DateTime(2026, 1, 1, 20);
      final tests = [
        _t(id: 1, completedAt: DateTime(2026, 1, 1, 8)),
        _t(id: 2, completedAt: DateTime(2026, 1, 1, 14)),
      ];
      final streak = ProgressCalculations.streak(tests, now);
      expect(streak.practiceDays, 1);
      expect(streak.currentStreak, 1);
    });
  });

  group('Daily goal calculation', () {
    test("sums only today's actual practice time", () {
      final now = DateTime(2026, 1, 5, 20);
      final tests = [
        _t(id: 1, actualDurationSeconds: 300, completedAt: DateTime(2026, 1, 5, 8)),
        _t(id: 2, actualDurationSeconds: 300, completedAt: DateTime(2026, 1, 5, 14)),
        _t(id: 3, actualDurationSeconds: 600, completedAt: DateTime(2026, 1, 4)),
      ];
      final goal = ProgressCalculations.dailyGoal(tests, 1200, now);
      expect(goal.practicedSeconds, 600);
      expect(goal.goalSeconds, 1200);
      expect(goal.progressPercent, 50);
    });

    test('progress percent is clamped at 100', () {
      final now = DateTime(2026, 1, 5, 20);
      final tests = [
        _t(id: 1, actualDurationSeconds: 2000, completedAt: DateTime(2026, 1, 5)),
      ];
      final goal = ProgressCalculations.dailyGoal(tests, 600, now);
      expect(goal.progressPercent, 100);
    });
  });

  group('Empty state', () {
    test('bestRecords on an empty list has all-null fields', () {
      final records = ProgressCalculations.bestRecords(const []);
      expect(records.bestWpmTest, isNull);
      expect(records.bestAccuracyTest, isNull);
      expect(records.longestPracticeTest, isNull);
      expect(records.mostErrorsTest, isNull);
    });

    test('streak on an empty list is StreakData.empty', () {
      final streak =
          ProgressCalculations.streak(const [], DateTime(2026, 1, 1));
      expect(streak.currentStreak, 0);
      expect(streak.longestStreak, 0);
      expect(streak.practiceDays, 0);
    });
  });

  group('Best records', () {
    test('identifies the correct test for each record type', () {
      final tests = [
        _t(id: 1, netWpm: 20, accuracy: 99, actualDurationSeconds: 30, totalErrors: 1),
        _t(id: 2, netWpm: 50, accuracy: 80, actualDurationSeconds: 600, totalErrors: 20),
        _t(id: 3, netWpm: 35, accuracy: 90, actualDurationSeconds: 60, totalErrors: 5),
      ];
      final records = ProgressCalculations.bestRecords(tests);
      expect(records.bestWpmTest!.id, 2);
      expect(records.bestAccuracyTest!.id, 1);
      expect(records.longestPracticeTest!.id, 2);
      expect(records.mostErrorsTest!.id, 2);
    });
  });
}
