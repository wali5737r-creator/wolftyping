import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/features/ppsc/model/mock_question.dart';
import 'package:typing_master/features/ppsc/service/mock_test_engine.dart';

MockQuestion _q(String id, {int correct = 0}) => MockQuestion(
  id: id,
  subject: MockSubject.generalKnowledge,
  question: 'Question $id?',
  options: const ['A', 'B', 'C', 'D'],
  correctIndex: correct,
);

void main() {
  group('MockTestEngine scoring', () {
    test('correct answers score 1 each, skipped score 0', () {
      final engine = MockTestEngine(
        questions: [_q('1'), _q('2'), _q('3')],
      );
      engine.answer('1', 0);
      expect(engine.correctCount, 1);
      expect(engine.wrongCount, 0);
      expect(engine.skippedCount, 2);
      expect(engine.score, 1);
      expect(engine.percentage, closeTo(100 / 3, 0.01));
    });

    test('wrong answers score 0 without negative marking', () {
      final engine = MockTestEngine(questions: [_q('1'), _q('2')]);
      engine.answer('1', 2);
      engine.answer('2', 3);
      expect(engine.wrongCount, 2);
      expect(engine.score, 0);
      expect(engine.negativeMarksDeducted, 0);
    });

    test('negative marking deducts per wrong answer', () {
      final engine = MockTestEngine(
        questions: [_q('1'), _q('2'), _q('3'), _q('4')],
        negativeMarking: true,
        negativeDeduction: 0.25,
      );
      engine.answer('1', 0); // correct
      engine.answer('2', 1); // wrong
      engine.answer('3', 1); // wrong
      expect(engine.correctCount, 1);
      expect(engine.wrongCount, 2);
      expect(engine.negativeMarksDeducted, 0.5);
      expect(engine.score, 0.5);
    });

    test('score never goes below zero with negative marking', () {
      final engine = MockTestEngine(
        questions: [_q('1')],
        negativeMarking: true,
        negativeDeduction: 1.0,
      );
      engine.answer('1', 3);
      expect(engine.score, 0);
    });

    test('unanswered list only contains unanswered questions', () {
      final engine = MockTestEngine(
        questions: [_q('1'), _q('2'), _q('3')],
      );
      engine.answer('2', 0);
      expect(
        engine.unanswered.map((q) => q.id).toList(),
        ['1', '3'],
      );
      expect(engine.unansweredCount, 2);
    });

    test('clearing an answer makes the question unanswered again', () {
      final engine = MockTestEngine(questions: [_q('1')]);
      engine.answer('1', 0);
      expect(engine.answeredCount, 1);
      engine.clearAnswer('1');
      expect(engine.answeredCount, 0);
      expect(engine.answerFor('1'), isNull);
    });
  });

  group('100-question sessions', () {
    test('engine handles 100 questions: answer all, score, review', () {
      final questions = List<MockQuestion>.generate(
        100,
        (i) => _q('q${i + 1}', correct: i % 4),
      );
      final engine = MockTestEngine(
        questions: questions,
        negativeMarking: true,
        negativeDeduction: 0.25,
      );
      expect(engine.totalQuestions, 100);
      // Answer 60 correctly, 30 wrong, leave 10 unanswered.
      for (int i = 0; i < 60; i++) {
        engine.answer('q${i + 1}', i % 4);
      }
      for (int i = 60; i < 90; i++) {
        engine.answer('q${i + 1}', (i % 4 + 1) % 4);
      }
      expect(engine.correctCount, 60);
      expect(engine.wrongCount, 30);
      expect(engine.skippedCount, 10);
      expect(engine.score, 60 - 30 * 0.25);
      expect(engine.unanswered.length, 10);
      final result = engine.result();
      expect(result.questions.length, 100);
      expect(result.answers.length, 90);
      expect(result.scoreLabel, '52.50 / 100');
    });
  });
}
