import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/ppsc/controller/mock_test_controller.dart';
import 'package:typing_master/features/ppsc/service/mock_progress_repository.dart';

/// Batch-click flake (live run-through 2026-11-13): tapping Q2 and Q3
/// in one quick batch left Q3 unanswered — the counter stayed at 2
/// and chip 3 stayed unanswered, while a separate re-click worked.
///
/// Two causes, both in the test panel:
/// (a) answering a question inserted a "Clear answer" button under
/// its options, pushing every later question down — the second tap,
/// aimed at the pre-tap position, landed on the wrong row;
/// (b) one Obx rebuilt all 100 questions on every answer and every
/// timer second, so a fast second tap could land on a tile being
/// rebuilt mid-gesture.
///
/// The fix reserves the Clear-answer row's height (answering never
/// moves the questions below) and scopes rebuilds per question card.
/// These tests pin both halves: the layout must not move, and two
/// answers tapped in quick succession must both register.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    MockProgressRepository.instance.resetForTest();
  });

  tearDown(() {
    Get.reset();
  });

  Future<MockTestController> startMock(WidgetTester tester) async {
    // A tall viewport: Q1–Q3 must all be built at once (the default
    // 800x600 only builds Q1 — the 5-minute banner plus one question
    // card already fill it), and taps need their tiles on screen.
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.ppscMockTest,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();
    final MockTestController controller = Get.find<MockTestController>();
    await tester.tap(find.text('5 minutes'));
    await tester.pump();
    await tester.ensureVisible(find.text('Start Mock Test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start Mock Test'));
    await tester.pump();
    expect(controller.phase.value, MockTestPhase.test);
    return controller;
  }

  testWidgets('answering Q1 does not move Q2 down', (tester) async {
    final MockTestController controller = await startMock(tester);
    final String q1Id = controller.engine.questions[0].id;
    final String q2Id = controller.engine.questions[1].id;

    // Q2's card is built (it sits inside the viewport) — record
    // where it is before any answer exists.
    final Offset before = tester.getTopLeft(find.byKey(ValueKey(q2Id)));
    expect(controller.engine.answerFor(q1Id), isNull);

    await tester.tap(find.byKey(Key('mock-option-$q1Id-0')));
    await tester.pump();

    expect(controller.engine.answerFor(q1Id), 0);
    // The Clear-answer button appeared under Q1, but Q2 must be in
    // exactly the same place: its reserved row absorbs the change.
    final Offset after = tester.getTopLeft(find.byKey(ValueKey(q2Id)));
    expect(after, before);
  });

  testWidgets('two answers tapped in quick succession both register',
      (tester) async {
    final MockTestController controller = await startMock(tester);
    final String q1Id = controller.engine.questions[0].id;
    final String q2Id = controller.engine.questions[1].id;

    // No pump between the taps: the second tap lands while the first
    // answer is still being applied — exactly the run-through batch.
    await tester.tap(find.byKey(Key('mock-option-$q1Id-0')));
    await tester.tap(find.byKey(Key('mock-option-$q2Id-1')));
    await tester.pump();

    expect(controller.engine.answerFor(q1Id), 0);
    expect(controller.engine.answerFor(q2Id), 1);
    expect(controller.engine.answeredCount, 2);
    expect(controller.unansweredQuestions.length, 98);
    expect(find.textContaining('Answered 2 of 100'), findsOneWidget);
  });

  testWidgets('two answers tapped across a rebuild both register',
      (tester) async {
    final MockTestController controller = await startMock(tester);
    final String q1Id = controller.engine.questions[0].id;
    final String q2Id = controller.engine.questions[1].id;

    await tester.tap(find.byKey(Key('mock-option-$q1Id-2')));
    // One frame passes — the panel rebuilds with Q1 answered — and
    // the next tap must still land on Q2's option, not a stale row.
    await tester.pump();
    await tester.tap(find.byKey(Key('mock-option-$q2Id-0')));
    await tester.pump();

    expect(controller.engine.answerFor(q1Id), 2);
    expect(controller.engine.answerFor(q2Id), 0);
    expect(controller.engine.answeredCount, 2);
  });
}
