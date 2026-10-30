import 'package:drift/drift.dart';
import 'users_table.dart';

/// One row per calendar day per user. Used to compute "Today's Goal"
/// progress and to determine whether a day counts toward the streak
/// (meaningful practice, not just opening the app).
class DailyProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();

  /// Stored as a date-only DateTime (time truncated to midnight).
  DateTimeColumn get date => dateTime()();

  IntColumn get practiceSeconds => integer().withDefault(const Constant(0))();
  IntColumn get testsCompleted => integer().withDefault(const Constant(0))();
  IntColumn get goalSeconds => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {userId, date},
      ];
}
