import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/features/practice/model/character_mistake_stat.dart';
import 'package:typing_master/features/practice/model/key_strength.dart';
import 'package:typing_master/features/practice/model/mistake_analysis_input.dart';
import 'package:typing_master/features/practice/model/word_mistake_stat.dart';
import 'package:typing_master/features/practice/service/mistake_analysis_service.dart';
import 'package:typing_master/features/practice/service/practice_content_generator.dart';
import 'package:typing_master/features/typing_test/model/typing_language.dart';

void main() {
  group('Empty state', () {
    test('no tests produces an empty summary with hasEnoughData false', () {
      final summary = MistakeAnalysisService.aggregate(const [], const []);
      expect(summary.hasEnoughData, isFalse);
      expect(summary.completedTestCount, 0);
      expect(summary.weakestCharacters, isEmpty);
      expect(summary.weakestWords, isEmpty);
      expect(summary.recentMistakes, isEmpty);
    });
  });

  group('Mistake aggregation / character frequency', () {
    test('character mistakes are counted per expected character', () {
      final DateTime t1 = DateTime(2026, 1, 1);
      final tests = [
        TestMistakeInput(
            id: 1,
            backspaces: 2,
            wrongWords: 1,
            skippedWords: 0,
            completedAt: t1),
      ];
      final mistakes = [
        const MistakeRowInput(
            id: 1,
            testId: 1,
            expectedCharacter: 'a',
            typedCharacter: 's',
            isSkippedWord: false,
            isWrongWord: false),
        const MistakeRowInput(
            id: 2,
            testId: 1,
            expectedCharacter: 'a',
            typedCharacter: 'd',
            isSkippedWord: false,
            isWrongWord: false),
        const MistakeRowInput(
            id: 3,
            testId: 1,
            expectedCharacter: 'k',
            typedCharacter: 'l',
            isSkippedWord: false,
            isWrongWord: false),
      ];

      final summary = MistakeAnalysisService.aggregate(tests, mistakes);

      expect(summary.completedTestCount, 1);
      expect(summary.totalMistakes, 3);
      expect(summary.wrongCharacters, 3);
      expect(summary.backspaces, 2);

      final CharacterMistakeStat aStat =
          summary.weakestCharacters.firstWhere((c) => c.character == 'a');
      expect(aStat.count, 2);
      // Most frequent wrong input for 'a' should come first.
      expect(aStat.commonWrongInputs.keys.first, isIn(['s', 'd']));

      // Sorted most-mistakes-first.
      expect(summary.weakestCharacters.first.character, 'a');
    });

    test('an empty expectedCharacter (overflow keystroke) is ignored', () {
      final tests = [
        TestMistakeInput(
            id: 1,
            backspaces: 0,
            wrongWords: 0,
            skippedWords: 0,
            completedAt: DateTime(2026, 1, 1)),
      ];
      final mistakes = [
        const MistakeRowInput(
            id: 1,
            testId: 1,
            expectedCharacter: '',
            typedCharacter: 'x',
            isSkippedWord: false,
            isWrongWord: false),
      ];
      final summary = MistakeAnalysisService.aggregate(tests, mistakes);
      expect(summary.weakestCharacters, isEmpty);
    });
  });

  group('Word frequency / skipped word frequency', () {
    test('wrong-word and skipped-word rows are tallied separately', () {
      final tests = [
        TestMistakeInput(
            id: 1,
            backspaces: 0,
            wrongWords: 1,
            skippedWords: 2,
            completedAt: DateTime(2026, 1, 1)),
      ];
      final mistakes = [
        const MistakeRowInput(
            id: 1,
            testId: 1,
            expectedCharacter: 'because',
            typedCharacter: 'becuase',
            isSkippedWord: false,
            isWrongWord: true),
        const MistakeRowInput(
            id: 2,
            testId: 1,
            expectedCharacter: 'because',
            typedCharacter: '',
            isSkippedWord: true,
            isWrongWord: false),
        const MistakeRowInput(
            id: 3,
            testId: 1,
            expectedCharacter: 'development',
            typedCharacter: '',
            isSkippedWord: true,
            isWrongWord: false),
      ];

      final summary = MistakeAnalysisService.aggregate(tests, mistakes);

      final WordMistakeStat because =
          summary.weakestWords.firstWhere((w) => w.word == 'because');
      expect(because.mistakeCount, 1);

      final WordMistakeStat becauseSkipped =
          summary.mostSkippedWords.firstWhere((w) => w.word == 'because');
      expect(becauseSkipped.skippedCount, 1);

      final WordMistakeStat development =
          summary.mostSkippedWords.firstWhere((w) => w.word == 'development');
      expect(development.skippedCount, 1);
      expect(development.mistakeCount, 0);
    });

    test('recent mistakes are ordered newest test first', () {
      final tests = [
        TestMistakeInput(
            id: 1,
            backspaces: 0,
            wrongWords: 0,
            skippedWords: 0,
            completedAt: DateTime(2026, 1, 1)),
        TestMistakeInput(
            id: 2,
            backspaces: 0,
            wrongWords: 0,
            skippedWords: 0,
            completedAt: DateTime(2026, 1, 5)),
      ];
      final mistakes = [
        const MistakeRowInput(
            id: 1,
            testId: 1,
            expectedCharacter: 'a',
            typedCharacter: 'b',
            isSkippedWord: false,
            isWrongWord: false),
        const MistakeRowInput(
            id: 2,
            testId: 2,
            expectedCharacter: 'c',
            typedCharacter: 'd',
            isSkippedWord: false,
            isWrongWord: false),
      ];
      final summary = MistakeAnalysisService.aggregate(tests, mistakes);
      // Test 2 (Jan 5) is newer than test 1 (Jan 1), so its mistake ("c")
      // should appear first.
      expect(summary.recentMistakes.first.contains('"c"'), isTrue);
    });
  });

  group('Heatmap classification', () {
    test('thresholds map mistake counts to the correct strength', () {
      expect(KeyStrengthThresholds.classify(0), KeyStrength.strong);
      expect(KeyStrengthThresholds.classify(1), KeyStrength.good);
      expect(KeyStrengthThresholds.classify(3), KeyStrength.good);
      expect(KeyStrengthThresholds.classify(4), KeyStrength.needsPractice);
      expect(KeyStrengthThresholds.classify(7), KeyStrength.needsPractice);
      expect(KeyStrengthThresholds.classify(8), KeyStrength.weak);
      expect(KeyStrengthThresholds.classify(100), KeyStrength.weak);
    });
  });

  group('Practice content generation', () {
    test('character practice with no data falls back to a real paragraph',
        () {
      final content = PracticeContentGenerator.characterPractice(
          [], TypingLanguage.english);
      expect(content, isNotEmpty);
    });

    test('English character practice contains the weak letters', () {
      const weak = [
        CharacterMistakeStat(
            character: 'a',
            count: 10,
            lastMistakeAt: null,
            commonWrongInputs: {}),
        CharacterMistakeStat(
            character: 's',
            count: 8,
            lastMistakeAt: null,
            commonWrongInputs: {}),
        CharacterMistakeStat(
            character: 'k',
            count: 5,
            lastMistakeAt: null,
            commonWrongInputs: {}),
      ];
      final content = PracticeContentGenerator.characterPractice(
          weak, TypingLanguage.english);
      expect(content, isNotEmpty);
      // Every word in the drill should contain at least one weak letter.
      final words = content.split(' ').where((w) => w.isNotEmpty);
      for (final w in words) {
        final bool hasWeakLetter = w.toLowerCase().contains('a') ||
            w.toLowerCase().contains('s') ||
            w.toLowerCase().contains('k');
        expect(hasWeakLetter, isTrue, reason: '"$w" has no weak letter');
      }
    });

    test('Urdu character practice never invents English words', () {
      const weak = [
        CharacterMistakeStat(
            character: 'ا',
            count: 5,
            lastMistakeAt: null,
            commonWrongInputs: {}),
        CharacterMistakeStat(
            character: 'ک',
            count: 3,
            lastMistakeAt: null,
            commonWrongInputs: {}),
      ];
      final content = PracticeContentGenerator.characterPractice(
          weak, TypingLanguage.urdu);
      expect(content, contains('ا'));
      expect(content, contains('ک'));
      expect(RegExp(r'[A-Za-z]').hasMatch(content), isFalse);
    });

    test("word practice repeats the user's own real weak words", () {
      const words = [
        WordMistakeStat(
            word: 'because',
            mistakeCount: 5,
            skippedCount: 0,
            lastMistakeAt: null),
        WordMistakeStat(
            word: 'development',
            mistakeCount: 3,
            skippedCount: 0,
            lastMistakeAt: null),
      ];
      final content =
          PracticeContentGenerator.wordPractice(words, TypingLanguage.english);
      expect(content, contains('because'));
      expect(content, contains('development'));
    });

    test('general practice returns real built-in paragraph text', () {
      final en =
          PracticeContentGenerator.generalPractice(TypingLanguage.english);
      final ur =
          PracticeContentGenerator.generalPractice(TypingLanguage.urdu);
      expect(en, isNotEmpty);
      expect(ur, isNotEmpty);
    });
  });
}
