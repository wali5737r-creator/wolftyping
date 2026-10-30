import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;

import '../../../core/database/app_database.dart';
import '../../typing_test/model/typing_language.dart';
import '../model/lesson_definition.dart';
import '../model/lesson_with_progress.dart';
import 'english_lesson_definitions.dart';
import 'urdu_lesson_definitions.dart';

/// Bridges the static [EnglishLessonDefinitions]/[UrduLessonDefinitions]
/// content with the existing Drift `Lessons` and `LessonProgress` tables.
///
/// No new tables, no schema changes — `Lessons` seeds itself (once, per
/// language) from the static definitions so `LessonProgress`'s existing
/// foreign key to `Lessons` has real rows to point at; the actual lesson
/// text/rules always come from the definitions, the database only ever
/// stores per-user progress.
class LessonRepository {
  LessonRepository._();
  static final LessonRepository instance = LessonRepository._();

  AppDatabase get _db => Get.find<AppDatabase>();

  Future<int> _ensureDefaultUserId() async {
    final existing = await _db.select(_db.users).get();
    if (existing.isNotEmpty) return existing.first.id;
    return _db.into(_db.users).insert(const UsersCompanion());
  }

  List<LessonDefinition> _definitionsFor(TypingLanguage language) {
    return language == TypingLanguage.english
        ? EnglishLessonDefinitions.all
        : UrduLessonDefinitions.all;
  }

  /// Keeps the `Lessons` rows in step with the built-in definitions (matched
  /// by language + orderIndex): inserts missing lessons, updates changed
  /// ones and removes rows that no longer exist. When a lesson's title or
  /// drill text changed, the saved progress for that row is dropped too,
  /// because "lesson 5 completed" no longer describes the same lesson.
  /// Unchanged lessons keep their progress.
  Future<void> _ensureSeeded(TypingLanguage language) async {
    final List<LessonDefinition> defs = _definitionsFor(language);
    final rows = await (_db.select(_db.lessons)
          ..where((t) => t.language.equals(language.code)))
        .get();
    final Map<int, Lesson> byOrder = {for (final r in rows) r.orderIndex: r};
    final Set<int> definedOrders = {for (final d in defs) d.orderIndex};

    await _db.transaction(() async {
      for (final LessonDefinition d in defs) {
        final Lesson? row = byOrder[d.orderIndex];
        if (row == null) {
          await _db.into(_db.lessons).insert(LessonsCompanion(
                title: Value(d.title),
                language: Value(d.language.code),
                level: Value(d.level.name),
                orderIndex: Value(d.orderIndex),
                content: Value(d.content),
                requiredAccuracy: Value(d.effectiveRequiredAccuracy),
                requiredWpm: Value(d.requiredWpm),
              ));
          continue;
        }
        final bool textChanged =
            row.title != d.title || row.content != d.content;
        final bool rulesChanged = row.level != d.level.name ||
            row.requiredAccuracy != d.effectiveRequiredAccuracy ||
            row.requiredWpm != d.requiredWpm;
        if (!textChanged && !rulesChanged) continue;
        if (textChanged) {
          await (_db.delete(_db.lessonProgress)
                ..where((t) => t.lessonId.equals(row.id)))
              .go();
        }
        await (_db.update(_db.lessons)..where((t) => t.id.equals(row.id)))
            .write(LessonsCompanion(
          title: Value(d.title),
          level: Value(d.level.name),
          content: Value(d.content),
          requiredAccuracy: Value(d.effectiveRequiredAccuracy),
          requiredWpm: Value(d.requiredWpm),
        ));
      }
      for (final Lesson row in rows) {
        if (definedOrders.contains(row.orderIndex)) continue;
        await (_db.delete(_db.lessonProgress)
              ..where((t) => t.lessonId.equals(row.id)))
            .go();
        await (_db.delete(_db.lessons)..where((t) => t.id.equals(row.id)))
            .go();
      }
    });
  }

  /// All lessons for [language], in order, combined with this user's
  /// progress and computed lock state. Seeds the `Lessons` table on first
  /// call for that language.
  Future<List<LessonWithProgress>> fetchLessons(
      TypingLanguage language) async {
    await _ensureSeeded(language);
    final int userId = await _ensureDefaultUserId();
    final List<LessonDefinition> defs = _definitionsFor(language);

    final lessonRows = await (_db.select(_db.lessons)
          ..where((t) => t.language.equals(language.code))
          ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
        .get();

    final progressRows = await (_db.select(_db.lessonProgress)
          ..where((t) => t.userId.equals(userId)))
        .get();
    final progressByLessonId = {for (final p in progressRows) p.lessonId: p};

    final List<LessonWithProgress> result = [];
    bool previousCompleted = true; // the first lesson is never locked
    for (final row in lessonRows) {
      final LessonDefinition def = defs.firstWhere(
        (d) => d.orderIndex == row.orderIndex,
        orElse: () => defs.first,
      );
      final progress = progressByLessonId[row.id];
      final bool completed = progress?.completed ?? false;

      result.add(LessonWithProgress(
        dbId: row.id,
        definition: def,
        completed: completed,
        bestAccuracy: progress?.bestAccuracy ?? 0,
        bestSpeed: progress?.bestSpeed ?? 0,
        attempts: progress?.attempts ?? 0,
        lastAttemptAt: progress?.lastAttemptAt,
        locked: !previousCompleted,
      ));
      previousCompleted = completed;
    }
    return result;
  }

  /// Records one attempt at [lesson]. Attempts always increase; best
  /// accuracy/speed only move up, never down (spec section 6); completed
  /// becomes true the first time an attempt meets the lesson's
  /// requirements and stays true afterward even if a later attempt is
  /// worse.
  Future<void> saveAttempt({
    required LessonWithProgress lesson,
    required double accuracy,
    required double wpm,
  }) async {
    final int userId = await _ensureDefaultUserId();

    final existing = await (_db.select(_db.lessonProgress)
          ..where((t) =>
              t.userId.equals(userId) & t.lessonId.equals(lesson.dbId)))
        .getSingleOrNull();

    final bool passedThisAttempt =
        accuracy >= lesson.definition.effectiveRequiredAccuracy &&
            (lesson.definition.requiredWpm == 0 ||
                wpm >= lesson.definition.requiredWpm);

    final double newBestAccuracy = existing == null
        ? accuracy
        : (accuracy > existing.bestAccuracy
            ? accuracy
            : existing.bestAccuracy);
    final double newBestSpeed = existing == null
        ? wpm
        : (wpm > existing.bestSpeed ? wpm : existing.bestSpeed);
    final int newAttempts = (existing?.attempts ?? 0) + 1;
    final bool newCompleted =
        (existing?.completed ?? false) || passedThisAttempt;

    final companion = LessonProgressCompanion(
      userId: Value(userId),
      lessonId: Value(lesson.dbId),
      completed: Value(newCompleted),
      bestAccuracy: Value(newBestAccuracy),
      bestSpeed: Value(newBestSpeed),
      attempts: Value(newAttempts),
      lastAttemptAt: Value(DateTime.now()),
    );

    if (existing == null) {
      await _db.into(_db.lessonProgress).insert(companion);
    } else {
      await (_db.update(_db.lessonProgress)
            ..where((t) => t.id.equals(existing.id)))
          .write(companion);
    }
  }
}
