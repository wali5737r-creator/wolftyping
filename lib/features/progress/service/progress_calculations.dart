import 'package:typing_master/features/progress/model/progress_models.dart';

import '../../history/model/typing_test_record.dart';

/// Every number on the Progress dashboard is computed by a pure static
/// method here — no GetX, no database — so each one is directly unit
/// testable with fixture data (spec section 27).
///
/// Streak/practice-day calculation deliberately reads distinct dates
/// straight from `TypingTests.completedAt` rather than the `Streaks`/
/// `DailyProgress` tables: nothing in the app currently writes to those
/// two tables (no prior phase wired that up), and adding new writes to
/// them would mean touching the English/Urdu/PPSC/Lessons/Practice
/// completion paths in five different controllers — exactly the kind of
/// invasive change this phase's instructions repeatedly warn against.
/// Reading `TypingTests` directly achieves the same real behavior ("a day
/// counts when a test completes") without touching any working feature.
class ProgressCalculations {
  ProgressCalculations._();

  static List<TypingTestRecord> filterByRange(
    List<TypingTestRecord> all,
    DateTime? startDate,
  ) {
    if (startDate == null) return all;
    return all.where((t) => !t.completedAt.isBefore(startDate)).toList();
  }

  static LanguageStats statsFor(List<TypingTestRecord> tests) {
    if (tests.isEmpty) return LanguageStats.empty;
    final List<double> wpms = [for (final t in tests) t.netWpm];
    final List<double> accs = [for (final t in tests) t.accuracy];
    return LanguageStats(
      tests: tests.length,
      bestWpm: wpms.reduce((a, b) => a > b ? a : b),
      averageWpm: wpms.reduce((a, b) => a + b) / wpms.length,
      bestAccuracy: accs.reduce((a, b) => a > b ? a : b),
      averageAccuracy: accs.reduce((a, b) => a + b) / accs.length,
      practiceSeconds:
          tests.fold<int>(0, (sum, t) => sum + t.actualDurationSeconds),
      totalErrors: tests.fold<int>(0, (sum, t) => sum + t.totalErrors),
      skippedWords: tests.fold<int>(0, (sum, t) => sum + t.skippedWords),
    );
  }

  /// All-time best records — deliberately NOT limited by the selected
  /// time range, since "your best ever" is the natural reading of these
  /// cards (spec section 13 gives no range qualifier).
  static BestRecords bestRecords(List<TypingTestRecord> allTests) {
    if (allTests.isEmpty) return const BestRecords();
    TypingTestRecord bestWpm = allTests.first;
    TypingTestRecord bestAcc = allTests.first;
    TypingTestRecord longest = allTests.first;
    TypingTestRecord mostErrors = allTests.first;
    for (final TypingTestRecord t in allTests) {
      if (t.netWpm > bestWpm.netWpm) bestWpm = t;
      if (t.accuracy > bestAcc.accuracy) bestAcc = t;
      if (t.actualDurationSeconds > longest.actualDurationSeconds) {
        longest = t;
      }
      if (t.totalErrors > mostErrors.totalErrors) mostErrors = t;
    }
    return BestRecords(
      bestWpmTest: bestWpm,
      bestAccuracyTest: bestAcc,
      longestPracticeTest: longest,
      mostErrorsTest: mostErrors,
    );
  }

  /// First-ever completed test vs the most recent one, all-time.
  static ImprovementData improvement(List<TypingTestRecord> allTests) {
    if (allTests.length < 2) return const ImprovementData();
    final List<TypingTestRecord> sorted = [...allTests]
      ..sort((a, b) => a.completedAt.compareTo(b.completedAt));
    final TypingTestRecord first = sorted.first;
    final TypingTestRecord latest = sorted.last;
    return ImprovementData(
      firstWpm: first.netWpm,
      latestWpm: latest.netWpm,
      firstAccuracy: first.accuracy,
      latestAccuracy: latest.accuracy,
    );
  }

  /// Current + longest streak, and total distinct practice days, all-time
  /// (a streak is a consecutive-day concept — a selected 7-day chart
  /// window shouldn't silently cap it).
  static StreakData streak(List<TypingTestRecord> allTests, DateTime now) {
    if (allTests.isEmpty) return StreakData.empty;

    final Set<DateTime> dateSet = {
      for (final t in allTests)
        DateTime(t.completedAt.year, t.completedAt.month, t.completedAt.day),
    };
    final List<DateTime> sorted = dateSet.toList()..sort();

    int longest = 1;
    int run = 1;
    for (int i = 1; i < sorted.length; i++) {
      final int diff = sorted[i].difference(sorted[i - 1]).inDays;
      run = diff == 1 ? run + 1 : 1;
      if (run > longest) longest = run;
    }

    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));
    final DateTime lastPracticed = sorted.last;

    int current = 0;
    if (lastPracticed == today || lastPracticed == yesterday) {
      current = 1;
      DateTime cursor = lastPracticed;
      for (int i = sorted.length - 2; i >= 0; i--) {
        final DateTime expectedPrev = cursor.subtract(const Duration(days: 1));
        if (sorted[i] == expectedPrev) {
          current++;
          cursor = sorted[i];
        } else {
          break;
        }
      }
    }

    return StreakData(
      currentStreak: current,
      longestStreak: longest,
      practiceDays: sorted.length,
    );
  }

  /// Sum of actual practice time for tests completed today.
  static DailyGoalData dailyGoal(
    List<TypingTestRecord> allTests,
    int goalSeconds,
    DateTime now,
  ) {
    final DateTime todayStart = DateTime(now.year, now.month, now.day);
    final DateTime tomorrowStart = todayStart.add(const Duration(days: 1));
    final int practicedToday = allTests
        .where((t) =>
            !t.completedAt.isBefore(todayStart) &&
            t.completedAt.isBefore(tomorrowStart))
        .fold<int>(0, (sum, t) => sum + t.actualDurationSeconds);
    return DailyGoalData(
      practicedSeconds: practicedToday,
      goalSeconds: goalSeconds,
    );
  }

  /// Chronologically ordered chart points — [valueOf] picks which
  /// numeric field to plot (WPM or accuracy).
  static List<ChartPoint> chartPoints(
    List<TypingTestRecord> tests, {
    required double Function(TypingTestRecord) valueOf,
  }) {
    final List<TypingTestRecord> sorted = [...tests]
      ..sort((a, b) => a.completedAt.compareTo(b.completedAt));
    return [
      for (final TypingTestRecord t in sorted)
        ChartPoint(date: t.completedAt, value: valueOf(t)),
    ];
  }

  /// Readable practice-time formatting (spec section 12): "2h 35m" or
  /// "45m" — never raw seconds.
  static String formatPracticeTime(int totalSeconds) {
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }
}
