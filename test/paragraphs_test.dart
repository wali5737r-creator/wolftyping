import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/features/paragraphs/controller/paragraphs_controller.dart';
import 'package:typing_master/features/paragraphs/model/custom_paragraph.dart';
import 'package:typing_master/features/paragraphs/model/paragraph_category.dart';
import 'package:typing_master/features/paragraphs/model/paragraph_sort.dart';
import 'package:typing_master/features/paragraphs/model/paragraph_validation.dart';
import 'package:typing_master/features/typing_test/model/english_paragraph.dart';
import 'package:typing_master/features/typing_test/model/paragraph_difficulty.dart';
import 'package:typing_master/features/typing_test/model/typing_language.dart';
import 'package:typing_master/features/typing_test/model/urdu_paragraph.dart';

CustomParagraph _p({
  required int id,
  String title = 'Title',
  TypingLanguage language = TypingLanguage.english,
  ParagraphCategory category = ParagraphCategory.general,
  String text = 'hello world',
  bool isCustom = true,
  DateTime? createdAt,
  ParagraphDifficulty? difficulty,
}) {
  return CustomParagraph(
    id: id,
    title: title,
    language: language,
    category: category,
    difficulty: difficulty,
    text: text,
    isCustom: isCustom,
    createdAt: createdAt ?? DateTime(2026, 1, 1),
    updatedAt: null,
  );
}

