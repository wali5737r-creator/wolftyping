import 'package:drift/drift.dart';
import 'users_table.dart';
import 'paragraphs_table.dart';

/// A single completed (or manually stopped) typing session result.
///
/// Covers: Typing Test, PPSC Urdu tests, Lessons, and timed Practice —
/// distinguished by [testType] — so History/Progress can query everything
/// from one table while still filtering "English vs Urdu vs PPSC vs
/// Lessons vs Practice" as required by the History Filters spec.
class TypingTests extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get userId => integer().references(Users, #id)();

  /// 'en' or 'ur'
  TextColumn get language => text()();

  /// 'test' | 'ppsc' | 'lesson' | 'practice'
  TextColumn get testType => text()();

  /// Nullable: a lesson id or practice session may not point at a
  /// Paragraphs row (e.g. generated mistake-practice text).
  IntColumn get paragraphId =>
      integer().nullable().references(Paragraphs, #id)();

  /// Planned duration in seconds (0/null for untimed free practice).
  IntColumn get durationSeconds => integer().nullable()();

  /// Actual elapsed typing time in seconds (excludes paused time).
  IntColumn get actualDurationSeconds => integer()();

  RealColumn get grossWpm => real()();
  RealColumn get netWpm => real()();

  /// Final accuracy shown as the headline result (0-100).
  RealColumn get accuracy => real()();

  /// Keystroke-level accuracy for detailed analytics (0-100), can differ
  /// from [accuracy] once backspace-corrected keystrokes are counted in.
  RealColumn get keystrokeAccuracy => real().withDefault(const Constant(0))();

  IntColumn get correctCharacters => integer()();
  IntColumn get wrongCharacters => integer()();
  IntColumn get correctWords => integer()();
  IntColumn get wrongWords => integer()();
  IntColumn get skippedWords => integer()();

  IntColumn get backspaces => integer().withDefault(const Constant(0))();
  IntColumn get correctedMistakes => integer().withDefault(const Constant(0))();
  IntColumn get uncorrectedMistakes =>
      integer().withDefault(const Constant(0))();

  IntColumn get totalErrors => integer()();

  DateTimeColumn get completedAt =>
      dateTime().withDefault(currentDateAndTime)();
}
