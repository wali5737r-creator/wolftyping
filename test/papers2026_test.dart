import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/ppsc/controller/mock_test_controller.dart';
import 'package:typing_master/features/ppsc/model/mock_question.dart';
import 'package:typing_master/features/ppsc/service/mock_test_engine.dart';
import 'package:typing_master/features/ppsc/service/papers2026_registry.dart';

/// Phase A tests: the 2026 papers registry, paper selection in the
/// controller, the papers list + paper setup views, and explanation
/// display in the end review.
void main() {
  const List<int> expectedCounts = [
    53, 81, 50, 20, 100, 100, 100, 100, 90, 100, 25, 84, 15, 40, 10, 20, 100,
    78, 76, 89, 86,
  ];

  group('2026 papers registry', () {
    test('has 21 papers, numbered 219-239, all year 2026', () {
      expect(papers2026.length, 21);
      for (int i = 0; i < papers2026.length; i++) {
        expect(papers2026[i].paperNo, 219 + i);
        expect(papers2026[i].year, 2026);
        expect(papers2026[i].questionCount, expectedCounts[i]);
      }
      expect(papers2026TotalQuestions, 1417);
    });

    test('every question is valid and ids are unique per paper', () {
      for (final paper in papers2026) {
        final ids = <String>{};
        for (final q in paper.questions) {
          expect(q.options.length, 4, reason: '${paper.id} ${q.id}');
          expect(q.correctIndex >= 0 && q.correctIndex <= 3, isTrue);
          expect(ids.add(q.id), isTrue, reason: 'duplicate id ${q.id}');
        }
      }
    });

    test('latest-update notes total 41', () {
      expect(papers2026TotalLatestUpdates, 41);
    });
  });

  group('paper selection in the controller', () {
    test('selectPaper exposes the paper questions and starts the engine',
        () {
      final controller = MockTestController();
      final paper = papers2026.first;
      controller.selectPaper(paper);
      expect(controller.kind.value, MockTestKind.paper);
      expect(controller.activePaper.value, paper);
      expect(controller.availableQuestions.length, paper.questionCount);
      expect(controller.negativeMarking.value, isFalse);
      controller.selectDuration(const Duration(minutes: 60));
      controller.startTest();
      expect(controller.engine.totalQuestions, paper.questionCount);
      expect(controller.phase.value, MockTestPhase.test);
      controller.onClose();
    });
  });

  group('papers views', () {
    testWidgets('papers list renders all 21 papers', (tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          initialRoute: AppRoutes.ppscPastPapers,
          getPages: AppPages.pages,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Practice Papers'), findsOneWidget);
      expect(find.text('Start'), findsNWidgets(21));
    });

    testWidgets('paper setup renders after selecting a paper',
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
      controller.selectPaper(papers2026.first);
      await tester.pumpAndSettle();
      expect(find.text('Practice Paper 219'), findsOneWidget);
      expect(find.text('Start This Paper'), findsOneWidget);
    });

    testWidgets('end review shows explanations and latest updates',
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
      const question = MockQuestion(
        id: 'expl-1',
        subject: MockSubject.generalKnowledge,
        question: 'Synthetic question?',
        options: ['A', 'B', 'C', 'D'],
        correctIndex: 1,
        explanation: 'B is correct because it is the verified fact.',
      );
      final engine = MockTestEngine(questions: [question]);
      engine.answer(question.id, 1);
      controller.selectPaper(papers2026.first);
      controller.result.value = engine.result();
      controller.phase.value = MockTestPhase.result;
      await tester.pumpAndSettle();
      // The review tile is an ExpansionTile: expand it first so the
      // explanation child is laid out.
      await tester.tap(find.text('Q1. Synthetic question?'));
      await tester.pumpAndSettle();
      expect(
        find.text('Explanation: B is correct because it is the verified fact.'),
        findsOneWidget,
      );
      expect(find.text('Latest updates'), findsOneWidget);
    });
  });
}
