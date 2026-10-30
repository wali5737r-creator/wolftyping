import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';

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
}
