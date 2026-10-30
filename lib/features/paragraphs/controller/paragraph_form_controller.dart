import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../typing_test/model/typing_language.dart';
import '../model/custom_paragraph.dart';
import '../model/paragraph_category.dart';
import '../model/paragraph_validation.dart';
import '../service/paragraph_repository.dart';

/// Drives the Add/Edit Paragraph screen. `Get.arguments` being a
/// CustomParagraph means "edit this one"; otherwise this is a fresh
/// "create new paragraph" form.
class ParagraphFormController extends GetxController {
  CustomParagraph? editingParagraph;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final Rx<TypingLanguage> language = TypingLanguage.english.obs;
  final Rx<ParagraphCategory> category = ParagraphCategory.general.obs;

  final RxnString titleError = RxnString();
  final RxnString textError = RxnString();

  /// Set when saving fails (e.g. storage unavailable); shown in the
  /// form so a failed save is visible instead of silent.
  final RxnString saveError = RxnString();
  final RxBool isSaving = false.obs;

  bool get isEditing => editingParagraph != null;

  @override
  void onInit() {
    super.onInit();
    final Object? args = Get.arguments;
    if (args is CustomParagraph) {
      editingParagraph = args;
      titleController.text = args.title;
      textController.text = args.text;
      language.value = args.language;
      category.value = args.category;
    }
  }

  /// Recomputed live as the user types, for the word/character counters
  /// shown on the form (spec section 3) — never entered manually.
  int get liveWordCount {
    final String trimmed = textController.text.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r'\s+')).length;
  }

  /// Unicode-aware so Urdu characters are counted correctly, not split by
  /// UTF-16 code units.
  int get liveCharacterCount => textController.text.runes.length;

  bool _validate() {
    final ParagraphValidationResult result = ParagraphValidation.validate(
      title: titleController.text,
      text: textController.text,
    );
    titleError.value = result.titleError;
    textError.value = result.textError;
    return result.isValid;
  }

  /// Returns true on success. Trims title/text before saving (spec
  /// section 2: "trim unnecessary leading/trailing whitespace").
  Future<bool> save() async => (await saveAndGetParagraph()) != null;

  /// Saves the form and returns the paragraph that was saved, or null
  /// when validation fails. Used by "Save & Start Test" so the freshly
  /// pasted text can run as a typing test immediately, with the same
  /// timing/result flow as any other test.
  Future<CustomParagraph?> saveAndGetParagraph() async {
    if (!_validate()) return null;
    saveError.value = null;
    isSaving.value = true;
    try {
      final String title = titleController.text.trim();
      final String text = textController.text.trim();
      if (isEditing) {
        await ParagraphRepository.instance.update(
          id: editingParagraph!.id,
          title: title,
          language: language.value,
          category: category.value,
          text: text,
          difficulty: editingParagraph!.difficulty,
        );
        return editingParagraph!.copyWith(
          title: title,
          language: language.value,
          category: category.value,
          text: text,
          updatedAt: DateTime.now(),
        );
      }
      await ParagraphRepository.instance.create(
        title: title,
        language: language.value,
        category: category.value,
        text: text,
      );
      return CustomParagraph(
        id: -1,
        title: title,
        language: language.value,
        category: category.value,
        difficulty: null,
        text: text,
        isCustom: true,
        createdAt: DateTime.now(),
        updatedAt: null,
      );
    } catch (_) {
      saveError.value =
          'Could not save this paragraph on this device — storage may be unavailable.';
      return null;
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    textController.dispose();
    super.onClose();
  }
}
