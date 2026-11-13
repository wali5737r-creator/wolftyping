import 'package:flutter/material.dart';
import 'app_fonts.dart';

/// Text styles used across the app.
///
/// Urdu text needs a taller line height and a Nastaliq font to render
/// correctly: [urduFontFamily] is Noto Nastaliq Urdu (see [AppFonts]).
/// Every other style inherits Inter from the app theme.
class AppTextStyles {
  AppTextStyles._();

  static const String urduFontFamily = AppFonts.urdu;

  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  /// Caption text with NO fixed color: it inherits the ambient text
  /// color. It used to hardcode the light-theme grey, which was too
  /// faint on dark surfaces. Prefer [captionOf] wherever a
  /// BuildContext is available so the muted color of the ACTIVE theme
  /// is used.
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// [caption] with the muted colour of the ACTIVE theme. Prefer this
  /// wherever a BuildContext is available.
  static TextStyle captionOf(BuildContext context) => caption.copyWith(
        color: Theme.of(context).textTheme.bodySmall?.color,
      );

  /// Big stat numbers (WPM, Accuracy) on dashboard / result cards.
  /// Display size (Package A polish): numbers read as headlines.
  static const TextStyle statValue = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: -0.5,
  );

  static const TextStyle statLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );

  /// English typing target/paragraph text style (Inter, like the rest of
  /// the English UI).
  static const TextStyle typingTextEn = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.9,
    fontFamily: AppFonts.ui,
    letterSpacing: 0.2,
  );

  // --- Urdu UI styles (Noto Nastaliq Urdu) ------------------------------
  // Use these for any Urdu / Arabic-script text shown OUTSIDE the typing
  // area (titles, previews, dialogs, picker items). Nastaliq is tall and
  // has a deep descender, so the line height is larger than Latin text.
  // The font is variable (wght 400-700), declared per weight in
  // pubspec.yaml, so w500 (typing text) and w700 (highlighted keyboard
  // keys) are real weights, not faux-bold.

  /// Urdu running text: previews, subtitles, dropdown items.
  /// Height 2.1 (was 1.8): Noto Nastaliq Urdu's natural line height is
  /// 2.5em (ascent 1.904em / descent 0.596em), so at 1.8 the line box
  /// left only ~7.3px below the baseline while the dots below a letter
  /// reach ~0.43em below it — the glyph sat low in its box with its
  /// descenders tight against the container's bottom edge.
  static const TextStyle urduBody = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 2.1,
    fontFamily: urduFontFamily,
  );

  /// Urdu card/section title (replaces [h3] for Urdu strings).
  static const TextStyle urduTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.7,
    fontFamily: urduFontFamily,
  );

  /// Urdu page/result heading (replaces [h1] for Urdu strings).
  static const TextStyle urduHeading = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w400,
    height: 1.7,
    fontFamily: urduFontFamily,
  );

  /// Single Urdu letter in a fixed-height tile (keyboard heatmap).
  /// Height 2.6 (was 1.5): Noto Nastaliq Urdu's natural line height is
  /// 2.5em (ascent 1.904em / descent 0.596em), so at 1.5 the 20px
  /// glyph's 50px extent spilled ~5px past the top and bottom of the
  /// 40px heatmap tile — the same defect the on-screen keyboard had.
  /// At 2.6 the line box is 52px, so the heatmap tiles are 58px tall
  /// (see keyboard_heatmap.dart) and the full glyph — dots above and
  /// below the baseline — fits inside its tile.
  static const TextStyle urduKey = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 2.6,
    fontFamily: urduFontFamily,
  );

  /// Urdu typing target/paragraph text style. Right-to-left, larger line
  /// height, no forced monospace (Urdu is not monospace-friendly).
  /// Height 2.6 (was 2.2): the font's natural line height is 2.5em, so
  /// 2.2 compressed the line box below what the glyphs need — the
  /// current-word highlight (a background painted over the line box)
  /// ended above the dots below the baseline (e.g. the پ of پاکستان).
  /// At 2.6 the box below the baseline is ~0.62em, room for the deepest
  /// positioned dots, and the highlight covers the whole glyph.
  static const TextStyle typingTextUr = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w500,
    height: 2.6,
    fontFamily: urduFontFamily,
  );
}
