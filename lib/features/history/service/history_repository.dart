import 'package:get/get.dart';

import '../../../core/database/app_database.dart';
import '../../../core/services/data_refresh_service.dart';
import '../../../core/services/db_change_broadcast.dart';
import '../../typing_test/model/typing_language.dart';
import '../../typing_test/model/typing_test_kind.dart';
import '../model/typing_test_record.dart';

/// Reads completed tests straight from the existing `TypingTests` table —
/// this IS the history source, no separate history table exists (spec
/// section 18).
class HistoryRepository {
  HistoryRepository._();
  static final HistoryRepository instance = HistoryRepository._();

  AppDatabase get _db => Get.find<AppDatabase>();

  Future<List<TypingTestRecord>> fetchAll() async {
    final rows = await _db.select(_db.typingTests).get();
    return [for (final r in rows) _mapRow(r)];
  }

  TypingTestRecord _mapRow(dynamic r) {
    return TypingTestRecord(
      id: r.id,
      language: r.language == TypingLanguage.urdu.code
          ? TypingLanguage.urdu
          : TypingLanguage.english,
      testType: TypingTestKind.fromDbValue(r.testType),
      durationSeconds: r.durationSeconds,
      actualDurationSeconds: r.actualDurationSeconds,
      grossWpm: r.grossWpm,
      netWpm: r.netWpm,
      accuracy: r.accuracy,
      correctCharacters: r.correctCharacters,
      wrongCharacters: r.wrongCharacters,
      correctWords: r.correctWords,
      wrongWords: r.wrongWords,
      skippedWords: r.skippedWords,
      backspaces: r.backspaces,
      totalErrors: r.totalErrors,
      completedAt: r.completedAt,
    );
  }

  /// Plain display lines for every mistake tied to [testId] — reuses the
  /// existing `Mistakes` table, never duplicates this data (spec section
  /// 5: "Do not duplicate mistake data").
  Future<List<String>> fetchMistakeLines(int testId) async {
    final rows = await (_db.select(_db.mistakes)
          ..where((m) => m.testId.equals(testId)))
        .get();
    return [
      for (final m in rows)
        if (m.isSkippedWord)
          'Skipped word: "${m.expectedCharacter}"'
        else if (m.isWrongWord)
          'Wrong word: expected "${m.expectedCharacter}", typed "${m.typedCharacter}"'
        else
          'Expected "${m.expectedCharacter}", typed "${m.typedCharacter}"',
    ];
  }

  /// Deletes a test AND its mistake rows together. `Mistakes.testId`
  /// has a foreign key to `TypingTests`, so with foreign keys enforced
  /// the mistakes must go first (spec section 6).
  ///
  /// The two deletes run SEQUENTIALLY, deliberately NOT inside
  /// `transaction()`: drift 2.35.0's web delegate (`_WasmDelegate`)
  /// flushes the IndexedDB file system after a write only when
  /// `isInTransaction` is false, so a delete inside a transaction
  /// sits unflushed in this tab's memory until the next
  /// non-transaction write or a `close()` — and nothing in the app
  /// closes the database on tab close. Sequential deletes each flush,
  /// so the row is really gone from IndexedDB (and visible as gone to
  /// other tabs) the moment this returns. The failure window this
  /// opens is narrow and benign: if the second delete threw, the
  /// mistakes would already be gone while the test remained — no
  /// orphan rows, just a test with no mistake lines.
  Future<void> deleteTest(int testId) async {
    await (_db.delete(_db.mistakes)..where((m) => m.testId.equals(testId)))
        .go();
    await (_db.delete(_db.typingTests)..where((t) => t.id.equals(testId)))
        .go();
    // Dashboard and Progress recalculate from the remaining tests.
    DataRefreshService.notifyChanged();
    DbChangeBroadcast.notify();
  }
}
