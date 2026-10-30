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
}
