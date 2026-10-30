import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;

import '../../../core/database/app_database.dart';
import '../../../core/services/data_refresh_service.dart';
import '../model/mistake_record.dart';
import '../model/typing_language.dart';
import '../model/typing_snapshot.dart';
import '../model/typing_test_kind.dart';

/// Persists a completed typing attempt into the existing `TypingTests`
/// and `Mistakes` Drift tables — no new tables, only the additive
/// `Mistakes.isWrongWord` column added for the Practice + Mistake
/// Analysis feature (schemaVersion 2).
///
/// Shared by English, Urdu and PPSC controllers, so Mistake Analysis has
/// real saved data to analyze regardless of which mode the user practices
/// in — Practice's whole purpose depends on this existing.
class TypingResultRepository {
  TypingResultRepository._();
  static final TypingResultRepository instance = TypingResultRepository._();

  AppDatabase get _db => Get.find<AppDatabase>();

  /// Returns the id of the single local profile row, creating it with all
  /// default values if it doesn't exist yet (v1 has no login/profile
  /// creation flow, but `TypingTests.userId` is a required foreign key).
  Future<int> _ensureDefaultUserId() async {
    final existing = await _db.select(_db.users).get();
    if (existing.isNotEmpty) return existing.first.id;
    return _db.into(_db.users).insert(const UsersCompanion());
  }

  /// Saves one completed attempt and its mistake records. Never throws to
  /// the caller — a failed save (e.g. the database isn't ready) is logged
  /// and swallowed rather than crashing the result screen, since the
  /// in-memory result the user is looking at is still correct either way.
  Future<void> saveCompletedTest({
    required TypingSnapshot snapshot,
    required TypingLanguage language,
    required TypingTestKind kind,
    required Duration? plannedDuration,
    List<MistakeRecord> mistakes = const [],
  }) async {
    try {
      final int userId = await _ensureDefaultUserId();
      final int testId = await _db.into(_db.typingTests).insert(
            TypingTestsCompanion(
              userId: Value(userId),
              language: Value(language.code),
              testType: Value(kind.dbValue),
              durationSeconds: Value(plannedDuration?.inSeconds),
              actualDurationSeconds: Value(snapshot.elapsed.inSeconds),
              grossWpm: Value(snapshot.grossWpm),
              netWpm: Value(snapshot.netWpm),
              accuracy: Value(snapshot.accuracy),
              correctCharacters: Value(snapshot.correctCharacters),
              wrongCharacters: Value(snapshot.wrongCharacters),
              correctWords: Value(snapshot.correctWords),
              wrongWords: Value(snapshot.wrongWords),
              skippedWords: Value(snapshot.skippedWords),
              backspaces: Value(snapshot.backspaces),
              correctedMistakes: Value(snapshot.correctedMistakes),
              uncorrectedMistakes: Value(snapshot.wrongCharacters),
              totalErrors: Value(snapshot.totalErrors),
            ),
          );

      if (mistakes.isNotEmpty) {
        await _db.batch((batch) {
          batch.insertAll(_db.mistakes, [
            for (final MistakeRecord m in mistakes)
              MistakesCompanion(
                testId: Value(testId),
                expectedCharacter: Value(m.expectedCharacter),
                typedCharacter: Value(m.typedCharacter),
                position: Value(m.position),
                wordIndex: Value(m.wordIndex),
                isSkippedWord: Value(m.isSkippedWord),
                isWrongWord: Value(m.isWrongWord),
              ),
          ]);
        });
      }
      // Dashboard / Progress / History reload now that this test is stored.
      DataRefreshService.notifyChanged();
    } catch (error) {
      // ignore: avoid_print
      print('TypingResultRepository: failed to save result — $error');
    }
  }
}
