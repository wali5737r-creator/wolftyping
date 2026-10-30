/// The two typefaces used by the app. Family names match the `fonts:`
/// entries in pubspec.yaml (and the names Windows itself uses for the
/// installed fonts, so a system-installed copy is also picked up).
///
///  * [ui]   - English text and all UI chrome: Inter.
///  * [urdu] - Urdu text everywhere (typing tests, lessons, practice,
///             PPSC, ...): Jameel Noori Nastaleeq.
///
/// The fonts are applied centrally through `AppTheme` (Inter as the base
/// family, Jameel Noori Nastaleeq as the glyph fallback so any Urdu text
/// automatically renders in it) plus `AppTextStyles.typingTextUr` for the
/// Urdu typing area - individual screens never name a font.
class AppFonts {
  AppFonts._();

  static const String ui = 'Inter';
  static const String urdu = 'Jameel Noori Nastaleeq';

  /// Tried in order for any glyph the base family lacks. Inter has no
  /// Arabic-script glyphs, so Urdu always lands on [urdu].
  static const List<String> fallback = [urdu, 'Segoe UI'];
}
