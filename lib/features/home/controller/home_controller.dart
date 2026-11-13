import 'dart:async';

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

  /// True when the latest load failed even after the background database
  /// recovery ran and reported the database still unreachable. Distinct
  /// from [loadTimedOut]: a plain timeout only means the load gave up
  /// waiting — recovery is still running in the background, and if it
  /// succeeds the Dashboard reloads on its own (see [load]).
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

  /// Loads the Dashboard data, bounded: a fetch that does not answer
  /// within [_loadTimeout] returns its fallback instead of spinning.
  /// The empty state + "Retry loading history" button therefore appear
  /// within ~8s of mount even when the database never answers.
  ///
  /// The two reads are independent and run concurrently: a hung or
  /// throwing history read degrades to the empty history state with a
  /// Retry (a throw used to propagate out of [load] entirely), and a
  /// failing daily-goal read falls back to the default goal without
  /// hiding the history rows — and vice versa. This is the same
  /// partial-data treatment History applies to its two sources.
  ///
  /// Database recovery runs in the BACKGROUND, never inside this load:
  /// the old in-load recovery cost up to ~41.5s of spinner (8s fetch
  /// timeout + 3 probes × 8s + backoff + 8s retry). Here a timeout or
  /// throw kicks off one background recovery (at most one per load()
  /// call) and the load finishes. If recovery succeeds it replaces the
  /// stuck instance and notifies via [DataRefreshService], so the
  /// `ever()` worker in [onInit] re-runs [load] automatically — no
  /// manual retry needed. If recovery reports the database still
  /// unreachable, [loadFailed] is set (only while the load is still
  /// timed out, so a later successful reload is never overwritten by a
  /// stale callback).
  Future<void> load() async {
    loadTimedOut.value = false;
    loadFailed.value = false;
    isLoading.value = true;
    // At most one background recovery per load() call, however many
    // fetches fail inside it.
    bool recoveryAttempted = false;

    void kickOffBackgroundRecovery() {
      if (recoveryAttempted) return;
      recoveryAttempted = true;
      unawaited(_runBackgroundRecovery());
    }

    /// Runs [fetch] under the load timeout. On a timeout OR a throw,
    /// marks the load timed out, kicks off background recovery once,
    /// and returns the fallback — the load finishes promptly and the
    /// view can offer Retry, instead of the throw propagating and
    /// leaving the screen with no way back.
    Future<T> fetchWithTimeout<T>(
      Future<T> Function() fetch,
      T fallback,
    ) async {
      try {
        return await fetch().timeout(
          _loadTimeout,
          onTimeout: () {
            loadTimedOut.value = true;
            kickOffBackgroundRecovery();
            return fallback;
          },
        );
      } catch (_) {
        loadTimedOut.value = true;
        kickOffBackgroundRecovery();
        return fallback;
      }
    }

    try {
      await Future.wait(<Future<void>>[
        fetchWithTimeout<List<TypingTestRecord>>(
          _repository.fetchAllTests,
          <TypingTestRecord>[],
        ).then((List<TypingTestRecord> tests) {
          allTests.value = tests;
        }),
        fetchWithTimeout<int>(
          _repository.fetchDailyGoalSeconds,
          600,
        ).then((int goal) {
          dailyGoalSeconds.value = goal;
        }),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  /// One background recovery run: replaces the stuck database instance
  /// if needed. On success [DatabaseRecovery] already notified via
  /// [DataRefreshService], so the reload happens through the `ever()`
  /// worker. On failure only the flag is set — the data is untouched.
  /// With [forceFresh] (the Retry path) the recovery starts a genuinely
  /// fresh probe sequence instead of joining an in-flight run that may
  /// already be doomed.
  Future<void> _runBackgroundRecovery({bool forceFresh = false}) async {
    bool recovered = false;
    try {
      recovered = await _recovery.ensureHealthy(forceFresh: forceFresh);
    } catch (_) {
      recovered = false;
    }
    if (!recovered && loadTimedOut.value) {
      loadFailed.value = true;
    }
  }

  /// Re-runs [load] from the empty/timeout state (the "Retry loading
  /// history" button). Resets the flags first so a recovered load clears
  /// the timeout notice. Also starts a genuinely fresh background
  /// recovery (not a join of the stale in-flight one) so the retry has
  /// a real chance to succeed.
  Future<void> retryLoad() async {
    loadTimedOut.value = false;
    loadFailed.value = false;
    unawaited(_runBackgroundRecovery(forceFresh: true));
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
