import '../../typing_test/model/paragraph_difficulty.dart';
import '../../typing_test/model/typing_language.dart';
import 'paragraph_category.dart';

/// A single paragraph shown on the My Paragraphs dashboard — either a
/// user-created row from the `Paragraphs` table ([isCustom] true), or one
/// of the static built-in English/Urdu paragraphs ([isCustom] false,
/// [id] a synthetic negative number since built-ins never get a real
/// database row).
class CustomParagraph {
  const CustomParagraph({
    required this.id,
    required this.title,
    required this.language,
    required this.category,
    required this.difficulty,
    required this.text,
    required this.isCustom,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String title;
  final TypingLanguage language;
  final ParagraphCategory category;
  final ParagraphDifficulty? difficulty;
  final String text;
  final bool isCustom;
  final DateTime createdAt;
  final DateTime? updatedAt;

  /// Unicode-aware word count — splitting on whitespace works the same
  /// for English and Urdu since words in both are space-separated.
  int get wordCount {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r'\s+')).length;
  }

  /// Character count by Unicode code point (runes), not UTF-16 code
  /// units, so Urdu characters are counted correctly (spec section 3).
  int get characterCount => text.runes.length;

  CustomParagraph copyWith({
    String? title,
    TypingLanguage? language,
    ParagraphCategory? category,
    ParagraphDifficulty? difficulty,
    String? text,
    DateTime? updatedAt,
  }) {
    return CustomParagraph(
      id: id,
      title: title ?? this.title,
      language: language ?? this.language,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      text: text ?? this.text,
      isCustom: isCustom,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
