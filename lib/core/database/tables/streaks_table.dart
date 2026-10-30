import 'package:drift/drift.dart';
import 'users_table.dart';

class Streaks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();

  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastPracticeDate => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {userId},
      ];
}
