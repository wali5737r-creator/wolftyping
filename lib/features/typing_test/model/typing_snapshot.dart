import 'typing_test_status.dart';

/// An immutable bundle of every stat the UI/controller needs at one point
/// in time.
///
/// TypingEngine recomputes all of this from its live counters on demand
/// (see `TypingEngine.snapshot`). The GetX TypingController will call that
/// getter inside its `onUpdate` callback and copy the whole thing into one
/// `Rx<TypingSnapshot>` — one reactive value instead of a dozen, so the UI
/// only rebuilds once per update instead of once per field.
class TypingSnapshot {
  const TypingSnapshot({
    required this.status,
    required this.elapsed,
    required this.remaining,
    required this.correctCharacters,
    required this.wrongCharacters,
    required this.totalTypedCharacters,
    required this.correctWords,
    required this.wrongWords,
    required this.skippedWords,
    required this.backspaces,
    required this.correctedMistakes,
    required this.totalErrors,
    required this.grossWpm,
    required this.netWpm,
    required this.accuracy,
    required this.progress,
    required this.currentWordIndex,
  });

  final TypingTestStatus status;
  final Duration elapsed;
  final Duration remaining;

  final int correctCharacters;
  final int wrongCharacters;
  final int totalTypedCharacters;

  final int correctWords;
  final int wrongWords;
  final int skippedWords;

  final int backspaces;
  final int correctedMistakes;

  /// wrongCharacters + the character-length penalty from skipped words.
  final int totalErrors;

  final double grossWpm;
  final double netWpm;

  /// 0-100. correctCharacters / totalTypedCharacters * 100, i.e. based on
  /// the *current* state of what's typed (backspacing a mistake away
  /// raises this back up), matching "the displayed accuracy must match
  /// the final calculation" from the Typing Test spec.
  final double accuracy;

  /// 0-100. How much of the target text (by character count, words only,
  /// spaces excluded) has been passed.
  final double progress;

  final int currentWordIndex;

  /// A zeroed-out snapshot matching a freshly-constructed TypingEngine
  /// that hasn't started yet. Used as the initial value for the
  /// controller's reactive snapshot before any test has been set up.
  factory TypingSnapshot.initial() => const TypingSnapshot(
        status: TypingTestStatus.notStarted,
        elapsed: Duration.zero,
        remaining: Duration.zero,
        correctCharacters: 0,
        wrongCharacters: 0,
        totalTypedCharacters: 0,
        correctWords: 0,
        wrongWords: 0,
        skippedWords: 0,
        backspaces: 0,
        correctedMistakes: 0,
        totalErrors: 0,
        grossWpm: 0,
        netWpm: 0,
        accuracy: 100,
        progress: 0,
        currentWordIndex: 0,
      );
}
