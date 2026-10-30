import 'package:drift/drift.dart';

/// Local user profile. Single-user app for v1 (no login), but modeled as a
/// table so multi-profile support is possible later without a migration
/// rewrite.
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withDefault(const Constant('Typist'))();
  TextColumn get profileImage => text().nullable()();

  /// 'en' or 'ur'
  TextColumn get preferredLanguage => text().withDefault(const Constant('en'))();

  /// Daily goal in seconds (e.g. 600 = 10 minutes).
  IntColumn get dailyGoalSeconds => integer().withDefault(const Constant(600))();

  /// Default duration for a new typing test, in seconds.
  IntColumn get preferredTestDurationSeconds =>
      integer().withDefault(const Constant(60))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
