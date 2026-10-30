/// One mistake event captured live during a test — a single wrong
/// character, an entire skipped word, or (new) an entire wrong word.
///
/// A completed test's `mistakes` list is what eventually gets written into
/// the `Mistakes` Drift table (see core/database/tables/mistakes_table.dart)
/// so "Weak Keys" / the keyboard heatmap / "Practice My Mistakes" can
/// aggregate by [expectedCharacter], and Word Mistake Analysis can
/// aggregate whole-word records by [isWrongWord]/[isSkippedWord].
class MistakeRecord {
  const MistakeRecord({
    required this.expectedCharacter,
    required this.typedCharacter,
    required this.position,
    required this.wordIndex,
    this.isSkippedWord = false,
    this.isWrongWord = false,
  });

  /// What the target text expected. For a skipped or wrong word this holds
  /// the *entire word* instead of a single character — [isSkippedWord] /
  /// [isWrongWord] tell you which case you're looking at.
  final String expectedCharacter;

  /// What the user actually typed instead. Empty for a skipped word,
  /// since nothing was typed for it at all; the full (incorrect) typed
  /// word for a wrong-word record.
  final String typedCharacter;

  /// Character position within the target text (words joined by single
  /// spaces) where this mistake occurred. Approximate for analytics
  /// purposes, not used for grading.
  final int position;

  /// Index of the word this mistake belongs to.
  final int wordIndex;

  final bool isSkippedWord;

  /// True for a whole-word record created when a word was typed (some
  /// characters entered) but didn't match the target word — as opposed to
  /// a single wrong keystroke, which is its own MistakeRecord with
  /// [isWrongWord] false. Lets Word Mistake Analysis (spec section 4)
  /// know which target word text was actually gotten wrong, which
  /// character-level records alone can't tell you.
  final bool isWrongWord;

  @override
  String toString() {
    if (isSkippedWord) {
      return 'MistakeRecord(skipped word: "$expectedCharacter" at word #$wordIndex)';
    }
    if (isWrongWord) {
      return 'MistakeRecord(wrong word: expected "$expectedCharacter", '
          'typed "$typedCharacter" at word #$wordIndex)';
    }
    return 'MistakeRecord(expected "$expectedCharacter", typed "$typedCharacter" '
        'at word #$wordIndex, pos $position)';
  }
}
