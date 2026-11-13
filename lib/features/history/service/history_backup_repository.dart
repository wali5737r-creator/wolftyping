import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;

import '../../../core/database/app_database.dart';
import '../../../core/services/data_refresh_service.dart';
import '../../../core/services/db_change_broadcast.dart';
import '../../progress/service/progress_repository.dart';
import 'history_backup.dart';

/// Reads the whole history out of the database for export, and writes
/// a validated backup back in on import.
///
/// No new tables: the backup is a file, the data stays in the existing
/// `TypingTests`, `Mistakes` and `LessonProgress` tables. Foreign keys
/// are enforced (`PRAGMA foreign_keys = ON`), so a restore never
/// writes a `paragraphId` or `lessonId` that does not exist on this
/// device — a missing paragraph is dropped to null, a missing lesson
/// is skipped, and both are counted in the result.
class HistoryBackupRepository {
  HistoryBackupRepository._();
  static final HistoryBackupRepository instance =
      HistoryBackupRepository._();

  AppDatabase get _db => Get.find<AppDatabase>();

  /// Collects everything the backup file holds, oldest test first.
  /// Reads the raw `TypingTests` rows (not `TypingTestRecord`) so the
  /// export keeps every stored field.
  Future<HistoryBackup> collect() async {
    final testRows = await (_db.select(_db.typingTests)
          ..orderBy([
            (t) => OrderingTerm(expression: t.completedAt),
          ]))
        .get();
    final mistakeRows = await _db.select(_db.mistakes).get();
    final lessonRows = await _db.select(_db.lessonProgress).get();
    final int goal = await ProgressRepository.instance.fetchDailyGoalSeconds();

    final Map<int, List<BackupMistake>> mistakesByTest = <int, List<BackupMistake>>{};
    for (final m in mistakeRows) {
      (mistakesByTest[m.testId] ??= <BackupMistake>[]).add(
        BackupMistake(
          expectedCharacter: m.expectedCharacter,
          typedCharacter: m.typedCharacter,
          count: m.count,
          position: m.position,
          wordIndex: m.wordIndex,
          isSkippedWord: m.isSkippedWord,
          isWrongWord: m.isWrongWord,
        ),
      );
    }

    return HistoryBackup(
      app: HistoryBackup.expectedApp,
      formatVersion: HistoryBackup.currentFormatVersion,
      exportedAt: DateTime.now(),
      dailyGoalSeconds: goal,
      tests: [
        for (final r in testRows)
          BackupTest(
            language: r.language,
            testType: r.testType,
            paragraphId: r.paragraphId,
            durationSeconds: r.durationSeconds,
            actualDurationSeconds: r.actualDurationSeconds,
            grossWpm: r.grossWpm,
            netWpm: r.netWpm,
            accuracy: r.accuracy,
            keystrokeAccuracy: r.keystrokeAccuracy,
            correctCharacters: r.correctCharacters,
            wrongCharacters: r.wrongCharacters,
            correctWords: r.correctWords,
            wrongWords: r.wrongWords,
            skippedWords: r.skippedWords,
            backspaces: r.backspaces,
            correctedMistakes: r.correctedMistakes,
            uncorrectedMistakes: r.uncorrectedMistakes,
            totalErrors: r.totalErrors,
            completedAt: r.completedAt,
            mistakes: mistakesByTest[r.id] ?? const <BackupMistake>[],
          ),
      ],
      lessons: [
        for (final r in lessonRows)
          BackupLesson(
            lessonId: r.lessonId,
            completed: r.completed,
            bestAccuracy: r.bestAccuracy,
            bestSpeed: r.bestSpeed,
            attempts: r.attempts,
            lastAttemptAt: r.lastAttemptAt,
          ),
      ],
    );
  }

