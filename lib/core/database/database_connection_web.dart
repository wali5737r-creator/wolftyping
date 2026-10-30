import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Web connection: sqlite3 compiled to WebAssembly.
///
/// `WasmDatabase.open` probes the browser and picks the most reliable
/// storage it supports (OPFS first, then IndexedDB), so history, lessons,
/// paragraphs and settings persist across reloads in modern browsers. In
/// browsers without OPFS/IndexedDB support drift falls back to an
/// in-memory database for the session (see WEB_NOTES.md).
///
/// Requires the two files shipped in `web/`:
///   * `sqlite3.wasm` — the sqlite3 build for drift 2.35.0
///     (from https://github.com/simolus3/drift/releases)
///   * `drift_worker.js` — drift's pre-compiled web worker for the same
///     release.
///
/// Both URIs are relative to the page the app is served from, so the app
/// must be served from the root of `build/web` (or with matching
/// `--base-href` handling). No repository or controller code changes are
/// needed: the returned executor exposes the same Drift tables as the
/// desktop file database.
QueryExecutor openDatabaseConnection() {
  return LazyDatabase(() async {
    final WasmDatabaseResult result = await WasmDatabase.open(
      databaseName: 'typing_master',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    return result.resolvedExecutor;
  });
}
