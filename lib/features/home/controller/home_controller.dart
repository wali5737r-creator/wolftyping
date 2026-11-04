import 'package:get/get.dart';

import '../../../core/services/data_refresh_service.dart';
import '../../history/model/typing_test_record.dart';
import '../../progress/model/progress_models.dart';
import '../../progress/service/progress_calculations.dart';
import '../../progress/service/progress_repository.dart';

/// Dashboard state. Everything shown comes from the completed tests stored
/// in SQLite (the same `TypingTests` rows History and Progress read) and
/// is derived with the existing [ProgressCalculations] - so Dashboard,
/// Progress and History can never disagree, and there is no placeholder
/// data anywhere.
///
/// It reloads whenever [DataRefreshService] reports a change (a test was
/// saved, a record deleted, history cleared, settings reset, daily goal
/// changed), so the Dashboard is always current.
class HomeController extends GetxController {
  /// How long a history/goal read may take before the dashboard gives up
  /// waiting and shows the empty state instead of spinning forever (the
  /// database open can hang on a reload). Tests inject a shorter value.
  static const Duration kLoadTimeout = Duration(seconds: 8);

  HomeController({
    ProgressRepository? repository,
    Duration loadTimeout = kLoadTimeout,
  })  : _repository = repository ?? ProgressRepository.instance,
        _loadTimeout = loadTimeout;

  final ProgressRepository _repository;
  final Duration _loadTimeout;

  final RxBool isLoading = true.obs;

  /// True when the latest load gave up waiting on the database. The view
  /// shows a one-line notice in that case; the stored data is untouched.
  final RxBool loadTimedOut = false.obs;
  final RxList<TypingTestRecord> allTests = <TypingTestRecord>[].obs;
  final RxInt dailyGoalSeconds = 600.obs;

  Worker? _refreshWorker;

  @override
  void onInit() {
    super.onInit();
    load();
    if (Get.isRegistered<DataRefreshService>()) {
      _refreshWorker = ever<int>(
        Get.find<DataRefreshService>().revision,
        (_) => load(),
      );
    }
  }

  Future<void> load() async {
    loadTimedOut.value = false;
    try {
      final tests = await _repository.fetchAllTests().timeout(
        _loadTimeout,
        onTimeout: () {
          loadTimedOut.value = true;
          return <TypingTestRecord>[];
        },
      );
      final goal = await _repository.fetchDailyGoalSeconds().timeout(
        _loadTimeout,
        onTimeout: () {
          loadTimedOut.value = true;
          return 600;
        },
      );
      allTests.value = tests;
      dailyGoalSeconds.value = goal;
    } finally {
      isLoading.value = false;
    }
  }

  bool get hasTests => allTests.isNotEmpty;

  List<TypingTestRecord> get _todayTests {
    final DateTime now = DateTime.now();
    final DateTime start = DateTime(now.year, now.month, now.day);
    final DateTime end = start.add(const Duration(days: 1));
    return [
      for (final TypingTestRecord t in allTests)
        if (!t.completedAt.isBefore(start) && t.completedAt.isBefore(end)) t,
    ];
  }

  /// Today's tests count, average WPM / accuracy, practice time.
  LanguageStats get today => ProgressCalculations.statsFor(_todayTests);

  /// All-time stats (best WPM, overall average WPM).
  LanguageStats get overall => ProgressCalculations.statsFor(allTests);

  DailyGoalData get dailyGoal => ProgressCalculations.dailyGoal(
      allTests, dailyGoalSeconds.value, DateTime.now());

  /// The five most recent completed tests, newest first.
  List<TypingTestRecord> get recentTests {
    final List<TypingTestRecord> sorted = [...allTests]
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
    return sorted.take(5).toList();
  }

  @override
  void onClose() {
    _refreshWorker?.dispose();
    super.onClose();
  }
}
