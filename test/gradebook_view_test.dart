import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/services/certificate_code.dart';
import 'package:typing_master/features/ppsc/service/gradebook_repository.dart';
import 'package:typing_master/core/theme/app_theme.dart';

/// Gradebook screen renders: empty state, a recorded entry grouped
/// under its test with stats, the add-code card and the honesty note,
/// and the Gradebook button on My Custom Tests that opens it.
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  tearDown(() {
    Get.reset();
  });

  Future<void> pumpGradebook(WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.gradebook,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('empty gradebook shows empty state and add-code card',
      (tester) async {
    await pumpGradebook(tester);
    expect(find.text('Gradebook'), findsWidgets);
    expect(find.text('No results recorded yet'), findsOneWidget);
    expect(find.text('Add a result code'), findsOneWidget);
    expect(find.text('Add result'), findsOneWidget);
    // Honesty note, same as the certificate screens.
    expect(
      find.textContaining('does not prove the test was supervised'),
      findsOneWidget,
    );
  });

  testWidgets('recorded entry shows grouped with stats and row',
      (tester) async {
    final String code = encodeCertificateCode(
      CertificateData(
        kind: CertificateKind.mock,
        testLabel: 'My Urdu Quiz',
        holderName: 'Ayesha',
        date: DateTime(2026, 11, 13),
        score: 88.5,
        totalQuestions: 100,
        correct: 90,
        wrong: 7,
        skipped: 3,
        accuracy: 0,
      ),
    );
    await GradebookRepository.instance.recordCode(code);
    await pumpGradebook(tester);
    expect(find.text('My Urdu Quiz'), findsOneWidget);
    expect(find.textContaining('1 attempt'), findsOneWidget);
    expect(find.textContaining('Average 88.5'), findsOneWidget);
    expect(find.textContaining('Best 88.5'), findsOneWidget);
    expect(find.textContaining('Ayesha — 88.5 / 100'), findsOneWidget);
    expect(find.textContaining('Correct 90'), findsOneWidget);
    expect(
      find.text('Correct 90 · Wrong 7 · Skipped 3 · 2026-11-13 · result code'),
      findsOneWidget,
    );
  });

  testWidgets('pasting a bad code shows a plain error, adds nothing',
      (tester) async {
    await pumpGradebook(tester);
    await tester.enterText(
      find.byType(TextField).first,
      'WT1.bogus.00000000',
    );
    await tester.tap(find.text('Add result'));
    await tester.pumpAndSettle();
    expect(find.textContaining('not valid'), findsOneWidget);
    expect(find.text('No results recorded yet'), findsOneWidget);
  });

  testWidgets('My Custom Tests has a Gradebook button that opens it',
      (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.ppscCustomTests,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Gradebook'), findsOneWidget);
    await tester.tap(find.text('Gradebook'));
    await tester.pumpAndSettle();
    expect(find.text('Add a result code'), findsOneWidget);
  });
}
