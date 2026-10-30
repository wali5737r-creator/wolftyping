/// Platform-specific database connection.
///
/// Re-exports [openDatabaseConnection] from the implementation selected by
/// the conditional import below:
///
/// * Desktop/mobile (`dart:io` available): a SQLite file in the
///   application support directory (`database_connection_io.dart`).
/// * Web (`dart:js_interop`): sqlite3 compiled to WebAssembly, persisted
///   through OPFS/IndexedDB (`database_connection_web.dart`, see
///   `web/sqlite3.wasm` and `web/drift_worker.js`).
///
/// Both implementations expose the same Drift tables, so repositories and
/// controllers are unchanged.
library;

export 'database_connection_io.dart'
    if (dart.library.js_interop) 'database_connection_web.dart';
