import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_controls.dart';
import '../../../../core/widgets/app_surfaces.dart';
import '../../../typing_test/model/typing_language.dart';
import '../../model/custom_paragraph.dart';

/// One paragraph tile on the My Paragraphs grid. Built-in paragraphs show
/// a "Built-in" badge and never expose Edit/Delete (spec section 12).
///
/// Layout is overflow-proof: every fixed row is a single line, the
/// buttons have a fixed size, and the paragraph preview takes whatever
/// height is left over, so the card looks the same for any amount of text.
class ParagraphCard extends StatelessWidget {
  const ParagraphCard({
    super.key,
    required this.paragraph,
    required this.onView,
    required this.onUseForTest,
    required this.onEdit,
    required this.onDelete,
  });

  final CustomParagraph paragraph;
  final VoidCallback onView;
  final VoidCallback onUseForTest;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final bool isUrdu = paragraph.language == TypingLanguage.urdu;

    return SoftSurface(
      onTap: onView,
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title (+ Built-in badge) - single line
              Row(
                children: [
                  Expanded(
                    child: Text(
                      paragraph.title,
                      style: isUrdu ? AppTextStyles.urduTitle : AppTextStyles.h3,
                      textDirection:
                          isUrdu ? TextDirection.rtl : TextDirection.ltr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!paragraph.isCustom) ...[
                    const SizedBox(width: 6),
                    const TagBadge(text: 'Built-in'),
                  ],
                ],
              ),
              const SizedBox(height: 6),

              // Language + category badges - single line
              Row(
                children: [
                  Flexible(child: TagBadge(text: paragraph.language.label)),
                  const SizedBox(width: 6),
                  Flexible(child: TagBadge(text: paragraph.category.label)),
                ],
              ),
              const SizedBox(height: 8),

              // Preview - small part of the paragraph, fixed 4 lines max
              Expanded(
                child: Directionality(
                  textDirection:
                      isUrdu ? TextDirection.rtl : TextDirection.ltr,
                  child: Text(
                    paragraph.text,
                    style: isUrdu ? AppTextStyles.urduBody : AppTextStyles.body,
                    // Nastaleeq lines are taller; 3 lines fit the fixed
                    // card height without overflowing.
                    maxLines: isUrdu ? 3 : 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Buttons - always ONE row, fixed sizes
              SizedBox(
                height: 34,
                child: Row(
                  children: [
                    SizedBox(
                      width: 110,
                      height: 32,
                      child: OutlinedButton(
                        onPressed: onUseForTest,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text(
                          'Use for Test',
                          style: TextStyle(fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _CardIconButton(
                      tooltip: 'View',
                      icon: Icons.visibility_outlined,
                      onPressed: onView,
                    ),
                    if (paragraph.isCustom) ...[
                      _CardIconButton(
                        tooltip: 'Edit',
                        icon: Icons.edit_outlined,
                        onPressed: onEdit,
                      ),
                      _CardIconButton(
                        tooltip: 'Delete',
                        icon: Icons.delete_outline,
                        color: AppColors.danger,
                        onPressed: onDelete,
                      ),
                    ],
                  ],
                ),
              ),
            ],
      ),
    );
  }
}

class _CardIconButton extends StatelessWidget {
  const _CardIconButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      constraints: const BoxConstraints.tightFor(width: 30, height: 34),
    );
  }
}
