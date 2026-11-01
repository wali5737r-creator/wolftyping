import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../model/mock_attempt.dart';
import '../model/paper_test.dart';

/// One todo-list style row for a practice paper: paper number, post /
/// department, question count, and a Start action. The whole row starts
/// the paper, so the row and its button do the same thing.
///
/// Once attempted, the row shows a tick and the BEST score for that
/// paper ('Best score: X/Y'), and the action becomes Retake. The best
/// score is stated in the UI so it is never confused with the latest.
///
/// Practice material only: the paper is never presented as an official
/// or verbatim paper.
class PaperRow extends StatelessWidget {
  const PaperRow({
    super.key,
    required this.paper,
    required this.onStart,
    this.bestAttempt,
  });

  final PaperTest paper;
  final VoidCallback onStart;

  /// Best recorded attempt for this paper, if any.
  final MockAttempt? bestAttempt;

  @override
  Widget build(BuildContext context) {
    final bool attempted = bestAttempt != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.gapSmall),
      child: SoftSurface(
        raised: false,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        onTap: onStart,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              attempted
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank,
              size: 22,
              color: attempted ? AppColors.success : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paper ${paper.paperNo} — ${paper.post}',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${paper.department} · ${paper.examDate} · '
                    '${paper.questionCount} questions',
                    style: AppTextStyles.body,
                  ),
                  if (attempted) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Best score: ${bestAttempt!.scoreLabel}',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: onStart,
              child: Text(attempted ? 'Retake' : 'Start'),
            ),
          ],
        ),
      ),
    );
  }
}
