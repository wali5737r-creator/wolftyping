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
/// slow connection takes minutes, inside the open — and drift 2.35.0's
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
/// This service NEVER deletes, resets, or clears any table or file — no
/// data loss by design. A reset/recovery option may only ever be an
/// explicit user choice, never automatic, and none is added here.
class DatabaseRecovery {
  DatabaseRecovery({
    AppDatabase Function()? databaseFactory,
    Future<void> Function(AppDatabase db)? probe,
    this.probeTimeout = const Duration(seconds: 8),
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

  /// Delay after failed attempt N is `retryDelays[N - 1]` (clamped to the
  /// last entry). Only the first `maxAttempts - 1` entries are used.
  final List<Duration> retryDelays;

  final AppDatabase Function() _databaseFactory;
  final Future<void> Function(AppDatabase db) _probe;

  Future<bool>? _inFlight;

  static Future<void> _defaultProbe(AppDatabase db) async {
    await db.customSelect('SELECT 1').get();
  }

  /// Returns true when the currently registered database answers a cheap
  /// probe. On a probe timeout/error the stuck instance is abandoned and
  /// replaced with a fresh one (bounded retries, see [maxAttempts]).
  ///
  /// Concurrent callers share one in-flight recovery instead of each
  /// replacing the instance underneath the other.
  Future<bool> ensureHealthy({
    Duration? probeTimeout,
    List<Duration>? retryDelays,
  }) {
    _inFlight ??= _ensureHealthy(
      probeTimeout ?? this.probeTimeout,
      retryDelays ?? this.retryDelays,
    ).whenComplete(() => _inFlight = null);
    return _inFlight!;
  }

  Future<bool> _ensureHealthy(
    Duration timeout,
    List<Duration> delays,
  ) async {
    bool replaced = false;
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      final AppDatabase current = _currentOrFresh();
      if (await _probeHealthy(current, timeout)) {
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
