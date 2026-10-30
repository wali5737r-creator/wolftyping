import 'package:drift/drift.dart';

/// Built-in structured lesson content (Home Row, Top Row, Urdu basics, etc).
class Lessons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();

  /// 'en' or 'ur'
  TextColumn get language => text()();

  /// 'beginner' | 'intermediate' | 'advanced'
  TextColumn get level => text()();

  /// Determines lesson order and unlock sequence within a language+level.
  IntColumn get orderIndex => integer()();

  /// The exercise text(s) for this lesson. Stored as plain text; multiple
  /// drills can be newline-separated and parsed by LessonController.
  TextColumn get content => text()();

  RealColumn get requiredAccuracy => real().withDefault(const Constant(90))();
  IntColumn get requiredWpm => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
