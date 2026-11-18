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
    this.hasDraft = false,
    this.onResume,
  });

  final PaperTest paper;
  final VoidCallback onStart;

  /// Best recorded attempt for this paper, if any.
  final MockAttempt? bestAttempt;

  /// True when this paper has an unfinished mid-test draft.
  final bool hasDraft;

  /// Resumes the unfinished test. Null (and no resume button) when
  /// there is no draft to resume.
  final VoidCallback? onResume;

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
            // The actions stack vertically so the row never overflows
            // at 360px wide even with both Start/Retake and the
            // resume button. Row tap stays = fresh start (onStart).
            // IntrinsicWidth bounds the column (a stretched column
            // inside a Row would get an infinite width); the buttons
            // then share the widest button's width.
            IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: onStart,
                    child: Text(attempted ? 'Retake' : 'Start'),
                  ),
                  if (hasDraft && onResume != null) ...[
                    const SizedBox(height: 6),
                    OutlinedButton(
                      onPressed: onResume,
                      child: const Text('Jari rakhein'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
