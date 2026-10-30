import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Desktop/mobile connection: `typing_master.sqlite` inside the OS
/// application support directory, e.g. on Windows:
/// `C:\Users\<user>\AppData\Roaming\typing_master\typing_master.sqlite`
///
/// Unchanged from the original Windows implementation — this file is only
/// compiled on platforms with `dart:io`.
QueryExecutor openDatabaseConnection() {
  return LazyDatabase(() async {
    final Directory dbFolder = await getApplicationSupportDirectory();
    final File file = File(p.join(dbFolder.path, 'typing_master.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
