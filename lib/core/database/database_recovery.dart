import 'dart:async';

import 'package:get/get.dart';

import '../../features/settings/controller/settings_controller.dart';
import '../services/data_refresh_service.dart';
import 'app_database.dart';

/// Recovery for a hung Drift database open (P0-5).
///
/// Root cause: on web the database opens through
/// `LazyDatabase(() async => ...)` (`lib/core/database/database_connection_web.dart`).
/// The current opener loads `sqlite3.wasm` (748,686 bytes) in the main
/// isolate and opens IndexedDB — it either completes or throws. (The
/// previous opener used drift's worker path, `WasmDatabase.open`, whose
/// shared-worker probe could hang forever on Chrome; see that file.
/// Recovery still matters because a fetch on a very slow connection can
/// legitimately exceed the probe budget, and a hung open must be
/// abandoned after a bounded probe.) Drift 2.35.0's `LazyDatabase`
/// caches that opener future (`_awaitOpened` in
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
/// loop restarts the open three times and gives up. EVERY probe
/// therefore gets the long budget ([firstProbeTimeout], 30s by default)
/// — the current instance AND each fresh replacement, because a fresh
/// WASM open needs just as long as the first one did. [probeTimeout]
/// is kept only as the fallback budget when no long budget is given.
///
/// An abandoned instance is not just dropped: its [close] is kicked off
/// unawaited behind its own short timeout (see [_defaultCloseInstance]),
/// so a stuck opener can never hold the OPFS/IndexedDB handles for
/// 'typing_master' against the replacement. The close is NEVER awaited
/// — drift 2.35.0's `LazyDatabase.close()` awaits the opener future
/// when the delegate is not yet available, so awaiting it would hang
/// this recovery exactly like the query did.
///
/// Concurrent callers share one in-flight recovery: [_inFlight] is
/// static, so the boot-path recovery (`main.dart`), the Dashboard
/// recovery and the History recovery all join the same future instead
/// of each replacing the instance underneath the others. (It used to be
/// an instance field, so two [DatabaseRecovery] instances raced.)
/// A caller that already watched one recovery run fail — the user's
/// Retry button — passes [ensureHealthy] `forceFresh: true` to start a
/// genuinely fresh probe sequence instead of joining the in-flight
/// future that is already doomed.
///
/// This service NEVER deletes, resets, or clears any table or file — no
/// data loss by design. A reset/recovery option may only ever be an
/// explicit user choice, never automatic, and none is added here.
class DatabaseRecovery {
  DatabaseRecovery({
    AppDatabase Function()? databaseFactory,
    Future<void> Function(AppDatabase db)? probe,
    Future<void> Function(AppDatabase db)? closeInstance,
    this.probeTimeout = const Duration(seconds: 8),
    this.firstProbeTimeout = const Duration(seconds: 30),
    this.retryDelays = const <Duration>[
      Duration(milliseconds: 500),
      Duration(seconds: 1),
      Duration(seconds: 2),
    ],
  })  : _databaseFactory = databaseFactory ?? AppDatabase.new,
        _probe = probe ?? _defaultProbe,
        _closeInstance = closeInstance ?? _defaultCloseInstance;

  /// At most this many probe attempts (the current instance plus fresh
  /// replacements) per [ensureHealthy] call — the call always returns,
  /// never loops forever.
  static const int maxAttempts = 3;

  /// Fallback probe budget, used only when no long budget is supplied
  /// to [ensureHealthy]. Kept for callers that probe with a short
  /// budget on purpose (tests).
  final Duration probeTimeout;

  /// Budget for EVERY probe (the currently registered instance AND
  /// each fresh replacement). Long on purpose: a slow-but-progressing
  /// cold open must be allowed to finish instead of being restarted,
  /// and a fresh replacement starts its WASM open from scratch, so it
  /// needs the same long budget as the first probe — a short budget
  /// for replacements could never succeed.
  final Duration firstProbeTimeout;

  /// Delay after failed attempt N is `retryDelays[N - 1]` (clamped to the
  /// last entry). Only the first `maxAttempts - 1` entries are used.
  final List<Duration> retryDelays;

  final AppDatabase Function() _databaseFactory;
  final Future<void> Function(AppDatabase db) _probe;

  /// Terminates an abandoned instance. Never awaited by recovery (see
  /// [_replaceWithFresh]) and never allowed to throw into it.
  final Future<void> Function(AppDatabase db) _closeInstance;

  /// Shared across ALL instances: concurrent callers (boot, Dashboard,
  /// History) join one in-flight recovery instead of racing replacements.
  /// Cleared when the recovery completes (see [ensureHealthy]).
  static Future<bool>? _inFlight;

  static Future<void> _defaultProbe(AppDatabase db) async {
    await db.customSelect('SELECT 1').get();
  }

  /// Bounded close of an abandoned instance: the close runs behind its
  /// own 5s budget and never throws. When the opener is stuck, drift's
  /// `LazyDatabase.close()` waits behind it, so the timeout gives up —
  /// the close stays pending and finishes (releasing the handles) if
  /// the opener ever completes. When the opener already answered, the
  /// close completes promptly and releases the handles at once.
  static Future<void> _defaultCloseInstance(AppDatabase db) async {
    try {
      await db.close().timeout(const Duration(seconds: 5));
    } catch (_) {
      // The opener never answered inside the budget: nothing more can
      // be done from here, and recovery must not fail over it.
    }
  }

