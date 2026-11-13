import 'package:get/get.dart';

import '../../../core/database/database_recovery.dart';
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
    DatabaseRecovery? databaseRecovery,
  })  : _repository = repository ?? ProgressRepository.instance,
        _loadTimeout = loadTimeout,
        _recovery = databaseRecovery ?? DatabaseRecovery();

  final ProgressRepository _repository;
  final Duration _loadTimeout;
  final DatabaseRecovery _recovery;

  final RxBool isLoading = true.obs;

  /// True when the latest load gave up waiting on the database. The view
  /// shows a one-line notice in that case; the stored data is untouched.
  final RxBool loadTimedOut = false.obs;

  /// True when the latest load failed even after database recovery (the
  /// database stayed unreachable). Distinct from [loadTimedOut]: a plain
  /// timeout that recovery fixed clears both flags on the retry.
  final RxBool loadFailed = false.obs;
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
    loadFailed.value = false;
    isLoading.value = true;
    // At most one recovery attempt per load() call, however many fetches
    // time out inside it — recovery is bounded (see DatabaseRecovery)
    // and a second attempt would just re-probe the same fresh instance.
    bool recoveryAttempted = false;

    /// Runs [fetch] under the load timeout. On a timeout, attempts one
    /// database recovery and retries the fetch once; a throw still
    /// propagates (unchanged from before recovery existed).
    Future<T> fetchWithRecovery<T>(
      Future<T> Function() fetch,
      T fallback,
    ) async {
      bool timedOut = false;
      T result = await fetch().timeout(
        _loadTimeout,
        onTimeout: () {
          timedOut = true;
          loadTimedOut.value = true;
          return fallback;
        },
      );
      if (!timedOut) return result;
      if (recoveryAttempted) {
        loadFailed.value = true;
        return result;
      }
      recoveryAttempted = true;
      final bool recovered =
          await _recovery.ensureHealthy(probeTimeout: _loadTimeout);
      if (!recovered) {
        loadFailed.value = true;
        return result;
      }
      // The database was replaced: retry once against the fresh instance
      // (repositories resolve it lazily via Get at call time).
      loadTimedOut.value = false;
      bool retriedOut = false;
      result = await fetch().timeout(
        _loadTimeout,
        onTimeout: () {
          retriedOut = true;
          loadTimedOut.value = true;
          return fallback;
        },
      );
      if (retriedOut) loadFailed.value = true;
      return result;
    }

    try {
      allTests.value = await fetchWithRecovery<List<TypingTestRecord>>(
        _repository.fetchAllTests,
        <TypingTestRecord>[],
      );
      dailyGoalSeconds.value = await fetchWithRecovery<int>(
        _repository.fetchDailyGoalSeconds,
        600,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Re-runs [load] from the empty/timeout state (the "Retry loading
  /// history" button). Resets the flags first so a recovered load clears
  /// the timeout notice.
  Future<void> retryLoad() async {
    loadTimedOut.value = false;
    loadFailed.value = false;
    await load();
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
