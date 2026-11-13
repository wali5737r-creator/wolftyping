import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/ppsc/controller/mock_test_controller.dart';
import 'package:typing_master/features/ppsc/model/mock_question.dart';
import 'package:typing_master/features/ppsc/service/mock_questions.dart';
import 'package:typing_master/features/ppsc/service/mock_test_engine.dart';

/// Phase D tests: the sample bank holds 100 original practice questions
/// per subject (600 total), the full test draws a balanced 100 across
/// subjects, each subject-wise test is 100, and subject durations suit
/// 100-question tests.
void main() {
  group('sample bank', () {
    test('has 600 questions, 100 per subject, ids unique', () {
      expect(sampleQuestions.length, 600);
      final ids = <String>{};
      for (final q in sampleQuestions) {
        expect(ids.add(q.id), isTrue, reason: 'duplicate id ${q.id}');
      }
      for (final subject in MockSubject.values) {
        final count = sampleQuestions
            .where((q) => q.subject == subject)
            .length;
        expect(count, 100, reason: subject.label);
      }
    });

    test('every bank question passes engine validation', () {
      expect(
        () => MockTestEngine(questions: sampleQuestions),
        returnsNormally,
      );
    });

    test('full test draws a balanced 100 with no repeats', () {
      final full = MockTestController.fullTestQuestions;
      expect(full.length, 100);
      expect(full.map((q) => q.id).toSet().length, 100);
      for (final subject in MockSubject.values) {
        final count =
            full.where((q) => q.subject == subject).length;
        expect(count >= 16 && count <= 17, isTrue,
            reason: '${subject.label} has $count');
      }
    });
  });

  group('sample test selection', () {
    test('full and subject selections are 100; durations suit 100', () {
      expect(MockTestController.subjectDurations, [
        const Duration(minutes: 60),
        const Duration(minutes: 90),
        const Duration(minutes: 120),
      ]);
      final controller = MockTestController();
      controller.selectKind(MockTestKind.full);
      expect(controller.availableQuestions.length, 100);
      for (final subject in MockSubject.values) {
        controller.selectSubject(subject);
        expect(controller.availableQuestions.length, 100,
            reason: subject.label);
        expect(
          MockTestController.subjectDurations
              .contains(controller.selectedDuration.value),
          isTrue,
        );
      }
      controller.onClose();
    });

    testWidgets('subject setup shows 100 questions', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          initialRoute: AppRoutes.ppscMockTest,
          getPages: AppPages.pages,
        ),
      );
      await tester.pumpAndSettle();
      final controller = Get.find<MockTestController>();
      controller.selectSubject(MockSubject.english);
      await tester.pumpAndSettle();
      expect(find.textContaining('100 questions'), findsWidgets);
    });
  });

  group('sample bank explanations (Phase 3: English, Mathematics and '
      'Everyday Science)', () {
    test('every English question has a verified explanation', () {
      final english = sampleQuestions
          .where((q) => q.subject == MockSubject.english)
          .toList();
      expect(english.length, 100);
      for (final q in english) {
        expect(q.explanation, isNotNull, reason: q.id);
        expect(q.explanation!.trim(), isNotEmpty, reason: q.id);
        expect(q.explanation, q.explanation!.trim(), reason: q.id);
        // One short sentence, not a paragraph.
        expect(q.explanation!.length, lessThanOrEqualTo(200),
            reason: q.id);
      }
    });

    test('every Mathematics question has a verified explanation', () {
      final maths = sampleQuestions
          .where((q) => q.subject == MockSubject.mathematics)
          .toList();
      expect(maths.length, 100);
      for (final q in maths) {
        expect(q.explanation, isNotNull, reason: q.id);
        expect(q.explanation!.trim(), isNotEmpty, reason: q.id);
        expect(q.explanation, q.explanation!.trim(), reason: q.id);
        // One short sentence, not a paragraph.
        expect(q.explanation!.length, lessThanOrEqualTo(200),
            reason: q.id);
      }
    });

    test('every Everyday Science question has a verified explanation '
        'except the one with a flagged wrong key', () {
      final science = sampleQuestions
          .where((q) => q.subject == MockSubject.everydayScience)
          .toList();
      expect(science.length, 100);
      // sci-new-55 is left without an explanation: its answer key is
      // wrong (it says fossil fuels formed from "Rocks only"), and the
      // key fix is a separate decision, so no explanation is attached.
      final explained =
          science.where((q) => q.explanation != null).toList();
      expect(explained.length, 99);
      final unexplained =
          science.where((q) => q.explanation == null).toList();
      expect(unexplained.map((q) => q.id), ['sci-new-55']);
      for (final q in explained) {
        expect(q.explanation!.trim(), isNotEmpty, reason: q.id);
        expect(q.explanation, q.explanation!.trim(), reason: q.id);
        // One short sentence, not a paragraph.
        expect(q.explanation!.length, lessThanOrEqualTo(200),
            reason: q.id);
      }
    });

    test('no other subject has explanations yet', () {
      for (final subject in MockSubject.values) {
        if (subject == MockSubject.english ||
            subject == MockSubject.mathematics ||
            subject == MockSubject.everydayScience) {
          continue;
        }
        final explained = sampleQuestions
            .where((q) =>
                q.subject == subject && q.explanation != null)
            .length;
        expect(explained, 0, reason: subject.label);
      }
    });

    testWidgets('end review shows an English explanation and nothing '
        'for a question without one', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          initialRoute: AppRoutes.ppscMockTest,
          getPages: AppPages.pages,
        ),
      );
      await tester.pumpAndSettle();
      final controller = Get.find<MockTestController>();
      final english = sampleQuestions.firstWhere(
          (q) => q.subject == MockSubject.english);
      final gk = sampleQuestions.firstWhere(
          (q) => q.subject == MockSubject.generalKnowledge);
      final engine = MockTestEngine(questions: [english, gk]);
      engine.answer(english.id, english.correctIndex);
      engine.answer(gk.id, gk.correctIndex);
      controller.selectKind(MockTestKind.full);
      controller.result.value = engine.result();
      controller.phase.value = MockTestPhase.result;
      await tester.pumpAndSettle();
      await tester.ensureVisible(
          find.text('Q1. ${english.question}'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Q1. ${english.question}'));
      await tester.pumpAndSettle();
      expect(
        find.text('Explanation: ${english.explanation!}'),
        findsOneWidget,
      );
      // Only the English question carries an explanation.
      expect(find.textContaining('Explanation:'), findsOneWidget);
      controller.onClose();
    });

    testWidgets('end review shows a Mathematics explanation and nothing '
        'for a question without one', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          initialRoute: AppRoutes.ppscMockTest,
          getPages: AppPages.pages,
        ),
      );
      await tester.pumpAndSettle();
      final controller = Get.find<MockTestController>();
      final maths = sampleQuestions.firstWhere(
          (q) => q.subject == MockSubject.mathematics);
      final gk = sampleQuestions.firstWhere(
          (q) => q.subject == MockSubject.generalKnowledge);
      final engine = MockTestEngine(questions: [maths, gk]);
      engine.answer(maths.id, maths.correctIndex);
      engine.answer(gk.id, gk.correctIndex);
      controller.selectKind(MockTestKind.full);
      controller.result.value = engine.result();
      controller.phase.value = MockTestPhase.result;
      await tester.pumpAndSettle();
      await tester.ensureVisible(
          find.text('Q1. ${maths.question}'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Q1. ${maths.question}'));
      await tester.pumpAndSettle();
      expect(
        find.text('Explanation: ${maths.explanation!}'),
        findsOneWidget,
      );
      // Only the Mathematics question carries an explanation.
      expect(find.textContaining('Explanation:'), findsOneWidget);
      controller.onClose();
    });

    testWidgets('end review shows an Everyday Science explanation and '
        'nothing for the question with the flagged wrong key',
        (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          initialRoute: AppRoutes.ppscMockTest,
          getPages: AppPages.pages,
        ),
      );
      await tester.pumpAndSettle();
      final controller = Get.find<MockTestController>();
      final science = sampleQuestions.firstWhere(
          (q) => q.subject == MockSubject.everydayScience);
      // sci-new-55 carries no explanation because its answer key is
      // flagged wrong; the review must show nothing for it.
      final flagged = sampleQuestions
          .firstWhere((q) => q.id == 'sci-new-55');
      expect(flagged.explanation, isNull);
      final engine = MockTestEngine(questions: [science, flagged]);
      engine.answer(science.id, science.correctIndex);
      engine.answer(flagged.id, flagged.correctIndex);
      controller.selectKind(MockTestKind.full);
      controller.result.value = engine.result();
      controller.phase.value = MockTestPhase.result;
      await tester.pumpAndSettle();
      await tester.ensureVisible(
          find.text('Q1. ${science.question}'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Q1. ${science.question}'));
      await tester.pumpAndSettle();
      expect(
        find.text('Explanation: ${science.explanation!}'),
        findsOneWidget,
      );
      // Only the Science question carries an explanation.
      expect(find.textContaining('Explanation:'), findsOneWidget);
      controller.onClose();
    });
  });
}
