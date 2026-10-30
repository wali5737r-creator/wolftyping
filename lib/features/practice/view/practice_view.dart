import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../../typing_test/model/typing_language.dart';
import '../controller/practice_controller.dart';
import '../model/character_mistake_stat.dart';
import '../model/mistake_analysis_summary.dart';
import '../model/word_mistake_stat.dart';
import 'widgets/keyboard_heatmap.dart';

/// Practice Dashboard: language filter, real mistake analysis (from saved
/// TypingTests/Mistakes data), keyboard heatmap, and the five practice
/// mode buttons. Shows a genuine empty state when there isn't enough data
/// yet -- never a fake zero-filled chart.
class PracticeView extends GetView<PracticeController> {
  const PracticeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.practice,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final MistakeAnalysisSummary summary = controller.summary.value;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                title: 'Practice',
                subtitle:
                    'See your typing weaknesses and practice them directly.',
                trailing: _LanguageToggle(controller: controller),
              ),
              const SizedBox(height: 20),
              if (!summary.hasEnoughData)
                _EmptyState(controller: controller)
              else ...[
                _StatsRow(summary: summary),
                const SizedBox(height: 24),
                _WeakKeysDrillCard(
                  controller: controller,
                  summary: summary,
                ),
                const SizedBox(height: 24),
                _ModeButtons(controller: controller),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _WeakCharactersCard(summary: summary)),
                    const SizedBox(width: AppDimensions.gapLarge),
                    Expanded(child: _WeakWordsCard(summary: summary)),
                  ],
                ),
                const SizedBox(height: 24),
                _RecentMistakesCard(summary: summary),
                const SizedBox(height: 24),
                SectionCard(
                  title: 'Keyboard Heatmap',
                  subtitle: 'Tap a key to see its mistakes',
                  child: KeyboardHeatmap(controller: controller),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle({required this.controller});

  final PracticeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
          spacing: 10,
          children: [
            for (final TypingLanguage lang in TypingLanguage.values)
              OptionChip(
                label: lang.label,
                selected: controller.selectedLanguage.value == lang,
                onSelected: () => controller.selectLanguage(lang),
              ),
          ],
        ));
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.controller});

  final PracticeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: EmptyStateView(
        icon: Icons.insights_outlined,
        title: 'No typing mistakes yet',
        message: 'Complete a typing test and your weak keys will appear here.',
        actions: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.typingTest),
              child: const Text('Start English Test'),
            ),
            OutlinedButton(
              onPressed: () => Get.toNamed(AppRoutes.urduTypingTest),
              child: const Text('Start Urdu Test'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.summary});

  final MistakeAnalysisSummary summary;

  @override
  Widget build(BuildContext context) {
    final entries = <MapEntry<String, String>>[
      MapEntry('Total mistakes', '${summary.totalMistakes}'),
      MapEntry('Wrong characters', '${summary.wrongCharacters}'),
      MapEntry('Wrong words', '${summary.wrongWords}'),
      MapEntry('Skipped words', '${summary.skippedWords}'),
      MapEntry('Backspaces', '${summary.backspaces}'),
    ];
    return Wrap(
      spacing: AppDimensions.gapMedium,
      runSpacing: AppDimensions.gapMedium,
      children: [
        for (final e in entries)
          StatCard(label: e.key, value: e.value, width: 160),
      ],
    );
  }
}

class _WeakKeysDrillCard extends StatelessWidget {
  const _WeakKeysDrillCard({
    required this.controller,
    required this.summary,
  });

  final PracticeController controller;
  final MistakeAnalysisSummary summary;

  @override
  Widget build(BuildContext context) {
    final List<CharacterMistakeStat> weak =
        summary.weakestCharacters.take(8).toList();
    return SectionCard(
      title: 'Weak-Keys Drill',
      subtitle:
          'Drill built from the keys you mistype most. Your weak keys are listed first — start the drill to practise them.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (weak.isEmpty)
            const Text('No weak keys yet — complete a typing test first.')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final CharacterMistakeStat c in weak)
                  ActionChip(
                    label: Text("'${c.character}' · ${c.count}"),
                    tooltip: 'Drill this key only',
                    onPressed: () =>
                        controller.startPracticeForCharacter(c.character),
                  ),
              ],
            ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: weak.isEmpty
                ? null
                : controller.startCharacterPractice,
            icon: const Icon(Icons.keyboard),
            label: const Text('Start Weak-Keys Drill'),
          ),
        ],
      ),
    );
  }
}

class _ModeButtons extends StatelessWidget {
  const _ModeButtons({required this.controller});

  final PracticeController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: controller.startQuickPractice,
          icon: const Icon(Icons.bolt),
          label: const Text('Practice My Mistakes'),
        ),
        OutlinedButton.icon(
          onPressed: controller.startCharacterPractice,
          icon: const Icon(Icons.keyboard),
          label: const Text('Character Practice'),
        ),
        OutlinedButton.icon(
          onPressed: controller.startWordPractice,
          icon: const Icon(Icons.text_fields),
          label: const Text('Word Practice'),
        ),
        OutlinedButton.icon(
          onPressed: controller.startSkippedWordPractice,
          icon: const Icon(Icons.skip_next),
          label: const Text('Skipped Word Practice'),
        ),
        OutlinedButton.icon(
          onPressed: controller.startGeneralPractice,
          icon: const Icon(Icons.fitness_center),
          label: const Text('General Practice'),
        ),
      ],
    );
  }
}

class _WeakCharactersCard extends StatelessWidget {
  const _WeakCharactersCard({required this.summary});

  final MistakeAnalysisSummary summary;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Weakest Characters',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (summary.weakestCharacters.isEmpty)
            const Text('No character mistakes yet.')
          else
            for (final c in summary.weakestCharacters.take(8))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(c.character,
                            style: AppTextStyles.bodyMedium)),
                    Text('${c.count} mistakes',
                        style: AppTextStyles.captionOf(context)),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

class _WeakWordsCard extends StatelessWidget {
  const _WeakWordsCard({required this.summary});

  final MistakeAnalysisSummary summary;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Weakest Words',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (summary.weakestWords.isEmpty)
            const Text('No word mistakes yet.')
          else
            for (final WordMistakeStat w in summary.weakestWords.take(8))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                        child:
                            Text(w.word, style: AppTextStyles.bodyMedium)),
                    Text('${w.mistakeCount} mistakes',
                        style: AppTextStyles.captionOf(context)),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

class _RecentMistakesCard extends StatelessWidget {
  const _RecentMistakesCard({required this.summary});

  final MistakeAnalysisSummary summary;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Recent Mistakes',
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (summary.recentMistakes.isEmpty)
              const Text('No recent mistakes.')
            else
              for (final line in summary.recentMistakes)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text(line, style: AppTextStyles.body),
                ),
          ],
        ),
      ),
    );
  }
}
