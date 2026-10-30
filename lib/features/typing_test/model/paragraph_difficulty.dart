/// Difficulty tiers for built-in paragraphs (spec section 30: "Easy /
/// Medium / Hard"). Used by both the Typing Test setup screen and,
/// eventually, Practice/PPSC.
enum ParagraphDifficulty {
  easy,
  medium,
  hard;

  String get label {
    switch (this) {
      case ParagraphDifficulty.easy:
        return 'Easy';
      case ParagraphDifficulty.medium:
        return 'Medium';
      case ParagraphDifficulty.hard:
        return 'Hard';
    }
  }
}
