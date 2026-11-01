import 'package:flutter/material.dart';

/// Centralized color palette for WolfTyping.
///
/// Rule: colors used to signal typing state (correct / wrong / current word /
/// warning) must ALWAYS come from here so the meaning stays consistent
/// across the Typing Test, Lessons, Practice and PPSC screens.
class AppColors {
  AppColors._();

  // Brand
  // Deep Teal. Primary is the button / selected-state colour on light and
  // dark; primaryDark is the brighter variant used for text, borders and
  // tints on dark surfaces. Secondary (amber) is for the second chart line.
  static const Color primary = Color(0xFF0F766E);
  static const Color primaryDark = Color(0xFF2DD4BF);
  static const Color secondary = Color(0xFFD97706);

  // Light theme surfaces — L1 "Teal Depth" (designer report 2026-10-31).
  // S1 = card, S2 = inner tile / input fill, S3 = track / third level.
  // The sidebar is dark teal in BOTH themes, so it has its own text tokens.
  static const Color lightBackground = Color(0xFFE9F2F0);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurface2 = Color(0xFFF4FAF8);
  static const Color lightSurface3 = Color(0xFFDCEAE7);
  static const Color lightTint = Color(0xFFD9EDE8);
  static const Color lightSidebar = Color(0xFF0B4F4A);
  static const Color lightSidebarGradientStart = Color(0xFF07332F);
  static const Color lightSidebarGradientEnd = Color(0xFF0B4F4A);
  static const Color lightSidebarText = Color(0xFFEAF6F3);
  static const Color lightSidebarSecondary = Color(0xFFA7CFC8);
  static const Color lightSidebarAccent = Color(0xFF2DD4BF);
  static const Color lightBorder = Color(0xFFC9DBD6);
  static const Color lightTextPrimary = Color(0xFF12211E);
  static const Color lightTextSecondary = Color(0xFF4A5A57);
  static const Color lightPrimaryText = Color(0xFF0B5B54);
  static const Color lightAccentText = Color(0xFFB45309);
  static const Color lightSuccessText = Color(0xFF15803D);
  static const Color lightWarningText = Color(0xFF92400E);
  static const Color lightErrorText = Color(0xFFBE123C);

  // Dark theme surfaces — D1 "Teal Night" (designer report 2026-10-31).
  // Depth is tonal: each higher surface is lighter; no pure black/white.
  static const Color darkBackground = Color(0xFF0A1211);
  static const Color darkSurface = Color(0xFF101C1A);
  // Deepened steps (Package A polish, 2026-11-01) so dark cards lift
  // off the background; all text pairs on S2/S3 stay WCAG AA.
  static const Color darkSurface2 = Color(0xFF182A26);
  static const Color darkSurface3 = Color(0xFF21382F);
  static const Color darkTint = Color(0xFF14302B);
  static const Color darkSidebar = Color(0xFF08100F);
  static const Color darkSidebarGradientStart = Color(0xFF050C0B);
  static const Color darkSidebarGradientEnd = Color(0xFF0E2A26);
  static const Color darkSidebarText = Color(0xFFEDF5F2);
  static const Color darkSidebarSecondary = Color(0xFF9DB3AD);
  static const Color darkSidebarAccent = Color(0xFF5EEAD4);
  static const Color darkBorder = Color(0xFF24382F);
  static const Color darkTextPrimary = Color(0xFFEDF5F2);
  static const Color darkTextSecondary = Color(0xFF9DB3AD);
  static const Color darkPrimaryText = Color(0xFF5EEAD4);
  static const Color darkAccentText = Color(0xFFF59E0B);
  static const Color darkSuccessText = Color(0xFF4ADE80);
  static const Color darkWarningText = Color(0xFFFBBF24);
  static const Color darkErrorText = Color(0xFFFB7185);

  // Typing engine semantic states (same across light/dark)
  static const Color correctChar = Color(0xFF16A34A); // green
  static const Color correctCharBg = Color(0x1A16A34A);
  static const Color wrongChar = Color(0xFFE11D48); // red
  static const Color wrongCharBg = Color(0x1AE11D48);
  static const Color skippedWord = Color(0xFFF59E0B); // amber
  static const Color skippedWordBg = Color(0x1AF59E0B);
  static const Color currentWordBg = Color(0x3314B8A6);
  static const Color pendingText = Color(0xFF9CA3AF);

  // Light-theme variants of the typing-text colors. The colors above were
  // chosen for the dark background; on a white/near-white surface the grey
  // (~2.5:1) and amber (~2:1) were too faint to read. These are all
  // >= 4.5:1 against the light surfaces. The dark theme keeps the originals.
  static const Color pendingTextLight = Color(0xFF5A6372); // grey
  static const Color correctCharLight = Color(0xFF15803D); // green
  static const Color skippedWordLight = Color(0xFFB45309); // amber/brown

  // Wrong-character text variants tuned for the new surfaces (>= 4.5:1).
  static const Color wrongCharLight = Color(0xFFC81443);
  static const Color wrongCharDark = Color(0xFFFB7185);

  // Legacy shadow tones (retained for compatibility; AppShadows no longer
  // uses the neumorphic pair — see AppShadows for the layered/tonal recipe).
  static const Color lightShadowDark = Color(0xFFC0CFCD);
  static const Color lightShadowHighlight = Color(0xFFFFFFFF);
  static const Color darkShadowDark = Color(0xFF0A0B0E);
  static const Color darkShadowHighlight = Color(0xFF262A33);

  // Clay accents (Dashboard stat cards only). Each is used as a soft tint
  // of the card surface, never as a flat saturated fill.
  // (clayBlue keeps its name but now carries the brand teal; clayTeal is a
  // cyan so the two stay distinguishable side by side.)
  static const Color clayBlue = Color(0xFF0F766E);
  static const Color clayTeal = Color(0xFF0891B2);
  static const Color clayAmber = Color(0xFFD97706);
  static const Color clayViolet = Color(0xFF7C5CE0);

  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFE11D48);

  // Streak
  // Keyboard heatmap "good" level: sits between strong (green) and needs
  // practice (amber) so it is not confused with the teal brand colour.
  static const Color goodKey = Color(0xFF65A30D);

  static const Color streakFlame = Color(0xFFFF7A1A);
}
