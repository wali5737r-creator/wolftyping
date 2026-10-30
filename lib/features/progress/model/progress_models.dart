import '../../history/model/typing_test_record.dart';

/// Aggregated stats for one language slice (English, Urdu, or PPSC-only).
class LanguageStats {
  const LanguageStats({
    required this.tests,
    required this.bestWpm,
    required this.averageWpm,
    required this.bestAccuracy,
    required this.averageAccuracy,
    required this.practiceSeconds,
    required this.totalErrors,
    this.skippedWords = 0,
  });

  final int tests;
  final double bestWpm;
  final double averageWpm;
  final double bestAccuracy;
  final double averageAccuracy;
  final int practiceSeconds;
  final int totalErrors;
  final int skippedWords;

  static const LanguageStats empty = LanguageStats(
    tests: 0,
    bestWpm: 0,
    averageWpm: 0,
    bestAccuracy: 0,
    averageAccuracy: 0,
    practiceSeconds: 0,
    totalErrors: 0,
  );
}

/// One point on the WPM or Accuracy chart — a real completed test, never
/// a fabricated data point (spec section 10: "Do not plot fake points").
class ChartPoint {
  const ChartPoint({required this.date, required this.value});

  final DateTime date;
  final double value;
}

/// Best-record cards (spec section 13). Each field is null when there's
/// no data for it yet — the UI shows nothing rather than a fake record.
class BestRecords {
  const BestRecords({
    this.bestWpmTest,
    this.bestAccuracyTest,
    this.longestPracticeTest,
    this.mostErrorsTest,
  });

  final TypingTestRecord? bestWpmTest;
  final TypingTestRecord? bestAccuracyTest;
  final TypingTestRecord? longestPracticeTest;
  final TypingTestRecord? mostErrorsTest;
}

/// First-vs-latest comparison (spec section 14). [hasEnoughData] requires
/// at least two completed tests — with only one, there's nothing to
/// compare against.
class ImprovementData {
  const ImprovementData({
    this.firstWpm,
    this.latestWpm,
    this.firstAccuracy,
    this.latestAccuracy,
  });

  final double? firstWpm;
  final double? latestWpm;
  final double? firstAccuracy;
  final double? latestAccuracy;

  bool get hasEnoughData =>
      firstWpm != null &&
      latestWpm != null &&
      firstAccuracy != null &&
      latestAccuracy != null;

  double get wpmChange => (latestWpm ?? 0) - (firstWpm ?? 0);
  double get accuracyChange => (latestAccuracy ?? 0) - (firstAccuracy ?? 0);
}

/// Streak data, computed directly from distinct practice dates in
/// TypingTests (see class doc on ProgressCalculations for why this
/// doesn't use the currently-unpopulated Streaks/DailyProgress tables).
class StreakData {
  const StreakData({
    required this.currentStreak,
    required this.longestStreak,
    required this.practiceDays,
  });

  final int currentStreak;
  final int longestStreak;
  final int practiceDays;

  static const StreakData empty =
      StreakData(currentStreak: 0, longestStreak: 0, practiceDays: 0);
}

/// Today's practice time against the user's daily goal (spec section 16).
class DailyGoalData {
  const DailyGoalData({
    required this.practicedSeconds,
    required this.goalSeconds,
  });

  final int practicedSeconds;
  final int goalSeconds;

  double get progressPercent => goalSeconds <= 0
      ? 0
      : (practicedSeconds / goalSeconds * 100).clamp(0, 100);
}

/// Lesson progress summary (spec section 26) — kept logically separate
/// from typing-test progress, sourced entirely from `LessonProgress`.
class LessonProgressSummary {
  const LessonProgressSummary({
    required this.completedCount,
    required this.inProgressCount,
    required this.bestLessonWpm,
    required this.bestLessonAccuracy,
  });

  final int completedCount;
  final int inProgressCount;
  final double bestLessonWpm;
  final double bestLessonAccuracy;

  static const LessonProgressSummary empty = LessonProgressSummary(
    completedCount: 0,
    inProgressCount: 0,
    bestLessonWpm: 0,
    bestLessonAccuracy: 0,
  );
}
