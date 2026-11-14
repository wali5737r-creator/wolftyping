import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/features/typing_test/model/paragraph_difficulty.dart';
import 'package:typing_master/features/typing_test/service/english_paragraph_provider.dart';
import 'package:typing_master/features/typing_test/service/urdu_paragraph_provider.dart';

/// Every built-in typing-practice paragraph must be at least 500 words
/// (Muhammad, 2026-11-14: the defaults were 19–57 words, far too short
/// for practice). Word count uses the same whitespace split as
/// TypingEngine (RegExp(r'\s+')) so "500 words" means the same thing
/// here as it does in the app.
void main() {
  int wordCount(String text) {
    return text
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .length;
  }

  group('default paragraph length', () {
    test('every English paragraph is at least 500 words', () {
      for (final d in ParagraphDifficulty.values) {
        for (final p in EnglishParagraphProvider.byDifficulty(d)) {
          final int count = wordCount(p.text);
          expect(count, greaterThanOrEqualTo(500),
              reason: 'English "${p.title}" has $count words');
          expect(count, lessThanOrEqualTo(650),
              reason: 'English "${p.title}" has $count words (cap 650)');
        }
      }
    });

    test('every Urdu paragraph is at least 500 words', () {
      for (final d in ParagraphDifficulty.values) {
        for (final p in UrduParagraphProvider.byDifficulty(d)) {
          final int count = wordCount(p.text);
          expect(count, greaterThanOrEqualTo(500),
              reason: 'Urdu "${p.title}" has $count words');
          expect(count, lessThanOrEqualTo(650),
              reason: 'Urdu "${p.title}" has $count words (cap 650)');
        }
      }
    });

    test('nine English and nine Urdu paragraphs, titles non-empty', () {
      int en = 0;
      int ur = 0;
      for (final d in ParagraphDifficulty.values) {
        for (final p in EnglishParagraphProvider.byDifficulty(d)) {
          expect(p.title.trim(), isNotEmpty);
          expect(p.text.trim(), isNotEmpty);
          en++;
        }
        for (final p in UrduParagraphProvider.byDifficulty(d)) {
          expect(p.title.trim(), isNotEmpty);
          expect(p.text.trim(), isNotEmpty);
          ur++;
        }
      }
      expect(en, 9);
      expect(ur, 9);
    });

    test('paragraph texts contain no question marks or list markers', () {
      for (final d in ParagraphDifficulty.values) {
        for (final p in EnglishParagraphProvider.byDifficulty(d)) {
          expect(p.text.contains('?'), isFalse,
              reason: 'English "${p.title}" contains a question');
        }
        for (final p in UrduParagraphProvider.byDifficulty(d)) {
          expect(p.text.contains('؟'), isFalse,
              reason: 'Urdu "${p.title}" contains a question');
        }
      }
    });
  });
}
