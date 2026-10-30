import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/ppsc/controller/mock_test_controller.dart';
import 'package:typing_master/features/ppsc/model/mock_attempt.dart';
import 'package:typing_master/features/ppsc/model/mock_question.dart';
import 'package:typing_master/features/ppsc/service/mock_progress_repository.dart';

/// Batch D: attempt persistence across a reload of progress storage,
/// the weakest-subject hint (real data only, neutral prompt otherwise),
/// and the bookmarked-questions entry from the papers list.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    MockProgressRepository.instance.resetForTest();
  });

  tearDown(() {
    Get.reset();
  });

  MockAttempt seededAttempt() => MockAttempt(
        id: 'seed-1',
        sourceKind: 'paper',
        sourceId: '2026-219',
        sourceLabel: 'Practice Paper 219',
        totalQuestions: 10,
        correct: 4,
        wrong: 6,
        skipped: 0,
        score: 4,
        attemptedAt: DateTime(2026, 10, 30),
        perSubjectCorrect: {'english': 1, 'mathematics': 3},
        perSubjectTotal: {'english': 5, 'mathematics': 5},
      );

  test('attempts survive a progress-storage reload', () async {
    final repo = MockProgressRepository.instance;
    await repo.init();
    await repo.recordAttempt(seededAttempt());
    // Simulate a fresh start: drop in-memory state, reload from prefs.
    repo.resetForTest();
    await repo.init();
    expect(repo.attempts.length, 1);
    expect(repo.bestAttemptFor('2026-219')?.score, 4);
    expect(repo.completedCount(['2026-219']), 1);
  });

  testWidgets('weakest-subject hint shows basis and practises the subject',
      (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      MockProgressRepository.attemptsKey:
          jsonEncode([seededAttempt().toJson()]),
    });
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.ppscMockTest,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Weakest subject'), findsOneWidget);
    expect(
      find.text('English: 1/5 correct in your recorded tests.'),
      findsOneWidget,
    );
    await tester.ensureVisible(find.text('Practise English test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Practise English test'));
    await tester.pumpAndSettle();
    expect(find.text('English test'), findsOneWidget);
  });

  testWidgets('no attempts means a neutral prompt, never a fake hint',
      (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.ppscMockTest,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Weakest subject'), findsOneWidget);
    expect(
      find.textContaining('Take a paper or mock test first'),
      findsOneWidget,
    );
    expect(find.textContaining('correct in your recorded tests'),
        findsNothing);
  });

  testWidgets('bookmarked entry from the papers list runs only bookmarks',
      (tester) async {
    const bookmarked = MockQuestion(
      id: 'bm-1',
      subject: MockSubject.english,
      question: 'Bookmarked question?',
      options: ['A', 'B', 'C', 'D'],
      correctIndex: 0,
    );
    SharedPreferences.setMockInitialValues(<String, Object>{
      MockProgressRepository.bookmarksKey:
          jsonEncode([bookmarked.toJson()]),
    });
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.ppscPastPapers,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Bookmarked questions'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bookmarked questions'));
    await tester.pumpAndSettle();
    expect(find.text('Bookmarked Questions'), findsOneWidget);
    expect(
      find.text('1 bookmarked question · all questions together on one page · auto-submit when time ends'),
      findsOneWidget,
    );
    await tester.tap(find.text('Start Bookmarked Practice'));
    await tester.pump();
    expect(find.text('Bookmarked question?'), findsOneWidget);
    final controller = Get.find<MockTestController>();
    expect(controller.engine.totalQuestions, 1);
  });
}
