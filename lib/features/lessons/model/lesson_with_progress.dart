import 'lesson_definition.dart';

/// A lesson combined with this user's progress on it — what the Lessons
/// Dashboard and Lesson Practice screen actually work with. [dbId] is the
/// row id in the `Lessons` table (needed to write to `LessonProgress`);
/// everything else about the content comes from [definition].
class LessonWithProgress {
  const LessonWithProgress({
    required this.dbId,
    required this.definition,
    required this.completed,
    required this.bestAccuracy,
    required this.bestSpeed,
    required this.attempts,
    required this.lastAttemptAt,
    required this.locked,
  });

  final int dbId;
  final LessonDefinition definition;

  final bool completed;
  final double bestAccuracy;
  final double bestSpeed;
  final int attempts;
  final DateTime? lastAttemptAt;

  /// True until the previous lesson (same language, orderIndex - 1) is
  /// completed. The very first lesson of each language is never locked.
  final bool locked;

  double get progressPercent {
    final double required = definition.effectiveRequiredAccuracy;
    if (required <= 0) return completed ? 100 : 0;
    return (bestAccuracy / required * 100).clamp(0, 100);
  }
}
