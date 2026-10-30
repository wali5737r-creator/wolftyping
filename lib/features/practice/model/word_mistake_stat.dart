/// Aggregated mistake data for a single word (spec section 4: Word
/// Mistake Analysis, and section 5: Skipped Word Analysis — a word can
/// appear here for either reason, sometimes both).
class WordMistakeStat {
  const WordMistakeStat({
    required this.word,
    required this.mistakeCount,
    required this.skippedCount,
    required this.lastMistakeAt,
  });

  /// The correct (target) word, in its original language/Unicode form —
  /// never translated or transliterated.
  final String word;

  /// Times this word was typed but came out wrong (whole-word mistakes).
  final int mistakeCount;

  /// Times this word was skipped entirely (Space pressed with nothing
  /// typed for it).
  final int skippedCount;

  final DateTime? lastMistakeAt;

  int get totalOccurrences => mistakeCount + skippedCount;
}