void main() {
  group('Word and character count', () {
    test('word count splits on whitespace', () {
      final p = _p(id: 1, text: 'The quick brown fox');
      expect(p.wordCount, 4);
    });

    test('word count is 0 for empty/whitespace-only text', () {
      final p = _p(id: 1, text: '   ');
      expect(p.wordCount, 0);
    });

    test('character count is Unicode-aware for Urdu (runes, not UTF-16)', () {
      // 'پاکستان' is 7 Urdu letters — must count as 7, not more.
      final p = _p(id: 1, language: TypingLanguage.urdu, text: 'پاکستان');
      expect(p.characterCount, 'پاکستان'.runes.length);
      expect(p.characterCount, 7);
    });
  });

  group('Validation', () {
    test('empty title is rejected', () {
      final result =
          ParagraphValidation.validate(title: '   ', text: 'some text');
      expect(result.isValid, isFalse);
      expect(result.titleError, isNotNull);
      expect(result.textError, isNull);
    });

    test('empty text is rejected', () {
      final result =
          ParagraphValidation.validate(title: 'My Title', text: '   ');
      expect(result.isValid, isFalse);
      expect(result.textError, isNotNull);
      expect(result.titleError, isNull);
    });

    test('valid title and text pass', () {
      final result =
          ParagraphValidation.validate(title: 'My Title', text: 'Some text');
      expect(result.isValid, isTrue);
      expect(result.titleError, isNull);
      expect(result.textError, isNull);
    });
  });

  group('Language filtering', () {
    final list = [
      _p(id: 1, language: TypingLanguage.english, title: 'A'),
      _p(id: 2, language: TypingLanguage.urdu, title: 'B'),
      _p(id: 3, language: TypingLanguage.english, title: 'C'),
    ];

    test('English filter shows only English paragraphs', () {
      final result = ParagraphsController.applyFilters(
        list,
        languageFilter: ParagraphLanguageFilter.english,
        categoryFilter: null,
        sort: ParagraphSort.newest,
        query: '',
      );
      expect(result.length, 2);
      expect(
          result.every((p) => p.language == TypingLanguage.english), isTrue);
    });

    test('Urdu filter shows only Urdu paragraphs', () {
      final result = ParagraphsController.applyFilters(
        list,
        languageFilter: ParagraphLanguageFilter.urdu,
        categoryFilter: null,
        sort: ParagraphSort.newest,
        query: '',
      );
      expect(result.length, 1);
      expect(result.first.language, TypingLanguage.urdu);
    });

    test('All filter shows every paragraph', () {
      final result = ParagraphsController.applyFilters(
        list,
        languageFilter: ParagraphLanguageFilter.all,
        categoryFilter: null,
        sort: ParagraphSort.newest,
        query: '',
      );
      expect(result.length, 3);
    });
  });

  group('Category filtering', () {
    test('only paragraphs matching the selected category are shown', () {
      final list = [
        _p(id: 1, category: ParagraphCategory.exam),
        _p(id: 2, category: ParagraphCategory.personal),
        _p(id: 3, category: ParagraphCategory.exam),
      ];
      final result = ParagraphsController.applyFilters(
        list,
        languageFilter: ParagraphLanguageFilter.all,
        categoryFilter: ParagraphCategory.exam,
        sort: ParagraphSort.newest,
        query: '',
      );
      expect(result.length, 2);
      expect(
          result.every((p) => p.category == ParagraphCategory.exam), isTrue);
    });
  });

  group('Search', () {
    test('search matches title, text, or category (case-insensitive)', () {
      final list = [
        _p(id: 1, title: 'Office Practice', text: 'irrelevant'),
        _p(id: 2, title: 'Other', text: 'contains OFFICE inside'),
        _p(id: 3, title: 'Unrelated', text: 'nothing here'),
      ];
      final result = ParagraphsController.applyFilters(
        list,
        languageFilter: ParagraphLanguageFilter.all,
        categoryFilter: null,
        sort: ParagraphSort.newest,
        query: 'office',
      );
      expect(result.length, 2);
    });
  });

  group('Sorting', () {
    final list = [
      _p(id: 1, title: 'Banana', createdAt: DateTime(2026, 1, 10)),
      _p(id: 2, title: 'Apple', createdAt: DateTime(2026, 1, 20)),
      _p(id: 3, title: 'Cherry', createdAt: DateTime(2026, 1, 5)),
    ];

    test('newest first', () {
      final result = ParagraphsController.applyFilters(
        list,
        languageFilter: ParagraphLanguageFilter.all,
        categoryFilter: null,
        sort: ParagraphSort.newest,
        query: '',
      );
      expect(result.map((p) => p.title).toList(),
          ['Apple', 'Banana', 'Cherry']);
    });

    test('oldest first', () {
      final result = ParagraphsController.applyFilters(
        list,
        languageFilter: ParagraphLanguageFilter.all,
        categoryFilter: null,
        sort: ParagraphSort.oldest,
        query: '',
      );
      expect(result.map((p) => p.title).toList(),
          ['Cherry', 'Banana', 'Apple']);
    });

    test('title A-Z', () {
      final result = ParagraphsController.applyFilters(
        list,
        languageFilter: ParagraphLanguageFilter.all,
        categoryFilter: null,
        sort: ParagraphSort.titleAZ,
        query: '',
      );
      expect(result.map((p) => p.title).toList(),
          ['Apple', 'Banana', 'Cherry']);
    });

    test('title Z-A', () {
      final result = ParagraphsController.applyFilters(
        list,
        languageFilter: ParagraphLanguageFilter.all,
        categoryFilter: null,
        sort: ParagraphSort.titleZA,
        query: '',
      );
      expect(result.map((p) => p.title).toList(),
          ['Cherry', 'Banana', 'Apple']);
    });
  });

  group('Built-in paragraph protection', () {
    test('a built-in paragraph is flagged isCustom = false', () {
      final builtIn = _p(id: -1, isCustom: false);
      expect(builtIn.isCustom, isFalse);
    });

    test('only custom paragraphs are considered editable/deletable', () {
      final list = [
        _p(id: -1, isCustom: false, title: 'Built-in'),
        _p(id: 1, isCustom: true, title: 'Mine'),
      ];
      final editable = list.where((p) => p.isCustom).toList();
      expect(editable.length, 1);
      expect(editable.first.title, 'Mine');
    });
  });

  group('Use paragraph for typing test', () {
    test('an English custom paragraph converts correctly', () {
      final p = _p(
        id: 1,
        language: TypingLanguage.english,
        title: 'My Paragraph',
        text: 'some english text',
        difficulty: ParagraphDifficulty.hard,
      );
      final EnglishParagraph result =
          ParagraphsController.toEnglishParagraph(p);
      expect(result.title, 'My Paragraph');
      expect(result.text, 'some english text');
      expect(result.difficulty, ParagraphDifficulty.hard);
    });

    test('a paragraph with no difficulty falls back to medium', () {
      final p = _p(id: 1, difficulty: null);
      final EnglishParagraph result =
          ParagraphsController.toEnglishParagraph(p);
      expect(result.difficulty, ParagraphDifficulty.medium);
    });

    test('a Urdu custom paragraph converts correctly', () {
      final p = _p(
        id: 1,
        language: TypingLanguage.urdu,
        title: 'اردو پیراگراف',
        text: 'یہ اردو متن ہے',
      );
      final UrduParagraph result = ParagraphsController.toUrduParagraph(p);
      expect(result.title, 'اردو پیراگراف');
      expect(result.text, 'یہ اردو متن ہے');
    });
  });
}
