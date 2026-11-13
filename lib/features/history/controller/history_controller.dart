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
///
/// The two history sources load INDEPENDENTLY (see [load]): the Drift
/// typing history under its own timeout, and the mock attempts with no
/// timeout (their store is already cached and cannot hang). A Drift
/// timeout/throw degrades to "typing history unavailable, mock attempts
/// shown" with an honest partial-data note — never to an empty list
/// that hides data the app already has. The same independence applies
/// in reverse: a mock read failing never hides the typing rows.
/// [retryLoad] re-runs only the part that failed.
class HistoryController extends GetxController {
  /// How long the history read may take before the screen gives up
  /// waiting and shows the empty state instead of spinning forever (the
  /// database open can hang on a reload). Tests inject a shorter value.
  /// Applies to the Drift typing read only — the mock read has no
  /// timeout (see [load]).
  static const Duration kLoadTimeout = Duration(seconds: 8);

  HistoryController({
    Future<List<TypingTestRecord>> Function()? fetchAll,
    Future<List<TypingTestRecord>> Function()? fetchTyping,
    Future<List<MockAttempt>> Function()? fetchMockAttempts,
    Duration loadTimeout = kLoadTimeout,
    DatabaseRecovery? databaseRecovery,
  })  : _fetchTyping = fetchTyping ?? fetchAll ?? fetchAllTyping,
        _fetchMockAttempts = fetchMockAttempts ??
            (fetchAll != null
                // Legacy combined fetch: the injected fetch already
                // represents the whole history, so the mock side is
                // not re-read separately.
                ? _noMockAttempts
                : _defaultFetchMockAttempts),
        _loadTimeout = loadTimeout,
        _recovery = databaseRecovery ?? DatabaseRecovery();

  /// Default Drift source: completed typing tests from the database.
  /// Kept separate from the mock source so a hung Drift read can never
  /// discard the mock rows already in memory.
  static Future<List<TypingTestRecord>> fetchAllTyping() =>
      HistoryRepository.instance.fetchAll();

  /// Default mock source: completed mock MCQ attempts from
  /// `MockProgressRepository`. No timeout is applied to this read:
  /// `init()` is already cached after the first call and reads
  /// SharedPreferences, which never hangs the way a Drift/WASM open
  /// can — bounding it would only invent failures.
  static Future<List<MockAttempt>> _defaultFetchMockAttempts() async {
    await MockProgressRepository.instance.init();
    return MockProgressRepository.instance.attempts.toList();
  }

