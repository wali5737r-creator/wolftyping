import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/ppsc/model/custom_set.dart';
import 'package:typing_master/features/ppsc/model/mock_question.dart';
import 'package:typing_master/features/ppsc/service/custom_sets_repository.dart';

CustomSet _seedSet() => CustomSet(
  id: 'custom-seed',
  name: 'Seed Quiz',
  questions: [
    const MockQuestion(
      id: 's1',
      subject: MockSubject.generalKnowledge,
      question: 'Seed question one?',
      options: ['A', 'B', 'C', 'D'],
      correctIndex: 1,
    ),
    const MockQuestion(
      id: 's2',
      subject: MockSubject.generalKnowledge,
      question: 'Seed question two?',
      options: ['A', 'B', 'C', 'D'],
      correctIndex: 0,
    ),
  ],
);

Future<void> _pumpCustomTests(WidgetTester tester) async {
  await tester.pumpWidget(
    GetMaterialApp(
      theme: AppTheme.light,
      initialRoute: AppRoutes.ppscCustomTests,
      getPages: AppPages.pages,
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('custom tests list shows empty state and editor opens',
      (tester) async {
    await _pumpCustomTests(tester);
    expect(find.text('My Custom Tests'), findsWidgets);
    expect(find.text('No custom tests yet'), findsOneWidget);
    expect(find.text('Create custom test'), findsOneWidget);

    await tester.tap(find.text('Create custom test'));
    await tester.pumpAndSettle();
    expect(find.text('Create Custom Test'), findsOneWidget);
    expect(find.text('Set name'), findsOneWidget);
    expect(find.text('Add question'), findsOneWidget);
    expect(find.text('Save set'), findsOneWidget);
    // One blank question card with exactly 4 option fields.
    expect(find.text('Question 1'), findsOneWidget);
    expect(find.text('Option A'), findsOneWidget);
    expect(find.text('Option D'), findsOneWidget);
  });

  testWidgets('saved custom set lists, and runs through the engine panels',
      (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      CustomSetsRepository.storageKey:
          jsonEncode([_seedSet().toJson()]),
    });
    await _pumpCustomTests(tester);
    expect(find.text('Seed Quiz'), findsOneWidget);
    expect(find.text('Start this test'), findsOneWidget);

    await tester.tap(find.text('Start this test'));
    await tester.pumpAndSettle();
    // The shared mock-test controller carried the set to its setup panel.
    expect(find.text('Custom Test: Seed Quiz'), findsOneWidget);
    expect(find.text('Start This Custom Test'), findsOneWidget);

    await tester.ensureVisible(find.text('Start This Custom Test'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start This Custom Test'));
    // pump(), not pumpAndSettle(): the running test's 1-second timer
    // keeps scheduling frames, so pumpAndSettle would never settle.
    await tester.pump();
    expect(find.text('Question 1 of 2'), findsOneWidget);
    expect(find.text('Question Palette'), findsOneWidget);
    expect(find.text('Submit Test'), findsOneWidget);
  });

  testWidgets('import dialog opens from the custom tests list',
      (tester) async {
    await _pumpCustomTests(tester);
    await tester.tap(find.text('Import a shared test'));
    await tester.pumpAndSettle();
    expect(find.text('Import a shared test'), findsWidgets);
    expect(find.text('Share code'), findsOneWidget);
    expect(find.text('Import'), findsOneWidget);
  });
}
