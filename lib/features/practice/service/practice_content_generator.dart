import '../../typing_test/model/paragraph_difficulty.dart';
import '../../typing_test/model/typing_language.dart';
import '../../typing_test/service/english_paragraph_provider.dart';
import '../../typing_test/service/urdu_paragraph_provider.dart';
import '../model/character_mistake_stat.dart';
import '../model/mistake_analysis_summary.dart';
import '../model/word_mistake_stat.dart';
import 'english_word_bank.dart';

/// Builds practice drill text from a user's actual saved mistakes.
///
/// English Character Practice looks up real dictionary words (see
/// [EnglishWordBank]) that contain the weak letters — matching the spec's
/// own example (weak A/S/K -> "ask sad desk asks..."). Urdu never gets a
/// made-up word list: its content is built directly from the user's own
/// weak characters/words, exactly as spec section 6 requires ("use actual
/// Urdu characters and words from the user's mistakes — do NOT translate
/// English into Urdu").
class PracticeContentGenerator {
  PracticeContentGenerator._();

  static const int _maxCharsConsidered = 6;
  static const int _maxWordsInDrill = 10;

  /// Character Practice content, built from the weakest characters.
  static String characterPractice(
    List<CharacterMistakeStat> weakestCharacters,
    TypingLanguage language,
  ) {
    if (weakestCharacters.isEmpty) {
      return _fallbackParagraph(language);
    }
    final List<String> chars = weakestCharacters
        .take(_maxCharsConsidered)
        .map((c) => c.character)
        .toList();

    if (language == TypingLanguage.english) {
      return _englishCharacterDrill(chars);
    }
    return _urduCharacterDrill(chars);
  }

  static String _englishCharacterDrill(List<String> chars) {
    final Set<String> lowerChars = chars.map((c) => c.toLowerCase()).toSet();

    final List<MapEntry<String, int>> scored = EnglishWordBank.words
        .map((w) {
          final int score =
              lowerChars.where((c) => w.toLowerCase().contains(c)).length;
          return MapEntry(w, score);
        })
        .where((e) => e.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final List<String> picked =
        scored.take(_maxWordsInDrill).map((e) => e.key).toList();

    if (picked.length < 4) {
      // Not enough real words matched — pad with simple letter-combo
      // drills built directly from the weak characters themselves.
      final String combo = chars.join();
      picked.addAll([combo, chars.reversed.join(), combo, combo]);
    }
    return picked.join(' ');
  }

  static String _urduCharacterDrill(List<String> chars) {
    final List<String> drillParts = [];
    for (final String c in chars) {
      drillParts.addAll([c, c, c]);
    }
    for (int i = 0; i < chars.length - 1; i++) {
      drillParts.add(chars[i] + chars[i + 1]);
    }
    return drillParts.join(' ');
  }

  /// Word Practice / Skipped Word Practice content — literally the user's
  /// own real words, repeated for a reasonably long drill. Same method
  /// serves both modes; the caller passes whichever list (weakest words
  /// or most-skipped words) is relevant.
  static String wordPractice(
    List<WordMistakeStat> words,
    TypingLanguage language,
  ) {
    if (words.isEmpty) return _fallbackParagraph(language);
    final List<String> picked =
        words.take(_maxWordsInDrill).map((w) => w.word).toList();
    // Repeat twice so short lists still make a reasonable-length drill.
    return [...picked, ...picked].join(' ');
  }

  /// Quick Practice — a short mix of the top weak characters' words and
  /// top weak words together.
  static String quickPractice(
    MistakeAnalysisSummary summary,
    TypingLanguage language,
  ) {
    if (!summary.hasEnoughData) return _fallbackParagraph(language);
    final String charPart = summary.weakestCharacters.isNotEmpty
        ? characterPractice(
            summary.weakestCharacters.take(3).toList(), language)
        : '';
    final String wordPart = summary.weakestWords.isNotEmpty
        ? wordPractice(summary.weakestWords.take(4).toList(), language)
        : '';
    final String combined =
        [charPart, wordPart].where((s) => s.trim().isNotEmpty).join(' ');
    return combined.trim().isEmpty ? _fallbackParagraph(language) : combined;
  }

  /// General Practice — normal typing using the existing built-in
  /// paragraphs, no mistake data involved at all.
  static String generalPractice(
    TypingLanguage language, {
    ParagraphDifficulty difficulty = ParagraphDifficulty.easy,
  }) {
    return language == TypingLanguage.english
        ? EnglishParagraphProvider.randomOf(difficulty).text
        : UrduParagraphProvider.randomOf(difficulty).text;
  }

  static String _fallbackParagraph(TypingLanguage language) =>
      generalPractice(language);
}
