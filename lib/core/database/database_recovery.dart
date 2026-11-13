import 'dart:async';

import 'package:get/get.dart';

import '../../features/settings/controller/settings_controller.dart';
import '../services/data_refresh_service.dart';
import 'app_database.dart';

/// Recovery for a hung Drift database open (P0-5).
///
/// Root cause: on web the database opens through
/// `LazyDatabase(() async => WasmDatabase.open(...))`
/// (`lib/core/database/database_connection_web.dart`). Fetching
/// `sqlite3.wasm` (748,686 bytes) + `drift_worker.js` (357,220 bytes) on a
/// slow connection takes a long time, inside the open — and drift 2.35.0's
/// `LazyDatabase` caches that opener future (`_awaitOpened` in
/// `lib/src/utils/lazy_database.dart`): every later query awaits the same
/// stuck future forever, so there is no retry today.
///
/// Recovery therefore abandons the stuck [AppDatabase] instance and
/// replaces the Get registration with a fresh one (new `LazyDatabase`, new
/// opener future). That works because every repository resolves the
/// database lazily at call time (`AppDatabase get _db =>
/// Get.find<AppDatabase>();`), so the next fetch reaches the new instance.
///
/// Two cases must not be confused. A permanently hung open never
/// answers, so it must be abandoned after a bounded probe. A merely
/// *slow* open — a fresh profile on a cold CDN / slow connection, where
/// the WASM fetch and compile legitimately take well over 8 seconds —
/// answers if it is given time. Abandoning that instance restarts the
/// open from scratch, so a short probe budget can never succeed: the
/// loop restarts the open three times and gives up. The first probe
/// therefore gets a long budget ([firstProbeTimeout], 30s by default);
/// only fresh replacements (attempts 2–3) use the short [probeTimeout].
/// An instance is replaced only on a probe error or after its budget
/// expires — never while it is still within its first-probe budget.
///
/// Concurrent callers share one in-flight recovery: [_inFlight] is
/// static, so the boot-path recovery (`main.dart`), the Dashboard
/// recovery and the History recovery all join the same future instead
/// of each replacing the instance underneath the others. (It used to be
/// an instance field, so two [DatabaseRecovery] instances raced.)
///
/// This service NEVER deletes, resets, or clears any table or file — no
/// data loss by design. A reset/recovery option may only ever be an
/// explicit user choice, never automatic, and none is added here.
class DatabaseRecovery {
  DatabaseRecovery({
    AppDatabase Function()? databaseFactory,
    Future<void> Function(AppDatabase db)? probe,
    this.probeTimeout = const Duration(seconds: 8),
    this.firstProbeTimeout = const Duration(seconds: 30),
    this.retryDelays = const <Duration>[
      Duration(milliseconds: 500),
      Duration(seconds: 1),
      Duration(seconds: 2),
    ],
  })  : _databaseFactory = databaseFactory ?? AppDatabase.new,
        _probe = probe ?? _defaultProbe;

  /// At most this many probe attempts (the current instance plus fresh
  /// replacements) per [ensureHealthy] call — the call always returns,
  /// never loops forever.
  static const int maxAttempts = 3;

  final Duration probeTimeout;

  /// Budget for the FIRST probe (the currently registered instance).
  /// Long on purpose: a slow-but-progressing cold open must be allowed
  /// to finish instead of being restarted. Attempts 2–3 probe fresh
  /// replacements with the short [probeTimeout].
  final Duration firstProbeTimeout;

  /// Delay after failed attempt N is `retryDelays[N - 1]` (clamped to the
  /// last entry). Only the first `maxAttempts - 1` entries are used.
  final List<Duration> retryDelays;

  final AppDatabase Function() _databaseFactory;
  final Future<void> Function(AppDatabase db) _probe;

  /// Shared across ALL instances: concurrent callers (boot, Dashboard,
  /// History) join one in-flight recovery instead of racing replacements.
  /// Cleared when the recovery completes (see [ensureHealthy]).
  static Future<bool>? _inFlight;

  static Future<void> _defaultProbe(AppDatabase db) async {
    await db.customSelect('SELECT 1').get();
  }

  /// Returns true when the currently registered database answers a cheap
  /// probe. On a probe timeout/error the stuck instance is abandoned and
  /// replaced with a fresh one (bounded retries, see [maxAttempts]).
  ///
  /// Concurrent callers share one in-flight recovery instead of each
  /// replacing the instance underneath the other — including callers
  /// holding different [DatabaseRecovery] instances.
  Future<bool> ensureHealthy({
    Duration? probeTimeout,
    Duration? firstProbeTimeout,
    List<Duration>? retryDelays,
  }) {
    _inFlight ??= _ensureHealthy(
      probeTimeout ?? this.probeTimeout,
      firstProbeTimeout ?? this.firstProbeTimeout,
      retryDelays ?? this.retryDelays,
    ).whenComplete(() => _inFlight = null);
    return _inFlight!;
  }

  Future<bool> _ensureHealthy(
    Duration timeout,
    Duration firstTimeout,
    List<Duration> delays,
  ) async {
    bool replaced = false;
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      final AppDatabase current = _currentOrFresh();
      // Attempt 1 probes the current instance with the long budget: a
      // slow cold open can complete inside it. Attempts 2–3 probe fresh
      // replacements with the short budget.
      final Duration budget = attempt == 1 ? firstTimeout : timeout;
      if (await _probeHealthy(current, budget)) {
        if (replaced) _notifyRecovered();
        return true;
      }
      if (attempt == maxAttempts) break;
      // Abandon the stuck instance — DO NOT await its close().
      //
      // drift 2.35.0 `LazyDatabase.close()` awaits the opener future
      // when the delegate is not yet available
      // (`else if (_openDelegate case final completer?) {
      //    await completer.future; ... }` in
      // `lib/src/utils/lazy_database.dart`), so closing a hung instance
      // hangs too. The abandoned instance is simply dropped: its opener
      // future, if it ever completes, touches nothing any repository
      // still resolves (they all re-resolve via Get at call time).
      _replaceWithFresh();
      replaced = true;
      final Duration delay =
          delays[(attempt - 1).clamp(0, delays.length - 1)];
      await Future<void>.delayed(delay);
    }
    return false;
  }

  Future<bool> _probeHealthy(AppDatabase db, Duration timeout) async {
    try {
      await _probe(db).timeout(timeout);
      return true;
    } catch (_) {
      return false;
    }
  }

  AppDatabase _currentOrFresh() {
    if (Get.isRegistered<AppDatabase>()) {
      return Get.find<AppDatabase>();
    }
    final AppDatabase fresh = _databaseFactory();
    Get.put<AppDatabase>(fresh);
    return fresh;
  }

  void _replaceWithFresh() {
    final AppDatabase fresh = _databaseFactory();
    if (Get.isRegistered<AppDatabase>()) {
      Get.delete<AppDatabase>(force: true);
    }
    Get.put<AppDatabase>(fresh);
  }

  /// After a successful replacement, reload settings (which were probably
  /// stuck on the old instance too) and tell Dashboard/Progress to reload
  /// from the healthy database. Fire-and-forget and guarded: recovery has
  /// already succeeded, and a settings reload must never fail it.
  void _notifyRecovered() {
    if (Get.isRegistered<SettingsController>()) {
      unawaited(_reloadSettings());
    }
    DataRefreshService.notifyChanged();
  }

  Future<void> _reloadSettings() async {
    try {
      await Get.find<SettingsController>().load();
    } catch (_) {
      // Settings fall back to built-in defaults; nothing more to do here.
    }
  }
}