  /// Writes a parsed backup into the database, in one transaction.
  /// Tests already present (same [BackupTest.duplicateKey]) are
  /// skipped, never duplicated; lesson rows are merged keeping the
  /// better side (see [BackupLesson.mergedWith]). The daily goal is
  /// NOT changed by an import — it is exported for reference only.
  Future<HistoryImportResult> restore(HistoryBackup backup) async {
    int importedTests = 0;
    int skippedDuplicates = 0;
    int importedMistakes = 0;
    int mergedLessons = 0;
    int skippedLessons = 0;

    await _db.transaction(() async {
      final int userId = await _ensureDefaultUserId();

      final existingTests = await _db.select(_db.typingTests).get();
      final Set<String> existingKeys = {
        for (final r in existingTests)
          BackupTest(
            language: r.language,
            testType: r.testType,
            paragraphId: r.paragraphId,
            durationSeconds: r.durationSeconds,
            actualDurationSeconds: r.actualDurationSeconds,
            grossWpm: r.grossWpm,
            netWpm: r.netWpm,
            accuracy: r.accuracy,
            keystrokeAccuracy: r.keystrokeAccuracy,
            correctCharacters: r.correctCharacters,
            wrongCharacters: r.wrongCharacters,
            correctWords: r.correctWords,
            wrongWords: r.wrongWords,
            skippedWords: r.skippedWords,
            backspaces: r.backspaces,
            correctedMistakes: r.correctedMistakes,
            uncorrectedMistakes: r.uncorrectedMistakes,
            totalErrors: r.totalErrors,
            completedAt: r.completedAt,
            mistakes: const <BackupMistake>[],
          ).duplicateKey,
      };
      final Set<int> paragraphIds = {
        for (final p in await _db.select(_db.paragraphs).get()) p.id,
      };
      final Set<int> lessonIds = {
        for (final l in await _db.select(_db.lessons).get()) l.id,
      };

      for (final BackupTest test in backup.tests) {
        if (existingKeys.contains(test.duplicateKey)) {
          skippedDuplicates++;
          continue;
        }
        final int testId = await _db.into(_db.typingTests).insert(
              TypingTestsCompanion(
                userId: Value(userId),
                language: Value(test.language),
                testType: Value(test.testType),
                paragraphId: Value(
                  test.paragraphId != null &&
                          paragraphIds.contains(test.paragraphId)
                      ? test.paragraphId
                      : null,
                ),
                durationSeconds: Value(test.durationSeconds),
                actualDurationSeconds: Value(test.actualDurationSeconds),
                grossWpm: Value(test.grossWpm),
                netWpm: Value(test.netWpm),
                accuracy: Value(test.accuracy),
                keystrokeAccuracy: Value(test.keystrokeAccuracy),
                correctCharacters: Value(test.correctCharacters),
                wrongCharacters: Value(test.wrongCharacters),
                correctWords: Value(test.correctWords),
                wrongWords: Value(test.wrongWords),
                skippedWords: Value(test.skippedWords),
                backspaces: Value(test.backspaces),
                correctedMistakes: Value(test.correctedMistakes),
                uncorrectedMistakes: Value(test.uncorrectedMistakes),
                totalErrors: Value(test.totalErrors),
                completedAt: Value(test.completedAt),
              ),
            );
        importedTests++;
        existingKeys.add(test.duplicateKey);
        if (test.mistakes.isNotEmpty) {
          await _db.batch((batch) {
            batch.insertAll(_db.mistakes, [
              for (final m in test.mistakes)
                MistakesCompanion(
                  testId: Value(testId),
                  expectedCharacter: Value(m.expectedCharacter),
                  typedCharacter: Value(m.typedCharacter),
                  count: Value(m.count),
                  position: Value(m.position),
                  wordIndex: Value(m.wordIndex),
                  isSkippedWord: Value(m.isSkippedWord),
                  isWrongWord: Value(m.isWrongWord),
                ),
            ]);
          });
          importedMistakes += test.mistakes.length;
        }
      }

      for (final BackupLesson lesson in backup.lessons) {
        if (!lessonIds.contains(lesson.lessonId)) {
          skippedLessons++;
          continue;
        }
        final existing = await (_db.select(_db.lessonProgress)
              ..where(
                (l) =>
                    l.userId.equals(userId) &
                    l.lessonId.equals(lesson.lessonId),
              ))
            .getSingleOrNull();
        if (existing == null) {
          await _db.into(_db.lessonProgress).insert(
                LessonProgressCompanion(
                  userId: Value(userId),
                  lessonId: Value(lesson.lessonId),
                  completed: Value(lesson.completed),
                  bestAccuracy: Value(lesson.bestAccuracy),
                  bestSpeed: Value(lesson.bestSpeed),
                  attempts: Value(lesson.attempts),
                  lastAttemptAt: Value(lesson.lastAttemptAt),
                ),
              );
        } else {
          final BackupLesson merged = BackupLesson(
            lessonId: existing.lessonId,
            completed: existing.completed,
            bestAccuracy: existing.bestAccuracy,
            bestSpeed: existing.bestSpeed,
            attempts: existing.attempts,
            lastAttemptAt: existing.lastAttemptAt,
          ).mergedWith(lesson);
          await (_db.update(_db.lessonProgress)
                ..where(
                  (l) =>
                      l.userId.equals(userId) &
                      l.lessonId.equals(lesson.lessonId),
                ))
              .write(
            LessonProgressCompanion(
              completed: Value(merged.completed),
              bestAccuracy: Value(merged.bestAccuracy),
              bestSpeed: Value(merged.bestSpeed),
              attempts: Value(merged.attempts),
              lastAttemptAt: Value(merged.lastAttemptAt),
            ),
          );
        }
        mergedLessons++;
      }
    });

    // The restore ran inside transaction(), whose writes drift 2.35.0's
    // web delegate never flushes to IndexedDB — force that flush now,
    // BEFORE broadcasting, or other tabs would re-read a file that
    // does not have the restored rows yet.
    await _db.flushAfterTransaction();

    // History, Dashboard and Progress recalculate from the new rows.
    DataRefreshService.notifyChanged();
    DbChangeBroadcast.notify();
    return HistoryImportResult(
      importedTests: importedTests,
      skippedDuplicates: skippedDuplicates,
      importedMistakes: importedMistakes,
      mergedLessons: mergedLessons,
      skippedLessons: skippedLessons,
    );
  }

  /// Same as `TypingResultRepository._ensureDefaultUserId`: the single
  /// local profile row, created with defaults if it does not exist yet.
  Future<int> _ensureDefaultUserId() async {
    final existing = await _db.select(_db.users).get();
    if (existing.isNotEmpty) return existing.first.id;
    return _db.into(_db.users).insert(const UsersCompanion());
  }
}

/// What an import actually did — shown on the History screen so the
/// user can see duplicates were skipped, not silently lost.
class HistoryImportResult {
  const HistoryImportResult({
    required this.importedTests,
    required this.skippedDuplicates,
    required this.importedMistakes,
    required this.mergedLessons,
    required this.skippedLessons,
  });

  final int importedTests;
  final int skippedDuplicates;
  final int importedMistakes;
  final int mergedLessons;
  final int skippedLessons;
}
