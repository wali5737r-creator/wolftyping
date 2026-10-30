import '../../typing_test/model/typing_language.dart';
import '../../typing_test/model/typing_test_kind.dart';

/// A completed typing test, exactly as it was saved by
/// `TypingResultRepository` at the moment the test finished — History and
/// Progress only ever read these fields back, never recompute them (spec
/// section 25: "Never calculate a statistic differently from the
/// original typing test").
class TypingTestRecord {
  const TypingTestRecord({
    required this.id,
    required this.language,
    required this.testType,
    required this.durationSeconds,
    required this.actualDurationSeconds,
    required this.grossWpm,
    required this.netWpm,
    required this.accuracy,
    required this.correctCharacters,
    required this.wrongCharacters,
    required this.correctWords,
    required this.wrongWords,
    required this.skippedWords,
    required this.backspaces,
    required this.totalErrors,
    required this.completedAt,
  });

  final int id;
  final TypingLanguage language;
  final TypingTestKind testType;

  /// The planned duration selected before the test (null for untimed).
  final int? durationSeconds;

  /// How long the user actually spent typing.
  final int actualDurationSeconds;

  final double grossWpm;
  final double netWpm;
  final double accuracy;

  final int correctCharacters;
  final int wrongCharacters;
  final int correctWords;
  final int wrongWords;
  final int skippedWords;
  final int backspaces;
  final int totalErrors;

  final DateTime completedAt;

  /// "PPSC" tests are always Urdu, but this makes that explicit wherever
  /// it's displayed (spec: "PPSC should be identified as Urdu + PPSC").
  String get languageAndTypeLabel => testType == TypingTestKind.ppsc
      ? '${language.label} · PPSC'
      : language.label;
}
