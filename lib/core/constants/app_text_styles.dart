import 'package:flutter/material.dart';
import 'app_fonts.dart';

/// Text styles used across the app.
///
/// Urdu text needs a taller line height and a Nastaliq font to render
/// correctly: [urduFontFamily] is Jameel Noori Nastaleeq (see [AppFonts]).
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

  // --- Urdu UI styles (Jameel Noori Nastaleeq) -------------------------
  // Use these for any Urdu / Arabic-script text shown OUTSIDE the typing
  // area (titles, previews, dialogs, picker items). Nastaleeq is tall and
  // has a deep descender, so the line height is larger than Latin text.
  // The font ships in one weight only, so no bold (it would be faux-bold).

  /// Urdu running text: previews, subtitles, dropdown items.
  static const TextStyle urduBody = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.8,
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
  static const TextStyle urduKey = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.5,
    fontFamily: urduFontFamily,
  );

  /// Urdu typing target/paragraph text style. Right-to-left, larger line
  /// height, no forced monospace (Urdu is not monospace-friendly).
  static const TextStyle typingTextUr = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w500,
    height: 2.2,
    fontFamily: urduFontFamily,
  );
}
