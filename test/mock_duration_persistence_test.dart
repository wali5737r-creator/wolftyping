import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/ppsc/controller/mock_test_controller.dart';
import 'package:typing_master/features/ppsc/service/mock_progress_repository.dart';

/// Duration reset (live run-through 2026-11-13): the 5-minute
/// selection reset to the 90-minute default after a full reload.
/// The chosen mock duration is now remembered on the device
/// (SharedPreferences) and restored on the setup page. The default
/// stays 90 minutes when nothing was ever chosen.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    MockProgressRepository.instance.resetForTest();
  });

  tearDown(() {
    Get.reset();
  });

  Future<MockTestController> pumpSetup(WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.ppscMockTest,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();
    return Get.find<MockTestController>();
  }

  testWidgets('a stored 5-minute choice is restored on the setup page',
      (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      MockTestController.mockDurationStorageKey: 5,
    });
    final MockTestController controller = await pumpSetup(tester);
    expect(controller.selectedDuration.value, const Duration(minutes: 5));
    expect(find.textContaining('100 questions · 5 minutes'), findsOneWidget);
  });

  testWidgets('choosing a duration persists it on the device',
      (tester) async {
    final MockTestController controller = await pumpSetup(tester);
    expect(controller.selectedDuration.value, const Duration(minutes: 90));

    await tester.tap(find.text('10 minutes'));
    await tester.pumpAndSettle();
    expect(controller.selectedDuration.value, const Duration(minutes: 10));

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(
      prefs.getInt(MockTestController.mockDurationStorageKey),
      10,
    );
  });

  testWidgets('no stored choice keeps the 90-minute default',
      (tester) async {
    final MockTestController controller = await pumpSetup(tester);
    expect(controller.selectedDuration.value, const Duration(minutes: 90));
    expect(find.textContaining('100 questions · 90 minutes'), findsOneWidget);
  });

  testWidgets('a stored duration the test does not offer is ignored',
      (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      MockTestController.mockDurationStorageKey: 45,
    });
    final MockTestController controller = await pumpSetup(tester);
    expect(controller.selectedDuration.value, const Duration(minutes: 90));
  });
}
