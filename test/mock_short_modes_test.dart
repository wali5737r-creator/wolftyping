import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/ppsc/controller/mock_test_controller.dart';
import 'package:typing_master/features/ppsc/service/mock_progress_repository.dart';

/// 5- and 10-minute quick mock modes: the same 100-question full mock
/// with the same rules, just a shorter countdown. The 5-minute warning
/// banner must make sense in a 5-minute test (it is live from the
/// start there), and auto-submit must still fire when time ends.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    MockProgressRepository.instance.resetForTest();
  });

  tearDown(() {
    Get.reset();
  });

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

  Future<MockTestController> startFullMock(
    WidgetTester tester,
    String durationLabel,
  ) async {
    await pumpMock(tester);
    final MockTestController controller = Get.find<MockTestController>();
    expect(controller.kind.value, MockTestKind.full);
    await tester.tap(find.text(durationLabel));
    await tester.pump();
    await tester.ensureVisible(find.text('Start Mock Test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start Mock Test'));
    await tester.pump();
    expect(controller.phase.value, MockTestPhase.test);
    return controller;
  }

  test('full mock offers 5 and 10 minutes alongside 60/90/120', () {
    expect(
      MockTestController.fullDurations,
      containsAll(<Duration>[
        const Duration(minutes: 5),
        const Duration(minutes: 10),
        const Duration(minutes: 60),
        const Duration(minutes: 90),
        const Duration(minutes: 120),
      ]),
    );
    // Existing durations are unchanged, not replaced.
    expect(MockTestController.fullDurations.length, 5);
  });

  testWidgets('5-minute mock starts with the warning banner shown',
      (tester) async {
    final MockTestController controller =
        await startFullMock(tester, '5 minutes');
    expect(controller.selectedDuration.value, const Duration(minutes: 5));
    expect(controller.remaining.value, const Duration(minutes: 5));
    expect(controller.engine.totalQuestions, 100);
    // 5 minutes or less remain from the very start of a 5-minute
    // test, so the banner is live immediately — but it must name the
    // quick test, not claim "only 5 minutes left" at the start.
    expect(controller.timeWarning, isTrue);
    expect(
      controller.timeWarningLabel,
      '5-minute quick test — the test will submit automatically when '
      'time ends.',
    );
    expect(find.textContaining('5-minute quick test'), findsOneWidget);
    expect(find.textContaining('Only 5 minutes left'), findsNothing);
    controller.onClose();
  });

  testWidgets(
      '10-minute mock warns at 5 minutes left, then auto-submits',
      (tester) async {
    final MockTestController controller =
        await startFullMock(tester, '10 minutes');
    expect(controller.selectedDuration.value, const Duration(minutes: 10));
    expect(controller.timeWarning, isFalse);
    expect(find.textContaining('Only 5 minutes left'), findsNothing);

    // Halfway through: 5 minutes remain, warning appears.
    await tester.pump(const Duration(minutes: 5));
    expect(controller.phase.value, MockTestPhase.test);
    expect(controller.remaining.value, const Duration(minutes: 5));
    expect(controller.timeWarning, isTrue);
    expect(find.textContaining('Only 5 minutes left'), findsOneWidget);

    // Time ends: auto-submit, result phase, autoSubmitted set.
    await tester.pump(const Duration(minutes: 5));
    expect(controller.phase.value, MockTestPhase.result);
    expect(controller.autoSubmitted.value, isTrue);
    expect(controller.result.value, isNotNull);
    expect(find.text('Mock Test Result'), findsOneWidget);
    expect(
      find.text('Time ended, so the test was submitted automatically.'),
      findsOneWidget,
    );
    controller.onClose();
  });

  testWidgets('5-minute mock auto-submits when its time ends',
      (tester) async {
    final MockTestController controller =
        await startFullMock(tester, '5 minutes');
    await tester.pump(const Duration(minutes: 5));
    expect(controller.phase.value, MockTestPhase.result);
    expect(controller.autoSubmitted.value, isTrue);
    expect(controller.result.value!.totalQuestions, 100);
    controller.onClose();
  });

  testWidgets('5-minute mock result offers the practice certificate',
      (tester) async {
    final MockTestController controller =
        await startFullMock(tester, '5 minutes');
    await tester.pump(const Duration(minutes: 5));
    expect(controller.phase.value, MockTestPhase.result);
    expect(find.text('Get Practice Certificate'), findsOneWidget);
    // The result card itself is not relabelled a certificate.
    expect(find.text('Mock Test Result'), findsOneWidget);
    controller.onClose();
  });
}
