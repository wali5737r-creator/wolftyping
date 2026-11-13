import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/services/certificate_code.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/certificate/service/last_certificate_store.dart';
import 'package:typing_master/features/certificate/view/certificate_card.dart';
import 'package:typing_master/features/ppsc/service/mock_progress_repository.dart';

/// Certificate state was in-memory only (live run-through 2026-11-13):
/// a direct visit to `#/certificate` lost the generated certificate
/// ("No result to certify yet") and only browser Back brought it
/// back. The last GENERATED certificate is now kept on the device
/// (SharedPreferences, no server), so a direct visit — or a reload —
/// after generating shows the certificate again.
///
/// The name field, same run-through: the first look-based fill failed
/// with "not_editable" and only worked after tapping the field. That
/// is Flutter web behaviour, not an app bug — on CanvasKit the DOM
/// `<input>` only exists while the field is focused — so the field
/// now takes focus as soon as the screen opens (autofocus), and the
/// layout is unchanged.
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    MockProgressRepository.instance.resetForTest();
  });

  tearDown(() {
    Get.reset();
  });

  CertificateData mockData() => CertificateData(
        kind: CertificateKind.mock,
        testLabel: 'Full mock test · 5 minutes',
        holderName: 'Test User',
        date: DateTime(2026, 11, 13),
        score: 2,
        totalQuestions: 100,
        correct: 2,
        wrong: 1,
        skipped: 97,
        accuracy: 0,
      );

  group('CertificateData JSON', () {
    test('toJson/fromJson round-trips', () {
      final CertificateData data = mockData();
      final CertificateData back = CertificateData.fromJson(
        Map<String, dynamic>.from(
          jsonDecode(jsonEncode(data.toJson())) as Map,
        ),
      );
      expect(back.kind, data.kind);
      expect(back.testLabel, data.testLabel);
      expect(back.holderName, data.holderName);
      expect(back.date, data.date);
      expect(back.score, data.score);
      expect(back.totalQuestions, data.totalQuestions);
      expect(back.correct, data.correct);
      expect(back.wrong, data.wrong);
      expect(back.skipped, data.skipped);
      expect(back.accuracy, data.accuracy);
    });

    test('fromJson rejects an impossible stored result', () {
      final Map<String, dynamic> bad =
          Map<String, dynamic>.from(mockData().toJson())
            ..['correct'] = 99; // 99 + 1 + 97 != 100
      expect(() => CertificateData.fromJson(bad), throwsFormatException);
    });
  });

  group('LastCertificateStore', () {
    test('save/load round-trips the generated certificate', () async {
      final CertificateData data = mockData();
      final String code = encodeCertificateCode(data);
      await LastCertificateStore.instance.save(data, code);
      final StoredCertificate? stored =
          await LastCertificateStore.instance.load();
      expect(stored, isNotNull);
      expect(stored!.code, code);
      expect(stored.data.holderName, 'Test User');
      expect(stored.data.testLabel, 'Full mock test · 5 minutes');
    });

    test('a corrupt stored blob loads as "no certificate"', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        LastCertificateStore.storageKey: 'not-json{{{',
      });
      expect(await LastCertificateStore.instance.load(), isNull);
    });

    test('a code that does not match the stored result is rejected', () async {
      final CertificateData data = mockData();
      final String otherCode = encodeCertificateCode(
        CertificateData(
          kind: CertificateKind.mock,
          testLabel: 'Full mock test · 5 minutes',
          holderName: 'Someone Else',
          date: DateTime(2026, 11, 13),
          score: 50,
          totalQuestions: 100,
          correct: 50,
          wrong: 10,
          skipped: 40,
          accuracy: 0,
        ),
      );
      await LastCertificateStore.instance.save(data, otherCode);
      expect(await LastCertificateStore.instance.load(), isNull);
    });

    test('clear forgets the stored certificate', () async {
      final CertificateData data = mockData();
      await LastCertificateStore.instance
          .save(data, encodeCertificateCode(data));
      await LastCertificateStore.instance.clear();
      expect(await LastCertificateStore.instance.load(), isNull);
    });
  });

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(body: Text('home')),
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();
  }

  CertificateData argsData() => CertificateData(
        kind: CertificateKind.mock,
        testLabel: 'Full mock test · 5 minutes',
        holderName: '',
        date: DateTime(2026, 11, 13),
        score: 2,
        totalQuestions: 100,
        correct: 2,
        wrong: 1,
        skipped: 97,
        accuracy: 0,
      );

  testWidgets('direct visit after generating shows the certificate',
      (tester) async {
    await pumpHome(tester);
    Get.toNamed(
      AppRoutes.certificate,
      arguments: CertificateScreenArgs(data: argsData()),
    );
    await tester.pumpAndSettle();
    expect(find.text('Practice Certificate'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Test User');
    await tester.tap(find.text('Generate Certificate'));
    await tester.pumpAndSettle();
    expect(find.text('Verification code'), findsOneWidget);

    // Direct navigation with no arguments — the run-through failure:
    // previously this showed "No result to certify yet".
    Get.offAllNamed(AppRoutes.certificate);
    await tester.pumpAndSettle();
    expect(find.textContaining('No result to certify yet'), findsNothing);
    expect(find.text('Verification code'), findsOneWidget);
    expect(find.text('Test User'), findsWidgets);
  });

  testWidgets('a fresh load after generating still shows the certificate',
      (tester) async {
    // A full reload: a brand-new app, same device store, opened
    // straight at #/certificate with no navigation arguments. The
    // store is seeded here exactly as _generate writes it (a second
    // GetMaterialApp in one test breaks GetX routing, so the
    // generate-then-reload path is covered by the direct-visit test
    // above and this one covers the cold start from the stored
    // record alone).
    final CertificateData data = mockData();
    SharedPreferences.setMockInitialValues(<String, Object>{
      LastCertificateStore.storageKey: jsonEncode(<String, dynamic>{
        'data': data.toJson(),
        'code': encodeCertificateCode(data),
      }),
    });
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.certificate,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('No result to certify yet'), findsNothing);
    expect(find.text('Verification code'), findsOneWidget);
    expect(find.text('Test User'), findsWidgets);
  });

  testWidgets('direct visit with nothing generated shows the empty state',
      (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.certificate,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('No result to certify yet'), findsOneWidget);
  });

  testWidgets('the name field is focused as soon as the screen opens',
      (tester) async {
    await pumpHome(tester);
    Get.toNamed(
      AppRoutes.certificate,
      arguments: CertificateScreenArgs(data: argsData()),
    );
    await tester.pumpAndSettle();
    final TextField field = tester.widget(find.byType(TextField));
    expect(field.autofocus, isTrue);
    final EditableText editable = tester.widget(find.byType(EditableText));
    expect(editable.focusNode.hasFocus, isTrue);
  });
}
