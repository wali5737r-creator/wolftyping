import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/ppsc/controller/mock_test_controller.dart';
import 'package:typing_master/features/ppsc/service/mock_progress_repository.dart';
import 'package:typing_master/features/ppsc/service/papers2024_registry.dart';
import 'package:typing_master/features/ppsc/service/papers2025_registry.dart';
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
    test('groups are newest-first, all years 2019-2026 built', () {
      final groups = paperYearGroups;
      expect(groups.first.year, 2026);
      expect(groups.first.isBuilt, isTrue);
      expect(groups.first.papers.length, 25);
      expect(groups.first.totalQuestions, 1812);
      expect(groups[1].year, 2025);
      expect(groups[1].isBuilt, isTrue);
      expect(groups[1].papers.length, 56);
      expect(groups[1].totalQuestions, 3179);
      expect(groups[2].year, 2024);
      expect(groups[2].isBuilt, isTrue);
      expect(groups[2].papers.length, 24);
      expect(groups[2].totalQuestions, 2175);
      expect(groups[3].year, 2023);
      expect(groups[3].isBuilt, isTrue);
      expect(groups[3].papers.length, 25);
      expect(groups[3].totalQuestions, 2381);
      expect(groups[4].year, 2022);
      expect(groups[4].isBuilt, isTrue);
      expect(groups[4].papers.length, 28);
      expect(groups[4].totalQuestions, 2712);
      expect(groups[5].year, 2021);
      expect(groups[5].isBuilt, isTrue);
      expect(groups[5].papers.length, 23);
      expect(groups[5].totalQuestions, 2051);
      expect(groups[6].year, 2020);
      expect(groups[6].isBuilt, isTrue);
      expect(groups[6].papers.length, 29);
      expect(groups[6].totalQuestions, 2866);
      expect(groups[7].year, 2019);
      expect(groups[7].isBuilt, isTrue);
      expect(groups[7].papers.length, 31);
      expect(groups[7].totalQuestions, 2987);
      expect(
        groups.map((g) => g.year).toList(),
        [2026, 2025, 2024, 2023, 2022, 2021, 2020, 2019],
      );
      for (final group in groups) {
        expect(group.isBuilt, isTrue);
        expect(group.papers, isNotEmpty);
      }
    });

    test(
        'papersForYear returns papers for built years and empty for unbuilt years',
        () {
      expect(papersForYear(2026), papers2026);
      expect(papersForYear(2025), papers2025);
      expect(papersForYear(2024), papers2024);
      expect(papersForYear(2030), isEmpty);
      expect(isPaperYearBuilt(2026), isTrue);
      expect(isPaperYearBuilt(2025), isTrue);
      expect(isPaperYearBuilt(2024), isTrue);
      expect(isPaperYearBuilt(2030), isFalse);
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
      expect(filterPapers(all).length, 25);
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
    testWidgets('shows heading, year rows, and no coming-soon years',
        (tester) async {
      await pumpEntry(tester);
      expect(find.text('Practice Papers'), findsOneWidget);
      expect(find.text('2026'), findsOneWidget);
      expect(find.text('2025'), findsOneWidget);
      expect(find.text('2024'), findsOneWidget);
      expect(find.text('2023'), findsOneWidget);
      expect(find.text('2022'), findsOneWidget);
      expect(find.text('2021'), findsOneWidget);
      expect(find.text('2020'), findsOneWidget);
      expect(find.text('2019'), findsOneWidget);
      // One row per built year, labelled Past Papers with counts;
      // no paper rows, Start buttons, or search controls on the
      // entry screen — papers live on each year's own page.
      expect(find.textContaining('Past Papers'), findsNWidgets(8));
      expect(find.text('Start'), findsNothing);
      expect(find.byKey(const Key('paper-search-field')), findsNothing);
      expect(find.byKey(const Key('paper-department-filter')),
          findsNothing);
      expect(find.text('Coming soon · 0 papers built'), findsNothing);
    });

    testWidgets('search filters the todo-list rows live', (tester) async {
      await pumpEntry(tester);
      // Search lives on the year's own page: open 2026 first.
      await tester.tap(find.byKey(const Key('paper-year-2026-header')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('paper-search-field')),
        '233',
      );
      await tester.pumpAndSettle();
      expect(find.text('Start'), findsNWidgets(1));
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
      expect(find.text('Start'), findsNothing);
    });

    testWidgets('tapping a built year opens its year page', (tester) async {
      await pumpEntry(tester);
      await tester.tap(find.byKey(const Key('paper-year-2026-header')));
      await tester.pumpAndSettle();
      expect(find.text('2026 Practice Papers'), findsOneWidget);
      expect(find.text('Start'), findsNWidgets(25));
      expect(find.text('0/25 papers complete'), findsOneWidget);
    });

    testWidgets('tapping the built 2025 year opens its year page',
        (tester) async {
      await pumpEntry(tester);
      // The 2025 header sits below the 25-paper 2026 section, off
      // screen in the test viewport: scroll it into view first.
      await tester.ensureVisible(
        find.byKey(const Key('paper-year-2025-header')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('paper-year-2025-header')));
      await tester.pumpAndSettle();
      expect(find.text('2025 Practice Papers'), findsOneWidget);
      expect(find.text('Start'), findsNWidgets(56));
      expect(find.text('0/56 papers complete'), findsOneWidget);
    });

    testWidgets('tapping the built 2024 year opens its year page',
        (tester) async {
      await pumpEntry(tester);
      await tester.ensureVisible(
        find.byKey(const Key('paper-year-2024-header')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('paper-year-2024-header')));
      await tester.pumpAndSettle();
      expect(find.text('2024 Practice Papers'), findsOneWidget);
      expect(find.text('Start'), findsNWidgets(24));
      expect(find.text('0/24 papers complete'), findsOneWidget);
    });

    testWidgets('year page for an unbuilt year is honest and has no Start',
        (tester) async {
      await pumpEntry(tester);
      Get.toNamed(AppRoutes.ppscPastPapersYear, arguments: 2030);
      await tester.pumpAndSettle();
      expect(find.text('2030 Practice Papers'), findsOneWidget);
      expect(find.text('Coming soon'), findsWidgets);
      expect(find.text('2030 — coming soon · 0 papers built'),
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
      // Back to the year's page: the row now shows the best score
      // + Retake (paper rows live on the year page, not the entry
      // screen).
      Get.toNamed(AppRoutes.ppscPastPapersYear, arguments: 2026);
      await tester.pumpAndSettle();
      expect(find.text('Retake'), findsOneWidget);
      expect(find.textContaining('Best score:'), findsOneWidget);
      expect(find.text('1/25 papers complete'), findsOneWidget);
    });
  });
}