  /// Returns true when the currently registered database answers a cheap
  /// probe. On a probe timeout/error the stuck instance is abandoned and
  /// replaced with a fresh one (bounded retries, see [maxAttempts]).
  ///
  /// Concurrent callers share one in-flight recovery instead of each
  /// replacing the instance underneath the other — including callers
  /// holding different [DatabaseRecovery] instances. Pass
  /// `forceFresh: true` (the Retry path) to start a genuinely fresh
  /// probe sequence instead of joining an in-flight run that may
  /// already be doomed; the fresh run becomes the shared in-flight
  /// one, so later callers join it.
  Future<bool> ensureHealthy({
    Duration? probeTimeout,
    Duration? firstProbeTimeout,
    List<Duration>? retryDelays,
    bool forceFresh = false,
  }) {
    // The long budget governs every attempt (see [firstProbeTimeout]):
    // an explicit per-call override wins, then the instance default.
    final Duration budget = firstProbeTimeout ??
        probeTimeout ??
        this.firstProbeTimeout;
    // Start the probe sequence ONLY when this call actually owns it:
    // creating the run eagerly would start probing even for a caller
    // that then joins the shared in-flight run, breaking the
    // exactly-one-sequence guarantee for concurrent callers.
    if (forceFresh) {
      return _track(_ensureHealthy(budget, retryDelays ?? this.retryDelays));
    }
    if (_inFlight != null) return _inFlight!;
    return _track(_ensureHealthy(budget, retryDelays ?? this.retryDelays));
  }

  /// Makes [run] the shared in-flight recovery, clearing the slot only
  /// if it is still the current one when the run completes — a newer
  /// forced-fresh run must never be cleared by an older run finishing.
  Future<bool> _track(Future<bool> run) {
    late final Future<bool> tracked;
    tracked = run.whenComplete(() {
      if (identical(_inFlight, tracked)) _inFlight = null;
    });
    _inFlight = tracked;
    return tracked;
  }

  Future<bool> _ensureHealthy(
    Duration budget,
    List<Duration> delays,
  ) async {
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      final AppDatabase current = _currentOrFresh();
      // Every attempt gets the same long budget: a fresh replacement
      // restarts the WASM open from scratch, so it needs just as long
      // as the first probe.
      if (await _probeHealthy(current, budget)) {
        // Notify on ANY success, not only after a replacement: a probe
        // that succeeds without replacement (a slow open that finally
        // answered) still means controllers waiting on the database
        // must reload — otherwise they sit on the timeout banner
        // while the database is already healthy.
        _notifyRecovered();
        return true;
      }
      if (attempt == maxAttempts) break;
      // Abandon the stuck instance: replace the registration first so
      // the next fetch reaches the fresh instance, then terminate the
      // abandoned one without awaiting it (see [_replaceWithFresh]).
      _replaceWithFresh(current);
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

  void _replaceWithFresh(AppDatabase abandoned) {
    final AppDatabase fresh = _databaseFactory();
    if (Get.isRegistered<AppDatabase>()) {
      Get.delete<AppDatabase>(force: true);
    }
    Get.put<AppDatabase>(fresh);
    // Terminate the abandoned instance WITHOUT awaiting it: drift
    // 2.35.0 `LazyDatabase.close()` awaits the opener future when the
    // delegate is not yet available, so awaiting the close of a hung
    // instance hangs too. The bounded close (see
    // [_defaultCloseInstance]) releases the OPFS/IndexedDB handles if
    // the opener ever completes, and gives up after its own budget.
    // A close failure must never fail the recovery that already
    // succeeded in replacing the instance.
    unawaited(_closeAbandoned(abandoned));
  }

  /// Cross-tab change: another tab wrote to the shared IndexedDB file
  /// and posted on the `DbChangeBroadcast` channel.
  ///
  /// This tab's in-memory snapshot predates that write (each tab
  /// loads its own copy at open and never re-reads), so the current
  /// instance is abandoned for a fresh one — the same replacement
  /// [ensureHealthy] uses, reusing its factory and bounded close —
  /// and controllers reload from the re-opened instance, whose
  /// `_readFiles()` then includes the other tab's rows. No probe:
  /// the database is not suspected of being hung, only stale, and a
  /// probe would delay the reload by its whole budget.
  ///
  /// A no-op when no database is registered yet (e.g. a message
  /// arriving before boot finished registering it).
  void handleExternalChange() {
    if (!Get.isRegistered<AppDatabase>()) return;
    final AppDatabase current = Get.find<AppDatabase>();
    _replaceWithFresh(current);
    _notifyRecovered();
  }

  Future<void> _closeAbandoned(AppDatabase abandoned) async {
    try {
      await _closeInstance(abandoned);
    } catch (_) {
      // The abandoned instance is already unreachable; nothing more
      // can be done, and recovery must not fail over it.
    }
  }

  /// After a successful probe — with or without a replacement — reload
  /// settings (which were probably stuck on the old instance too) and
  /// tell Dashboard/Progress/History to reload from the healthy
  /// database. Fire-and-forget and guarded: recovery has already
  /// succeeded, and a settings reload must never fail it.
  /// [DataRefreshService.notifyChanged] is a no-op when the service
  /// is not registered (e.g. the boot-path recovery before the app
  /// has mounted), so this is safe to call unconditionally.
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
