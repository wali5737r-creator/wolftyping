import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/ppsc/controller/mock_test_controller.dart';
import 'package:typing_master/features/ppsc/model/mock_question.dart';
import 'package:typing_master/features/ppsc/model/mock_test_draft.dart';
import 'package:typing_master/features/ppsc/model/paper_test.dart';
import 'package:typing_master/features/ppsc/service/mock_progress_repository.dart';
import 'package:typing_master/features/ppsc/service/papers2026_registry.dart';
import 'package:typing_master/features/ppsc/view/paper_row.dart';

/// Mid-test resume for PPSC practice-paper tests: leaving a paper test
/// halfway saves a draft on the device (answers, remaining time,
/// current question, option-shuffle seed); the paper row and the setup
/// panel offer 'Jari rakhein' to pick up exactly where the user
/// stopped. Submitting (manually or by auto-submit) or starting the
/// paper fresh clears the draft.
void main() {
  const PaperTest testPaper = PaperTest(
    id: '2026-219',
    paperNo: 219,
    year: 2026,
    post: 'Test Post',
    department: 'Test Department',
    examDate: '01.01.2026',
    questions: <MockQuestion>[
      MockQuestion(
        id: 't-1',
        subject: MockSubject.english,
        question: 'First question?',
        options: <String>['A one', 'B two', 'C three', 'D four'],
        correctIndex: 1,
      ),
      MockQuestion(
        id: 't-2',
        subject: MockSubject.mathematics,
        question: 'Second question?',
        options: <String>['A one', 'B two', 'C three', 'D four'],
        correctIndex: 2,
      ),
      MockQuestion(
        id: 't-3',
        subject: MockSubject.generalKnowledge,
        question: 'Third question?',
        options: <String>['A one', 'B two', 'C three', 'D four'],
        correctIndex: 0,
      ),
    ],
  );

  MockTestDraft draftFor(
    String paperId, {
    Map<String, int> answers = const <String, int>{},
    int remainingSeconds = 600,
    int currentIndex = 0,
    int shuffleSeed = 42,
    int plannedDurationSeconds = 5400,
    int totalQuestions = 3,
  }) {
    return MockTestDraft(
      paperId: paperId,
      answers: answers,
      remainingSeconds: remainingSeconds,
      currentIndex: currentIndex,
      shuffleSeed: shuffleSeed,
      plannedDurationSeconds: plannedDurationSeconds,
      negativeMarking: false,
      negativeDeduction: 0.25,
      totalQuestions: totalQuestions,
      savedAt: 1000,
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    MockProgressRepository.instance.resetForTest();
    await MockProgressRepository.instance.init();
  });

  tearDown(() {
    Get.reset();
  });

  group('MockTestDraft json', () {
    test('round-trips through toJson/fromJson', () {
      final MockTestDraft draft = draftFor(
        '2026-219',
        answers: <String, int>{'t-1': 2, 't-3': 0},
        remainingSeconds: 123,
        currentIndex: 2,
        shuffleSeed: 7,
      );
      final MockTestDraft parsed = MockTestDraft.fromJson(draft.toJson());
      expect(parsed.paperId, '2026-219');
      expect(parsed.answers, <String, int>{'t-1': 2, 't-3': 0});
      expect(parsed.remainingSeconds, 123);
      expect(parsed.currentIndex, 2);
      expect(parsed.shuffleSeed, 7);
      expect(parsed.plannedDurationSeconds, 5400);
      expect(parsed.totalQuestions, 3);
    });

    test('fromJson drops invalid answer entries, keeps the rest', () {
      final MockTestDraft parsed = MockTestDraft.fromJson(
        <String, dynamic>{
          'paperId': '2026-219',
          'answers': <String, dynamic>{
            't-1': 2,
            't-2': 'not-an-int',
            't-3': 7,
            't-4': -1,
          },
          'remainingSeconds': 'soon',
          'currentIndex': -5,
          'shuffleSeed': 9,
        },
      );
      expect(parsed.answers, <String, int>{'t-1': 2});
      expect(parsed.remainingSeconds, 0);
      expect(parsed.currentIndex, 0);
      expect(parsed.shuffleSeed, 9);
    });

    test('fromJson throws only for a missing/empty paperId', () {
      expect(
        () => MockTestDraft.fromJson(<String, dynamic>{}),
        throwsFormatException,
      );
      expect(
        () => MockTestDraft.fromJson(
          <String, dynamic>{'paperId': '   '},
        ),
        throwsFormatException,
      );
      // Everything else bad still parses with defaults.
      final MockTestDraft parsed = MockTestDraft.fromJson(
        <String, dynamic>{'paperId': '2026-219'},
      );
      expect(parsed.paperId, '2026-219');
      expect(parsed.answers, isEmpty);
      expect(parsed.plannedDurationSeconds, 5400);
    });
  });

  group('draft storage in MockProgressRepository', () {
    test('save/load round-trip and persistence across reload', () async {
      final MockTestDraft draft = draftFor(
        '2026-219',
        answers: <String, int>{'t-1': 1},
        remainingSeconds: 321,
        currentIndex: 1,
      );
      await MockProgressRepository.instance.saveDraft(draft);
      expect(
        MockProgressRepository.instance.draftFor('2026-219')?.answers,
        <String, int>{'t-1': 1},
      );

      // App close/reopen: clear in-memory state and reload from the
      // mocked device storage — the draft must still be there.
      MockProgressRepository.instance.resetForTest();
      await MockProgressRepository.instance.init();
      final MockTestDraft? reloaded =
          MockProgressRepository.instance.draftFor('2026-219');
      expect(reloaded, isNotNull);
      expect(reloaded!.answers, <String, int>{'t-1': 1});
      expect(reloaded.remainingSeconds, 321);
      expect(reloaded.currentIndex, 1);
      expect(reloaded.shuffleSeed, 42);
    });

    test('corrupt draft entry is skipped, the rest are kept', () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        MockProgressRepository.draftsKey,
        jsonEncode(<Object>[
          draftFor('2026-219').toJson(),
          <String, dynamic>{
            'answers': <String, dynamic>{'t-1': 1}
          },
          'not-a-map',
          draftFor('2026-220').toJson(),
        ]),
      );
      MockProgressRepository.instance.resetForTest();
      await MockProgressRepository.instance.init();
      expect(
        MockProgressRepository.instance.draftFor('2026-219'),
        isNotNull,
      );
      expect(
        MockProgressRepository.instance.draftFor('2026-220'),
        isNotNull,
      );
      expect(MockProgressRepository.instance.drafts.length, 2);
    });

    test('a wholly corrupt drafts blob loads as empty', () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        MockProgressRepository.draftsKey,
        'this is not json',
      );
      MockProgressRepository.instance.resetForTest();
      await MockProgressRepository.instance.init();
      expect(MockProgressRepository.instance.drafts, isEmpty);
    });

    test('deleteDraft removes the draft and is a no-op when absent', () async {
      await MockProgressRepository.instance.saveDraft(draftFor('2026-219'));
      await MockProgressRepository.instance.deleteDraft('2026-219');
      expect(
        MockProgressRepository.instance.draftFor('2026-219'),
        isNull,
      );
      // No-op: must not throw and must not touch other drafts.
      await MockProgressRepository.instance.saveDraft(draftFor('2026-220'));
      await MockProgressRepository.instance.deleteDraft('2026-999');
      expect(
        MockProgressRepository.instance.draftFor('2026-220'),
        isNotNull,
      );
    });
  });

  group('resume through MockTestController', () {
    late MockTestController controller;

    setUp(() {
      controller = MockTestController();
    });

    tearDown(() {
      controller.onClose();
    });

    Future<void> startAndAnswer() async {
      controller.selectPaper(testPaper);
      controller.startTest();
      expect(controller.phase.value, MockTestPhase.test);
      // Answer Q1 and Q2, then move to Q3.
      controller.selectOptionFor(
        controller.engine.questions[0],
        1,
      );
      controller.selectOptionFor(
        controller.engine.questions[1],
        3,
      );
      // Set the remaining time BEFORE the navigation that autosaves,
      // so the saved draft carries the 10 minutes left.
      controller.remaining.value = const Duration(minutes: 10);
      controller.goToQuestion(2);
      await controller.flushProgress();
    }

    test('autosave writes a draft after selectOption', () async {
      controller.selectPaper(testPaper);
      controller.startTest();
      expect(
        MockProgressRepository.instance.draftFor('2026-219'),
        isNull,
      );
      controller.selectOption(2);
      await controller.flushProgress();
      final MockTestDraft? draft =
          MockProgressRepository.instance.draftFor('2026-219');
      expect(draft, isNotNull);
      expect(draft!.answers.length, 1);
      expect(draft.remainingSeconds, greaterThan(0));
      expect(draft.shuffleSeed, controller.shuffleSeed);
      expect(draft.plannedDurationSeconds, 5400);
    });

    test(
        'resume restores answers, remaining time, current question '
        'and the same option order', () async {
      await startAndAnswer();
      final MockTestDraft? draft =
          MockProgressRepository.instance.draftFor('2026-219');
      expect(draft, isNotNull);
      final String firstId = controller.engine.questions[0].id;
      final String firstOptionText = controller
          .engine.questions[0].options[controller.engine.answerFor(firstId)!];
      final String secondOptionText = controller.engine.questions[1].options[
          controller.engine.answerFor(controller.engine.questions[1].id)!];

      controller.backToSetup();
      expect(controller.phase.value, MockTestPhase.setup);
      // Leaving mid-test keeps the draft.
      expect(
        MockProgressRepository.instance.draftFor('2026-219'),
        isNotNull,
      );

      final bool resumed = await controller.resumeTest(draft!);
      expect(resumed, isTrue);
      expect(controller.phase.value, MockTestPhase.test);
      expect(controller.currentIndex.value, 2);
      expect(
        controller.remaining.value,
        const Duration(minutes: 10),
      );
      expect(controller.selectedDuration.value, const Duration(minutes: 90));
      // Same seed => same shuffled order: the restored answers still
      // point at the same option TEXT as before.
      expect(
        controller
            .engine.questions[0].options[controller.engine.answerFor(firstId)!],
        firstOptionText,
      );
      expect(
        controller.engine.questions[1].options[
            controller.engine.answerFor(controller.engine.questions[1].id)!],
        secondOptionText,
      );
    });

    test('draft is cleared on manual submit', () async {
      await startAndAnswer();
      expect(
        MockProgressRepository.instance.draftFor('2026-219'),
        isNotNull,
      );
      controller.submit();
      await controller.flushProgress();
      expect(
        MockProgressRepository.instance.draftFor('2026-219'),
        isNull,
      );
      expect(controller.phase.value, MockTestPhase.result);
    });

    test('draft is cleared on fresh start', () async {
      await startAndAnswer();
      expect(
        MockProgressRepository.instance.draftFor('2026-219'),
        isNotNull,
      );
      controller.startTest();
      await controller.flushProgress();
      expect(
        MockProgressRepository.instance.draftFor('2026-219'),
        isNull,
      );
      expect(controller.phase.value, MockTestPhase.test);
      expect(controller.engine.answeredCount, 0);
    });

    test('stale draft never crashes and restores only valid answers', () async {
      controller.selectPaper(testPaper);
      const MockTestDraft stale = MockTestDraft(
        paperId: '2026-219',
        // 'gone-1' is not a question in this paper; 't-2' has an
        // out-of-range option; only 't-1' is valid.
        answers: <String, int>{'gone-1': 1, 't-2': 99, 't-1': 2},
        remainingSeconds: 99999,
        currentIndex: 999,
        shuffleSeed: 5,
        plannedDurationSeconds: 5400,
        negativeMarking: false,
        negativeDeduction: 0.25,
        totalQuestions: 999,
        savedAt: 1000,
      );
      final bool resumed = await controller.resumeTest(stale);
      expect(resumed, isTrue);
      expect(controller.phase.value, MockTestPhase.test);
      expect(controller.engine.answers, <String, int>{'t-1': 2});
      // Clamped to the last question and to the planned duration.
      expect(controller.currentIndex.value, 2);
      expect(
        controller.remaining.value,
        const Duration(minutes: 90),
      );
    });

    test('resume with a mismatched paper deletes the stale draft', () async {
      controller.selectPaper(testPaper);
      final bool resumed = await controller.resumeTest(draftFor('2026-220'));
      expect(resumed, isFalse);
      expect(controller.phase.value, MockTestPhase.setup);
      await controller.flushProgress();
      expect(
        MockProgressRepository.instance.draftFor('2026-220'),
        isNull,
      );
    });

    test('resume with no paper selected returns false', () async {
      final bool resumed = await controller.resumeTest(draftFor('2026-219'));
      expect(resumed, isFalse);
    });
  });

  group('resume UI', () {
    Future<MockTestController> pumpMock(
      WidgetTester tester, {
      String initialRoute = AppRoutes.ppscMockTest,
      Object? arguments,
    }) async {
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          initialRoute: initialRoute,
          getPages: AppPages.pages,
        ),
      );
      if (arguments != null) {
        Get.toNamed(initialRoute, arguments: arguments);
      }
      await tester.pumpAndSettle();
      return Get.find<MockTestController>();
    }

    testWidgets('setup panel offers resume and restores the test',
        (tester) async {
      final MockTestController controller = await pumpMock(tester);
      controller.selectPaper(testPaper);
      controller.startTest();
      controller.selectOptionFor(controller.engine.questions[0], 1);
      controller.goToQuestion(1);
      await controller.flushProgress();
      controller.backToSetup();
      await tester.pumpAndSettle();

      expect(find.text('Jari rakhein'), findsOneWidget);
      await tester.ensureVisible(find.text('Jari rakhein'));
      await tester.tap(find.text('Jari rakhein'));
      await tester.pump();
      expect(controller.phase.value, MockTestPhase.test);
      expect(controller.currentIndex.value, 1);
      expect(controller.engine.answeredCount, 1);
      // The draft is still there while the resumed test runs.
      expect(
        MockProgressRepository.instance.draftFor('2026-219'),
        isNotNull,
      );
      controller.onClose();
    });

    testWidgets('setup panel shows no resume button without a draft',
        (tester) async {
      final MockTestController controller = await pumpMock(tester);
      controller.selectPaper(testPaper);
      await tester.pumpAndSettle();
      expect(find.text('Jari rakhein'), findsNothing);
      expect(find.text('Start This Paper'), findsOneWidget);
      controller.onClose();
    });

    testWidgets(
        'resumed test with 2 seconds left auto-submits and clears '
        'the draft', (tester) async {
      final MockTestController controller = await pumpMock(tester);
      controller.selectPaper(testPaper);
      final MockTestDraft shortDraft = draftFor(
        '2026-219',
        answers: <String, int>{'t-1': 0},
        remainingSeconds: 2,
        currentIndex: 0,
      );
      final bool resumed = await controller.resumeTest(shortDraft);
      expect(resumed, isTrue);
      await tester.pump();
      expect(controller.phase.value, MockTestPhase.test);
      // The countdown reaches zero: auto-submit, result phase, and
      // the draft is gone.
      await tester.pump(const Duration(seconds: 3));
      expect(controller.phase.value, MockTestPhase.result);
      expect(controller.autoSubmitted.value, isTrue);
      await controller.flushProgress();
      expect(
        MockProgressRepository.instance.draftFor('2026-219'),
        isNull,
      );
      controller.onClose();
    });

    testWidgets('year-page row resume restores the test with its answers',
        (tester) async {
      // Build a real draft for the first 2026 paper first.
      final MockTestController setupController = MockTestController();
      final PaperTest paper = papers2026.first;
      setupController.selectPaper(paper);
      setupController.startTest();
      setupController.selectOptionFor(
        setupController.engine.questions[0],
        2,
      );
      await setupController.flushProgress();
      final String answeredText = setupController.engine.questions[0].options[
          setupController.engine
              .answerFor(setupController.engine.questions[0].id)!];
      setupController.backToSetup();
      setupController.onClose();
      expect(
        MockProgressRepository.instance.draftFor(paper.id),
        isNotNull,
      );

      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          initialRoute: AppRoutes.ppscPastPapers,
          getPages: AppPages.pages,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('paper-year-2026-header')));
      await tester.pumpAndSettle();
      expect(find.text('2026 Practice Papers'), findsOneWidget);
      expect(find.text('Jari rakhein'), findsOneWidget);

      await tester.ensureVisible(find.text('Jari rakhein').first);
      await tester.tap(find.text('Jari rakhein').first);
      await tester.pumpAndSettle();
      final MockTestController controller = Get.find<MockTestController>();
      expect(controller.phase.value, MockTestPhase.test);
      expect(controller.activePaper.value?.id, paper.id);
      expect(controller.engine.answeredCount, 1);
      expect(
        controller.engine.questions[0].options[
            controller.engine.answerFor(controller.engine.questions[0].id)!],
        answeredText,
      );
      controller.onClose();
    });
  });

  group('PaperRow at 360px', () {
    testWidgets('shows Jari rakhein only with a draft, no overflow',
        (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      Future<void> pumpRow({required bool hasDraft}) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PaperRow(
                paper: testPaper,
                onStart: () {},
                hasDraft: hasDraft,
                onResume: hasDraft ? () {} : null,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      }

      await pumpRow(hasDraft: false);
      expect(find.text('Start'), findsOneWidget);
      expect(find.text('Jari rakhein'), findsNothing);
      expect(tester.takeException(), isNull);

      await pumpRow(hasDraft: true);
      expect(find.text('Start'), findsOneWidget);
      expect(find.text('Jari rakhein'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('tapping Jari rakhein calls onResume, row tap starts',
        (tester) async {
      var resumed = false;
      var started = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaperRow(
              paper: testPaper,
              onStart: () => started = true,
              hasDraft: true,
              onResume: () => resumed = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Jari rakhein'));
      expect(resumed, isTrue);
      expect(started, isFalse);
    });
  });
}
