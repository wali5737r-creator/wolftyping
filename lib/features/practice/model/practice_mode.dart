/// The practice modes offered on the Practice Dashboard (spec section 7).
enum PracticeMode {
  quick,
  character,
  word,
  skippedWord,
  general;

  String get label {
    switch (this) {
      case PracticeMode.quick:
        return 'Quick Practice';
      case PracticeMode.character:
        return 'Character Practice';
      case PracticeMode.word:
        return 'Word Practice';
      case PracticeMode.skippedWord:
        return 'Skipped Word Practice';
      case PracticeMode.general:
        return 'General Practice';
    }
  }

  String get description {
    switch (this) {
      case PracticeMode.quick:
        return 'A short exercise built from your top mistakes.';
      case PracticeMode.character:
        return 'Practice your weakest characters.';
      case PracticeMode.word:
        return 'Practice the words you get wrong most often.';
      case PracticeMode.skippedWord:
        return 'Practice the words you skip most often.';
      case PracticeMode.general:
        return 'Normal typing practice using built-in paragraphs.';
    }
  }
}
