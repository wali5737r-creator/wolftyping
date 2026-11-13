import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/ppsc/controller/mock_test_controller.dart';

/// Regression test for the reported blank PPSC mock-test page: the setup
/// panel (test type, duration, negative marking, question-count card and
/// Start button) must actually render when the route is opened.
void main() {
  testWidgets('PPSC mock test setup panel renders', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.ppscMockTest,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('PPSC Practice Mock Test'), findsOneWidget);
    expect(find.text('Test type'), findsOneWidget);
    expect(find.text('Duration'), findsOneWidget);
    expect(find.text('Negative marking'), findsOneWidget);
    expect(find.text('Full mock test'), findsOneWidget);
    expect(find.text('Start Mock Test'), findsOneWidget);
  });

  testWidgets('5-minute warning banner lists unanswered questions',
      (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.ppscMockTest,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();

    // The Start button sits below the fold in the default 800x600
    // test viewport: scroll it into view before tapping.
    await tester.ensureVisible(find.text('Start Mock Test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start Mock Test'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // No warning yet with 90 minutes left.
    expect(find.textContaining('Only 5 minutes left!'), findsNothing);

    // Move the clock into the last 5 minutes.
    final MockTestController controller = Get.find<MockTestController>();
    controller.remaining.value = const Duration(minutes: 4);
    await tester.pump();

    expect(
      find.text(
        'Only 5 minutes left! The test will submit automatically when time ends.',
      ),
      findsOneWidget,
    );
    // Full mock test, nothing answered yet: all 100 questions listed.
    expect(find.text('100 questions are still unanswered:'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
  });
}
