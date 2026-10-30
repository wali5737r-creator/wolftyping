import 'package:drift/drift.dart';
import 'typing_tests_table.dart';

/// One row per distinct mistake event tied to a completed test. Aggregating
/// this table by [expectedCharacter] powers "Weak Keys" / the keyboard
/// heatmap and "Practice My Mistakes".
class Mistakes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get testId => integer().references(TypingTests, #id)();

  /// The character the user was supposed to type.
  TextColumn get expectedCharacter => text()();

  /// What the user actually typed instead (empty string for a skipped
  /// character within a skipped word).
  TextColumn get typedCharacter => text().withDefault(const Constant(''))();

  /// How many times this exact expected/typed pair occurred in this test.
  IntColumn get count => integer().withDefault(const Constant(1))();

  /// Character position within the target paragraph.
  IntColumn get position => integer()();

  /// Index of the word this character belongs to.
  IntColumn get wordIndex => integer()();

  /// True when this row represents an entire skipped word rather than a
  /// single wrong character.
  BoolColumn get isSkippedWord =>
      boolean().withDefault(const Constant(false))();

  /// True when this row represents an entire wrong (typed but incorrect)
  /// word rather than a single wrong character. Added alongside
  /// [isSkippedWord] so Word Mistake Analysis can tell which target word
  /// text a user actually got wrong — schemaVersion 2 (see app_database.dart).
  BoolColumn get isWrongWord =>
      boolean().withDefault(const Constant(false))();
}
