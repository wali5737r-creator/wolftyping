import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:sqlite3/wasm.dart';

/// Web connection: sqlite3 compiled to WebAssembly, running in the main
/// isolate and persisted through IndexedDB.
///
/// This deliberately does NOT use `WasmDatabase.open` (the worker path).
/// Why — verified in drift 2.35.0's own source
/// (`lib/src/web/wasm_setup.dart`): `WasmDatabase.open` first probes a
/// *shared* worker (`new SharedWorker('drift_worker.js', 'drift worker')`)
/// and awaits its compatibility reply with no timeout. Inside the shared
/// worker, feature detection spawns a nested dedicated worker — which
/// drift's own docs (`lib/src/web/wasm_setup/types.dart`, citing
/// crbug.com/1088481) say Chrome and Safari don't support. When the
/// nested worker neither answers nor errors, the probe never returns,
/// the dedicated-worker probe never starts, and `WasmDatabase.open`
/// never completes — in a real browser profile the database open hung
/// for minutes, and the Dashboard/History fallbacks were the only
/// thing working. Retries cannot escape it: a SharedWorker is a
/// singleton per origin+URL+name, so every fresh `AppDatabase` instance
/// reconnects to the same stuck worker, and nothing in the app can
/// terminate it from the page.
///
/// The replacement below opens the database in the main isolate with
/// the exact storage drift's worker path uses for IndexedDB
/// (`IndexedDbFileSystem`, database name `typing_master`, file
/// `/database` — see drift's `lib/src/web/wasm_setup/shared.dart`,
/// `openConnection`): the same IndexedDB database, the same
/// `files`/`blocks` stores, the same format — existing typing history,
/// settings and lesson data are read as-is, nothing is migrated,
/// deleted or re-created. Drift's `_WasmDelegate` flushes the file
/// system after writes (same as the worker path, which also passes
/// `writeAutomatically: false`), so durability is unchanged.
/// `drift_worker.js` is no longer fetched at all; it stays in `web/`
/// only as a spare in case the worker path is ever needed again.
///
/// The open is still bounded by the callers' timeouts
/// (`DatabaseRecovery` probes `SELECT 1`): fetching `sqlite3.wasm`
/// (748,686 bytes) can be slow on a bad connection, but it either
/// completes or throws — it cannot deadlock behind a worker probe.
/// Only `sqlite3.wasm` must be shipped in `web/`.
///
/// Queries run on the main isolate (no worker), so a query briefly
/// blocks the UI thread. The app's queries are small history/settings
/// reads and single-row writes, which is fine; the worker's
/// parallelism was never load-bearing here.
QueryExecutor openDatabaseConnection() {
  return LazyDatabase(() async {
    final WasmSqlite3 sqlite3 =
        await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
    final IndexedDbFileSystem fileSystem =
        await IndexedDbFileSystem.open(
      dbName: 'typing_master',
      // Drift's delegate flushes after writes (same as the worker
      // path); don't also flush asynchronously behind it.
      writeAutomatically: false,
    );
    sqlite3.registerVirtualFileSystem(fileSystem, makeDefault: true);
    return WasmDatabase(
      sqlite3: sqlite3,
      path: '/database',
      fileSystem: fileSystem,
    );
  });
}
