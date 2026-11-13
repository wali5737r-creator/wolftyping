import 'dart:async';

import 'package:get/get.dart';

import '../../../core/database/database_recovery.dart';
import '../../../core/services/data_refresh_service.dart';
import '../../../core/services/history_file_share.dart';
import '../../ppsc/model/mock_attempt.dart';
import '../../ppsc/service/mock_progress_repository.dart';
import '../../typing_test/model/typing_language.dart';
import '../../typing_test/model/typing_test_kind.dart';
import '../model/history_filters.dart';
import '../model/typing_test_record.dart';
import '../service/history_backup.dart';
import '../service/history_backup_repository.dart';
import '../service/history_repository.dart';

/// Drives the History screen: loads completed tests once, then applies
/// filters/search/sort entirely in memory (spec section 19: don't
/// recalculate the whole database repeatedly) via the pure
/// [applyFilters] method.
class HistoryController extends GetxController {
  /// How long the history read may take before the screen gives up
  /// waiting and shows the empty state instead of spinning forever (the
  /// database open can hang on a reload). Tests inject a shorter value.
  static const Duration kLoadTimeout = Duration(seconds: 8);

  HistoryController({
    Future<List<TypingTestRecord>> Function()? fetchAll,
    Duration loadTimeout = kLoadTimeout,
    DatabaseRecovery? databaseRecovery,
  })  : _fetchAll = fetchAll ?? fetchAllHistory,
        _loadTimeout = loadTimeout,
        _recovery = databaseRecovery ?? DatabaseRecovery();

  /// Default history source: completed typing tests from the database
  /// PLUS completed mock MCQ attempts from `MockProgressRepository`,
  /// mapped onto [TypingTestRecord] for display (see
  /// `TypingTestRecord.fromMockAttempt`). The merge is a pure read —
  /// nothing is written, so a reload can never duplicate a mock
  /// result, and re-visiting the result screen records nothing.
  /// Attempts recorded before durations were stored map with no
  /// duration rather than an invented one.
  ///
  /// This lives here, not in [HistoryRepository.fetchAll], because
  /// Progress and Profile also read that method straight from the
  /// `TypingTests` table — mock rows (0 WPM) must never reach their
  /// typing averages. Backup/export likewise reads the raw table.
  static Future<List<TypingTestRecord>> fetchAllHistory() async {
    final List<TypingTestRecord> typing =
        await HistoryRepository.instance.fetchAll();
    await MockProgressRepository.instance.init();
    return mergeWithMockAttempts(
      typing,
      MockProgressRepository.instance.attempts.toList(),
    );
  }

  /// Pure merge of the two history sources, newest last (sorting is
  /// applied later by [applyFilters]). Unit tested directly.
  static List<TypingTestRecord> mergeWithMockAttempts(
    List<TypingTestRecord> typing,
    List<MockAttempt> attempts,
  ) {
    return [
      ...typing,
      for (final MockAttempt a in attempts)
        TypingTestRecord.fromMockAttempt(a),
    ];
  }

  final Future<List<TypingTestRecord>> Function() _fetchAll;
  final Duration _loadTimeout;
  final DatabaseRecovery _recovery;

  final RxBool isLoading = false.obs;

  /// True when the latest load gave up waiting on the database. The view
  /// shows a Retry button in that case; the stored data is untouched.
  final RxBool loadTimedOut = false.obs;

  /// True when the latest load timed out AND the background database
  /// recovery reported the database still unreachable.
  final RxBool loadFailed = false.obs;

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

