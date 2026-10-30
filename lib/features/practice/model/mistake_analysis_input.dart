/// A minimal, DB-agnostic view of one completed `TypingTests` row — just
/// the fields the aggregation logic actually needs. Kept separate from
/// the Drift-generated row type so `MistakeAnalysisService.aggregate()`
/// can be unit tested with plain Dart objects, no database required.
class TestMistakeInput {
  const TestMistakeInput({
    required this.id,
    required this.backspaces,
    required this.wrongWords,
    required this.skippedWords,
    required this.completedAt,
  });

  final int id;
  final int backspaces;
  final int wrongWords;
  final int skippedWords;
  final DateTime completedAt;
}

/// A minimal, DB-agnostic view of one `Mistakes` row.
class MistakeRowInput {
  const MistakeRowInput({
    required this.id,
    required this.testId,
    required this.expectedCharacter,
    required this.typedCharacter,
    required this.isSkippedWord,
    required this.isWrongWord,
  });

  final int id;
  final int testId;
  final String expectedCharacter;
  final String typedCharacter;
  final bool isSkippedWord;
  final bool isWrongWord;
}
