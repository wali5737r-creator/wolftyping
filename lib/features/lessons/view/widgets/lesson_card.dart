import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_controls.dart';
import '../../../../core/widgets/app_surfaces.dart';
import '../../model/lesson_with_progress.dart';

/// One lesson tile on the Lessons Dashboard grid.
class LessonCard extends StatelessWidget {
  const LessonCard({
    super.key,
    required this.lesson,
    required this.onTap,
  });

  final LessonWithProgress lesson;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool locked = lesson.locked;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color accent = isDark ? AppColors.primaryDark : AppColors.primary;
    return Opacity(
      opacity: locked ? 0.55 : 1,
      child: SoftSurface(
        onTap: locked ? null : onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _NumberBadge(number: lesson.definition.orderIndex),
                const Spacer(),
                if (locked)
                  const Icon(Icons.lock_outline,
                      size: 18, color: AppColors.pendingText)
                else if (lesson.completed)
                  const TagBadge(text: 'Completed', color: AppColors.success),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              lesson.definition.title,
              style: AppTextStyles.h3,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              lesson.definition.description,
              style: AppTextStyles.captionOf(context),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: TagBadge(text: lesson.definition.level.label),
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (lesson.progressPercent / 100).clamp(0, 1),
                minHeight: 5,
                color: lesson.completed ? AppColors.success : accent,
                backgroundColor:
                    Theme.of(context).dividerColor.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _MiniStat(
                    label: 'Best WPM',
                    value: lesson.bestSpeed.toStringAsFixed(0)),
                _MiniStat(
                    label: 'Best Acc',
                    value: '${lesson.bestAccuracy.toStringAsFixed(0)}%'),
                _MiniStat(label: 'Attempts', value: '${lesson.attempts}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color accent = isDark ? AppColors.primaryDark : AppColors.primary;
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.22 : 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$number',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: accent,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.captionOf(context)),
        Text(value, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}
