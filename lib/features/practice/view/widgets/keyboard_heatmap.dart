import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../typing_test/model/typing_language.dart';
import '../../controller/practice_controller.dart';
import '../../model/character_mistake_stat.dart';
import '../../model/key_strength.dart';
import 'mistake_detail_dialog.dart';

/// Professional keyboard heatmap (spec section 9-10). English renders a
/// simplified but recognizable physical keyboard layout, colored by
/// mistake frequency. Urdu deliberately does NOT invent a QWERTY-to-Urdu
/// key mapping (spec explicitly forbids guessing one) — instead it shows
/// the standard Urdu alphabet in a heatmap grid, which is reliable and
/// still gives real per-letter weak-spot information.
class KeyboardHeatmap extends StatelessWidget {
  const KeyboardHeatmap({super.key, required this.controller});

  final PracticeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isEnglish =
          controller.selectedLanguage.value == TypingLanguage.english;
      return isEnglish
          ? _EnglishKeyboard(controller: controller)
          : _UrduAlphabetGrid(controller: controller);
    });
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 6,
      children: [
        for (final s in KeyStrength.values) _LegendDot(strength: s),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.strength});

  final KeyStrength strength;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: _colorFor(context, strength),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: _hueFor(strength), width: 1),
          ),
        ),
        const SizedBox(width: 6),
        Text(strength.label, style: AppTextStyles.captionOf(context)),
      ],
    );
  }
}

/// Base hue for each strength level. The tile fill is a stronger tint of it
/// than the old 10% alpha so the levels stay distinguishable on both the
/// light and the dark card surface.
Color _hueFor(KeyStrength s) {
  switch (s) {
    case KeyStrength.strong:
      return AppColors.correctChar;
    case KeyStrength.good:
      return AppColors.goodKey;
    case KeyStrength.needsPractice:
      return AppColors.warning;
    case KeyStrength.weak:
      return AppColors.danger;
  }
}

Color _colorFor(BuildContext context, KeyStrength s) {
  final bool isDark = Theme.of(context).brightness == Brightness.dark;
  return _hueFor(s).withValues(alpha: isDark ? 0.30 : 0.20);
}

class _EnglishKeyboard extends StatelessWidget {
  const _EnglishKeyboard({required this.controller});

  final PracticeController controller;

  static const List<List<String>> _rows = [
    ['`', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '='],
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '[', ']'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ';', "'"],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M', ',', '.', '/'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Legend(),
        const SizedBox(height: 12),
        Row(
          children: [
            for (final k in _rows[0])
              Expanded(child: _KeyTile(label: k, controller: controller)),
            Expanded(
              flex: 2,
              child: _KeyTile(
                  label: 'Backspace', controller: controller, trackable: false),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _KeyTile(
                  label: 'Tab', controller: controller, trackable: false),
            ),
            for (final k in _rows[1])
              Expanded(child: _KeyTile(label: k, controller: controller)),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _KeyTile(
                  label: 'Caps', controller: controller, trackable: false),
            ),
            for (final k in _rows[2])
              Expanded(child: _KeyTile(label: k, controller: controller)),
            Expanded(
              flex: 2,
              child: _KeyTile(
                  label: 'Enter', controller: controller, trackable: false),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _KeyTile(
                  label: 'Shift', controller: controller, trackable: false),
            ),
            for (final k in _rows[3])
              Expanded(child: _KeyTile(label: k, controller: controller)),
            Expanded(
              flex: 2,
              child: _KeyTile(
                  label: 'Shift', controller: controller, trackable: false),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 6,
              child: _KeyTile(
                  label: 'Space', controller: controller, trackable: false),
            ),
          ],
        ),
      ],
    );
  }
}

class _UrduAlphabetGrid extends StatelessWidget {
  const _UrduAlphabetGrid({required this.controller});

  final PracticeController controller;

  /// The standard Urdu alphabet — a fixed, well-established ordering,
  /// independent of any physical keyboard layout (see class doc for why
  /// this widget deliberately avoids a QWERTY position mapping for Urdu).
  static const List<String> _alphabet = [
    'ا', 'آ', 'ب', 'پ', 'ت', 'ٹ', 'ث', 'ج', 'چ', 'ح', 'خ', 'د', 'ڈ', 'ذ',
    'ر', 'ڑ', 'ز', 'ژ', 'س', 'ش', 'ص', 'ض', 'ط', 'ظ', 'ع', 'غ', 'ف', 'ق',
    'ک', 'گ', 'ل', 'م', 'ن', 'و', 'ہ', 'ھ', 'ء', 'ی', 'ے',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Legend(),
        const SizedBox(height: 6),
        Text(
          'Urdu keyboard layouts vary by device, so this heatmap shows '
          'the alphabet directly rather than guessing physical key '
          'positions.',
          style: AppTextStyles.captionOf(context),
        ),
        const SizedBox(height: 12),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final c in _alphabet)
                _KeyTile(label: c, controller: controller, width: 46),
            ],
          ),
        ),
      ],
    );
  }
}

class _KeyTile extends StatelessWidget {
  const _KeyTile({
    required this.label,
    required this.controller,
    this.trackable = true,
    this.width,
  });

  final String label;
  final PracticeController controller;
  final bool trackable;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final Widget content =
        trackable ? _trackedKey(context) : _plainKey(context);
    return width != null ? SizedBox(width: width, child: content) : content;
  }

  Widget _plainKey(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: AppTextStyles.captionOf(context)),
    );
  }

  Widget _trackedKey(BuildContext context) {
    return Obx(() {
      final KeyStrength strength = controller.strengthForKey(label);
      final CharacterMistakeStat? stat = controller.statForKey(label);
      final bool isUrdu =
          controller.selectedLanguage.value == TypingLanguage.urdu;
      return Tooltip(
        message: stat == null
            ? '$label — no mistakes'
            : '$label — ${stat.count} mistakes',
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => showDialog(
            context: context,
            builder: (_) => MistakeDetailDialog(
              character: label,
              stat: stat,
              controller: controller,
              isUrdu: isUrdu,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(3),
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _colorFor(context, strength),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: _hueFor(strength).withValues(alpha: 0.55)),
            ),
            child: Text(label,
                style: isUrdu
                    ? AppTextStyles.urduKey
                    : AppTextStyles.bodyMedium),
          ),
        ),
      );
    });
  }
}
