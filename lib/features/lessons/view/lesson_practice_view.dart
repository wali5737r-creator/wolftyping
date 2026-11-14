import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
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
import '../controller/lesson_practice_controller.dart';
import 'lesson_keyboard_guide_view.dart';

/// Lesson Practice screen: instructions -> live typing -> result, all for
/// one lesson. Uses the same `TypingEngine` and the same
/// `TypingParagraphText` render widget as the Typing Test/Urdu/PPSC
/// screens (untimed here — a lesson ends when its drill is finished, not
/// on a countdown).
class LessonPracticeView extends GetView<LessonPracticeController> {
  const LessonPracticeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.lessons,
      body: Obx(() {
        switch (controller.phase.value) {
          case LessonPracticePhase.intro:
            return _IntroPanel(controller: controller);
          case LessonPracticePhase.practice:
            return _PracticePanel(controller: controller);
          case LessonPracticePhase.result:
            return _ResultPanel(controller: controller);
        }
      }),
    );
  }
}

class _IntroPanel extends StatelessWidget {
  const _IntroPanel({required this.controller});

  final LessonPracticeController controller;

  @override
  Widget build(BuildContext context) {
    final lesson = controller.lesson;
    final bool isUrdu = lesson.definition.language == TypingLanguage.urdu;
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
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
            if (lesson.definition.stage.isNotEmpty) ...[
              TagBadge(
                text: lesson.definition.stage,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.primaryDark
                    : AppColors.primary,
              ),
              const SizedBox(height: 10),
            ],
            PageHeader(
              title:
                  'Lesson ${lesson.definition.orderIndex}: ${lesson.definition.title}',
              subtitle: lesson.definition.description,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: AppDimensions.gapMedium,
              runSpacing: AppDimensions.gapMedium,
              children: [
                StatCard(
                  label: 'Required accuracy',
                  value:
                      '${lesson.definition.effectiveRequiredAccuracy.toStringAsFixed(0)}%',
                ),
                if (lesson.definition.requiredWpm > 0)
                  StatCard(
                    label: 'Target WPM',
                    value: '${lesson.definition.requiredWpm}',
                  ),
                StatCard(label: 'Attempts so far', value: '${lesson.attempts}'),
              ],
            ),
            const SizedBox(height: 20),
            if (lesson.definition.tip.isNotEmpty) ...[
              SectionCard(
                title: 'Before you start',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (lesson.definition.fingerGuide.isNotEmpty) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.back_hand_outlined, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(lesson.definition.fingerGuide,
                                style: AppTextStyles.bodyMedium),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text(lesson.definition.tip, style: AppTextStyles.body),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            SoftSurface(
              child: SizedBox(
                width: double.infinity,
                child: Directionality(
                  textDirection:
                      isUrdu ? urduTextDirection() : TextDirection.ltr,
                  child: Text(
                    lesson.definition.content,
                    style: isUrdu
                        ? AppTextStyles.typingTextUr
                        : AppTextStyles.typingTextEn,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: controller.startPractice,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 16),
                  ),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Lesson'),
                ),
                // The finger-guide board lives on its own page — it opens
                // in this lesson's language with this lesson's new keys
                // outlined, and never sits inside the practice panel.
                OutlinedButton.icon(
                  onPressed: () => Get.toNamed(
                    AppRoutes.lessonKeyboardGuide,
                    arguments: LessonKeyboardGuideArgs(
                      isUrdu: isUrdu,
                      focusKeys: lesson.definition.focusKeys,
                    ),
                  ),
                  icon: const Icon(Icons.keyboard_outlined),
                  label: const Text('Keyboard guide'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
        ),
      ),
    );
  }
}

class _PracticePanel extends StatelessWidget {
  const _PracticePanel({required this.controller});

  final LessonPracticeController controller;

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
    final bool isUrdu =
        controller.lesson.definition.language == TypingLanguage.urdu;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
        // No on-screen keyboard: lessons type with the physical keyboard
        // only (same controller methods as before).
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
                onPressed: controller.restartPractice,
                icon: const Icon(Icons.refresh),
                label: const Text('Restart'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close),
                label: const Text('Exit'),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Press Space after the last word to finish.',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.captionOf(context),
                  ),
                ),
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

  final LessonPracticeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final TypingSnapshot s = controller.snapshot.value;
      final bool passed = controller.lastAttemptPassed.value;
      final lesson = controller.lesson;

      return Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      passed ? Icons.check_circle : Icons.cancel,
                      color: passed ? AppColors.success : AppColors.danger,
                      size: 28,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      passed ? 'Lesson Completed!' : 'Lesson Not Completed',
                      style: AppTextStyles.h1,
                    ),
                  ],
                ),
                if (!passed) ...[
                  const SizedBox(height: 8),
                  Text(
                    'You needed ${lesson.definition.effectiveRequiredAccuracy.toStringAsFixed(0)}% '
                    'accuracy${lesson.definition.requiredWpm > 0 ? " and ${lesson.definition.requiredWpm} WPM" : ""} '
                    'to pass this lesson. Try again!',
                    style: AppTextStyles.body,
                  ),
                ],
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
                    StatCard(label: 'Attempts', value: '${lesson.attempts + 1}'),
                    StatCard(
                        label: 'Best WPM',
                        value:
                        (s.netWpm > lesson.bestSpeed
                                ? s.netWpm
                                : lesson.bestSpeed)
                            .toStringAsFixed(1)),
                    StatCard(
                        label: 'Best Accuracy',
                        value:
                        '${(s.accuracy > lesson.bestAccuracy ? s.accuracy : lesson.bestAccuracy).toStringAsFixed(1)}%'),
                  ],
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: controller.restartPractice,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        controller.phase.value = LessonPracticePhase.intro;
                      },
                      icon: const Icon(Icons.menu_book_outlined),
                      label: const Text('Practice Again'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back to Lessons'),
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
