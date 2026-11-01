import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../../typing_test/model/typing_language.dart';
import '../controller/paragraph_form_controller.dart';
import '../controller/paragraphs_controller.dart';
import '../model/custom_paragraph.dart';
import '../model/paragraph_category.dart';

/// Add/Edit Paragraph screen (spec sections 2 and 4 share this one form —
/// editing just pre-fills it and updates the existing row instead of
/// creating a new one).
class ParagraphFormView extends GetView<ParagraphFormController> {
  const ParagraphFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.myParagraphs,
      body: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
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
                PageHeader(
                  title:
                      controller.isEditing ? 'Edit Paragraph' : 'Add Paragraph',
                  subtitle: 'Your paragraph is saved on this computer.',
                ),
                const SizedBox(height: 20),
                const Text('Title', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Obx(() => TextField(
                      controller: controller.titleController,
                      decoration: InputDecoration(
                        hintText: 'e.g. My Office Practice',
                        errorText: controller.titleError.value,
                      ),
                    )),
                const SizedBox(height: 20),
                const Text('Language', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Obx(() => Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        for (final lang in TypingLanguage.values)
                          OptionChip(
                            label: lang.label,
                            selected: controller.language.value == lang,
                            onSelected: () => controller.language.value = lang,
                          ),
                      ],
                    )),
                const SizedBox(height: 20),
                const Text('Category', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Obx(() => Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        for (final cat in ParagraphCategory.values)
                          OptionChip(
                            label: cat.label,
                            selected: controller.category.value == cat,
                            onSelected: () => controller.category.value = cat,
                          ),
                      ],
                    )),
                const SizedBox(height: 20),
                const Text('Paragraph Text', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                Obx(() {
                  final bool isUrdu =
                      controller.language.value == TypingLanguage.urdu;
                  return Directionality(
                    textDirection:
                        isUrdu ? TextDirection.rtl : TextDirection.ltr,
                    child: TextField(
                      controller: controller.textController,
                      maxLines: 8,
                      style: isUrdu
                          ? AppTextStyles.typingTextUr.copyWith(fontSize: 18)
                          : null,
                      decoration: InputDecoration(
                        hintText: isUrdu
                            ? 'یہاں اردو میں پیراگراف لکھیں'
                            : 'Type or paste the paragraph here',
                        errorText: controller.textError.value,
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                // ValueListenableBuilder (not Obx) because the live counts
                // read from a plain TextEditingController, which isn't a
                // GetX Rx value — this is what actually rebuilds on every
                // keystroke.
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller.textController,
                  builder: (context, value, _) => Text(
                    '${controller.liveWordCount} words · '
                    '${controller.liveCharacterCount} characters',
                    style: AppTextStyles.captionOf(context),
                  ),
                ),
                const SizedBox(height: 28),
                Obx(() => Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: controller.isSaving.value
                              ? null
                              : () async {
                                  final bool ok = await controller.save();
                                  if (ok) Get.back();
                                },
                          icon: const Icon(Icons.save_outlined),
                          label: Text(controller.isEditing
                              ? 'Save Changes'
                              : 'Save Paragraph'),
                        ),
                        const SizedBox(width: 12),
                        FilledButton.icon(
                          onPressed: controller.isSaving.value
                              ? null
                              : () async {
                                  final CustomParagraph? saved =
                                      await controller.saveAndGetParagraph();
                                  if (saved == null) return;
                                  if (saved.language ==
                                      TypingLanguage.english) {
                                    Get.offNamed(
                                      AppRoutes.typingTest,
                                      arguments:
                                          ParagraphsController.toEnglishParagraph(
                                        saved,
                                      ),
                                    );
                                  } else {
                                    Get.offNamed(
                                      AppRoutes.urduTypingTest,
                                      arguments:
                                          ParagraphsController.toUrduParagraph(
                                        saved,
                                      ),
                                    );
                                  }
                                },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Save & Start Test'),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                      ],
                    )),
                Obx(() {
                  final String? error = controller.saveError.value;
                  if (error == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      error,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  );
                }),
                const SizedBox(height: AppDimensions.gapLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
