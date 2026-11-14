import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/core/constants/app_colors.dart';
import 'package:typing_master/core/constants/app_text_styles.dart';

/// Regression tests for the invisible Urdu passage (2026-11-14, Muhammad's
/// screenshot: the passage box nearly empty, only faint dots). Two causes:
///
///  (1) untyped ("pending") text was mid-grey #9CA3AF at w500 in hairline
///      Nastaliq — 6.88:1 on paper, but strokes ~1px so only dots read;
///  (2) the 675 KB Noto Nastaliq Urdu font was fetched only on first Urdu
///      paint, with no fallback that can draw Urdu on web.
///
/// (2) is fixed outside Dart (preload in web/index.html, cache rule in
/// web/_headers, FontLoader warm-up in main) and is asserted by the
/// build-output check, not here. These tests pin the in-Dart half: the
/// pending colour, the weight, and that correct/wrong/skipped stay
/// distinct from pending.
void main() {
  double contrast(Color a, Color b) {
    final double la = a.computeLuminance();
    final double lb = b.computeLuminance();
    final double hi = la > lb ? la : lb;
    final double lo = la > lb ? lb : la;
    return (hi + 0.05) / (lo + 0.05);
  }

  test('dark pending text is near-white, not mid-grey', () {
    expect(AppColors.pendingText, const Color(0xFFDCE5E0));
    // ~13.6:1 vs the dark typing surface — far above WCAG AAA (7:1),
    // so hairline Nastaliq strokes read even before the first keystroke.
    expect(
      contrast(AppColors.pendingText, AppColors.darkSurface),
      greaterThanOrEqualTo(12.0),
    );
    expect(
      contrast(AppColors.pendingText, AppColors.darkSurface2),
      greaterThanOrEqualTo(10.0),
    );
  });

  test('light pending text is left alone (already readable)', () {
    expect(AppColors.pendingTextLight, const Color(0xFF5A6372));
    expect(
      contrast(AppColors.pendingTextLight, AppColors.lightSurface),
      greaterThanOrEqualTo(4.5),
    );
  });

  test('Urdu typing text is semibold (w600), not w500', () {
    expect(AppTextStyles.typingTextUr.fontWeight, FontWeight.w600);
    expect(AppTextStyles.typingTextUr.fontSize, 26);
    expect(AppTextStyles.typingTextUr.height, 2.6);
  });

  test('pending stays distinct from correct / wrong / skipped', () {
    expect(AppColors.pendingText, isNot(AppColors.correctChar));
    expect(AppColors.pendingText, isNot(AppColors.wrongChar));
    expect(AppColors.pendingText, isNot(AppColors.skippedWord));
    expect(AppColors.pendingText, isNot(AppColors.darkTextPrimary));
  });
}
