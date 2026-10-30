import 'package:drift/drift.dart';
import 'users_table.dart';
import 'lessons_table.dart';

/// Tracks per-user completion and best results for each lesson, and drives
/// the lesson unlock system (a lesson at orderIndex N unlocks once N-1 is
/// completed).
class LessonProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get lessonId => integer().references(Lessons, #id)();

  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  RealColumn get bestAccuracy => real().withDefault(const Constant(0))();
  RealColumn get bestSpeed => real().withDefault(const Constant(0))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();

  DateTimeColumn get lastAttemptAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {userId, lessonId},
      ];
}
