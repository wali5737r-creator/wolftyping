import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_surfaces.dart';
import '../../model/typing_test_record.dart';

class HistoryRow extends StatelessWidget {
  const HistoryRow({
    super.key,
    required this.record,
    required this.onTap,
    required this.onDelete,
  });

  final TypingTestRecord record;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return SoftSurface(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              _formatDateTime(record.completedAt),
              style: AppTextStyles.captionOf(context),
            ),
          ),
          SizedBox(
            width: 110,
            child: Text(record.languageAndTypeLabel,
                style: AppTextStyles.bodyMedium),
          ),
          if (record.isMock) ...[
            SizedBox(
              width: 90,
              child: Text(record.mockScoreLabel,
                  style: AppTextStyles.bodyMedium),
            ),
            SizedBox(
              width: 100,
              child: Text(
                  '${record.accuracy.toStringAsFixed(0)}% correct',
                  style: AppTextStyles.bodyMedium),
            ),
            Expanded(
              child: Text(
                _mockSummary(record),
                style: AppTextStyles.captionOf(context),
                textAlign: TextAlign.right,
              ),
            ),
          ] else ...[
            SizedBox(
              width: 90,
              child: Text('${record.netWpm.toStringAsFixed(0)} WPM',
                  style: AppTextStyles.bodyMedium),
            ),
            SizedBox(
              width: 100,
              child: Text('${record.accuracy.toStringAsFixed(0)}% acc',
                  style: AppTextStyles.bodyMedium),
            ),
            Expanded(
              child: Text(
                '${record.totalErrors} errors · ${record.actualDurationSeconds}s',
                style: AppTextStyles.captionOf(context),
                textAlign: TextAlign.right,
              ),
            ),
          ],
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline,
                size: 20, color: AppColors.danger),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  /// 'Full mock test · 5 minutes · 2 correct · 90 wrong · 8 skipped ·
  /// 300s' — the test label plus the breakdown, so the row reads as a
  /// mock result at a glance, not a typing test.
  String _mockSummary(TypingTestRecord record) {
    final List<String> parts = [
      if (record.mockLabel != null) record.mockLabel!,
      '${record.mockCorrect ?? 0} correct',
      '${record.mockWrong ?? 0} wrong',
      '${record.mockSkipped ?? 0} skipped',
    ];
    final String duration = record.mockDurationText;
    if (duration.isNotEmpty) parts.add(duration);
    return parts.join(' · ');
  }
}

String _formatDateTime(DateTime d) {
  final String date =
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  final String time =
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  return '$date $time';
}
