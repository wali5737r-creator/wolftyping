import 'dart:ui'
    show
        LineMetrics,
        Paragraph,
        ParagraphBuilder,
        ParagraphConstraints,
        ParagraphStyle;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:typing_master/core/constants/app_fonts.dart';
import 'package:typing_master/core/constants/app_text_styles.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/ppsc/controller/ppsc_typing_controller.dart';
import 'package:typing_master/features/typing_test/controller/urdu_typing_controller.dart';
import 'package:typing_master/features/typing_test/model/typing_screen_phase.dart';
import 'package:typing_master/features/typing_test/model/urdu_style_typing_controller.dart';

/// The on-screen Urdu keyboard was removed 2026-11-14 (Muhammad: "keyboard
/// htao") — see the deleted test/urdu_onscreen_keyboard_test.dart. What
/// remains, and what these tests pin down:
///
///  * no on-screen keyboard renders on the Urdu Typing Test or PPSC Urdu
///    screens (no Shift/Space key caps anywhere);
///  * physical-keyboard input still scores exactly as before, through the
///    same controller methods the physical key handlers call;
///  * the Nastaleeq line boxes still leave room for the dots below the
///    baseline (moved here from the deleted keyboard test — it tests the
///    typing text styles, not the keyboard).
void main() {
  group('no on-screen keyboard on the Urdu screens', () {
    Future<UrduStyleTypingController> startUrduTest(
      WidgetTester tester,
      String route,
    ) async {
      tester.view.physicalSize = const Size(1400, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          initialRoute: route,
          getPages: AppPages.pages,
        ),
      );
      await tester.pumpAndSettle();

      // No ternary here: its inferred type would be the branches' least
      // upper bound (GetxController), not the shared interface.
      final UrduStyleTypingController controller;
      if (route == AppRoutes.ppscUrdu) {
        controller = Get.find<PpscTypingController>();
      } else {
        controller = Get.find<UrduTypingController>();
      }      controller.selectDuration(const Duration(seconds: 60));
      await tester.tap(find.text('Start Test'));
      await tester.pumpAndSettle();
      expect(controller.screenPhase.value, TypingScreenPhase.test);
      return controller;
    }

    testWidgets('Urdu Typing Test shows no on-screen keyboard',
        (tester) async {
      await startUrduTest(tester, AppRoutes.urduTypingTest);
      // The removed board's key caps: a Shift key and a Space key.
      expect(find.text('Shift'), findsNothing);
      expect(find.text('Space'), findsNothing);
      // The passage itself still renders.
      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('PPSC Urdu shows no on-screen keyboard', (tester) async {
      await startUrduTest(tester, AppRoutes.ppscUrdu);
      expect(find.text('Shift'), findsNothing);
      expect(find.text('Space'), findsNothing);
      expect(find.byType(RichText), findsWidgets);
    });
  });

  group('physical-keyboard input still scores correctly', () {
    testWidgets('two words typed via controller calls score 2 correct',
        (tester) async {
      tester.view.physicalSize = const Size(1400, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          initialRoute: AppRoutes.urduTypingTest,
          getPages: AppPages.pages,
        ),
      );
      await tester.pumpAndSettle();

      final UrduTypingController controller =
          Get.find<UrduTypingController>();
      controller.selectDuration(const Duration(seconds: 60));
      await tester.tap(find.text('Start Test'));
      await tester.pumpAndSettle();
      expect(controller.screenPhase.value, TypingScreenPhase.test);
      expect(controller.targetWords.length, greaterThan(1));

      // The physical-key path: _handleKey calls exactly these methods.
      for (final String word in controller.targetWords.take(2)) {
        for (final int rune in word.runes) {
          controller.onCharacter(String.fromCharCode(rune));
        }
        controller.onSpace();
      }
      await tester.pump();
      expect(controller.committedWordBuffers[0], controller.targetWords[0]);
      expect(controller.committedWordBuffers[1], controller.targetWords[1]);
      expect(controller.snapshot.value.correctWords, 2);
      expect(controller.snapshot.value.totalErrors, 0);
      expect(
        controller.snapshot.value.correctCharacters,
        controller.targetWords[0].runes.length +
            controller.targetWords[1].runes.length,
      );
    });
  });

  testWidgets('Nastaleeq line boxes leave room for dots below the baseline',
      (tester) async {
    // Load the real font: the test font has Latin metrics and would
    // not show the Nastaleeq overflow.
    final FontLoader loader = FontLoader(AppFonts.urdu)
      ..addFont(rootBundle.load('assets/fonts/NotoNastaliqUrdu.ttf'));
    await loader.load();
    // Noto Nastaliq Urdu: ascent 1.904em, descent 0.596em, dots below
    // a letter reach ~0.43em below the baseline. The line box must
    // leave at least that much room below the baseline or the dots
    // fall outside the current-word highlight (typingTextUr), the
    // descenders crowd the bottom edge (urduBody), and the glyph
    // spills out of its heatmap tile (urduKey).
    for (final TextStyle style in <TextStyle>[
      AppTextStyles.typingTextUr,
      AppTextStyles.urduBody,
      AppTextStyles.urduKey,
    ]) {
      final ParagraphBuilder builder = ParagraphBuilder(ParagraphStyle(
        fontFamily: style.fontFamily,
        fontSize: style.fontSize,
        height: style.height,
        fontWeight: style.fontWeight,
      ));
      builder.addText('پاکستان ایک خوبصورت ملک ہے');
      final Paragraph paragraph = builder.build();
      paragraph.layout(const ParagraphConstraints(width: 600));
      final List<LineMetrics> lines = paragraph.computeLineMetrics();
      expect(lines, hasLength(1), reason: '$style');
      final double fontSize = style.fontSize!;
      expect(lines.first.descent, greaterThanOrEqualTo(0.48 * fontSize),
          reason: 'descent below baseline for $style');
      expect(lines.first.ascent, greaterThanOrEqualTo(1.35 * fontSize),
          reason: 'ascent above baseline for $style');
    }
  });
}
