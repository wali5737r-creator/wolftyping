import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/ppsc/controller/mock_test_controller.dart';
import 'package:typing_master/features/ppsc/service/mock_progress_repository.dart';
import 'package:typing_master/features/ppsc/service/papers2026_registry.dart';
import 'package:typing_master/features/ppsc/service/papers_registry.dart';

/// Year grouping: registry shape, entry-screen year sections, year-page
/// navigation, and honest empty-year behaviour. No papers are invented
/// for unbuilt years.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    MockProgressRepository.instance.resetForTest();
  });

  tearDown(() {
    Get.reset();
  });

  group('papers registry by year', () {
    test('groups are newest-first, 2026 built, later years empty', () {
      final groups = paperYearGroups;
      expect(groups.first.year, 2026);
      expect(groups.first.isBuilt, isTrue);
      expect(groups.first.papers.length, 21);
      expect(groups.first.totalQuestions, 1417);
      expect(
        groups.map((g) => g.year).toList(),
        [2026, 2025, 2024, 2023, 2022, 2021, 2020, 2019],
      );
      for (final group in groups.skip(1)) {
        expect(group.isBuilt, isFalse);
        expect(group.papers, isEmpty);
      }
    });

    test('papersForYear returns 2026 papers and empty for unbuilt years',
        () {
      expect(papersForYear(2026), papers2026);
      expect(papersForYear(2025), isEmpty);
      expect(papersForYear(2030), isEmpty);
      expect(isPaperYearBuilt(2026), isTrue);
      expect(isPaperYearBuilt(2025), isFalse);
    });

    test('filterPapers matches number, post, department and filters', () {
      final all = papersForYear(2026);
      expect(filterPapers(all, query: '233').length, 1);
      expect(filterPapers(all, query: '233').first.paperNo, 233);
      expect(filterPapers(all, query: 'no-such-paper'), isEmpty);
      final dept = all.first.department;
      final byDept = filterPapers(all, department: dept);
      expect(byDept, isNotEmpty);
      expect(byDept.every((p) => p.department == dept), isTrue);
      expect(
        filterPapers(all, query: '233', department: 'No such department'),
        isEmpty,
      );
      expect(filterPapers(all).length, 21);
    });
  });

  Future<void> pumpEntry(WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.ppscPastPapers,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();
  }

  group('year-grouped list screen', () {
    testWidgets('shows heading, 2026 papers, and coming-soon years',
        (tester) async {
      await pumpEntry(tester);
      expect(find.text('Practice Papers'), findsOneWidget);
      expect(find.text('2026'), findsOneWidget);
      expect(find.text('Start'), findsNWidgets(21));
      expect(find.text('0/21 papers complete'), findsOneWidget);
      expect(find.text('2025'), findsOneWidget);
      expect(find.text('Coming soon · 0 papers built'), findsNWidgets(7));
      // Search + filter controls are present on the entry screen.
      expect(find.byKey(const Key('paper-search-field')), findsOneWidget);
      expect(
        find.byKey(const Key('paper-department-filter')),
        findsOneWidget,
      );
    });

    testWidgets('search filters the todo-list rows live', (tester) async {
      await pumpEntry(tester);
      await tester.enterText(
        find.byKey(const Key('paper-search-field')),
        '233',
      );
      await tester.pumpAndSettle();
      expect(find.text('Start'), findsOneWidget);
      expect(
        find.textContaining('Paper 233'),
        findsOneWidget,
      );
      await tester.enterText(
        find.byKey(const Key('paper-search-field')),
        'no-such-paper-xyz',
      );
      await tester.pumpAndSettle();
      expect(find.text('No papers match this search or filter.'),
          findsOneWidget);
    });

    testWidgets('tapping a built year opens its year page', (tester) async {
      await pumpEntry(tester);
      await tester.tap(find.byKey(const Key('paper-year-2026-header')));
      await tester.pumpAndSettle();
      expect(find.text('2026 Practice Papers'), findsOneWidget);
      expect(find.text('Start'), findsNWidgets(21));
      expect(find.text('0/21 papers complete'), findsOneWidget);
    });

    testWidgets('tapping a coming-soon year goes nowhere', (tester) async {
      await pumpEntry(tester);
      await tester.tap(find.byKey(const Key('paper-year-2025-row')));
      await tester.pumpAndSettle();
      expect(find.text('Practice Papers'), findsOneWidget);
      expect(find.text('2025 Practice Papers'), findsNothing);
    });

    testWidgets('year page for an unbuilt year is honest and has no Start',
        (tester) async {
      await pumpEntry(tester);
      Get.toNamed(AppRoutes.ppscPastPapersYear, arguments: 2025);
      await tester.pumpAndSettle();
      expect(find.text('2025 Practice Papers'), findsOneWidget);
      expect(find.text('Coming soon'), findsWidgets);
      expect(find.text('2025 — coming soon · 0 papers built'),
          findsOneWidget);
      expect(find.text('Start'), findsNothing);
      expect(find.text('Retake'), findsNothing);
    });

    testWidgets('unknown year does not crash and shows coming soon',
        (tester) async {
      await pumpEntry(tester);
      Get.toNamed(AppRoutes.ppscPastPapersYear, arguments: 2030);
      await tester.pumpAndSettle();
      expect(find.text('2030 Practice Papers'), findsOneWidget);
      expect(find.text('Start'), findsNothing);
    });

    testWidgets('completed paper shows tick, best score and Retake',
        (tester) async {
      await pumpEntry(tester);
      final controller = Get.find<MockTestController>();
      controller.selectPaper(papers2026.first);
      controller.startTest();
      // Answer the first question correctly, then submit.
      final engine = controller.engine;
      controller.selectOptionFor(engine.questions.first, engine.questions.first.correctIndex);
      controller.submit();
      await controller.flushProgress();
      await tester.pumpAndSettle();
      // Back to the list: the row now shows the best score + Retake.
      Get.toNamed(AppRoutes.ppscPastPapers);
      await tester.pumpAndSettle();
      expect(find.text('Retake'), findsOneWidget);
      expect(find.textContaining('Best score:'), findsOneWidget);
      expect(find.text('1/21 papers complete'), findsOneWidget);
    });
  });
}
