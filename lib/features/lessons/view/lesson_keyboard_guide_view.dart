import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import 'widgets/lesson_keyboard.dart';

/// Arguments for the lessons keyboard-guide page.
///
/// [isUrdu] picks the starting layout; [focusKeys] outlines the keys a
/// lesson introduces (empty when opened from the Lessons list, where no
/// single lesson is in context).
class LessonKeyboardGuideArgs {
  const LessonKeyboardGuideArgs({required this.isUrdu, this.focusKeys = ''});

  final bool isUrdu;
  final String focusKeys;
}

/// Lessons keyboard guide — its OWN page, not part of any typing or
/// practice panel.
///
/// Muhammad's scope decision 2026-11-14: the on-screen keyboard was only
/// to be removed from the typing places (PPSC Urdu test, Urdu typing test,
/// custom Urdu paragraphs, mistake/weak-key practice). In Lessons the
/// finger-guide board lives on, but on a separate page, so the lesson
/// practice panel is never disturbed by it again.
///
/// The board is DISPLAY-ONLY: no [LessonKeyboard] callbacks are passed, so
/// (see `LessonKeyboard._tappable`) no key is tappable — tapping a key
/// types nothing. It is a teaching diagram: the colours show which finger
/// types each key. Both Urdu and English layouts are available here via
/// the language switch.
class LessonKeyboardGuideView extends StatefulWidget {
  const LessonKeyboardGuideView({super.key, this.args});

  /// Null = English layout, no outlined keys (e.g. opened directly).
  final LessonKeyboardGuideArgs? args;

  @override
  State<LessonKeyboardGuideView> createState() =>
      _LessonKeyboardGuideViewState();
}

class _LessonKeyboardGuideViewState extends State<LessonKeyboardGuideView> {
  late bool _isUrdu;
  late String _focusKeys;

  /// The Show/Hide control, restored here on the guide page itself: the
  /// board is shown by default and this button hides/shows it. Opening
  /// the page is already "showing" the guide, so the button is never a
  /// toggle for nothing.
  bool _showBoard = true;

  @override
  void initState() {
    super.initState();
    _isUrdu = widget.args?.isUrdu ?? false;
    _focusKeys = widget.args?.focusKeys ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.lessons,
      body: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Back to Lessons'),
                ),
                const SizedBox(height: 8),
                const PageHeader(
                  title: 'Keyboard guide',
                  subtitle:
                      'Which finger types each key — Urdu and English layouts.',
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    OptionChip(
                      label: 'English',
                      selected: !_isUrdu,
                      onSelected: () => setState(() => _isUrdu = false),
                    ),
                    OptionChip(
                      label: 'Urdu',
                      selected: _isUrdu,
                      onSelected: () => setState(() => _isUrdu = true),
                    ),
                    const SizedBox(width: 6),
                    OutlinedButton.icon(
                      onPressed: () =>
                          setState(() => _showBoard = !_showBoard),
                      icon: const Icon(Icons.keyboard_outlined),
                      label: Text(
                          _showBoard ? 'Hide keyboard' : 'Show keyboard'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_showBoard) ...[
                  // Display-only: NO onCharacter/onSpace/onBackspace
                  // callbacks — the board never types anything.
                  LessonKeyboard(
                    focusKeys: _focusKeys,
                    urdu: _isUrdu,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Colours show which finger types each key. '
                    'Outlined keys are new in this lesson.',
                    style: AppTextStyles.captionOf(context),
                  ),
                  const SizedBox(height: 10),
                  // Legend: one swatch per finger colour, from the
                  // board's own mapping (LessonKeyboard.fingerLegend).
                  // The colours are identical in the Urdu and English
                  // layouts, so the legend is the same for both.
                  Wrap(
                    spacing: 14,
                    runSpacing: 8,
                    children: [
                      for (final entry in LessonKeyboard.fingerLegend)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: entry.color,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              entry.label,
                              style: AppTextStyles.captionOf(context),
                            ),
                          ],
                        ),
                    ],
                  ),
                ] else
                  Text(
                    'Keyboard guide hidden — tap "Show keyboard" to see it again.',
                    style: AppTextStyles.captionOf(context),
                  ),
                const SizedBox(height: 16),
                Text(
                  'This is a guide only — tapping a key types nothing. '
                  'Type with your physical keyboard in the lessons.',
                  style: AppTextStyles.captionOf(context),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