  static Future<List<MockAttempt>> _noMockAttempts() async =>
      <MockAttempt>[];

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
  ///
  /// Kept for callers that want the combined list in one await; the
  /// controller's own [load] does NOT use it — it reads the two
  /// sources independently so one hanging source cannot discard the
  /// other (see [load]).
  static Future<List<TypingTestRecord>> fetchAllHistory() async {
    final List<TypingTestRecord> typing = await fetchAllTyping();
    final List<MockAttempt> attempts = await _defaultFetchMockAttempts();
    return mergeWithMockAttempts(typing, attempts);
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

  final Future<List<TypingTestRecord>> Function() _fetchTyping;
  final Future<List<MockAttempt>> Function() _fetchMockAttempts;
  final Duration _loadTimeout;
  final DatabaseRecovery _recovery;

  final RxBool isLoading = false.obs;

  /// True when the latest load gave up waiting on (or failed to read)
  /// any history source. The view shows a Retry button in that case;
  /// the stored data is untouched.
  final RxBool loadTimedOut = false.obs;

  /// True when the latest load timed out AND the background database
  /// recovery reported the database still unreachable. Distinct from
  /// [loadTimedOut]: a plain timeout only means the load gave up
  /// waiting — recovery is still running in the background, and if it
  /// succeeds the screen reloads on its own (see [load]). The view
  /// reads this to tell "still recovering" from "recovery failed".
  final RxBool loadFailed = false.obs;

  /// True when the Drift typing history could not be read in the
  /// latest load (timeout or throw) — the mock attempts, if any, are
  /// still shown, with [partialDataNote] explaining the gap.
  final RxBool typingUnavailable = false.obs;

  /// True when the mock attempts could not be read in the latest
  /// load — the typing history, if any, is still shown.
  final RxBool mockUnavailable = false.obs;

  /// True when part of the history is shown while another part could
  /// not be read. The view shows [partialDataNote] plus a Retry for
  /// the failed part only, instead of pretending the list is complete.
  bool get hasPartialData =>
      (typingUnavailable.value || mockUnavailable.value) &&
      allTests.isNotEmpty;

  /// Honest one-line note for a partial load: names the missing part,
  /// what IS shown instead, and whether recovery is still running or
  /// has already failed, so the user can tell the two states apart.
  /// Empty when nothing is missing.
  String get partialDataNote {
    final String missing = typingUnavailable.value && mockUnavailable.value
        ? 'Typing history and mock attempts'
        : typingUnavailable.value
            ? 'Typing history'
            : mockUnavailable.value
                ? 'Mock attempts'
                : '';
    if (missing.isEmpty) return '';
    final String shown = typingUnavailable.value && mockUnavailable.value
        ? 'nothing'
        : typingUnavailable.value
            ? 'your mock attempts'
            : 'your typing history';
    final String recovery = loadFailed.value
        ? 'Recovery did not succeed — tap Retry to try again.'
        : 'Still recovering in the background — tap Retry to try again, '
            'or wait and this page will reload on its own.';
    return '$missing could not be loaded. Your data is safe — '
        'showing $shown instead. $recovery';
  }

  final RxList<TypingTestRecord> allTests = <TypingTestRecord>[].obs;

  /// The two sources, kept apart so a failed part can be retried on
  /// its own while the good part's rows stay on screen.
  List<TypingTestRecord> _typingTests = <TypingTestRecord>[];
  List<TypingTestRecord> _mockTests = <TypingTestRecord>[];

  /// Whether each part failed in the latest load — drives
  /// [retryLoad], which re-runs only the failed part(s).
  bool _typingFailed = false;
  bool _mockFailed = false;

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

  /// Loads the history, bounded and decoupled: the Drift typing read
  /// and the mock read run concurrently and independently. A Drift
  /// read that does not answer within [_loadTimeout] — or throws —
  /// marks only the typing part unavailable and kicks off background
  /// recovery; the mock rows already in memory are still shown, with
  /// [partialDataNote] saying what is missing. A mock read that
  /// throws marks only the mock part unavailable; the typing rows are
  /// still shown. Neither failure ever produces an empty list that
  /// hides data the app already has.
  ///
  /// Database recovery runs in the BACKGROUND (at most one per load()
  /// call, shared in-flight with the Dashboard/boot recovery): if it
  /// succeeds it notifies via [DataRefreshService], so the `ever()`
  /// worker in [onInit] re-runs [load] automatically. If recovery
  /// reports the database still unreachable, [loadFailed] is set.
  ///
  /// With [onlyFailed] (used by [retryLoad]) only the part(s) that
  /// failed in the latest load are re-read; the good part's rows stay
  /// exactly as they are.
  Future<void> load({bool onlyFailed = false}) async {
    loadTimedOut.value = false;
    loadFailed.value = false;
    isLoading.value = true;
    // At most one background recovery per load() call, however many
    // parts fail inside it.
    bool recoveryAttempted = false;

    void kickOffBackgroundRecovery() {
      if (recoveryAttempted) return;
      recoveryAttempted = true;
      unawaited(_runBackgroundRecovery());
    }

    if (!onlyFailed) {
      _typingTests = <TypingTestRecord>[];
      _mockTests = <TypingTestRecord>[];
      _typingFailed = false;
      _mockFailed = false;
      typingUnavailable.value = false;
      mockUnavailable.value = false;
    }
    try {
      await Future.wait(<Future<void>>[
        _loadTypingPart(
          onlyFailed: onlyFailed,
          kickOffBackgroundRecovery: kickOffBackgroundRecovery,
        ),
        _loadMockPart(onlyFailed: onlyFailed),
      ]);
      _publish();
    } finally {
      isLoading.value = false;
    }
  }

  /// One half of [load]: the Drift typing history, bounded by
  /// [_loadTimeout]. A timeout OR a throw marks the part unavailable
  /// (both show the same banner + Retry: a throw used to fall through
  /// to a plain "No completed tests yet" with no Retry at all, which
  /// hid a read failure as an empty history). The good part is never
  /// touched here.
  Future<void> _loadTypingPart({
    required bool onlyFailed,
    required void Function() kickOffBackgroundRecovery,
  }) async {
    if (onlyFailed && !_typingFailed) return;
    try {
      _typingTests = await _fetchTyping().timeout(_loadTimeout);
      _typingFailed = false;
      typingUnavailable.value = false;
    } on TimeoutException {
      _typingTests = <TypingTestRecord>[];
      _typingFailed = true;
      typingUnavailable.value = true;
      loadTimedOut.value = true;
      kickOffBackgroundRecovery();
    } catch (_) {
      _typingTests = <TypingTestRecord>[];
      _typingFailed = true;
      typingUnavailable.value = true;
      loadTimedOut.value = true;
      kickOffBackgroundRecovery();
    }
  }

  /// The other half of [load]: the mock attempts. No timeout — the
  /// store is already cached and cannot hang — but a throw still marks
  /// only this part unavailable instead of failing the whole load.
  Future<void> _loadMockPart({required bool onlyFailed}) async {
    if (onlyFailed && !_mockFailed) return;
    try {
      final List<MockAttempt> attempts = await _fetchMockAttempts();
      _mockTests = [
        for (final MockAttempt a in attempts)
          TypingTestRecord.fromMockAttempt(a),
      ];
      _mockFailed = false;
      mockUnavailable.value = false;
    } catch (_) {
      _mockTests = <TypingTestRecord>[];
      _mockFailed = true;
      mockUnavailable.value = true;
      loadTimedOut.value = true;
    }
  }

  void _publish() {
    allTests.value = <TypingTestRecord>[..._typingTests, ..._mockTests];
  }

  /// One background recovery run. On success [DatabaseRecovery] already
  /// notified via [DataRefreshService], so the reload happens through
  /// the `ever()` worker. On failure only the flag is set.
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

  /// Re-runs [load] from the timeout/partial state (the "Retry loading
  /// history" button) — but only the part(s) that failed: the good
  /// part is not re-read. Resets the flags first so a recovered load
  /// clears the timeout notice. A failed typing part also starts a
  /// genuinely fresh background recovery (not a join of the stale
  /// in-flight one) so the retry has a real chance to succeed.
  Future<void> retryLoad() async {
    loadTimedOut.value = false;
    loadFailed.value = false;
    if (!_typingFailed && !_mockFailed) {
      await load();
      return;
    }
    if (_typingFailed) {
      unawaited(_runBackgroundRecovery(forceFresh: true));
    }
    await load(onlyFailed: true);
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
