import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/lessons/view/lesson_keyboard_guide_view.dart';
import 'package:typing_master/features/lessons/view/widgets/lesson_keyboard.dart';

/// Lessons keyboard guide (Muhammad's scope decision 2026-11-14):
///
/// the on-screen keyboard was only removed from the TYPING places. In
/// Lessons the finger-guide board lives on — as its OWN page, display-only
/// (no input callbacks), for Urdu AND English. These tests pin down:
///
///  * the guide page renders the coloured finger-guide board (both
///    languages) with the finger-colour caption;
///  * a legend under the board names every finger colour (same mapping
///    the board paints, so a learner can tell which colour means which
///    finger) in both layouts;
///  * the board is display-only: no onCharacter/onSpace/onBackspace
///    callbacks are wired, no key is tappable, tapping a key types
///    nothing;
///  * the Show/Hide control on the guide page hides/shows the board;
///  * the route is registered and opens from the Lessons area with the
///    right language.
///
/// The typing screens stay keyboard-free — that is pinned by
/// test/urdu_physical_keyboard_test.dart (kept passing, untouched here).
void main() {
  Future<void> pumpGuide(
    WidgetTester tester, {
    LessonKeyboardGuideArgs? args,
  }) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        home: LessonKeyboardGuideView(args: args),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('lessons keyboard guide page', () {
    testWidgets('English guide renders the finger-guide board + caption',
        (tester) async {
      await pumpGuide(tester);
      expect(find.text('Keyboard guide'), findsOneWidget);
      expect(find.byType(LessonKeyboard), findsOneWidget);
      // Key caps of the board: the wide Space key and both Shift keys.
      expect(find.text('Space'), findsOneWidget);
      expect(find.text('Shift'), findsNWidgets(2));
      expect(
        find.text(
          'Colours show which finger types each key. '
          'Outlined keys are new in this lesson.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('Urdu guide renders the board in Urdu layout',
        (tester) async {
      await pumpGuide(
        tester,
        args: const LessonKeyboardGuideArgs(isUrdu: true),
      );
      expect(find.byType(LessonKeyboard), findsOneWidget);
      final LessonKeyboard board =
          tester.widget<LessonKeyboard>(find.byType(LessonKeyboard));
      expect(board.urdu, isTrue);
      expect(find.text('Space'), findsOneWidget);
      expect(find.text('Shift'), findsNWidgets(2));
    });

    // The legend (2026-11-14): the caption alone never said which
    // colour belongs to which finger, so a new learner could not read
    // the board from the page alone. One swatch per finger, from the
    // board's own mapping — same in both layouts, since the colours
    // are identical in Urdu and English.
    testWidgets('legend names every finger colour (English layout)',
        (tester) async {
      await pumpGuide(tester);
      for (final label in [
        'Little finger',
        'Ring finger',
        'Middle finger',
        'Index finger',
        'Thumb (Space bar)',
      ]) {
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('legend is present in the Urdu layout too',
        (tester) async {
      await pumpGuide(
        tester,
        args: const LessonKeyboardGuideArgs(isUrdu: true),
      );
      for (final label in [
        'Little finger',
        'Ring finger',
        'Middle finger',
        'Index finger',
        'Thumb (Space bar)',
      ]) {
        expect(find.text(label), findsOneWidget);
      }
    });

    test('fingerLegend pins the board\'s exact colour mapping', () {
      final legend = LessonKeyboard.fingerLegend;
      expect(legend.map((e) => e.label), [
        'Little finger',
        'Ring finger',
        'Middle finger',
        'Index finger',
        'Thumb (Space bar)',
      ]);
      expect(legend.map((e) => e.color), [
        const Color(0xFF8B5CF6),
        const Color(0xFF0891B2),
        const Color(0xFFD97706),
        const Color(0xFF0F766E),
        const Color(0xFF64748B),
      ]);
    });

    testWidgets('language switch flips the board Urdu <-> English',
        (tester) async {
      await pumpGuide(tester);
      expect(
        tester.widget<LessonKeyboard>(find.byType(LessonKeyboard)).urdu,
        isFalse,
      );
      await tester.tap(find.text('Urdu'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<LessonKeyboard>(find.byType(LessonKeyboard)).urdu,
        isTrue,
      );
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<LessonKeyboard>(find.byType(LessonKeyboard)).urdu,
        isFalse,
      );
    });

    testWidgets('board is display-only: no callbacks, no tappable keys',
        (tester) async {
      await pumpGuide(
        tester,
        args: const LessonKeyboardGuideArgs(isUrdu: true),
      );
      final LessonKeyboard board =
          tester.widget<LessonKeyboard>(find.byType(LessonKeyboard));
      expect(board.onCharacter, isNull);
      expect(board.onSpace, isNull);
      expect(board.onBackspace, isNull);
      // Display-only keys have no InkWell at all (see _KeyCap) — scope
      // the check to the board itself: the scaffold and chips around it
      // legitimately use InkWell.
      expect(
        find.descendant(
          of: find.byType(LessonKeyboard),
          matching: find.byType(InkWell),
        ),
        findsNothing,
      );
      // Tapping a key types nothing and leaves the page exactly as-is.
      await tester.tap(find.text('Space'));
      await tester.pumpAndSettle();
      expect(find.byType(LessonKeyboard), findsOneWidget);
      expect(find.text('Keyboard guide'), findsOneWidget);
    });

    testWidgets('Show/Hide control hides and shows the board',
        (tester) async {
      await pumpGuide(tester);
      expect(find.text('Hide keyboard'), findsOneWidget);
      await tester.tap(find.text('Hide keyboard'));
      await tester.pumpAndSettle();
      expect(find.byType(LessonKeyboard), findsNothing);
      expect(find.text('Show keyboard'), findsOneWidget);
      await tester.tap(find.text('Show keyboard'));
      await tester.pumpAndSettle();
      expect(find.byType(LessonKeyboard), findsOneWidget);
      expect(find.text('Hide keyboard'), findsOneWidget);
    });
  });

  group('guide route', () {
    testWidgets('route opens the guide page with the passed language',
        (tester) async {
      tester.view.physicalSize = const Size(1400, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          getPages: AppPages.pages,
          home: const SizedBox.shrink(),
        ),
      );
      await tester.pumpAndSettle();
      Get.toNamed(
        AppRoutes.lessonKeyboardGuide,
        arguments: const LessonKeyboardGuideArgs(isUrdu: true),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LessonKeyboardGuideView), findsOneWidget);
      expect(find.byType(LessonKeyboard), findsOneWidget);
      expect(
        tester.widget<LessonKeyboard>(find.byType(LessonKeyboard)).urdu,
        isTrue,
      );
    });

    testWidgets('route with no argument opens the English guide',
        (tester) async {
      tester.view.physicalSize = const Size(1400, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          getPages: AppPages.pages,
          home: const SizedBox.shrink(),
        ),
      );
      await tester.pumpAndSettle();
      Get.toNamed(AppRoutes.lessonKeyboardGuide);
      await tester.pumpAndSettle();
      expect(find.byType(LessonKeyboardGuideView), findsOneWidget);
      expect(
        tester.widget<LessonKeyboard>(find.byType(LessonKeyboard)).urdu,
        isFalse,
      );
    });
  });
}
