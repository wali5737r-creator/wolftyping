import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;

import '../../../core/database/app_database.dart';
import '../../typing_test/model/paragraph_difficulty.dart';
import '../../typing_test/model/typing_language.dart';
import '../../typing_test/service/english_paragraph_provider.dart';
import '../../typing_test/service/urdu_paragraph_provider.dart';
import '../model/custom_paragraph.dart';
import '../model/paragraph_category.dart';

/// CRUD for user-created paragraphs (the existing `Paragraphs` Drift
/// table — no duplicate table created) plus read-only access to the
/// static built-in English/Urdu paragraphs, merged into one list for the
/// dashboard.
///
/// Built-in paragraphs are never written to the database (spec section
/// 12 explicitly allows this) — they get a synthetic negative [id] so
/// they're still uniquely identifiable in the UI without colliding with
/// real (positive, autoincrement) row ids.
class ParagraphRepository {
  ParagraphRepository._();
  static final ParagraphRepository instance = ParagraphRepository._();

  AppDatabase get _db => Get.find<AppDatabase>();

  Future<List<CustomParagraph>> fetchAll() async {
    final rows = await _db.select(_db.paragraphs).get();
    final List<CustomParagraph> custom = [
      for (final r in rows)
        CustomParagraph(
          id: r.id,
          title: r.title,
          language: r.language == TypingLanguage.urdu.code
              ? TypingLanguage.urdu
              : TypingLanguage.english,
          category: ParagraphCategory.fromDbValue(r.category),
          difficulty: _difficultyFromDb(r.difficulty),
          text: r.content,
          isCustom: r.isCustom,
          createdAt: r.createdAt,
          updatedAt: r.updatedAt,
        ),
    ];
    return [...custom, ..._builtIns()];
  }

  Future<void> create({
    required String title,
    required TypingLanguage language,
    required ParagraphCategory category,
    required String text,
    ParagraphDifficulty? difficulty,
  }) async {
    await _db.into(_db.paragraphs).insert(
          ParagraphsCompanion(
            title: Value(title.trim()),
            language: Value(language.code),
            category: Value(category.label),
            difficulty: Value(_difficultyToDb(difficulty)),
            content: Value(text.trim()),
            isCustom: const Value(true),
          ),
        );
  }

  /// Updates a custom paragraph. The `isCustom = true` guard in the WHERE
  /// clause means this can never touch a built-in row even if one
  /// somehow existed in the table — belt-and-suspenders alongside the
  /// fact that built-ins are never inserted at all (spec section 12).
  Future<void> update({
    required int id,
    required String title,
    required TypingLanguage language,
    required ParagraphCategory category,
    required String text,
    ParagraphDifficulty? difficulty,
  }) async {
    await (_db.update(_db.paragraphs)
          ..where((t) => t.id.equals(id) & t.isCustom.equals(true)))
        .write(
      ParagraphsCompanion(
        title: Value(title.trim()),
        language: Value(language.code),
        category: Value(category.label),
        difficulty: Value(_difficultyToDb(difficulty)),
        content: Value(text.trim()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> delete(int id) async {
    await (_db.delete(_db.paragraphs)
          ..where((t) => t.id.equals(id) & t.isCustom.equals(true)))
        .go();
  }

  List<CustomParagraph> _builtIns() {
    final List<CustomParagraph> result = [];
    int syntheticId = -1;
    // A fixed, non-meaningful date — never shown for built-ins in the UI
    // (see ParagraphCard), it only exists so CustomParagraph doesn't
    // need a nullable createdAt just for this one case.
    final DateTime placeholderDate = DateTime(2026, 1, 1);

    for (final ParagraphDifficulty d in ParagraphDifficulty.values) {
      for (final p in EnglishParagraphProvider.byDifficulty(d)) {
        result.add(CustomParagraph(
          id: syntheticId--,
          title: p.title,
          language: TypingLanguage.english,
          category: ParagraphCategory.general,
          difficulty: p.difficulty,
          text: p.text,
          isCustom: false,
          createdAt: placeholderDate,
          updatedAt: null,
        ));
      }
      for (final p in UrduParagraphProvider.byDifficulty(d)) {
        result.add(CustomParagraph(
          id: syntheticId--,
          title: p.title,
          language: TypingLanguage.urdu,
          category: ParagraphCategory.general,
          difficulty: p.difficulty,
          text: p.text,
          isCustom: false,
          createdAt: placeholderDate,
          updatedAt: null,
        ));
      }
    }
    return result;
  }

  ParagraphDifficulty? _difficultyFromDb(String? raw) {
    switch (raw) {
      case 'easy':
        return ParagraphDifficulty.easy;
      case 'medium':
        return ParagraphDifficulty.medium;
      case 'hard':
        return ParagraphDifficulty.hard;
      default:
        return null;
    }
  }

  String? _difficultyToDb(ParagraphDifficulty? d) {
    if (d == null) return null;
    switch (d) {
      case ParagraphDifficulty.easy:
        return 'easy';
      case ParagraphDifficulty.medium:
        return 'medium';
      case ParagraphDifficulty.hard:
        return 'hard';
    }
  }
}
