import 'package:drift/drift.dart';

/// Built-in and user-created paragraphs used by Typing Test, Practice and
/// PPSC Urdu sections.
class Paragraphs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();

  /// 'en' or 'ur'
  TextColumn get language => text()();

  /// e.g. General, Education, Technology, Jobs, Office, Programming,
  /// Quotes, PPSC, Pakistan Studies, English Grammar, Urdu General,
  /// Urdu Education.
  TextColumn get category => text().withDefault(const Constant('General'))();

  /// 'easy' | 'medium' | 'hard' — used by Typing Test / PPSC difficulty
  /// filters. Nullable because a user's custom paragraph may not set one.
  TextColumn get difficulty => text().nullable()();

  TextColumn get content => text()();

  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  /// True for paragraphs meant for the PPSC Urdu section specifically.
  BoolColumn get isPpsc => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Set only when a custom paragraph is actually edited after creation
  /// (spec section 6: "Updated date"). Null means never edited. Added in
  /// schemaVersion 3 — see app_database.dart.
  DateTimeColumn get updatedAt => dateTime().nullable()();
}
