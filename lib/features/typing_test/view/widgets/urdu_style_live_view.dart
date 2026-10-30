import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/typing_focus_keeper.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../model/typing_snapshot.dart';
import '../../model/typing_test_status.dart';
import '../../../settings/controller/settings_controller.dart';
import '../../../settings/model/app_settings.dart';
import '../../model/urdu_style_typing_controller.dart';
import '../../../../core/utils/urdu_text_direction.dart';
import 'auto_scroll_typing_area.dart';
import 'typing_ui_parts.dart';
import 'typing_paragraph_text.dart';

/// Live test screen shared by the Urdu Typing Test and PPSC Urdu screens.
/// Same keyboard-capture approach as the English `TypingLiveScreen`
/// (physical keyboard only, no visible TextField), wrapped in RTL
/// [Directionality] for the paragraph display — the Urdu string itself is
/// never reversed; Flutter's bidi text layout handles the visual RTL
/// order on its own once the ambient direction is set.
class UrduStyleLiveScreen extends StatelessWidget {
  const UrduStyleLiveScreen({super.key, required this.controller});

  final UrduStyleTypingController controller;

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

    // Urdu keyboard layouts deliver the correct Urdu Unicode character
    // here via `event.character` exactly like any other layout — no
    // special-casing needed, no transliteration.
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
    return TypingScreenFrame(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TopStatsBar(controller: controller),
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
                child: AutoScrollTypingArea(
                  builder: (currentWordKey, follow) => Directionality(
                    // Settings > Urdu RTL display.
                    textDirection: urduTextDirection(),
                    child: Obx(() {
                      follow();
                      return TypingParagraphText(
                        targetWords: controller.targetWords,
                        wordStatuses: controller.wordStatuses,
                        committedWordBuffers: controller.committedWordBuffers,
                        currentWordIndex:
                            controller.snapshot.value.currentWordIndex,
                        currentWordBuffer: controller.currentWordBuffer.value,
                        baseStyle: AppTextStyles.typingTextUr,
                        currentWordKey: currentWordKey,
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
          ),
        ),
        const SizedBox(height: AppDimensions.gapLarge),
        _BottomStatsGrid(controller: controller),
        const SizedBox(height: AppDimensions.gapMedium),
        _Controls(controller: controller),
      ],
      ),
    );
  }
}

String _formatDuration(Duration d) {
  final int minutes = d.inMinutes;
  final int seconds = d.inSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

class _TopStatsBar extends StatelessWidget {
  const _TopStatsBar({required this.controller});

  final UrduStyleTypingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final TypingSnapshot s = controller.snapshot.value;
      final bool paused = s.status == TypingTestStatus.paused;
      final AppSettings? settings = SettingsController.currentOrNull;
      final bool showTimer = settings?.showTimer ?? true;
      final bool showWpm = settings?.showLiveWpm ?? true;
      final bool showAccuracy = settings?.showLiveAccuracy ?? true;
      return LiveStatsHeader(
        stats: [
          if (showTimer)
            LiveStat(
              label: 'Time left',
              value: _formatDuration(s.remaining),
              highlight: paused,
            ),
          if (showWpm) LiveStat(label: 'WPM', value: s.netWpm.toStringAsFixed(0)),
          if (showAccuracy)
            LiveStat(
                label: 'Accuracy', value: '${s.accuracy.toStringAsFixed(0)}%'),
          LiveStat(label: 'Mistakes', value: '${s.totalErrors}'),
          LiveStat(
              label: 'Progress', value: '${s.progress.toStringAsFixed(0)}%'),
        ],
        progressPercent: s.progress,
        paused: paused,
        waitingForFirstKey: controller.isWaitingForFirstKey.value,
      );
    });
  }
}

class _BottomStatsGrid extends StatelessWidget {
  const _BottomStatsGrid({required this.controller});

  final UrduStyleTypingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final TypingSnapshot s = controller.snapshot.value;
      return CompactStatsStrip(
        entries: <MapEntry<String, String>>[
          MapEntry('Gross WPM', s.grossWpm.toStringAsFixed(1)),
          MapEntry('Net WPM', s.netWpm.toStringAsFixed(1)),
          MapEntry('Correct words', '${s.correctWords}'),
          MapEntry('Wrong words', '${s.wrongWords}'),
          MapEntry('Skipped words', '${s.skippedWords}'),
          MapEntry('Backspaces', '${s.backspaces}'),
        ],
      );
    });
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.controller});

  final UrduStyleTypingController controller;

  Future<void> _confirmStop(BuildContext context) async {
    // Freeze the clock the moment Stop is tapped. Before this fix the
    // timer kept running while the confirmation dialog was open, and a
    // second tap could dismiss the dialog on its barrier without
    // stopping anything — so Stop appeared to do nothing. Pausing first
    // makes the first tap always stop the timer; Cancel resumes it.
    final bool wasPaused =
        controller.snapshot.value.status == TypingTestStatus.paused;
    if (!wasPaused) controller.togglePauseResume();
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Stop test?'),
        content: const Text(
          'Your progress will not be saved as a completed test.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Stop'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      controller.stopTest();
    } else {
      // Cancelled: resume only if the test was running when Stop was
      // tapped (an already-paused test stays paused).
      if (!wasPaused) controller.togglePauseResume();
      controller.focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
            onPressed: controller.restartTest,
            icon: const Icon(Icons.refresh),
            label: const Text('Restart'),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: () => _confirmStop(context),
            icon: const Icon(Icons.stop_circle_outlined),
            label: const Text('Stop'),
          ),
        ],
      ),
      );
    });
  }
}
