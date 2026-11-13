import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/core/constants/app_fonts.dart';
import 'package:typing_master/features/practice/controller/practice_controller.dart';
import 'package:typing_master/features/practice/view/widgets/keyboard_heatmap.dart';
import 'package:typing_master/features/typing_test/model/typing_language.dart';

/// The lesson keyboard heatmap's Urdu tiles: the urduKey line box is
/// 20px x 2.6 = 52px (Noto Nastaliq Urdu's natural line height is 2.5em),
/// so the 40px tiles used before let the glyphs' dots and tails spill
/// past the top and bottom edges — the same defect the on-screen keyboard
/// had (commit 7ac2a11). Urdu tiles are now 58px tall; every letter must
/// fit inside its tile at 360px and at desktop width.
void main() {
  group('Urdu heatmap glyph fit', () {
    Future<void> pumpHeatmap(WidgetTester tester, {double width = 800}) async {
      // Constructed directly, never registered with Get: onInit (which
      // loads mistake analysis from the Drift database) never runs, so
      // no database is needed — the heatmap reads the default empty
      // summary and shows every tile in its "no mistakes" state.
      final PracticeController controller = PracticeController();
      controller.selectedLanguage.value = TypingLanguage.urdu;
      tester.view.physicalSize = Size(width, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: width,
                child: KeyboardHeatmap(controller: controller),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('Urdu heatmap glyphs fit inside their tiles at 360px',
        (tester) async {
      await pumpHeatmap(tester, width: 360);
      _assertHeatmapGlyphsFit(tester);
    });

    testWidgets(
        'Urdu heatmap glyphs fit inside their tiles at desktop width',
        (tester) async {
      await pumpHeatmap(tester, width: 800);
      _assertHeatmapGlyphsFit(tester);
    });
  });
}

/// Every Urdu tile label must fit inside its tile's visible box: the
/// label's line box (fontSize x 2.6) may be neither taller nor wider than
/// the decorated tile it is painted in (tile size minus its margin).
void _assertHeatmapGlyphsFit(WidgetTester tester) {
  final Finder urduLabels = find.byWidgetPredicate(
    (Widget w) =>
        w is Text &&
        w.style?.fontFamily == AppFonts.urdu &&
        (w.data?.isNotEmpty ?? false),
  );
  // The 39-letter Urdu alphabet grid.
  expect(urduLabels, findsNWidgets(39));
  for (final Element el in urduLabels.evaluate()) {
    final Text text = el.widget as Text;
    final Container? tile = el.findAncestorWidgetOfExactType<Container>();
    expect(tile, isNotNull, reason: 'tile for ${text.data}');
    final Size tileSize = tester.getSize(find.byWidget(tile!));
    final EdgeInsets margin = tile.margin as EdgeInsets? ?? EdgeInsets.zero;
    final double visualHeight = tileSize.height - margin.vertical;
    final double visualWidth = tileSize.width - margin.horizontal;
    // The tile must be tall enough for the urduKey line box (52px).
    expect(visualHeight, greaterThanOrEqualTo(52.0),
        reason: 'tile for ${text.data} too short for the urduKey line box');
    final Size labelSize = tester.getSize(find.byWidget(text));
    expect(labelSize.height, lessThanOrEqualTo(visualHeight),
        reason: '${text.data} label taller than its tile');
    expect(labelSize.width, lessThanOrEqualTo(visualWidth),
        reason: '${text.data} label wider than its tile');
  }
}
