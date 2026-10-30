import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_controls.dart';
import '../../controller/practice_controller.dart';
import '../../model/character_mistake_stat.dart';

/// Detail popup for one character/key (spec section 11): total mistakes,
/// common wrong inputs, and a button to practice that key specifically.
class MistakeDetailDialog extends StatelessWidget {
  const MistakeDetailDialog({
    super.key,
    required this.character,
    required this.stat,
    required this.controller,
    required this.isUrdu,
  });

  final String character;
  final CharacterMistakeStat? stat;
  final PracticeController controller;
  final bool isUrdu;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      title: Directionality(
        textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        child: Text(character,
            style: isUrdu ? AppTextStyles.urduHeading : AppTextStyles.h1),
      ),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TagBadge(text: '${stat?.count ?? 0} mistakes'),
            const SizedBox(height: 14),
            if (stat != null && stat!.commonWrongInputs.isNotEmpty) ...[
              Text('Common wrong input:', style: AppTextStyles.captionOf(context)),
              const SizedBox(height: 6),
              for (final entry in stat!.commonWrongInputs.entries.take(5))
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Directionality(
                    textDirection:
                        isUrdu ? TextDirection.rtl : TextDirection.ltr,
                    child: Text('${entry.key}  →  ${entry.value}',
                        style: isUrdu ? AppTextStyles.urduBody : null),
                  ),
                ),
            ] else
              const Text('No mistakes recorded for this key yet.'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        ElevatedButton.icon(
          onPressed: stat == null
              ? null
              : () {
                  Navigator.of(context).pop();
                  controller.startPracticeForCharacter(character);
                },
          icon: const Icon(Icons.fitness_center, size: 18),
          label: const Text('Practice This Key'),
        ),
      ],
    );
  }
}
