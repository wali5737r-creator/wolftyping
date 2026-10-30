/// Aggregated mistake data for a single character (spec section 3:
/// Character Mistake Analysis). [character] is always the *expected*
/// character — what the user was supposed to type — since that's the key
/// that needs practice, not whatever was mistakenly typed instead.
class CharacterMistakeStat {
  const CharacterMistakeStat({
    required this.character,
    required this.count,
    required this.lastMistakeAt,
    required this.commonWrongInputs,
  });

  final String character;
  final int count;
  final DateTime? lastMistakeAt;

  /// What the user typed instead, and how often — e.g. {'S': 6, 'D': 4}
  /// — sorted most-frequent first, for the mistake detail view (spec
  /// section 11).
  final Map<String, int> commonWrongInputs;

  double percentageOf(int totalMistakes) =>
      totalMistakes == 0 ? 0 : (count / totalMistakes * 100);
}
