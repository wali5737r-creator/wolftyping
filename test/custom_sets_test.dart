import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/features/ppsc/controller/mock_test_controller.dart';
import 'package:typing_master/features/ppsc/model/custom_set.dart';
import 'package:typing_master/features/ppsc/model/mock_question.dart';
import 'package:typing_master/features/ppsc/service/custom_sets_repository.dart';

MockQuestion _q(String id, {int correct = 0}) => MockQuestion(
  id: id,
  subject: MockSubject.generalKnowledge,
  question: 'Sample question $id?',
  options: const ['Option A', 'Option B', 'Option C', 'Option D'],
  correctIndex: correct,
);

CustomSet _set({String id = 'custom-1', String name = 'Test Set'}) =>
    CustomSet(id: id, name: name, questions: [_q('q1'), _q('q2', correct: 2)]);

void main() {
  group('CustomSet JSON round-trip', () {
    test('toJson/fromJson preserves name, questions and explanations', () {
      final CustomSet original = CustomSet(
        id: 'custom-9',
        name: 'Round Trip',
        questions: [
          const MockQuestion(
            id: 'r1',
            subject: MockSubject.mathematics,
            question: 'What is 2 + 2?',
            options: ['3', '4', '5', '6'],
            correctIndex: 1,
            topic: 'Arithmetic',
            explanation: 'Two plus two equals four.',
          ),
        ],
      );
      final CustomSet restored = CustomSet.fromJson(original.toJson());
      expect(restored.id, 'custom-9');
      expect(restored.name, 'Round Trip');
      expect(restored.questions.length, 1);
      expect(restored.questions.first.subject, MockSubject.mathematics);
      expect(restored.questions.first.correctIndex, 1);
      expect(restored.questions.first.topic, 'Arithmetic');
      expect(
        restored.questions.first.explanation,
        'Two plus two equals four.',
      );
    });

    test('encode/decode round-trips, and plain JSON decodes too', () {
      final CustomSet set = _set();
      final CustomSet fromCode = CustomSet.decode(set.encode());
      expect(fromCode.name, 'Test Set');
      expect(fromCode.questions.length, 2);
      final CustomSet fromJson =
          CustomSet.decode(jsonEncode(set.toJson()));
      expect(fromJson.id, 'custom-1');
    });
  });

  group('CustomSet import validation', () {
    test('rejects a question with fewer than 4 options', () {
      final Map<String, dynamic> bad = _set().toJson();
      (bad['questions'] as List).first['options'] = ['A', 'B'];
      expect(
        () => CustomSet.fromJson(bad),
        throwsA(isA<FormatException>()),
      );
    });

    test('rejects a correctIndex outside 0-3', () {
      final Map<String, dynamic> bad = _set().toJson();
      (bad['questions'] as List).first['correctIndex'] = 4;
      expect(
        () => CustomSet.fromJson(bad),
        throwsA(isA<FormatException>()),
      );
    });

    test('rejects an empty name, no questions, and garbage codes', () {
      expect(
        () => CustomSet.fromJson(_set(name: '').toJson()),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => CustomSet.fromJson(
          CustomSet(id: 'x', name: 'Empty', questions: []).toJson(),
        ),
        throwsA(isA<FormatException>()),
      );
      expect(() => CustomSet.decode('not-a-code!!!'), throwsFormatException);
      expect(() => CustomSet.decode(''), throwsFormatException);
    });

    test('rejects an empty option and duplicate question ids', () {
      final CustomSet emptyOption = CustomSet(
        id: 'e1',
        name: 'Bad',
        questions: [
          const MockQuestion(
            id: 'q1',
            subject: MockSubject.english,
            question: 'Q?',
            options: ['A', '', 'C', 'D'],
            correctIndex: 0,
          ),
        ],
      );
      expect(() => CustomSet.validate(emptyOption), throwsFormatException);
      final CustomSet dup = CustomSet(
        id: 'e2',
        name: 'Bad',
        questions: [_q('q1'), _q('q1')],
      );
      expect(() => CustomSet.validate(dup), throwsFormatException);
    });
  });

  group('CustomSetsRepository persistence', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
    });

    test('save/load round-trips sets on the device', () async {
      final CustomSetsRepository repo = CustomSetsRepository.instance;
      expect(await repo.load(), isEmpty);
      await repo.upsert(_set());
      await repo.upsert(_set(id: 'custom-2', name: 'Second'));
      final List<CustomSet> loaded = await repo.load();
      expect(loaded.length, 2);
      expect(loaded.map((s) => s.name), containsAll(['Test Set', 'Second']));
      await repo.delete('custom-1');
      expect((await repo.load()).length, 1);
    });

    test('import renames on id clash instead of overwriting', () async {
      final CustomSetsRepository repo = CustomSetsRepository.instance;
      await repo.upsert(_set());
      final CustomSet imported = await repo.importCode(_set().encode());
      expect(imported.id, isNot('custom-1'));
      expect(imported.name, 'Test Set');
      expect((await repo.load()).length, 2);
    });

    test('corrupt stored data loads as empty, never throws', () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        CustomSetsRepository.storageKey,
        'this is not json {{{',
      );
      expect(await CustomSetsRepository.instance.load(), isEmpty);
    });
  });

  group('MockTestController custom-set run', () {
    setUp(() {
      Get.testMode = true;
    });

    tearDown(() {
      Get.reset();
    });

    test('custom run uses the engine: score, skipped and review', () {
      final MockTestController controller = MockTestController();
      controller.selectCustomSet(_set());
      expect(controller.kind.value, MockTestKind.custom);
      expect(controller.availableQuestions.length, 2);
      // Negative marking defaults to OFF for a custom run.
      expect(controller.negativeMarking.value, isFalse);

      controller.startTest();
      expect(controller.phase.value, MockTestPhase.test);
      controller.selectOption(0); // q1 correct
      controller.nextQuestion();
      // q2 left unanswered (skipped).
      controller.submit();
      expect(controller.phase.value, MockTestPhase.result);
      final result = controller.result.value!;
      expect(result.correct, 1);
      expect(result.skipped, 1);
      expect(result.score, 1);
      expect(result.questions.length, 2);
      controller.onClose();
    });

    test('selecting a sample kind again clears the custom set', () {
      final MockTestController controller = MockTestController();
      controller.selectCustomSet(_set());
      controller.selectKind(MockTestKind.full);
      expect(controller.activeCustomSet.value, isNull);
      controller.onClose();
    });
  });
}
