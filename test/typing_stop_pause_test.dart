import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/typing_test/controller/typing_controller.dart';
import 'package:typing_master/features/typing_test/controller/urdu_typing_controller.dart';
import 'package:typing_master/features/typing_test/model/typing_test_status.dart';

/// Reproduction / regression test for the live report that tapping Pause
/// or Stop on a running typing test did not stop the on-screen timer.
///
/// The test drives the real widget tree and the real [EngineClock]
/// (a periodic timer + stopwatch): after the first keystroke starts the
/// clock, pumping time must shrink `remaining`; after Pause (or Stop)
/// pumping more time must NOT shrink it any further.
void main() {
  Future<TypingController> pumpRunningTest(
    WidgetTester tester, {
    Duration duration = const Duration(seconds: 30),
  }) async {
    // The setup panel and live controls are taller than the default
    // 800x600 test viewport; give the test a tall window so every
    // button is on-screen and tappable.
    tester.view.physicalSize = const Size(1400, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.typingTest,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();

    final TypingController controller = Get.find<TypingController>();
    controller.selectDuration(duration);
    await tester.tap(find.text('Start Test'));
    await tester.pumpAndSettle();
    expect(controller.screenPhase.value, TypingScreenPhase.test);

    // First keystroke starts the engine clock.
    final String firstWord = controller.targetWords.first;
    controller.onCharacter(String.fromCharCode(firstWord.runes.first));
    await tester.pump();
    expect(controller.engine.hasTypingStarted, isTrue);
    return controller;
  }

  testWidgets('Pause freezes the timer and Resume restarts it',
      (tester) async {
    final TypingController controller = await pumpRunningTest(tester);

    await tester.pump(const Duration(seconds: 5));
    final Duration after5s = controller.snapshot.value.remaining;
    expect(after5s, lessThan(const Duration(seconds: 30)));
    expect(after5s, greaterThanOrEqualTo(const Duration(seconds: 24)));

    await tester.tap(find.text('Pause'));
    await tester.pump();
    expect(controller.snapshot.value.status, TypingTestStatus.paused);
    final Duration pausedAt = controller.snapshot.value.remaining;

    // Pump far longer than a clock tick: remaining must not move.
    await tester.pump(const Duration(seconds: 5));
    expect(controller.snapshot.value.remaining, pausedAt);

    await tester.tap(find.text('Resume'));
    await tester.pump();
    expect(controller.snapshot.value.status, TypingTestStatus.running);
    await tester.pump(const Duration(seconds: 3));
    expect(controller.snapshot.value.remaining, lessThan(pausedAt));
  });

  testWidgets('opening the Stop dialog freezes the timer; Cancel resumes it',
      (tester) async {
    final TypingController controller = await pumpRunningTest(tester);

    await tester.pump(const Duration(seconds: 5));
    final Duration beforeDialog = controller.snapshot.value.remaining;

    await tester.tap(find.text('Stop'));
    await tester.pumpAndSettle();
    expect(find.text('Stop test?'), findsOneWidget);
    expect(controller.snapshot.value.status, TypingTestStatus.paused);

    // The dialog is open and no choice has been made yet: the timer
    // must already be frozen.
    await tester.pump(const Duration(seconds: 5));
    expect(controller.snapshot.value.remaining, beforeDialog);

    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(controller.snapshot.value.status, TypingTestStatus.running);
    await tester.pump(const Duration(seconds: 3));
    expect(controller.snapshot.value.remaining, lessThan(beforeDialog));
  });

  testWidgets('Urdu test: opening the Stop dialog freezes the timer',
      (tester) async {
    tester.view.physicalSize = const Size(1400, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.urduTypingTest,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();

    final UrduTypingController controller = Get.find<UrduTypingController>();
    controller.selectDuration(const Duration(seconds: 30));
    await tester.tap(find.text('Start Test'));
    await tester.pumpAndSettle();
    final String firstWord = controller.targetWords.first;
    controller.onCharacter(String.fromCharCode(firstWord.runes.first));
    await tester.pump(const Duration(seconds: 5));
    final Duration beforeDialog = controller.snapshot.value.remaining;
    expect(beforeDialog, lessThan(const Duration(seconds: 30)));

    await tester.tap(find.text('Stop'));
    await tester.pumpAndSettle();
    expect(find.text('Stop test?'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    expect(controller.snapshot.value.remaining, beforeDialog);
  });

  testWidgets('Stop (confirmed in dialog) returns to setup and stops time',
      (tester) async {
    final TypingController controller = await pumpRunningTest(tester);

    await tester.pump(const Duration(seconds: 5));
    expect(controller.snapshot.value.remaining,
        lessThan(const Duration(seconds: 30)));

    await tester.tap(find.text('Stop'));
    await tester.pumpAndSettle();
    // The confirmation dialog's Stop button is a TextButton; the live
    // screen's Stop button is an OutlinedButton.
    await tester.tap(find.widgetWithText(TextButton, 'Stop'));
    await tester.pumpAndSettle();

    expect(controller.screenPhase.value, TypingScreenPhase.setup);
    // No live test screen remains, so no timer can keep running.
    expect(find.text('Start Test'), findsOneWidget);
  });
}
