/// Platform-specific database connection.
///
/// Re-exports [openDatabaseConnection] from the implementation selected by
/// the conditional import below:
///
/// * Desktop/mobile (`dart:io` available): a SQLite file in the
///   application support directory (`database_connection_io.dart`).
/// * Web (`dart:js_interop`): sqlite3 compiled to WebAssembly, running
///   in the main isolate and persisted through IndexedDB
///   (`database_connection_web.dart`, see `web/sqlite3.wasm`). The
///   drift worker path (`WasmDatabase.open` + `drift_worker.js`) is
///   deliberately NOT used: its shared-worker probe hangs on Chrome
///   (see that file).
///
/// Both implementations expose the same Drift tables, so repositories and
/// controllers are unchanged.
library;

export 'database_connection_io.dart'
    if (dart.library.js_interop) 'database_connection_web.dart';
