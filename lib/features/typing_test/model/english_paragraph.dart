import 'paragraph_difficulty.dart';

/// A single built-in English practice paragraph. This is a plain in-memory
/// model for now — once "My Paragraphs" and the Paragraphs Drift table are
/// wired up, custom/saved paragraphs will use the same shape.
class EnglishParagraph {
  const EnglishParagraph({
    required this.title,
    required this.text,
    required this.difficulty,
  });

  final String title;
  final String text;
  final ParagraphDifficulty difficulty;
}
