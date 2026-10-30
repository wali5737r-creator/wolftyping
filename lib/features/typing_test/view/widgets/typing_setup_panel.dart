import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/app_controls.dart';
import '../../../../core/widgets/app_surfaces.dart';
import '../../controller/typing_controller.dart';
import '../../model/english_paragraph.dart';
import '../../model/paragraph_difficulty.dart';
import '../../model/typing_durations.dart';
import '../../service/english_paragraph_provider.dart';

/// "Before starting the test, allow the user to select: Duration,
/// Paragraph" (spec section 7). Shown when `screenPhase == setup`.
class TypingSetupPanel extends StatelessWidget {
  const TypingSetupPanel({super.key, required this.controller});

  final TypingController controller;

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
              const PageHeader(
                title: 'English Typing Test',
                subtitle: 'Choose a duration and a paragraph, then start.',
              ),
              const SizedBox(height: AppDimensions.gapLarge),
              SectionCard(
                title: 'Duration',
                subtitle: 'How long the test runs',
                child: _DurationPicker(controller: controller),
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
                  child: Text(
                    error,
                    style: const TextStyle(color: AppColors.danger),
                  ),
                );
              }),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: controller.startTest,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 16),
                    ),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Test'),
                  ),
                  const SizedBox(width: AppDimensions.gapMedium),
                  TextButton.icon(
                    // Replace (not push), same as the Urdu screen's switch
                    // button and the sidebar, so English <-> Urdu never
                    // builds up a back stack and Back behaves the same
                    // from both screens.
                    onPressed: () => Get.offNamed(AppRoutes.urduTypingTest),
                    icon: const Icon(Icons.language, size: 18),
                    label: const Text('Switch to Urdu Test'),
                  ),
                ],
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
  const _DurationPicker({required this.controller});

  final TypingController controller;

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
    _customSelected = !TypingDurations.presets.contains(current);
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
              for (final Duration d in TypingDurations.presets)
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

  final TypingController controller;

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

  final TypingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ParagraphDifficulty difficulty =
          controller.selectedDifficulty.value;
      final options = EnglishParagraphProvider.byDifficulty(difficulty);
      final selected = controller.selectedParagraph.value;
      final Map<String, EnglishParagraph> byTitle = {};
      for (final p in options) {
        byTitle.putIfAbsent(p.title, () => p);
      }
      if (selected != null) {
        byTitle.putIfAbsent(selected.title, () => selected);
      }
      final List<EnglishParagraph> items = byTitle.values.toList();

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
                        DropdownMenuItem(value: p.title, child: Text(p.title)),
                    ],
                    onChanged: (title) {
                      EnglishParagraph? match;
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
            child: Text(
              selected?.text ?? '',
              style: AppTextStyles.body,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    });
  }
}
