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

  group('sample bank explanations (Phase 6: English, Mathematics, '
      'Everyday Science, Pakistan Studies, Islamiat and General '
      'Knowledge)', () {
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

    test('every Pakistan Studies question has a verified explanation',
        () {
      final pakistanStudies = sampleQuestions
          .where((q) => q.subject == MockSubject.pakistanStudies)
          .toList();
      expect(pakistanStudies.length, 100);
      for (final q in pakistanStudies) {
        expect(q.explanation, isNotNull, reason: q.id);
        expect(q.explanation!.trim(), isNotEmpty, reason: q.id);
        expect(q.explanation, q.explanation!.trim(), reason: q.id);
        // One short sentence, not a paragraph.
        expect(q.explanation!.length, lessThanOrEqualTo(200),
            reason: q.id);
      }
    });

    test('every Islamiat question has a verified explanation', () {
      final islamiat = sampleQuestions
          .where((q) => q.subject == MockSubject.islamiat)
          .toList();
      expect(islamiat.length, 100);
      for (final q in islamiat) {
        expect(q.explanation, isNotNull, reason: q.id);
        expect(q.explanation!.trim(), isNotEmpty, reason: q.id);
        expect(q.explanation, q.explanation!.trim(), reason: q.id);
        // One short sentence, not a paragraph.
        expect(q.explanation!.length, lessThanOrEqualTo(200),
            reason: q.id);
      }
    });

    test('every General Knowledge question has a verified explanation',
        () {
      final gk = sampleQuestions
          .where((q) => q.subject == MockSubject.generalKnowledge)
          .toList();
      expect(gk.length, 100);
      for (final q in gk) {
        expect(q.explanation, isNotNull, reason: q.id);
        expect(q.explanation!.trim(), isNotEmpty, reason: q.id);
        expect(q.explanation, q.explanation!.trim(), reason: q.id);
        // One short sentence, not a paragraph.
        expect(q.explanation!.length, lessThanOrEqualTo(200),
            reason: q.id);
      }
    });

    test('all six subjects are covered; the only question without an '
        'explanation is the one with a flagged wrong key', () {
      // Every subject now has explanations: English, Mathematics,
      // Everyday Science, Pakistan Studies, Islamiat and General
      // Knowledge. The single known gap is sci-new-55, left without
      // an explanation because its answer key is flagged wrong (it
      // says fossil fuels formed from "Rocks only") and the key fix
      // is a separate decision.
      for (final subject in MockSubject.values) {
        final questions = sampleQuestions
            .where((q) => q.subject == subject)
            .toList();
        expect(questions.length, 100, reason: subject.label);
        final explained =
            questions.where((q) => q.explanation != null).length;
        if (subject == MockSubject.everydayScience) {
          expect(explained, 99, reason: subject.label);
        } else {
          expect(explained, 100, reason: subject.label);
        }
      }
      final unexplained = sampleQuestions
          .where((q) => q.explanation == null)
          .map((q) => q.id)
          .toList();
      expect(unexplained, ['sci-new-55']);
      expect(
        sampleQuestions.where((q) => q.explanation != null).length,
        599,
      );
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

    testWidgets('end review shows a Pakistan Studies explanation and '
        'nothing for a question without one', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          initialRoute: AppRoutes.ppscMockTest,
          getPages: AppPages.pages,
        ),
      );
      await tester.pumpAndSettle();
      final controller = Get.find<MockTestController>();
      final pakistanStudies = sampleQuestions.firstWhere(
          (q) => q.subject == MockSubject.pakistanStudies);
      final gk = sampleQuestions.firstWhere(
          (q) => q.subject == MockSubject.generalKnowledge);
      final engine =
          MockTestEngine(questions: [pakistanStudies, gk]);
      engine.answer(
          pakistanStudies.id, pakistanStudies.correctIndex);
      engine.answer(gk.id, gk.correctIndex);
      controller.selectKind(MockTestKind.full);
      controller.result.value = engine.result();
      controller.phase.value = MockTestPhase.result;
      await tester.pumpAndSettle();
      await tester.ensureVisible(
          find.text('Q1. ${pakistanStudies.question}'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Q1. ${pakistanStudies.question}'));
      await tester.pumpAndSettle();
      expect(
        find.text('Explanation: ${pakistanStudies.explanation!}'),
        findsOneWidget,
      );
      // Only the Pakistan Studies question carries an explanation.
      expect(find.textContaining('Explanation:'), findsOneWidget);
      controller.onClose();
    });
    testWidgets('end review shows an Islamiat explanation and '
        'nothing for a question without one', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          initialRoute: AppRoutes.ppscMockTest,
          getPages: AppPages.pages,
        ),
      );
      await tester.pumpAndSettle();
      final controller = Get.find<MockTestController>();
      final islamiat = sampleQuestions.firstWhere(
          (q) => q.subject == MockSubject.islamiat);
      final gk = sampleQuestions.firstWhere(
          (q) => q.subject == MockSubject.generalKnowledge);
      final engine = MockTestEngine(questions: [islamiat, gk]);
      engine.answer(islamiat.id, islamiat.correctIndex);
      engine.answer(gk.id, gk.correctIndex);
      controller.selectKind(MockTestKind.full);
      controller.result.value = engine.result();
      controller.phase.value = MockTestPhase.result;
      await tester.pumpAndSettle();
      await tester.ensureVisible(
          find.text('Q1. ${islamiat.question}'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Q1. ${islamiat.question}'));
      await tester.pumpAndSettle();
      expect(
        find.text('Explanation: ${islamiat.explanation!}'),
        findsOneWidget,
      );
      // Only the Islamiat question carries an explanation.
      expect(find.textContaining('Explanation:'), findsOneWidget);
      controller.onClose();
    });

    testWidgets('end review shows a General Knowledge explanation and '
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
      final gk = sampleQuestions.firstWhere(
          (q) => q.subject == MockSubject.generalKnowledge);
      // sci-new-55 carries no explanation because its answer key is
      // flagged wrong; the review must show nothing for it.
      final flagged = sampleQuestions
          .firstWhere((q) => q.id == 'sci-new-55');
      expect(flagged.explanation, isNull);
      final engine = MockTestEngine(questions: [gk, flagged]);
      engine.answer(gk.id, gk.correctIndex);
      engine.answer(flagged.id, flagged.correctIndex);
      controller.selectKind(MockTestKind.full);
      controller.result.value = engine.result();
      controller.phase.value = MockTestPhase.result;
      await tester.pumpAndSettle();
      await tester.ensureVisible(
          find.text('Q1. ${gk.question}'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Q1. ${gk.question}'));
      await tester.pumpAndSettle();
      expect(
        find.text('Explanation: ${gk.explanation!}'),
        findsOneWidget,
      );
      // Only the General Knowledge question carries an explanation.
      expect(find.textContaining('Explanation:'), findsOneWidget);
      controller.onClose();
    });
  });
}
