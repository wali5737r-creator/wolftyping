import 'db_change_broadcast_stub.dart'
    if (dart.library.js_interop) 'db_change_broadcast_web.dart'
    as platform;

/// Cross-tab "the local database changed" signal (web only).
///
/// Why this exists: on web each tab holds its own private in-memory
/// snapshot of the SQLite file, loaded once at database open
/// (`IndexedDbFileSystem._readFiles()` copies everything into `_memory`;
/// `xRead` never touches IndexedDB again). There is no storage event
/// and no focus re-read anywhere in the app, so a tab opened before a
/// test finishes can never see that test's row without a reload or a
/// database re-open — the Dashboard showed "No completed tests yet"
/// and hid its stat cards even though the row was saved, because
/// `HomeController` read the same stale snapshot. The save itself
/// works and is flushed (drift 2.35.0's `_WasmDelegate` awaits a
/// flush after every non-transaction write).
///
/// So after every Drift write, repositories call [notify], which posts
/// on a `BroadcastChannel`. Every other tab of this origin listens
/// (registered in `main.dart`) and, on a message, abandons its stale
/// database instance for a fresh one — whose `_readFiles()` then
/// includes the new row — and reloads its controllers. A tab never
/// receives its own post (per the BroadcastChannel spec), so the tab
/// that saved does not needlessly re-open its database.
///
/// On non-web platforms this is a no-op: desktop/mobile use a real
/// SQLite file that every read sees, so there is no stale snapshot.
class DbChangeBroadcast {
  /// The channel every tab of this origin shares. Kept in one place
  /// so the sender, the listener and the live-bundle check all agree.
  static const String channelName = 'wolftyping-db-changed';

  /// Test seam: when set, [notify] calls this instead of the platform
  /// channel, so tests can observe the broadcast without a browser
  /// (BroadcastChannel is web-only). Null in production — never set
  /// it outside a test.
  static void Function()? testNotifyOverride;

  /// Post "the database changed" to every other tab. Fire-and-forget:
  /// a posting failure must never fail the save/delete that just
  /// succeeded — the writing tab's own data is already correct.
  static void notify() {
    final void Function()? override = testNotifyOverride;
    if (override != null) {
      override();
      return;
    }
    platform.postDbChanged(channelName);
  }

  /// Listen for other tabs' changes. The callback runs once per
  /// message; it is the listener's job to re-open the database and
  /// reload (see `DatabaseRecovery.handleExternalChange`).
  static void listen(void Function() onDbChanged) {
    platform.listenDbChanged(channelName, onDbChanged);
  }
}
