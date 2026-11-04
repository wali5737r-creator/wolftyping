import 'package:get/get.dart';

import '../../../core/services/data_refresh_service.dart';
import '../../history/model/typing_test_record.dart';
import '../../typing_test/model/typing_language.dart';
import '../../typing_test/model/typing_test_kind.dart';
import '../model/progress_models.dart';
import '../model/progress_time_range.dart';
import '../service/progress_calculations.dart';
import '../service/progress_repository.dart';

/// Drives the Progress dashboard. Loads raw data once per refresh, then
/// every displayed number is derived via ProgressCalculations — no
/// widget ever computes a statistic itself (spec section 19/25).
class ProgressController extends GetxController {
  /// How long a data read may take before the screen gives up waiting and
  /// shows empty data instead of spinning forever (the database open can
  /// hang on a reload). Tests inject a shorter value.
  static const Duration kLoadTimeout = Duration(seconds: 8);

  ProgressController({
    ProgressRepository? repository,
    Duration loadTimeout = kLoadTimeout,
  })  : _repository = repository ?? ProgressRepository.instance,
        _loadTimeout = loadTimeout;

  final ProgressRepository _repository;
  final Duration _loadTimeout;

  final RxBool isLoading = false.obs;

  /// True when the latest load gave up waiting on the database.
  final RxBool loadTimedOut = false.obs;
  final RxList<TypingTestRecord> allTests = <TypingTestRecord>[].obs;
  final RxInt dailyGoalSeconds = 600.obs;
  final Rx<LessonProgressSummary> lessonSummary =
      LessonProgressSummary.empty.obs;

  final Rx<ProgressTimeRange> timeRange = ProgressTimeRange.allTime.obs;
  final Rx<ChartLanguageFilter> chartLanguage = ChartLanguageFilter.all.obs;

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
    loadTimedOut.value = false;
    try {
      final results = await Future.wait([
        _repository.fetchAllTests().timeout(
          _loadTimeout,
          onTimeout: () {
            loadTimedOut.value = true;
            return <TypingTestRecord>[];
          },
        ),
        _repository.fetchDailyGoalSeconds().timeout(
          _loadTimeout,
          onTimeout: () {
            loadTimedOut.value = true;
            return 600;
          },
        ),
        _repository.fetchLessonProgressSummary().timeout(
          _loadTimeout,
          onTimeout: () {
            loadTimedOut.value = true;
            return LessonProgressSummary.empty;
          },
        ),
      ]);
      allTests.value = results[0] as List<TypingTestRecord>;
      dailyGoalSeconds.value = results[1] as int;
      lessonSummary.value = results[2] as LessonProgressSummary;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> refresh() => load();

  bool get hasData => allTests.isNotEmpty;

  List<TypingTestRecord> get _testsInRange => ProgressCalculations
      .filterByRange(allTests, timeRange.value.startDate(DateTime.now()));

  // --- Overall (respects the selected time range) -----------------------

  LanguageStats get overall => ProgressCalculations.statsFor(_testsInRange);

  int get totalCharactersTyped => _testsInRange.fold<int>(
      0, (sum, t) => sum + t.correctCharacters + t.wrongCharacters);

  int get totalWordsTyped => _testsInRange.fold<int>(
      0, (sum, t) => sum + t.correctWords + t.wrongWords);

  // --- Per-language (respects the selected time range) -------------------

  LanguageStats get englishStats => ProgressCalculations.statsFor(
      _testsInRange
          .where((t) => t.language == TypingLanguage.english)
          .toList());

  /// Urdu including PPSC (spec: "PPSC should remain identifiable as
  /// Urdu/PPSC" — not excluded from the Urdu totals).
  LanguageStats get urduStats => ProgressCalculations.statsFor(_testsInRange
      .where((t) => t.language == TypingLanguage.urdu)
      .toList());

  LanguageStats get ppscStats => ProgressCalculations.statsFor(_testsInRange
      .where((t) => t.testType == TypingTestKind.ppsc)
      .toList());

  // --- All-time (not limited by the range selector) ----------------------

  BestRecords get bestRecords => ProgressCalculations.bestRecords(allTests);

  ImprovementData get improvement =>
      ProgressCalculations.improvement(allTests);

  StreakData get streak =>
      ProgressCalculations.streak(allTests, DateTime.now());

  DailyGoalData get dailyGoal => ProgressCalculations.dailyGoal(
      allTests, dailyGoalSeconds.value, DateTime.now());

  // --- Charts (respect both the range and the chart language filter) -----

  List<TypingTestRecord> get _chartTests {
    switch (chartLanguage.value) {
      case ChartLanguageFilter.all:
        return _testsInRange;
      case ChartLanguageFilter.english:
        return _testsInRange
            .where((t) => t.language == TypingLanguage.english)
            .toList();
      case ChartLanguageFilter.urdu:
        return _testsInRange
            .where((t) =>
                t.language == TypingLanguage.urdu &&
                t.testType != TypingTestKind.ppsc)
            .toList();
      case ChartLanguageFilter.ppsc:
        return _testsInRange
            .where((t) => t.testType == TypingTestKind.ppsc)
            .toList();
    }
  }

  List<ChartPoint> get wpmChartPoints =>
      ProgressCalculations.chartPoints(_chartTests, valueOf: (t) => t.netWpm);

  List<ChartPoint> get accuracyChartPoints => ProgressCalculations
      .chartPoints(_chartTests, valueOf: (t) => t.accuracy);
}
