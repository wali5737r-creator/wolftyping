import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../controller/typing_controller.dart';
import '../../model/typing_snapshot.dart';
import 'result_card.dart';
import 'typing_ui_parts.dart';

/// File-level key: stable across rebuilds so the PNG capture always
/// finds the same RepaintBoundary.
final GlobalKey _resultCardKey = GlobalKey();

/// Shown once `screenPhase == result` (the engine reached
/// TypingTestStatus.completed). Every number here is read straight from
/// the controller's last snapshot — nothing is recomputed or estimated.
///
/// No Best WPM / history comparison yet, per spec: that needs the
/// database integration, which is a later step.
class TypingResultScreen extends StatelessWidget {
  const TypingResultScreen({super.key, required this.controller});

  final TypingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final TypingSnapshot s = controller.snapshot.value;
      final String paragraphTitle =
          controller.selectedParagraph.value?.title ?? '';

      return Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Test Complete', style: AppTextStyles.h1),
                if (paragraphTitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(paragraphTitle, style: AppTextStyles.body),
                ],
                const SizedBox(height: 20),
                ResultSummaryBlock(
                  netWpm: s.netWpm.toStringAsFixed(0),
                  accuracy: '${s.accuracy.toStringAsFixed(0)}%',
                  // Net WPM and Accuracy are the headline numbers above,
                  // so they are not repeated as tiles.
                  details: <MapEntry<String, String>>[
                    MapEntry('Gross WPM', s.grossWpm.toStringAsFixed(1)),
                    MapEntry('Correct characters', '${s.correctCharacters}'),
                    MapEntry('Wrong characters', '${s.wrongCharacters}'),
                    MapEntry('Correct words', '${s.correctWords}'),
                    MapEntry('Wrong words', '${s.wrongWords}'),
                    MapEntry('Skipped words', '${s.skippedWords}'),
                    MapEntry('Total errors', '${s.totalErrors}'),
                    MapEntry('Backspaces', '${s.backspaces}'),
                    MapEntry('Test duration', _formatElapsed(s.elapsed)),
                    MapEntry('Progress', '${s.progress.toStringAsFixed(0)}%'),
                  ],
                ),
                const SizedBox(height: 28),
                RepaintBoundary(
                  key: _resultCardKey,
                  child: ShareableResultCard(
                    snapshot: s,
                    title: 'Typing Test Result',
                    subtitle: paragraphTitle,
                    completedAt: DateTime.now(),
                  ),
                ),
                const SizedBox(height: 12),
                ResultShareButtons(
                  boundaryKey: _resultCardKey,
                  shareText: formatResultShareText(
                    snapshot: s,
                    title: 'Typing Test Result',
                    completedAt: DateTime.now(),
                  ),
                  fileName: 'wolftyping-result.png',
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: controller.tryAgain,
                      icon: const Icon(Icons.replay),
                      label: const Text('Try Again'),
                    ),
                    OutlinedButton.icon(
                      onPressed: controller.restartTest,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Restart (same paragraph)'),
                    ),
                    OutlinedButton.icon(
                      onPressed: controller.backToSetupFromResult,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back to Setup'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        controller.backToSetupFromResult();
                        Get.offNamed(AppRoutes.dashboard);
                      },
                      icon: const Icon(Icons.home_outlined),
                      label: const Text('Back to Dashboard'),
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
  if (minutes == 0) return '${seconds}s';
  return '${minutes}m ${seconds}s';
}
