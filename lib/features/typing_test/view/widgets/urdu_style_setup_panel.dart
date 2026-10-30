import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_controls.dart';
import '../../../../core/widgets/app_surfaces.dart';
import '../../model/paragraph_difficulty.dart';
import '../../model/urdu_paragraph.dart';
import '../../model/urdu_style_typing_controller.dart';
import '../../service/urdu_paragraph_provider.dart';

/// Setup panel shared by the Urdu Typing Test and PPSC Urdu screens.
/// [durationPresets] lets each screen offer its own duration list (spec:
/// Urdu Test gets 30s..10min, PPSC gets 2/5/10min only) without
/// duplicating this whole widget.
class UrduStyleSetupPanel extends StatelessWidget {
  const UrduStyleSetupPanel({
    super.key,
    required this.controller,
    required this.title,
    required this.subtitle,
    required this.durationPresets,
  });

  final UrduStyleTypingController controller;
  final String title;
  final String subtitle;
  final List<Duration> durationPresets;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.h1),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.urduBody.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: AppDimensions.gapLarge),
              SectionCard(
                title: 'Duration',
                subtitle: 'How long the test runs',
                child: _DurationPicker(
                    controller: controller, presets: durationPresets),
              ),
              const SizedBox(height: AppDimensions.gapMedium),
              SectionCard(
                title: 'Difficulty',
                subtitle: 'Filters the paragraphs below',
                child: _DifficultyPicker(controller: controller),
              ),
              const SizedBox(height: AppDimensions.gapMedium),
              SectionCard(
                title: 'Paragraph',
                child: _ParagraphPicker(controller: controller),
              ),
              const SizedBox(height: AppDimensions.gapLarge),
              Obx(() {
                final String? error = controller.startError.value;
                if (error == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(error,
                      style: const TextStyle(color: AppColors.danger)),
                );
              }),
              ElevatedButton.icon(
                onPressed: controller.startTest,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                ),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Test'),
              ),
              const SizedBox(height: AppDimensions.gapLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _DurationPicker extends StatefulWidget {
  const _DurationPicker({required this.controller, required this.presets});

  final UrduStyleTypingController controller;
  final List<Duration> presets;

  @override
  State<_DurationPicker> createState() => _DurationPickerState();
}

class _DurationPickerState extends State<_DurationPicker> {
  late bool _customSelected;
  final TextEditingController _customFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If the starting duration (e.g. from Settings) isn't one of the quick
    // picks, it is a custom value -> open the custom field showing it.
    final Duration current = widget.controller.selectedDuration.value;
    _customSelected = !widget.presets.contains(current);
    if (_customSelected) {
      _customFieldController.text = current.inSeconds.toString();
    }
  }

  @override
  void dispose() {
    _customFieldController.dispose();
    super.dispose();
  }

  String _label(Duration d) {
    if (d.inSeconds < 60) return '${d.inSeconds}s';
    if (d.inSeconds % 60 == 0) return '${d.inMinutes} min';
    return '${d.inMinutes}m ${d.inSeconds % 60}s';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final Duration selected = widget.controller.selectedDuration.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final Duration d in widget.presets)
                OptionChip(
                  label: _label(d),
                  selected: !_customSelected && selected == d,
                  onSelected: () {
                    setState(() => _customSelected = false);
                    widget.controller.selectDuration(d);
                  },
                ),
              OptionChip(
                label: 'Custom',
                selected: _customSelected,
                onSelected: () {
                  setState(() => _customSelected = true);
                  if (_customFieldController.text.isEmpty) {
                    _customFieldController.text =
                        selected.inSeconds.toString();
                  }
                },
              ),
            ],
          ),
          if (_customSelected) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                SizedBox(
                  width: 160,
                  child: TextField(
                    controller: _customFieldController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Seconds',
                      isDense: true,
                    ),
                    // Applied as the user types, so the value is used even
                    // if they press Start without pressing Apply.
                    onChanged: widget.controller.selectCustomDurationSeconds,
                    onSubmitted: widget.controller.selectCustomDurationSeconds,
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => widget.controller
                      .selectCustomDurationSeconds(_customFieldController.text),
                  child: const Text('Apply'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Test duration: ${_label(selected)}',
              style: AppTextStyles.captionOf(context),
            ),
            Obx(() {
              final String? error = widget.controller.durationError.value;
              if (error == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(error,
                    style: const TextStyle(color: AppColors.danger)),
              );
            }),
          ],
        ],
      );
    });
  }
}

class _DifficultyPicker extends StatelessWidget {
  const _DifficultyPicker({required this.controller});

  final UrduStyleTypingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final ParagraphDifficulty d in ParagraphDifficulty.values)
              OptionChip(
                label: d.label,
                selected: controller.selectedDifficulty.value == d,
                onSelected: () => controller.selectDifficulty(d),
              ),
          ],
        ));
  }
}

class _ParagraphPicker extends StatelessWidget {
  const _ParagraphPicker({required this.controller});

  final UrduStyleTypingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ParagraphDifficulty difficulty =
          controller.selectedDifficulty.value;
      final List<UrduParagraph> options =
          UrduParagraphProvider.byDifficulty(difficulty);
      final UrduParagraph? selected = controller.selectedParagraph.value;
      final Map<String, UrduParagraph> byTitle = {};
      for (final p in options) {
        byTitle.putIfAbsent(p.title, () => p);
      }
      if (selected != null) {
        byTitle.putIfAbsent(selected.title, () => selected);
      }
      final List<UrduParagraph> items = byTitle.values.toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: FilterShell(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(12),
                    value: selected?.title,
                    items: [
                      for (final p in items)
                        DropdownMenuItem(
                            value: p.title,
                            child: Text(p.title,
                                style: AppTextStyles.urduBody,
                                textDirection: TextDirection.rtl)),
                    ],
                    onChanged: (title) {
                      UrduParagraph? match;
                      for (final p in items) {
                        if (p.title == title) {
                          match = p;
                          break;
                        }
                      }
                      if (match != null) controller.selectParagraph(match);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: controller.shuffleParagraph,
                icon: const Icon(Icons.shuffle, size: 18),
                label: const Text('Random'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SoftSurface(
            raised: false,
            radius: 12,
            padding: const EdgeInsets.all(14),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SizedBox(
              width: double.infinity,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  selected?.text ?? '',
                  style: AppTextStyles.urduBody,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
