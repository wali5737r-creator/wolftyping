import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/core/theme/app_theme.dart';

/// Selected "5 minutes" duration button (live run-through 2026-11-13):
/// pale text on light green — the Material 3 default selected label
/// (onSecondaryContainer, a pale dynamic colour for this scheme)
/// against the theme's light tint background. The theme now pins the
/// label to the primary text colour in both states, and these tests
/// pin the measured contrast: >= 4.5:1 (WCAG AA for normal text) for
/// the selected AND unselected label, in light AND dark themes.
void main() {
  group('ChoiceChip contrast (WCAG AA, 4.5:1)', () {
    void checkTheme(String name, ThemeData theme) {
      final ChipThemeData chips = theme.chipTheme;
      final Color selectedBg = chips.selectedColor!;
      final Color selectedFg = chips.secondaryLabelStyle!.color!;
      final Color unselectedBg = chips.backgroundColor!;
      final Color unselectedFg = chips.labelStyle!.color!;
      test('$name: selected chip label meets 4.5:1', () {
        expect(contrast(selectedFg, selectedBg), greaterThanOrEqualTo(4.5));
      });
      test('$name: unselected chip label meets 4.5:1', () {
        expect(
          contrast(unselectedFg, unselectedBg),
          greaterThanOrEqualTo(4.5),
        );
      });
      test('$name: chip labels are the primary text colour', () {
        // The fix is explicit, not a dynamic M3 default: the chip
        // labels must be the same readable colour as body text.
        expect(selectedFg, theme.textTheme.bodyLarge!.color);
        expect(unselectedFg, theme.textTheme.bodyLarge!.color);
      });
    }

    checkTheme('light', AppTheme.light);
    checkTheme('dark', AppTheme.dark);
  });

  testWidgets('a selected ChoiceChip renders the readable label colour',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const Scaffold(
          body: ChoiceChip(
            label: Text('5 minutes'),
            selected: true,
            onSelected: null,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final TextStyle rendered =
        DefaultTextStyle.of(tester.element(find.text('5 minutes'))).style;
    expect(
      rendered.color,
      AppTheme.light.chipTheme.secondaryLabelStyle!.color,
    );
    expect(
      contrast(
        rendered.color!,
        AppTheme.light.chipTheme.selectedColor!,
      ),
      greaterThanOrEqualTo(4.5),
    );
  });
}

/// WCAG contrast ratio between two opaque colours.
double contrast(Color foreground, Color background) {
  final double l1 = _luminance(foreground);
  final double l2 = _luminance(background);
  final double light = math.max(l1, l2);
  final double dark = math.min(l1, l2);
  return (light + 0.05) / (dark + 0.05);
}

/// WCAG relative luminance for an opaque colour. [Color.r]/[Color.g]/
/// [Color.b] are 0..1 doubles in this Flutter version.
double _luminance(Color color) {
  double channel(double c) {
    if (c <= 0.03928) return c / 12.92;
    return math.pow((c + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * channel(color.r) +
      0.7152 * channel(color.g) +
      0.0722 * channel(color.b);
}
