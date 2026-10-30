import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Shows the "Are you sure you want to delete this paragraph?" dialog
/// (spec section 5) and returns true only if the user confirms.
Future<bool> confirmDeleteParagraph(BuildContext context, String title) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete paragraph?'),
      content: Text(
        'Are you sure you want to delete "$title"? This cannot be undone.',
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
