import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_fonts.dart';
import '../../../core/utils/unicode_chars.dart';
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
import '../../typing_test/model/typing_word_status.dart';
import '../../typing_test/view/widgets/typing_ui_parts.dart';
import '../../settings/controller/settings_controller.dart';
import '../controller/lesson_practice_controller.dart';
import 'lesson_keyboard_guide_view.dart';
import 'widgets/lesson_keyboard.dart';
import 'widgets/lesson_word_boxes.dart';

/// Lesson Practice screen: instructions -> live typing -> result, all for
/// one lesson. Uses the same `TypingEngine` as the Typing Test/Urdu/PPSC
/// screens (untimed here — a lesson ends when its drill is finished, not
/// on a countdown), but renders its drill as key-style word boxes
/// ([LessonWordBoxes]) instead of the flowing paragraph the timed screens
/// use: one box per word, each box edged in the colour of the finger that
/// types its first letter, so practice sets the learner's hand.
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
    final List<String> previewWords =
        lesson.definition.content.split(RegExp(r'\s+'));
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
            // The drill previewed exactly as practice shows it: one
            // key-style box per word, edged in the colour of the finger
            // that types its first letter (preview mode — all pending,
            // no word highlighted).
            SoftSurface(
              child: SizedBox(
                width: double.infinity,
                child: Directionality(
                  textDirection:
                      isUrdu ? urduTextDirection() : TextDirection.ltr,
                  child: LessonWordBoxes(
                    targetWords: previewWords,
                    wordStatuses: List<TypingWordStatus>.filled(
                      previewWords.length,
                      TypingWordStatus.pending,
                    ),
                    committedWordBuffers: const [],
                    currentWordIndex: -1,
                    currentWordBuffer: '',
                    isUrdu: isUrdu,
                    baseStyle: isUrdu
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
        // Lesson header: which lesson this is, and where the learner is
        // in its drill — the old panel showed neither during practice.
        Obx(() {
          final TypingSnapshot s = controller.snapshot.value;
          final int total = controller.targetWords.length;
          final int shown =
              total == 0 ? 0 : (s.currentWordIndex + 1).clamp(1, total);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Lesson ${controller.lesson.definition.orderIndex}: '
                    '${controller.lesson.definition.title}',
                    style: AppTextStyles.h3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Word $shown of $total',
                  style: AppTextStyles.captionOf(context),
                ),
              ],
            ),
          );
        }),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Which key comes next, and which finger types it —
                      // the hand-setting cue: the learner never has to
                      // guess, lesson after lesson.
                      _FingerHintBar(controller: controller, isUrdu: isUrdu),
                      const SizedBox(height: 16),
                      Directionality(
                        textDirection:
                            isUrdu ? urduTextDirection() : TextDirection.ltr,
                        child: Obx(() => LessonWordBoxes(
                              targetWords: controller.targetWords,
                              wordStatuses: controller.wordStatuses,
                              committedWordBuffers:
                                  controller.committedWordBuffers,
                              currentWordIndex:
                                  controller.snapshot.value.currentWordIndex,
                              currentWordBuffer:
                                  controller.currentWordBuffer.value,
                              isUrdu: isUrdu,
                              baseStyle: isUrdu
                                  ? AppTextStyles.typingTextUr
                                  : AppTextStyles.typingTextEn,
                            )),
                      ),
                      const SizedBox(height: 20),
                      // The colour language, spelled out under the boxes:
                      // same swatches as the guide page, same mapping.
                      Wrap(
                        spacing: 14,
                        runSpacing: 8,
                        children: [
                          for (final entry in LessonKeyboard.fingerLegend)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
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
                      const SizedBox(height: 4),
                      Text(
                        'Box colours show which finger types the first '
                        'letter of each word.',
                        style: AppTextStyles.captionOf(context),
                      ),
                    ],
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

/// The hand-setting cue above the word boxes: the next key to type as a
/// mini key cap, in the colour of the finger that types it, with that
/// finger named in words — plus a link to the full keyboard guide. The
/// learner never has to guess which finger types what; the cue follows
/// every keystroke. Display only — nothing here is tappable except the
/// guide link, and no key types anything.
class _FingerHintBar extends StatelessWidget {
  const _FingerHintBar({required this.controller, required this.isUrdu});

  final LessonPracticeController controller;
  final bool isUrdu;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int idx = controller.snapshot.value.currentWordIndex;
      final List<String> words = controller.targetWords;
      if (idx < 0 || idx >= words.length) return const SizedBox.shrink();
      final List<String> targetChars = splitChars(words[idx]);
      final List<String> typedChars =
          splitChars(controller.currentWordBuffer.value);
      // The next character of the current word — or the Space that ends
      // it (typed by the thumb).
      final String next = typedChars.length < targetChars.length
          ? targetChars[typedChars.length]
          : ' ';
      final ({Color color, String label})? finger =
          LessonKeyboard.fingerInfoFor(next, urdu: isUrdu);
      final bool isDark = Theme.of(context).brightness == Brightness.dark;
      final Color fingerColor = finger?.color ??
          (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8));

      return Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: fingerColor.withValues(alpha: isDark ? 0.22 : 0.16),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: fingerColor, width: 1.5),
            ),
            child: Text(
              next == ' ' ? 'Space' : next,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: isUrdu && next != ' ' ? 1.8 : null,
                fontFamily:
                    isUrdu && next != ' ' ? AppFonts.urdu : null,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              next == ' '
                  ? 'Next: Space — press it with your thumb'
                  : finger == null
                      ? 'Next: $next'
                      : 'Next: $next — ${finger.label}',
              style: AppTextStyles.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () => Get.toNamed(
              AppRoutes.lessonKeyboardGuide,
              arguments: LessonKeyboardGuideArgs(
                isUrdu: isUrdu,
                focusKeys: controller.lesson.definition.focusKeys,
              ),
            ),
            icon: const Icon(Icons.keyboard_outlined, size: 18),
            label: const Text('Keyboard guide'),
          ),
        ],
      );
    });
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
