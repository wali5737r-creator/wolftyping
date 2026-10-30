import 'package:get/get.dart';

import '../../../core/services/data_refresh_service.dart';
import '../../typing_test/model/typing_language.dart';
import '../../typing_test/model/typing_test_kind.dart';
import '../model/history_filters.dart';
import '../model/typing_test_record.dart';
import '../service/history_repository.dart';

/// Drives the History screen: loads completed tests once, then applies
/// filters/search/sort entirely in memory (spec section 19: don't
/// recalculate the whole database repeatedly) via the pure
/// [applyFilters] method.
class HistoryController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<TypingTestRecord> allTests = <TypingTestRecord>[].obs;

  final Rx<HistoryLanguageFilter> languageFilter =
      HistoryLanguageFilter.all.obs;
  final Rx<HistoryTestTypeFilter> testTypeFilter =
      HistoryTestTypeFilter.all.obs;
  final Rx<HistoryDurationFilter> durationFilter =
      HistoryDurationFilter.all.obs;
  final Rx<HistoryDateFilter> dateFilter = HistoryDateFilter.allTime.obs;
  final Rx<HistorySort> sort = HistorySort.newestFirst.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
    // Reload when tests are saved/deleted/cleared elsewhere.
    if (Get.isRegistered<DataRefreshService>()) {
      _refreshWorker = ever<int>(
        Get.find<DataRefreshService>().revision,
        (_) => load(),
      );
    }
  }

  Worker? _refreshWorker;

  @override
  void onClose() {
    _refreshWorker?.dispose();
    super.onClose();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      allTests.value = await HistoryRepository.instance.fetchAll();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> refresh() => load();

  List<TypingTestRecord> get filtered => applyFilters(
        allTests,
        language: languageFilter.value,
        testType: testTypeFilter.value,
        duration: durationFilter.value,
        date: dateFilter.value,
        sort: sort.value,
        query: searchQuery.value,
        now: DateTime.now(),
      );

  Future<void> deleteTest(TypingTestRecord test) async {
    await HistoryRepository.instance.deleteTest(test.id);
    await refresh();
  }

  /// Pure filter+search+sort — no GetX, no database — unit tested
  /// directly (see test/history_test.dart). [now] is injected so date
  /// filtering ("Today" / "Last 7 Days" / "Last 30 Days") is testable
  /// with fixed fixture dates instead of the real clock.
  static List<TypingTestRecord> applyFilters(
    List<TypingTestRecord> all, {
    required HistoryLanguageFilter language,
    required HistoryTestTypeFilter testType,
    required HistoryDurationFilter duration,
    required HistoryDateFilter date,
    required HistorySort sort,
    required String query,
    required DateTime now,
  }) {
    Iterable<TypingTestRecord> list = all;

    if (language == HistoryLanguageFilter.english) {
      list = list.where((t) => t.language == TypingLanguage.english);
    } else if (language == HistoryLanguageFilter.urdu) {
      list = list.where((t) => t.language == TypingLanguage.urdu);
    }

    if (testType == HistoryTestTypeFilter.normal) {
      list = list.where((t) => t.testType == TypingTestKind.normal);
    } else if (testType == HistoryTestTypeFilter.ppsc) {
      list = list.where((t) => t.testType == TypingTestKind.ppsc);
    }

    if (duration != HistoryDurationFilter.all) {
      if (duration == HistoryDurationFilter.custom) {
        const presets = [30, 60, 120, 300, 600];
        list = list.where((t) =>
            t.durationSeconds != null &&
            !presets.contains(t.durationSeconds));
      } else {
        final int? seconds = duration.seconds;
        list = list.where((t) => t.durationSeconds == seconds);
      }
    }

    if (date != HistoryDateFilter.allTime) {
      final DateTime todayStart = DateTime(now.year, now.month, now.day);
      DateTime cutoff;
      switch (date) {
        case HistoryDateFilter.today:
          cutoff = todayStart;
          break;
        case HistoryDateFilter.last7Days:
          cutoff = todayStart.subtract(const Duration(days: 6));
          break;
        case HistoryDateFilter.last30Days:
          cutoff = todayStart.subtract(const Duration(days: 29));
          break;
        case HistoryDateFilter.allTime:
          cutoff = DateTime(0);
          break;
      }
      list = list.where((t) => !t.completedAt.isBefore(cutoff));
    }

    final String q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((t) =>
          t.language.label.toLowerCase().contains(q) ||
          t.testType.label.toLowerCase().contains(q) ||
          _formatDateForSearch(t.completedAt).contains(q));
    }

    final List<TypingTestRecord> result = list.toList();
    switch (sort) {
      case HistorySort.newestFirst:
        result.sort((a, b) => b.completedAt.compareTo(a.completedAt));
        break;
      case HistorySort.oldestFirst:
        result.sort((a, b) => a.completedAt.compareTo(b.completedAt));
        break;
      case HistorySort.highestWpm:
        result.sort((a, b) => b.netWpm.compareTo(a.netWpm));
        break;
      case HistorySort.lowestWpm:
        result.sort((a, b) => a.netWpm.compareTo(b.netWpm));
        break;
      case HistorySort.highestAccuracy:
        result.sort((a, b) => b.accuracy.compareTo(a.accuracy));
        break;
      case HistorySort.lowestAccuracy:
        result.sort((a, b) => a.accuracy.compareTo(b.accuracy));
        break;
    }
    return result;
  }

  static String _formatDateForSearch(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
