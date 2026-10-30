import 'package:get/get.dart';

import '../../../core/database/app_database.dart';
import '../../history/model/typing_test_record.dart';
import '../../history/service/history_repository.dart';
import '../model/progress_models.dart';

/// Reads the raw data Progress needs from the existing database —
/// `TypingTests` (via the same mapping `HistoryRepository` already uses,
/// no duplicated query logic), `Users.dailyGoalSeconds`, and
/// `LessonProgress`. All the actual math lives in ProgressCalculations,
/// kept separate so it's testable without a database.
class ProgressRepository {
  ProgressRepository._();
  static final ProgressRepository instance = ProgressRepository._();

  AppDatabase get _db => Get.find<AppDatabase>();

  Future<List<TypingTestRecord>> fetchAllTests() =>
      HistoryRepository.instance.fetchAll();

  /// The single local profile's daily goal, in seconds. Falls back to the
  /// `Users` table's own default (600s / 10 minutes) if no profile row
  /// exists yet — never a value hard-coded in a widget (spec section 16).
  Future<int> fetchDailyGoalSeconds() async {
    final rows = await _db.select(_db.users).get();
    if (rows.isEmpty) return 600;
    return rows.first.dailyGoalSeconds;
  }

  Future<LessonProgressSummary> fetchLessonProgressSummary() async {
    final rows = await _db.select(_db.lessonProgress).get();
    if (rows.isEmpty) return LessonProgressSummary.empty;

    final int completed = rows.where((r) => r.completed).length;
    final int inProgress =
        rows.where((r) => !r.completed && r.attempts > 0).length;
    final double bestWpm = rows
        .map((r) => r.bestSpeed)
        .fold<double>(0, (a, b) => a > b ? a : b);
    final double bestAccuracy = rows
        .map((r) => r.bestAccuracy)
        .fold<double>(0, (a, b) => a > b ? a : b);

    return LessonProgressSummary(
      completedCount: completed,
      inProgressCount: inProgress,
      bestLessonWpm: bestWpm,
      bestLessonAccuracy: bestAccuracy,
    );
  }
}
