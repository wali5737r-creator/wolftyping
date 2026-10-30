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
}

String _formatDateTime(DateTime d) {
  final String date =
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  final String time =
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  return '$date $time';
}
