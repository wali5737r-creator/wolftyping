import 'paragraph_difficulty.dart';

/// A single built-in Urdu practice paragraph. Deliberately the same shape
/// as `EnglishParagraph` but kept as its own class rather than reusing
/// that one directly — this way the existing English Typing Test's models
/// and code never need to change to accommodate Urdu.
class UrduParagraph {
  const UrduParagraph({
    required this.title,
    required this.text,
    required this.difficulty,
  });

  final String title;

  /// Proper Unicode Urdu text, stored and compared exactly as-is — never
  /// reversed or transliterated (see TypingEngine's Urdu support: it
  /// compares Unicode code points directly, RTL is a display concern only).
  final String text;

  final ParagraphDifficulty difficulty;
}
