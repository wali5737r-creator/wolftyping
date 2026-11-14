import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/lessons/controller/lesson_practice_controller.dart';
import 'package:typing_master/features/lessons/model/lesson_with_progress.dart';
import 'package:typing_master/features/lessons/service/english_lesson_definitions.dart';
import 'package:typing_master/features/lessons/service/urdu_lesson_definitions.dart';
import 'package:typing_master/features/lessons/view/lesson_practice_view.dart';
import 'package:typing_master/features/typing_test/model/typing_language.dart';

/// DEFECT 2 reproduction (Muhammad, 2026-11-14): with "Urdu Lessons"
/// selected, Lesson 1 still shows the English title and Latin drill
/// boxes ("ff, jjj, jfj…") — no Urdu content — even after Exit + Restart.
///
/// Suspected root cause: the LessonPracticeController is NOT disposed
/// when the practice route is popped (the practice clock keeps running
/// on other pages — the fresh-tab check saw the timer advance 00:59 →
/// 01:16 → 01:44 after leaving practice), so `onInit` never re-runs and
/// the `late final lesson` stays the FIRST lesson opened (English).
/// Re-entering practice with a different lesson must show the new
/// lesson's content.
///
/// NOTE: each test pumps its own GetMaterialApp, so GetX's global
/// registry must be reset between tests or a leftover controller/route
/// from the previous test leaks into the next one.
void main() {
  tearDown(Get.reset);
  LessonWithProgress lessonOf(TypingLanguage language, int dbId) {
    final definition = language == TypingLanguage.english
        ? EnglishLessonDefinitions.all.first
        : UrduLessonDefinitions.all.first;
    return LessonWithProgress(
      dbId: dbId,
      definition: definition,
      completed: false,
      bestAccuracy: 0,
      bestSpeed: 0,
      attempts: 0,
      lastAttemptAt: null,
      locked: false,
    );
  }

  Future<void> pumpApp(WidgetTester tester) async {
    Get.testMode = true;
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/home',
        getPages: [
          GetPage(name: '/home', page: () => const SizedBox()),
          GetPage(
            name: '/lesson-practice',
            page: () => const SizedBox(),
            binding: BindingsBuilder(() {
              Get.lazyPut<LessonPracticeController>(
                () => LessonPracticeController(),
              );
            }),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('re-entering practice with an Urdu lesson shows Urdu content',
      (WidgetTester tester) async {
    await pumpApp(tester);

    // First visit: English Lesson 1.
    await tester.runAsync(() async {
      Get.toNamed('/lesson-practice',
          arguments: lessonOf(TypingLanguage.english, 1));
    });
    await tester.pumpAndSettle();
    final LessonPracticeController first =
        Get.find<LessonPracticeController>();
    expect(first.lesson.definition.language, TypingLanguage.english);
    expect(first.lesson.definition.content, contains('ff'));

    // Exit (the practice screen's Exit button does Get.back()).
    await tester.runAsync(() async {
      Get.back();
    });
    await tester.pumpAndSettle();

    // Second visit: Urdu Lesson 1.
    await tester.runAsync(() async {
      Get.toNamed('/lesson-practice',
          arguments: lessonOf(TypingLanguage.urdu, 101));
    });
    await tester.pumpAndSettle();
    final LessonPracticeController second =
        Get.find<LessonPracticeController>();
    expect(
      second.lesson.definition.language,
      TypingLanguage.urdu,
      reason: 're-entering practice with an Urdu lesson must load the '
          'Urdu definition, not keep the first (English) lesson',
    );
    expect(second.lesson.definition.content, contains('فف'));
  });

  testWidgets('leaving practice disposes the controller (clock stops)',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.runAsync(() async {
      Get.toNamed('/lesson-practice',
          arguments: lessonOf(TypingLanguage.english, 1));
    });
    await tester.pumpAndSettle();
    final LessonPracticeController controller =
        Get.find<LessonPracticeController>();
    controller.startPractice();
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      Get.back();
    });
    await tester.pumpAndSettle();

    expect(
      Get.isRegistered<LessonPracticeController>(),
      isFalse,
      reason: 'the practice controller must be disposed when the '
          'practice route is popped, otherwise its clock keeps running '
          'on other pages and its lesson goes stale',
    );
  });

  /// Same re-entry flow, but through the REAL LessonPracticeView (the
  /// stub-page test above passes — if this one fails, something in the
  /// real view keeps the controller alive across navigations).
  testWidgets('real view: re-entering practice with Urdu shows Urdu boxes',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Get.testMode = true;
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: '/home',
        getPages: [
          GetPage(name: '/home', page: () => const SizedBox()),
          GetPage(
            name: '/lesson-practice',
            page: () => const LessonPracticeView(),
            binding: BindingsBuilder(() {
              Get.lazyPut<LessonPracticeController>(
                () => LessonPracticeController(),
              );
            }),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();

    bool hasPlainText(String plain) {
      return find
          .byWidgetPredicate((Widget w) =>
              w is RichText && w.text.toPlainText().contains(plain))
          .evaluate()
          .isNotEmpty;
    }

    // First visit: English Lesson 1 — intro preview shows Latin boxes.
    await tester.runAsync(() async {
      Get.toNamed('/lesson-practice',
          arguments: lessonOf(TypingLanguage.english, 1));
    });
    await tester.pumpAndSettle();
    expect(hasPlainText('ff'), isTrue);

    // Exit, then re-enter with Urdu Lesson 1.
    await tester.runAsync(() async {
      Get.back();
    });
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      Get.toNamed('/lesson-practice',
          arguments: lessonOf(TypingLanguage.urdu, 101));
    });
    await tester.pumpAndSettle();
    expect(
      hasPlainText('فف'),
      isTrue,
      reason: 'the intro preview must show the Urdu drill (فف…) when '
          'the lesson opened is the Urdu Lesson 1',
    );
    expect(
      hasPlainText('ff'),
      isFalse,
      reason: 'no Latin drill boxes may remain after opening the Urdu '
          'lesson',
    );
  });

  /// [LessonPracticeController.ensureLesson]: if a controller instance
  /// is ever reused across navigations (the binding normally disposes
  /// it on pop — see the tests above — but a stale instance must still
  /// be harmless), the screen re-binds to the lesson of the CURRENT
  /// navigation instead of showing the previous lesson's drill.
  testWidgets('ensureLesson re-binds a reused controller to new arguments',
      (WidgetTester tester) async {
    await pumpApp(tester);

    // Open with English Lesson 1 args and create the controller
    // manually, so it is NOT owned by the route binding and survives
    // the navigation below — the reuse scenario.
    await tester.runAsync(() async {
      Get.toNamed('/lesson-practice',
          arguments: lessonOf(TypingLanguage.english, 1));
    });
    await tester.pumpAndSettle();
    final LessonPracticeController controller = LessonPracticeController();
    Get.put<LessonPracticeController>(controller);
    // Get.put does not call onInit for a manually registered
    // controller — bind the lesson explicitly.
    controller.onInit();
    expect(controller.lesson.definition.language, TypingLanguage.english);
    expect(controller.lesson.definition.content, contains('ff'));

    // A new navigation now carries Urdu Lesson 1 args while the SAME
    // controller instance lives on. (preventDuplicates: false — plain
    // toNamed to the route already on top is a no-op in GetX.)
    await tester.runAsync(() async {
      Get.toNamed('/lesson-practice',
          arguments: lessonOf(TypingLanguage.urdu, 101),
          preventDuplicates: false);
    });
    await tester.pumpAndSettle();
    controller.ensureLesson();

    expect(controller.lesson.definition.language, TypingLanguage.urdu);
    expect(controller.lesson.definition.content, contains('فف'));
    expect(controller.phase.value, LessonPracticePhase.intro);

    // Calling it again with the same arguments is a no-op.
    controller.ensureLesson();
    expect(controller.lesson.definition.language, TypingLanguage.urdu);
  });
}
