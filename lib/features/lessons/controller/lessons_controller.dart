import 'package:get/get.dart';

import '../../typing_test/model/typing_language.dart';
import '../model/lesson_level.dart';
import '../model/lesson_status_filter.dart';
import '../model/lesson_with_progress.dart';
import '../service/lesson_repository.dart';

/// Drives the Lessons Dashboard: which language tab is active, the
/// search/level/status filters, and the loaded lesson+progress list for
/// the current language. All filtering happens here, never inside a
/// widget — [filteredLessons] is the only thing the view reads.
class LessonsController extends GetxController {
  final Rx<TypingLanguage> selectedLanguage = TypingLanguage.english.obs;
  final RxString searchQuery = ''.obs;
  final Rx<LessonLevel?> levelFilter = Rx<LessonLevel?>(null);
  final Rx<LessonStatusFilter> statusFilter = LessonStatusFilter.all.obs;

  final RxBool isLoading = false.obs;
  final RxList<LessonWithProgress> lessons = <LessonWithProgress>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLessons();
    ever(selectedLanguage, (_) => loadLessons());
  }

  Future<void> loadLessons() async {
    isLoading.value = true;
    try {
      lessons.value = await LessonRepository.instance
          .fetchLessons(selectedLanguage.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Call after returning from a lesson attempt so progress/lock state
  /// reflects what was just saved.
  @override
  Future<void> refresh() => loadLessons();

  void selectLanguage(TypingLanguage language) {
    if (selectedLanguage.value == language) return;
    selectedLanguage.value = language;
  }

  void setSearch(String query) => searchQuery.value = query;

  void setLevelFilter(LessonLevel? level) => levelFilter.value = level;

  void setStatusFilter(LessonStatusFilter filter) =>
      statusFilter.value = filter;

  List<LessonWithProgress> get filteredLessons {
    final String query = searchQuery.value.trim().toLowerCase();
    return lessons.where((l) {
      if (levelFilter.value != null &&
          l.definition.level != levelFilter.value) {
        return false;
      }
      switch (statusFilter.value) {
        case LessonStatusFilter.completed:
          if (!l.completed) return false;
          break;
        case LessonStatusFilter.inProgress:
          if (l.locked || l.completed || l.attempts == 0) return false;
          break;
        case LessonStatusFilter.locked:
          if (!l.locked) return false;
          break;
        case LessonStatusFilter.all:
          break;
      }
      if (query.isNotEmpty &&
          !l.definition.title.toLowerCase().contains(query) &&
          !l.definition.description.toLowerCase().contains(query)) {
        return false;
      }
      return true;
    }).toList();
  }
}
