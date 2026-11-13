import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/services/certificate_code.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/certificate/view/certificate_card.dart';
import 'package:typing_master/features/ppsc/service/mock_progress_repository.dart';

/// Certificate screen (name → certificate + code) and the verify
/// screen (paste a code → decoded result or rejection), wired through
/// the real routes.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    MockProgressRepository.instance.resetForTest();
  });

  tearDown(() {
    Get.reset();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    // A plain home: the dashboard pulls in AppDatabase via
    // HomeController, which these tests do not need.
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: Text('home')),
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();
  }

  CertificateData mockData() => CertificateData(
        kind: CertificateKind.mock,
        testLabel: 'Full mock test · 5 minutes',
        holderName: '',
        date: DateTime(2026, 11, 13),
        score: 88.5,
        totalQuestions: 100,
        correct: 90,
        wrong: 7,
        skipped: 3,
        accuracy: 0,
      );

  testWidgets('certificate screen generates a code for the typed name',
      (tester) async {
    await pumpApp(tester);
    Get.toNamed(
      AppRoutes.certificate,
      arguments: CertificateScreenArgs(data: _mockArgsData),
    );
    await tester.pumpAndSettle();
    expect(find.text('Practice Certificate'), findsOneWidget);

    await tester.enterText(
      find.byType(TextField),
      'Muhammad',
    );
    await tester.tap(find.text('Generate Certificate'));
    await tester.pumpAndSettle();

    // The certificate document appears with the name and a code.
    expect(find.text('Muhammad'), findsWidgets);
    expect(find.text('Verification code'), findsOneWidget);
    expect(find.text('Copy Verification Code'), findsOneWidget);
    // And it says plainly what it is not (header + card disclaimer).
    expect(
      find.textContaining('not an official PPSC'),
      findsWidgets,
    );
  });

  testWidgets('verify screen decodes a valid code', (tester) async {
    final String code = encodeCertificateCode(
      mockData().copyWithName('Muhammad'),
    );
    await pumpApp(tester);
    Get.toNamed(AppRoutes.certificateVerify, arguments: code);
    await tester.pumpAndSettle();

    expect(find.text('Verify Certificate'), findsOneWidget);
    expect(find.text('Certificate verified'), findsOneWidget);
    expect(find.text('Muhammad'), findsOneWidget);
    expect(find.text('Full mock test · 5 minutes'), findsOneWidget);
    expect(find.text('88.5 / 100'), findsOneWidget);
  });

  testWidgets('verify screen rejects a tampered code', (tester) async {
    final String code = encodeCertificateCode(
      mockData().copyWithName('Muhammad'),
    );
    final List<String> parts = code.split('.');
    final String tampered = 'WT1.${parts[1]}.00000000';
    await pumpApp(tester);
    Get.toNamed(AppRoutes.certificateVerify, arguments: tampered);
    await tester.pumpAndSettle();

    expect(find.text('Certificate verified'), findsNothing);
    expect(find.text('Code not valid'), findsOneWidget);
  });
}

final CertificateData _mockArgsData = CertificateData(
  kind: CertificateKind.mock,
  testLabel: 'Full mock test · 5 minutes',
  holderName: '',
  date: DateTime(2026, 11, 13),
  score: 88.5,
  totalQuestions: 100,
  correct: 90,
  wrong: 7,
  skipped: 3,
  accuracy: 0,
);

extension on CertificateData {
  CertificateData copyWithName(String name) => CertificateData(
        kind: kind,
        testLabel: testLabel,
        holderName: name,
        date: date,
        score: score,
        totalQuestions: totalQuestions,
        correct: correct,
        wrong: wrong,
        skipped: skipped,
        accuracy: accuracy,
      );
}
