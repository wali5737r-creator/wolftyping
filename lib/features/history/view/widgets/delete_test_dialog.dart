import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Shows the "Are you sure you want to delete this test result?" dialog
/// (spec section 6) and returns true only if the user confirms.
Future<bool> confirmDeleteTest(BuildContext context) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete test result?'),
      content: const Text(
        'Are you sure you want to delete this test result? This cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return confirmed == true;
}
