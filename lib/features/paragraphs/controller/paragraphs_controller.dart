import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../typing_test/model/english_paragraph.dart';
import '../../typing_test/model/paragraph_difficulty.dart';
import '../../typing_test/model/typing_language.dart';
import '../../typing_test/model/urdu_paragraph.dart';
import '../model/custom_paragraph.dart';
import '../model/paragraph_category.dart';
import '../model/paragraph_sort.dart';
import '../service/paragraph_repository.dart';

/// Drives the My Paragraphs dashboard: loads the merged built-in+custom
/// list, applies search/language/category filters and sort, and handles
/// delete + "Use for Test" (which reuses the existing Typing Test screens
/// — no second typing test is ever created).
class ParagraphsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<CustomParagraph> allParagraphs = <CustomParagraph>[].obs;

  final Rx<ParagraphLanguageFilter> languageFilter =
      ParagraphLanguageFilter.all.obs;
  final Rx<ParagraphCategory?> categoryFilter = Rx<ParagraphCategory?>(null);
  final Rx<ParagraphSort> sort = ParagraphSort.newest.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      allParagraphs.value = await ParagraphRepository.instance.fetchAll();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> refresh() => load();

  void setLanguageFilter(ParagraphLanguageFilter f) =>
      languageFilter.value = f;

  void setCategoryFilter(ParagraphCategory? c) => categoryFilter.value = c;

  void setSort(ParagraphSort s) => sort.value = s;

  void setSearch(String q) => searchQuery.value = q;

  int get totalCount => allParagraphs.length;

  int get englishCount =>
      allParagraphs.where((p) => p.language == TypingLanguage.english).length;

  int get urduCount =>
      allParagraphs.where((p) => p.language == TypingLanguage.urdu).length;

  List<CustomParagraph> get filtered => applyFilters(
        allParagraphs,
        languageFilter: languageFilter.value,
        categoryFilter: categoryFilter.value,
        sort: sort.value,
        query: searchQuery.value,
      );

  /// Pure filter+search+sort logic — no GetX, no database — so it can be
  /// unit tested directly with plain [CustomParagraph] lists (see
  /// test/paragraphs_test.dart).
  static List<CustomParagraph> applyFilters(
    List<CustomParagraph> all, {
    required ParagraphLanguageFilter languageFilter,
    required ParagraphCategory? categoryFilter,
    required ParagraphSort sort,
    required String query,
  }) {
    Iterable<CustomParagraph> list = all;

    if (languageFilter == ParagraphLanguageFilter.english) {
      list = list.where((p) => p.language == TypingLanguage.english);
    } else if (languageFilter == ParagraphLanguageFilter.urdu) {
      list = list.where((p) => p.language == TypingLanguage.urdu);
    }

    if (categoryFilter != null) {
      list = list.where((p) => p.category == categoryFilter);
    }

    final String q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((p) =>
          p.title.toLowerCase().contains(q) ||
          p.text.toLowerCase().contains(q) ||
          p.category.label.toLowerCase().contains(q));
    }

    final List<CustomParagraph> result = list.toList();
    switch (sort) {
      case ParagraphSort.newest:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case ParagraphSort.oldest:
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case ParagraphSort.titleAZ:
        result.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case ParagraphSort.titleZA:
        result.sort(
            (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
    }
    return result;
  }

  Future<void> deleteParagraph(CustomParagraph paragraph) async {
    if (!paragraph.isCustom) return; // built-ins can never be deleted
    await ParagraphRepository.instance.delete(paragraph.id);
    await refresh();
  }

  void openAdd() =>
      Get.toNamed(AppRoutes.paragraphForm)?.then((_) => refresh());

  void openEdit(CustomParagraph paragraph) {
    if (!paragraph.isCustom) return; // built-ins can never be edited
    Get.toNamed(AppRoutes.paragraphForm, arguments: paragraph)
        ?.then((_) => refresh());
  }

  void openPreview(CustomParagraph paragraph) {
    Get.toNamed(AppRoutes.paragraphPreview, arguments: paragraph);
  }

  /// Reuses the existing Typing Test screens — English/Urdu Typing Test
  /// controllers already accept an initial paragraph via `Get.arguments`
  /// (see TypingController/UrduTypingController `onInit`).
  void useForTest(CustomParagraph paragraph) {
    if (paragraph.language == TypingLanguage.english) {
      Get.toNamed(
        AppRoutes.typingTest,
        arguments: toEnglishParagraph(paragraph),
      );
    } else {
      Get.toNamed(
        AppRoutes.urduTypingTest,
        arguments: toUrduParagraph(paragraph),
      );
    }
  }

  /// Pure conversion, no GetX — testable directly (see
  /// test/paragraphs_test.dart). Falls back to medium difficulty for a
  /// custom paragraph that never had one set.
  static EnglishParagraph toEnglishParagraph(CustomParagraph paragraph) {
    return EnglishParagraph(
      title: paragraph.title,
      text: paragraph.text,
      difficulty: paragraph.difficulty ?? ParagraphDifficulty.medium,
    );
  }

  static UrduParagraph toUrduParagraph(CustomParagraph paragraph) {
    return UrduParagraph(
      title: paragraph.title,
      text: paragraph.text,
      difficulty: paragraph.difficulty ?? ParagraphDifficulty.medium,
    );
  }
}
