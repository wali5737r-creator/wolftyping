/// A saved mid-test draft for one PPSC practice-paper run, stored on
/// the device only (see [MockProgressRepository]). One draft per paper,
/// keyed by paper id: leaving a paper test halfway keeps the answers,
/// the remaining time and the current question, so the test can be
/// resumed later exactly where it stopped — same shuffled option order
/// (via [shuffleSeed]), same planned duration and negative-marking
/// settings.
///
/// Practice material only: a draft is never presented as an official
/// or verbatim paper; it only restores the user's own in-progress
/// practice attempt.
class MockTestDraft {
  const MockTestDraft({
    required this.paperId,
    required this.answers,
    required this.remainingSeconds,
    required this.currentIndex,
    required this.shuffleSeed,
    required this.plannedDurationSeconds,
    required this.negativeMarking,
    required this.negativeDeduction,
    required this.totalQuestions,
    required this.savedAt,
  });

  /// Paper id (e.g. '2026-219'). The draft key.
  final String paperId;

  /// question id -> selected option index (0-3). Absent = unanswered.
  final Map<String, int> answers;

  /// Seconds left on the countdown when the draft was saved.
  final int remainingSeconds;

  /// Index of the question the user was on when the draft was saved.
  final int currentIndex;

  /// Seed for the per-run option shuffle, so resuming reproduces the
  /// exact option order the user saw (a restored answer still points
  /// at the same option text).
  final int shuffleSeed;

  /// Planned test duration in seconds (the duration chosen at setup).
  final int plannedDurationSeconds;

  final bool negativeMarking;

  final double negativeDeduction;

  /// Questions the paper had when the draft was saved. Only a hint
  /// for stale-draft handling — resume clamps against the paper's
  /// current question list, never trusts this number.
  final int totalQuestions;

  /// Milliseconds since epoch when the draft was saved.
  final int savedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'paperId': paperId,
        'answers': answers,
        'remainingSeconds': remainingSeconds,
        'currentIndex': currentIndex,
        'shuffleSeed': shuffleSeed,
        'plannedDurationSeconds': plannedDurationSeconds,
        'negativeMarking': negativeMarking,
        'negativeDeduction': negativeDeduction,
        'totalQuestions': totalQuestions,
        'savedAt': savedAt,
      };

  /// Parses [toJson] output. Never throws except for a missing or
  /// empty [paperId] (a [FormatException], so the loader can skip the
  /// entry): every other bad value is coerced defensively — invalid
  /// answer entries (non-int values, option outside 0-3) are dropped,
  /// the rest fall back to sensible defaults.
  factory MockTestDraft.fromJson(Map<String, dynamic> json) {
    final String paperId = (json['paperId'] as String?)?.trim() ?? '';
    if (paperId.isEmpty) {
      throw const FormatException('MockTestDraft has no paperId.');
    }

    final Map<String, int> answers = <String, int>{};
    final Object? rawAnswers = json['answers'];
    if (rawAnswers is Map) {
      rawAnswers.forEach((key, value) {
        if (value is int && value >= 0 && value <= 3) {
          answers[key.toString()] = value;
        }
      });
    }

    int intValue(Object? raw, int fallback) {
      if (raw is num) return raw.toInt();
      return fallback;
    }

    int nonNegative(Object? raw, int fallback) {
      final int value = intValue(raw, fallback);
      return value < 0 ? fallback : value;
    }

    final int planned = nonNegative(json['plannedDurationSeconds'], 5400);
    final double deduction =
        (json['negativeDeduction'] as num?)?.toDouble() ?? 0.25;

    return MockTestDraft(
      paperId: paperId,
      answers: answers,
      remainingSeconds: nonNegative(json['remainingSeconds'], 0),
      currentIndex: nonNegative(json['currentIndex'], 0),
      shuffleSeed: intValue(json['shuffleSeed'], 0),
      plannedDurationSeconds: planned == 0 ? 5400 : planned,
      negativeMarking: json['negativeMarking'] is bool
          ? json['negativeMarking'] as bool
          : false,
      negativeDeduction: deduction > 0 && deduction <= 1 ? deduction : 0.25,
      totalQuestions: nonNegative(json['totalQuestions'], answers.length),
      savedAt: nonNegative(json['savedAt'], 0),
    );
  }
}
