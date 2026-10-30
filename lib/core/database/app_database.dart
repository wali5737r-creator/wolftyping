import 'package:drift/drift.dart';

import 'database_connection.dart';
import 'tables/users_table.dart';
import 'tables/typing_tests_table.dart';
import 'tables/paragraphs_table.dart';
import 'tables/lessons_table.dart';
import 'tables/lesson_progress_table.dart';
import 'tables/mistakes_table.dart';
import 'tables/daily_progress_table.dart';
import 'tables/streaks_table.dart';
import 'tables/settings_table.dart';

part 'app_database.g.dart';

/// The single local SQLite database for WolfTyping.
///
/// Everything the app needs offline lives here: profile, test history,
/// lessons + progress, paragraphs (built-in and custom), mistakes, daily
/// goal progress, streaks and settings.
///
/// Run code generation after editing any table:
///   dart run build_runner build --delete-conflicting-outputs
@DriftDatabase(
  tables: [
    Users,
    TypingTests,
    Paragraphs,
    Lessons,
    LessonProgress,
    Mistakes,
    DailyProgress,
    Streaks,
    Settings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openDatabaseConnection());

  /// Bump this whenever a table shape changes and add a migration step
  /// below. Never skip a version — Drift replays them in order.
  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            // Adds Mistakes.isWrongWord (Practice + Mistake Analysis
            // feature). Purely additive — every existing row gets the
            // column's default (false); no data is touched or lost.
            await m.addColumn(mistakes, mistakes.isWrongWord);
          }
          if (from < 3) {
            // Adds Paragraphs.updatedAt (My Paragraphs feature). Nullable
            // and additive — existing paragraphs simply get null (never
            // edited), no data lost.
            await m.addColumn(paragraphs, paragraphs.updatedAt);
          }
          if (from < 4) {
            // Removes Settings.soundEnabled (sound feature removed).
            // alterTable rebuilds the settings table without that column
            // and copies every remaining column's value across, so all
            // other saved settings are preserved. No other table touched.
            await m.alterTable(TableMigration(settings));
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

/// The database connection is platform-specific and lives in
/// `database_connection.dart` (conditional import): a SQLite file on
/// desktop, sqlite3/WASM with OPFS/IndexedDB persistence on web.
