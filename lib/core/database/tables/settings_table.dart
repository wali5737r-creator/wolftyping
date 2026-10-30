import 'package:drift/drift.dart';
import 'users_table.dart';

/// Per-user app settings. Simple ephemeral UI prefs (e.g. last selected
/// sidebar tab) can still use SharedPreferences directly, but anything that
/// affects typing/grading behavior lives here so it's part of the durable,
/// queryable local database.
class Settings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();

  /// 'light' | 'dark' | 'system'
  TextColumn get theme => text().withDefault(const Constant('system'))();

  BoolColumn get showLiveWpm => boolean().withDefault(const Constant(true))();
  BoolColumn get showLiveAccuracy =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get showErrors => boolean().withDefault(const Constant(true))();
  BoolColumn get autoScroll => boolean().withDefault(const Constant(true))();
  BoolColumn get countBackspaces =>
      boolean().withDefault(const Constant(true))();

  /// When true, any incomplete word followed by Space is immediately
  /// counted as a skipped word (see Anti-Skip Logic spec). Kept
  /// configurable in case a softer mode is wanted later, but defaults on
  /// because the spec requires skips to never be silently ignored.
  BoolColumn get strictSkipDetection =>
      boolean().withDefault(const Constant(true))();

  IntColumn get defaultTestDurationSeconds =>
      integer().withDefault(const Constant(60))();

  /// 'en' or 'ur'
  TextColumn get defaultLanguage => text().withDefault(const Constant('en'))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {userId},
      ];
}
