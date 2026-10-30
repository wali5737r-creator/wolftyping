import '../model/mock_question.dart';

/// Pure scoring/session logic for the PPSC practice mock test — no
/// Flutter, no GetX, no timers — so it can be unit tested directly (see
/// `test/mock_test_engine_test.dart`, including a generated 100-question
/// session).
///
/// Scoring: each correct answer scores +1. With negative marking on,
/// each wrong answer deducts [negativeDeduction] marks. Skipped
/// (unanswered) questions never deduct. The total is floored at 0 so a
/// session can never score below zero.
class MockTestEngine {
  MockTestEngine({
    required List<MockQuestion> questions,
    this.negativeMarking = false,
    this.negativeDeduction = 0.25,
  }) : questions = List<MockQuestion>.unmodifiable(questions) {
    // The question data file is plain user-editable data, so validate it
    // here (the model constructor is const and cannot assert on it).
    for (final MockQuestion q in this.questions) {
      if (q.options.length != 4) {
        throw ArgumentError(
          'MockQuestion ${q.id} must have exactly 4 options '
          '(found ${q.options.length}).',
        );
      }
      if (q.correctIndex < 0 || q.correctIndex > 3) {
        throw ArgumentError(
          'MockQuestion ${q.id} correctIndex must be 0-3 '
          '(found ${q.correctIndex}).',
        );
      }
    }
  }

  /// The questions in this session, in the order they are presented.
  final List<MockQuestion> questions;

  final bool negativeMarking;

  /// Marks deducted per wrong answer when [negativeMarking] is on.
  final double negativeDeduction;

  /// question id -> selected option index. Absent = unanswered.
  final Map<String, int> _answers = {};

  Map<String, int> get answers => Map<String, int>.unmodifiable(_answers);

  int get totalQuestions => questions.length;

  void answer(String questionId, int optionIndex) {
    _answers[questionId] = optionIndex;
  }

  void clearAnswer(String questionId) {
    _answers.remove(questionId);
  }

  int? answerFor(String questionId) => _answers[questionId];

  bool isAnsweredQuestion(String questionId) =>
      _answers.containsKey(questionId);

  int get answeredCount => _answers.length;

  int get unansweredCount => totalQuestions - answeredCount;

  List<MockQuestion> get unanswered =>
      questions.where((q) => !_answers.containsKey(q.id)).toList();

  int get correctCount => questions
      .where((q) => q.isCorrect(_answers[q.id]))
      .length;

  int get wrongCount => questions
      .where((q) => _answers.containsKey(q.id) && !q.isCorrect(_answers[q.id]))
      .length;

  int get skippedCount => unansweredCount;

  /// Marks deducted by negative marking (0 when it is off).
  double get negativeMarksDeducted {
    if (!negativeMarking) return 0;
    return wrongCount * negativeDeduction;
  }

  /// Final score, floored at zero.
  double get score {
    final double raw = correctCount - negativeMarksDeducted;
    return raw < 0 ? 0 : raw;
  }

  /// Score as a percentage of the maximum (total questions × 1 mark).
  double get percentage {
    if (totalQuestions == 0) return 0;
    return score / totalQuestions * 100;
  }

  MockTestResult result() {
    return MockTestResult(
      totalQuestions: totalQuestions,
      correct: correctCount,
      wrong: wrongCount,
      skipped: skippedCount,
      score: score,
      negativeMarksDeducted: negativeMarksDeducted,
      negativeMarking: negativeMarking,
      negativeDeduction: negativeDeduction,
      questions: questions,
      answers: answers,
    );
  }
}

/// The finished result of one mock-test session, used by the result
/// screen and its per-question review.
class MockTestResult {
  const MockTestResult({
    required this.totalQuestions,
    required this.correct,
    required this.wrong,
    required this.skipped,
    required this.score,
    required this.negativeMarksDeducted,
    required this.negativeMarking,
    required this.negativeDeduction,
    required this.questions,
    required this.answers,
  });

  final int totalQuestions;
  final int correct;
  final int wrong;
  final int skipped;
  final double score;
  final double negativeMarksDeducted;
  final bool negativeMarking;
  final double negativeDeduction;
  final List<MockQuestion> questions;
  final Map<String, int> answers;

  double get percentage =>
      totalQuestions == 0 ? 0 : score / totalQuestions * 100;

  String get scoreLabel {
    final String s = score == score.truncateToDouble()
        ? '${score.toInt()}'
        : score.toStringAsFixed(2);
    return '$s / $totalQuestions';
  }
}
