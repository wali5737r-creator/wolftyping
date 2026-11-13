import '../../ppsc/model/mock_attempt.dart';
import '../../typing_test/model/typing_language.dart';
import '../../typing_test/model/typing_test_kind.dart';

/// A completed typing test, exactly as it was saved by
/// `TypingResultRepository` at the moment the test finished — History and
/// Progress only ever read these fields back, never recompute them (spec
/// section 25: "Never calculate a statistic differently from the
/// original typing test").
///
/// A completed mock MCQ test is shown in History through the same
/// record (see [TypingTestRecord.fromMockAttempt]): the attempt itself
/// stays in `MockProgressRepository` — the single source of truth for
/// mock results and subject stats — and History only maps it for
/// display. Mock records never reach the `TypingTests` table, so typing
/// WPM/accuracy averages are never polluted by MCQ scores.
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
    this.mockAttemptId,
    this.mockLabel,
    this.mockTotalQuestions,
    this.mockCorrect,
    this.mockWrong,
    this.mockSkipped,
    this.mockScore,
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

  /// Mock-only fields. Null for every typing test; non-null exactly
  /// when [isMock] is true.
  ///
  /// [mockAttemptId] is the [MockAttempt.id] — the key History's
  /// delete action uses to remove the attempt from
  /// `MockProgressRepository`. [id] is NOT a `TypingTests` row id for
  /// mock records: it is a negative timestamp, so it can never
  /// collide with a real auto-increment row id and a mistaken
  /// `deleteTest(id)` against the database would match nothing.
  final String? mockAttemptId;

  /// Display label, e.g. 'Full mock test · 5 minutes' or
  /// 'Practice Paper 246 · 90 minutes'.
  final String? mockLabel;

  final int? mockTotalQuestions;
  final int? mockCorrect;
  final int? mockWrong;
  final int? mockSkipped;

  /// Raw score (negative marking can make it fractional).
  final double? mockScore;

  bool get isMock => mockAttemptId != null;

  /// '2 / 100' — the score as the mock result screen shows it.
  String get mockScoreLabel {
    final double score = mockScore ?? 0;
    final String s = score == score.truncateToDouble()
        ? '${score.toInt()}'
        : score.toStringAsFixed(2);
    return '$s / ${mockTotalQuestions ?? 0}';
  }

  /// Duration text for a mock row: time actually spent when known,
  /// otherwise the planned duration, otherwise nothing. Old attempts
  /// recorded before durations were stored have neither, so no
  /// duration is invented for them.
  String get mockDurationText {
    if (!isMock) return '${actualDurationSeconds}s';
    if (actualDurationSeconds > 0) return '${actualDurationSeconds}s';
    final int? planned = durationSeconds;
    if (planned != null) return '${(planned / 60).round()} min planned';
    return '';
  }

  /// Maps a recorded mock attempt onto a History record. The mapping
  /// copies the attempt's own numbers — scoring is never recomputed
  /// here. A mock test has no typing speed, so WPM is 0 and
  /// [accuracy] is the attempt percentage (so "Highest accuracy"
  /// sorting stays meaningful); word counts carry the MCQ
  /// correct/wrong/skipped counts. Mock tests are English-medium, but
  /// the language filter passes mock records through either way (see
  /// `HistoryController.applyFilters`): a mock test is not an English
  /// or Urdu typing test.
  factory TypingTestRecord.fromMockAttempt(MockAttempt attempt) {
    final double percentage = attempt.percentage;
    return TypingTestRecord(
      // Negative timestamp: unmistakably "not a database row".
      id: -attempt.attemptedAt.microsecondsSinceEpoch,
      language: TypingLanguage.english,
      testType: TypingTestKind.mock,
      durationSeconds: attempt.durationSeconds,
      actualDurationSeconds: attempt.actualDurationSeconds ?? 0,
      grossWpm: 0,
      netWpm: 0,
      accuracy: percentage,
      correctCharacters: 0,
      wrongCharacters: 0,
      correctWords: attempt.correct,
      wrongWords: attempt.wrong,
      skippedWords: attempt.skipped,
      backspaces: 0,
      totalErrors: attempt.wrong,
      completedAt: attempt.attemptedAt,
      mockAttemptId: attempt.id,
      mockLabel: attempt.displayLabel,
      mockTotalQuestions: attempt.totalQuestions,
      mockCorrect: attempt.correct,
      mockWrong: attempt.wrong,
      mockSkipped: attempt.skipped,
      mockScore: attempt.score,
    );
  }

  /// "PPSC" tests are always Urdu, but this makes that explicit wherever
  /// it's displayed (spec: "PPSC should be identified as Urdu + PPSC").
  /// Mock records show as 'Mock test'.
  String get languageAndTypeLabel {
    if (isMock) return 'Mock test';
    return testType == TypingTestKind.ppsc
        ? '${language.label} · PPSC'
        : language.label;
  }
}
