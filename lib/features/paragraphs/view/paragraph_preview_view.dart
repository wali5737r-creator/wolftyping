import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../../typing_test/model/typing_language.dart';
import '../controller/paragraphs_controller.dart';
import '../model/custom_paragraph.dart';

/// Read-only preview/details screen (spec section 6). Purely a display of
/// data already computed elsewhere — "Use for Test"/"Edit" delegate back
/// to ParagraphsController, which is still alive on the stack underneath
/// this route.
class ParagraphPreviewView extends StatelessWidget {
  const ParagraphPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final Object? args = Get.arguments;
    final CustomParagraph? paragraph = args is CustomParagraph ? args : null;

    return AppScaffold(
      currentRoute: AppRoutes.myParagraphs,
      body: paragraph == null
          ? const Center(child: Text('Paragraph not found.'))
          : _PreviewContent(paragraph: paragraph),
    );
  }
}

class _PreviewContent extends StatelessWidget {
  const _PreviewContent({required this.paragraph});

  final CustomParagraph paragraph;

  @override
  Widget build(BuildContext context) {
    final bool isUrdu = paragraph.language == TypingLanguage.urdu;
    final ParagraphsController controller = Get.find<ParagraphsController>();

    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Back to My Paragraphs'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Directionality(
                      textDirection:
                          isUrdu ? TextDirection.rtl : TextDirection.ltr,
                      child: Text(paragraph.title,
                          style: isUrdu
                              ? AppTextStyles.urduHeading
                              : AppTextStyles.h1),
                    ),
                  ),
                  if (!paragraph.isCustom) const TagBadge(text: 'Built-in'),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  TagBadge(text: paragraph.language.label),
                  TagBadge(text: paragraph.category.label),
                  TagBadge(text: '${paragraph.wordCount} words'),
                  TagBadge(text: '${paragraph.characterCount} characters'),
                  if (paragraph.isCustom) ...[
                    TagBadge(
                        text: 'Created: ${_formatDate(paragraph.createdAt)}'),
                    TagBadge(
                      text: paragraph.updatedAt != null
                          ? 'Updated: ${_formatDate(paragraph.updatedAt!)}'
                          : 'Never edited',
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 20),
              SoftSurface(
                child: SizedBox(
                  width: double.infinity,
                  child: Directionality(
                    textDirection:
                        isUrdu ? TextDirection.rtl : TextDirection.ltr,
                    child: Text(
                      paragraph.text,
                      style: isUrdu
                          ? AppTextStyles.typingTextUr
                          : AppTextStyles.typingTextEn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => controller.useForTest(paragraph),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Use for Test'),
                  ),
                  if (paragraph.isCustom)
                    OutlinedButton.icon(
                      onPressed: () {
                        Get.back();
                        controller.openEdit(paragraph);
                      },
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Edit'),
                    ),
                  OutlinedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    label: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
