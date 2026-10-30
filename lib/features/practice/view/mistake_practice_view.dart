import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/utils/urdu_text_direction.dart';
import '../../../core/widgets/typing_focus_keeper.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../../typing_test/model/typing_language.dart';
import '../../typing_test/model/typing_snapshot.dart';
import '../../typing_test/model/typing_test_status.dart';
import '../../typing_test/view/widgets/typing_paragraph_text.dart';
import '../../typing_test/view/widgets/typing_ui_parts.dart';
import '../../settings/controller/settings_controller.dart';
import '../controller/mistake_practice_controller.dart';

/// Live typing + result for any of the five practice modes. Same
/// TypingEngine, same TypingParagraphText render widget as every other
/// typing screen — untimed, like Lessons.
class MistakePracticeView extends GetView<MistakePracticeController> {
  const MistakePracticeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.practice,
      body: Obx(() {
        switch (controller.phase.value) {
          case MistakePracticePhase.practice:
            return _PracticePanel(controller: controller);
          case MistakePracticePhase.result:
            return _ResultPanel(controller: controller);
        }
      }),
    );
  }
}

class _PracticePanel extends StatelessWidget {
  const _PracticePanel({required this.controller});

  final MistakePracticeController controller;

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final HardwareKeyboard hw = HardwareKeyboard.instance;
    if (hw.isControlPressed || hw.isAltPressed || hw.isMetaPressed) {
      return KeyEventResult.ignored;
    }
    final LogicalKeyboardKey key = event.logicalKey;
    if (key == LogicalKeyboardKey.backspace) {
      controller.onBackspace();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.space) {
      controller.onSpace();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.tab ||
        key == LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    final String? character = event.character;
    if (character != null &&
        character.isNotEmpty &&
        character.runes.first >= 0x20 &&
        character.runes.first != 0x7f) {
      controller.onCharacter(character);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final bool isUrdu = controller.args.language == TypingLanguage.urdu;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            TextButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back to Practice'),
            ),
            const Spacer(),
            Text(controller.args.mode.label, style: AppTextStyles.h3),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          final TypingSnapshot s = controller.snapshot.value;
          final bool paused = s.status == TypingTestStatus.paused;
          return LiveStatsHeader(
            stats: [
              // Settings > Show timer / Show live WPM / Show live accuracy.
              if (SettingsController.currentOrNull?.showTimer ?? true)
                LiveStat(
                  label: 'Timer',
                  value: _formatElapsed(s.elapsed),
                  highlight: paused,
                ),
              if (SettingsController.currentOrNull?.showLiveWpm ?? true)
                LiveStat(label: 'WPM', value: s.netWpm.toStringAsFixed(0)),
              if (SettingsController.currentOrNull?.showLiveAccuracy ?? true)
                LiveStat(
                    label: 'Accuracy',
                    value: '${s.accuracy.toStringAsFixed(0)}%'),
              LiveStat(label: 'Errors', value: '${s.totalErrors}'),
              LiveStat(
                  label: 'Progress',
                  value: '${s.progress.toStringAsFixed(0)}%'),
            ],
            progressPercent: s.progress,
            paused: paused,
            waitingForFirstKey: false,
          );
        }),
        const SizedBox(height: AppDimensions.gapLarge),
        Expanded(
          child: TypingFocusKeeper(
            focusNode: controller.focusNode,
            child: GestureDetector(
            onTap: () => controller.focusNode.requestFocus(),
            child: Focus(
              focusNode: controller.focusNode,
              autofocus: false, // TypingFocusKeeper honours Settings > Auto Focus
              onKeyEvent: _handleKey,
              child: TypingAreaFrame(
                focusNode: controller.focusNode,
                child: SingleChildScrollView(
                  child: Directionality(
                    textDirection:
                        isUrdu ? urduTextDirection() : TextDirection.ltr,
                    child: Obx(() => TypingParagraphText(
                          targetWords: controller.targetWords,
                          wordStatuses: controller.wordStatuses,
                          committedWordBuffers:
                              controller.committedWordBuffers,
                          currentWordIndex:
                              controller.snapshot.value.currentWordIndex,
                          currentWordBuffer:
                              controller.currentWordBuffer.value,
                          baseStyle: isUrdu
                              ? AppTextStyles.typingTextUr
                              : AppTextStyles.typingTextEn,
                        )),
                  ),
                ),
              ),
            ),
          ),
          ),
        ),
        const SizedBox(height: AppDimensions.gapMedium),
        Obx(() {
          final bool paused =
              controller.snapshot.value.status == TypingTestStatus.paused;
          return ExcludeFocus(
        // Buttons never take keyboard focus, so clicking Pause / Restart /
        // Stop (or closing a dialog opened from them) leaves the typing
        // area focused and Space keeps typing instead of re-pressing a button.
        child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: controller.togglePauseResume,
                icon: Icon(paused ? Icons.play_arrow : Icons.pause),
                label: Text(paused ? 'Resume' : 'Pause'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: controller.restart,
                icon: const Icon(Icons.refresh),
                label: const Text('Restart'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.stop_circle_outlined),
                label: const Text('Stop'),
              ),
            ],
          ),
      );
        }),
      ],
    );
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({required this.controller});

  final MistakePracticeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final TypingSnapshot s = controller.snapshot.value;
      return Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageHeader(
                  title: 'Practice Complete',
                  subtitle: controller.args.mode.label,
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: AppDimensions.gapMedium,
                  runSpacing: AppDimensions.gapMedium,
                  children: [
                    StatCard(label: 'WPM', value: s.netWpm.toStringAsFixed(1)),
                    StatCard(label: 'Accuracy', value: '${s.accuracy.toStringAsFixed(1)}%'),
                    StatCard(label: 'Errors', value: '${s.totalErrors}'),
                    StatCard(label: 'Correct characters', value: '${s.correctCharacters}'),
                    StatCard(label: 'Wrong characters', value: '${s.wrongCharacters}'),
                    StatCard(label: 'Duration', value: _formatElapsed(s.elapsed)),
                    if (controller.args.practicedCharacters.isNotEmpty)
                      StatCard(
                          label: 'Mistakes improved',
                          value: '${controller.improvedCount}/'
                              '${controller.args.practicedCharacters.length}'),
                    if (controller.args.practicedCharacters.isNotEmpty)
                      StatCard(
                          label: 'Weak characters practiced',
                          value: controller.args.practicedCharacters.join(', '),
                          wrapValue: true),
                  ],
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: controller.restart,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Practice Again'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back to Practice'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

String _formatElapsed(Duration d) {
  final int minutes = d.inMinutes;
  final int seconds = d.inSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}
