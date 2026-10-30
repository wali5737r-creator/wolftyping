import 'character_mistake_stat.dart';
import 'word_mistake_stat.dart';

/// Everything the Practice Dashboard needs for one language, computed
/// once by [MistakeAnalysisService] rather than recomputed by widgets.
class MistakeAnalysisSummary {
  const MistakeAnalysisSummary({
    required this.totalMistakes,
    required this.wrongCharacters,
    required this.wrongWords,
    required this.skippedWords,
    required this.backspaces,
    required this.weakestCharacters,
    required this.weakestWords,
    required this.mostSkippedWords,
    required this.recentMistakes,
    required this.completedTestCount,
  });

  final int totalMistakes;
  final int wrongCharacters;
  final int wrongWords;
  final int skippedWords;
  final int backspaces;

  /// Sorted most mistakes first.
  final List<CharacterMistakeStat> weakestCharacters;

  /// Sorted most mistakes first.
  final List<WordMistakeStat> weakestWords;

  /// Sorted most skipped first.
  final List<WordMistakeStat> mostSkippedWords;

  /// Most recent mistake events, newest first — each a plain display
  /// string built by the service (e.g. "expected 'a', typed 's'").
  final List<String> recentMistakes;

  /// How many completed tests this summary is based on — used to decide
  /// whether to show the empty state (spec section 15).
  final int completedTestCount;

  bool get hasEnoughData => completedTestCount > 0;
}
