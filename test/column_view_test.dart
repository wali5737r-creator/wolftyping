import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/ppsc/controller/mock_test_controller.dart';
import 'package:typing_master/features/ppsc/model/custom_set.dart';
import 'package:typing_master/features/ppsc/model/mock_question.dart';
import 'package:typing_master/features/ppsc/service/mock_progress_repository.dart';

/// Column view: every question on one scrollable page, answers
/// selectable for several questions without navigation, submit +
/// review score, custom-test name dialog + name on the result, and
/// bookmark toggle + bookmarked-only run.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    MockProgressRepository.instance.resetForTest();
  });

  tearDown(() {
    Get.reset();
  });

  CustomSet smallSet() => CustomSet(
        id: 'custom-small',
        name: 'Small Quiz',
        questions: const [
          MockQuestion(
            id: 'q1',
            subject: MockSubject.english,
            question: 'First question?',
            options: ['A', 'B', 'C', 'D'],
            correctIndex: 0,
          ),
          MockQuestion(
            id: 'q2',
            subject: MockSubject.mathematics,
            question: 'Second question?',
            options: ['A', 'B', 'C', 'D'],
            correctIndex: 1,
          ),
          MockQuestion(
            id: 'q3',
            subject: MockSubject.english,
            question: 'Third question?',
            options: ['A', 'B', 'C', 'D'],
            correctIndex: 2,
          ),
        ],
      );

  /// Option positions are shuffled at test start, so tests must read
  /// the position from the engine's (shuffled) questions, never assume
  /// the stored order. Options render as a letter-badge tile keyed
  /// `mock-option-<question id>-<position>` with the option text
  /// beside the badge (no "A. ..." prefix text).
  Future<void> tapOption(
    WidgetTester tester,
    String questionId,
    int optionIndex,
  ) =>
      tester.tap(find.byKey(Key('mock-option-$questionId-$optionIndex')));

  MockQuestion sessionQuestion(MockTestController controller, String id) =>
      controller.engine.questions.firstWhere((q) => q.id == id);

  Future<void> pumpMock(WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.ppscMockTest,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('column view shows all questions and answers several',
      (tester) async {
    await pumpMock(tester);
    final controller = Get.find<MockTestController>();
    controller.selectCustomSet(smallSet());
    controller.startTest();
    await tester.pump();
    expect(find.text('All questions'), findsOneWidget);
    expect(find.text('First question?'), findsOneWidget);
    expect(find.text('Second question?'), findsOneWidget);
    // No Next/Previous navigation in the column view.
    expect(find.text('Next'), findsNothing);
    expect(find.text('Previous'), findsNothing);
    expect(find.text('Question Palette'), findsNothing);

    // Answer Q1 correctly, without any navigation: tap the
    // correct option at its shuffled position. The selected tile
    // shows a letter badge and a check icon.
    final MockQuestion q1 = sessionQuestion(controller, 'q1');
    await tapOption(tester, 'q1', q1.correctIndex);
    await tester.pump();
    expect(controller.engine.answerFor('q1'), q1.correctIndex);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('q1')),
        matching: find.byIcon(Icons.check),
      ),
      findsOneWidget,
    );
    // The third card is built lazily: scroll it into view, then
    // answer it wrongly — still without any Next/Previous navigation.
    await tester.scrollUntilVisible(
      find.text('Third question?'),
      200,
      scrollable: find.descendant(
        of: find.byKey(const Key('mock-test-question-list')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pump();
    expect(find.text('Third question?'), findsOneWidget);
    // Answer Q3 wrongly: tap any option that is not its
    // correct one, at its shuffled position.
    final MockQuestion q3 = sessionQuestion(controller, 'q3');
    final int wrongIndex =
        q3.correctIndex == 0 ? 1 : 0;
    await tapOption(tester, 'q3', wrongIndex);
    await tester.pump();
    expect(controller.engine.answerFor('q3'), wrongIndex);
    expect(controller.engine.answeredCount, 2);
  });

  testWidgets('option tiles show letter badges, not "A. ..." prefixes',
      (tester) async {
    await pumpMock(tester);
    final controller = Get.find<MockTestController>();
    controller.selectCustomSet(smallSet());
    controller.startTest();
    await tester.pump();
    // q1/q2 cards are built initially; the old combined "A. <text>"
    // prefix text no longer exists anywhere in the built cards.
    for (final String id in <String>['q1', 'q2']) {
      for (int i = 0; i < 4; i++) {
        expect(find.byKey(Key('mock-option-$id-$i')), findsOneWidget);
      }
    }
    expect(find.textContaining(RegExp(r'^[A-D]\. ')), findsNothing);
    // The third card builds lazily on scroll (and the first cards are
    // recycled away), so assert its tiles only after scrolling to it.
    await tester.scrollUntilVisible(
      find.text('Third question?'),
      200,
      scrollable: find.descendant(
        of: find.byKey(const Key('mock-test-question-list')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pump();
    for (int i = 0; i < 4; i++) {
      expect(find.byKey(Key('mock-option-q3-$i')), findsOneWidget);
    }
  });

  testWidgets('submit with unanswered questions confirms and reviews',
      (tester) async {
    await pumpMock(tester);
    final controller = Get.find<MockTestController>();
    controller.selectCustomSet(smallSet());
    controller.startTest();
    await tester.pump();
    // Answer Q1 correctly at its shuffled position, leaving the
    // other two unanswered, so the result is 1 / 3.
    final MockQuestion q1 = sessionQuestion(controller, 'q1');
    await tapOption(tester, 'q1', q1.correctIndex);
    await tester.pump();
    await tester.tap(find.text('Submit Test'));
    await tester.pumpAndSettle();
    expect(find.text('Submit test?'), findsOneWidget);
    expect(find.textContaining('still unanswered'), findsOneWidget);
    await tester.tap(find.text('Submit Anyway'));
    await tester.pumpAndSettle();
    expect(find.text('Mock Test Result'), findsOneWidget);
    expect(find.textContaining('1 / 3'), findsWidgets);
    await controller.flushProgress();
    expect(MockProgressRepository.instance.attempts.length, 1);
  });

  testWidgets('custom test asks for a name and shows it with the score',
      (tester) async {
    await pumpMock(tester);
    final controller = Get.find<MockTestController>();
    controller.selectCustomSet(smallSet());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start This Custom Test'));
    await tester.pumpAndSettle();
    expect(find.text('Your name'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('student-name-field')),
      'Ayesha',
    );
    await tester.tap(find.text('Start test'));
    await tester.pump();
    expect(find.text('All questions'), findsOneWidget);
    controller.submit();
    await tester.pumpAndSettle();
    expect(find.textContaining('Ayesha — Score'), findsOneWidget);
    // The last-used name is saved on the device for next time.
    await controller.flushProgress();
    expect(
      MockProgressRepository.instance.lastStudentName.value,
      'Ayesha',
    );
  });

  testWidgets('empty name falls back to Student and never blocks',
      (tester) async {
    await pumpMock(tester);
    final controller = Get.find<MockTestController>();
    controller.selectCustomSet(smallSet());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start This Custom Test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start test'));
    await tester.pump();
    expect(find.text('All questions'), findsOneWidget);
    controller.submit();
    await tester.pumpAndSettle();
    expect(find.textContaining('Student — Score'), findsOneWidget);
  });

  testWidgets('sample tests do not ask for a name', (tester) async {
    await pumpMock(tester);
    await tester.ensureVisible(find.text('Start Mock Test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start Mock Test'));
    await tester.pump();
    expect(find.text('Your name'), findsNothing);
    expect(find.text('All questions'), findsOneWidget);
  });

  testWidgets('bookmark toggle in review and bookmarked-only run',
      (tester) async {
    await pumpMock(tester);
    final controller = Get.find<MockTestController>();
    controller.selectCustomSet(smallSet());
    controller.startTest();
    await tester.pump();
    controller.submit();
    await tester.pumpAndSettle();
    expect(find.text('Mock Test Result'), findsOneWidget);
    // Bookmark the first question from its review tile.
    await tester.ensureVisible(find.text('Q1. First question?'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Q1. First question?'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Bookmark this question').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bookmark this question').first);
    await tester.pumpAndSettle();
    expect(find.text('Bookmarked'), findsWidgets);
    expect(
      MockProgressRepository.instance.bookmarks.length,
      1,
    );
    // Run only the bookmarked question.
    controller.backToSetup();
    controller.selectBookmarked();
    await tester.pumpAndSettle();
    expect(find.text('Bookmarked Questions'), findsOneWidget);
    await tester.tap(find.text('Start Bookmarked Practice'));
    await tester.pump();
    expect(find.text('First question?'), findsOneWidget);
    expect(find.text('Second question?'), findsNothing);
  });
}
