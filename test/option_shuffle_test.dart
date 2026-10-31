import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/features/ppsc/model/mock_question.dart';
import 'package:typing_master/features/ppsc/service/mock_test_engine.dart';

MockQuestion _q({int correct = 2}) => MockQuestion(
      id: 'q1',
      subject: MockSubject.generalKnowledge,
      question: 'Which option is correct?',
      options: const ['Alpha', 'Beta', 'Gamma', 'Delta'],
      correctIndex: correct,
      topic: 'General',
      explanation: 'Gamma is correct.',
    );

void main() {
  group('Option shuffle', () {
    test('shuffled question keeps the same options and correct text', () {
      final MockQuestion original = _q();
      final MockQuestion shuffled = original.withShuffledOptions(Random(7));
      expect(shuffled.options.toSet(), original.options.toSet());
      expect(shuffled.options.length, 4);
      expect(
        shuffled.options[shuffled.correctIndex],
        original.options[original.correctIndex],
      );
      expect(shuffled.id, original.id);
      expect(shuffled.subject, original.subject);
      expect(shuffled.question, original.question);
      expect(shuffled.topic, original.topic);
      expect(shuffled.explanation, original.explanation);
    });

    test('original question is not mutated by shuffling', () {
      final MockQuestion original = _q();
      original.withShuffledOptions(Random(7));
      expect(original.options, const ['Alpha', 'Beta', 'Gamma', 'Delta']);
      expect(original.correctIndex, 2);
    });

    test('same seed gives the same order, so shuffling is reproducible', () {
      final MockQuestion a = _q().withShuffledOptions(Random(42));
      final MockQuestion b = _q().withShuffledOptions(Random(42));
      expect(a.options, b.options);
      expect(a.correctIndex, b.correctIndex);
    });

    test('shuffling across many runs moves the correct answer around', () {
      final Set<int> positions = <int>{};
      for (var seed = 0; seed < 40; seed++) {
        positions.add(_q().withShuffledOptions(Random(seed)).correctIndex);
      }
      // With 40 seeds the correct answer should land in more than one
      // position; the exact set is not asserted, only that it is not
      // stuck on the stored position for every run.
      expect(positions.length, greaterThan(1));
    });

    test('engine scoring follows the remapped correct index', () {
      // Find a seed that actually moves the correct answer, so the
      // test proves scoring follows the shuffle rather than the
      // stored index.
      MockQuestion? moved;
      for (var seed = 0; seed < 40; seed++) {
        final MockQuestion candidate = _q().withShuffledOptions(Random(seed));
        if (candidate.correctIndex != 2) {
          moved = candidate;
          break;
        }
      }
      expect(moved, isNotNull);
      final MockQuestion shuffled = moved!;
      final MockTestEngine engine =
          MockTestEngine(questions: <MockQuestion>[shuffled]);
      engine.answer('q1', shuffled.correctIndex);
      expect(engine.correctCount, 1);
      expect(engine.score, 1);
      final MockTestEngine wrongEngine =
          MockTestEngine(questions: <MockQuestion>[shuffled]);
      wrongEngine.answer('q1', 2 == shuffled.correctIndex ? 0 : 2);
      expect(wrongEngine.correctCount, 0);
    });
  });
}