  /// Loads the history, bounded: a read that does not answer within
  /// [_loadTimeout] returns an empty list instead of spinning forever
  /// (the old load awaited `fetchAll()` with no timeout at all).
  /// Database recovery runs in the BACKGROUND (at most one per load()
  /// call, shared in-flight with the Dashboard/boot recovery): if it
  /// succeeds it notifies via [DataRefreshService], so the `ever()`
  /// worker in [onInit] re-runs [load] automatically. If recovery
  /// reports the database still unreachable, [loadFailed] is set.
  Future<void> load() async {
    loadTimedOut.value = false;
    loadFailed.value = false;
    isLoading.value = true;
    bool recoveryAttempted = false;
    try {
      bool timedOut = false;
      allTests.value = await _fetchAll().timeout(
        _loadTimeout,
        onTimeout: () {
          timedOut = true;
          loadTimedOut.value = true;
          return <TypingTestRecord>[];
        },
      );
      if (timedOut && !recoveryAttempted) {
        recoveryAttempted = true;
        unawaited(_runBackgroundRecovery());
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// One background recovery run. On success [DatabaseRecovery] already
  /// notified via [DataRefreshService], so the reload happens through
  /// the `ever()` worker. On failure only the flag is set.
  Future<void> _runBackgroundRecovery() async {
    bool recovered = false;
    try {
      recovered = await _recovery.ensureHealthy();
    } catch (_) {
      recovered = false;
    }
    if (!recovered && loadTimedOut.value) {
      loadFailed.value = true;
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
    if (test.isMock) {
      // A mock record is not a database row: remove the attempt from
      // its own store (which also notifies, so the list reloads).
      await MockProgressRepository.instance
          .removeAttempt(test.mockAttemptId!);
      await refresh();
      return;
    }
    await HistoryRepository.instance.deleteTest(test.id);
    await refresh();
  }

  /// Downloads the full backup (tests, mistakes, lesson progress,
  /// daily goal) as a JSON file. Returns a message for the History
  /// screen to show, or null when downloads are unavailable on this
  /// platform (desktop/mobile have no browser download).
  Future<String?> exportHistoryJson() async {
    final HistoryBackup backup =
        await HistoryBackupRepository.instance.collect();
    final String fileName = _backupFileName('json');
    final bool ok = await downloadHistoryFile(
      fileName,
      backup.toJsonString(),
      'application/json',
    );
    if (!ok) return null;
    return 'Downloaded $fileName — ${backup.tests.length} '
        'test${backup.tests.length == 1 ? '' : 's'}, '
        '${backup.lessons.length} lesson record'
        '${backup.lessons.length == 1 ? '' : 's'}.';
  }

  /// Downloads the same tests as a CSV file (one row per test, for a
  /// spreadsheet). Mistakes are a row count here — the full mistake
  /// rows live in the JSON backup.
  Future<String?> exportHistoryCsv() async {
    final HistoryBackup backup =
        await HistoryBackupRepository.instance.collect();
    final String fileName = _backupFileName('csv');
    final bool ok = await downloadHistoryFile(
      fileName,
      buildHistoryCsv(backup.tests),
      'text/csv',
    );
    if (!ok) return null;
    return 'Downloaded $fileName — ${backup.tests.length} '
        'test${backup.tests.length == 1 ? '' : 's'}.';
  }

  /// Restores a JSON backup picked from a file. Returns null when the
  /// user cancels the picker; throws [FormatException] with a plain
  /// message when the file is not a valid backup (the History screen
  /// shows that message).
  Future<HistoryImportResult?> importHistoryBackup() async {
    final String? text = await pickHistoryBackupText();
    if (text == null) return null;
    final HistoryBackup backup = HistoryBackup.parse(text);
    final HistoryImportResult result =
        await HistoryBackupRepository.instance.restore(backup);
    await refresh();
    return result;
  }

  String _backupFileName(String extension) {
    final DateTime now = DateTime.now();
    final String date =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    return 'wolftyping-history-$date.$extension';
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

    // Mock tests are not English or Urdu typing tests, so the
    // language filter passes them through either way — filtering by
    // language must never make a finished mock test disappear.
    if (language == HistoryLanguageFilter.english) {
      list = list.where(
          (t) => t.isMock || t.language == TypingLanguage.english);
    } else if (language == HistoryLanguageFilter.urdu) {
      list = list.where((t) => t.isMock || t.language == TypingLanguage.urdu);
    }

    if (testType == HistoryTestTypeFilter.normal) {
      list = list.where((t) => t.testType == TypingTestKind.normal);
    } else if (testType == HistoryTestTypeFilter.ppsc) {
      list = list.where((t) => t.testType == TypingTestKind.ppsc);
    } else if (testType == HistoryTestTypeFilter.mock) {
      list = list.where((t) => t.testType == TypingTestKind.mock);
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
          (t.mockLabel?.toLowerCase().contains(q) ?? false) ||
          (t.isMock && t.mockScoreLabel.toLowerCase().contains(q)) ||
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
