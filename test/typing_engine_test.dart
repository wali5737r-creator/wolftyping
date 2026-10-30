import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/features/typing_test/model/typing_test_status.dart';
import 'package:typing_master/features/typing_test/model/typing_word_status.dart';
import 'package:typing_master/features/typing_test/service/typing_engine.dart';

void main() {
  group('1. Correct typing', () {
    test('every character typed correctly gives 0 errors and 100% accuracy',
        () {
      final engine = TypingEngine(
        targetText: 'cat dog',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      for (final ch in 'cat'.split('')) {
        engine.typeCharacter(ch);
      }
      expect(engine.correctCharacters, 3);
      expect(engine.wrongCharacters, 0);
      expect(engine.accuracy, 100);
    });
  });

  group('2. Wrong character', () {
    test('a mismatched character is tracked and lowers accuracy', () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      engine.typeCharacter('c'); // correct
      engine.typeCharacter('x'); // expected 'a'
      expect(engine.correctCharacters, 1);
      expect(engine.wrongCharacters, 1);
      expect(engine.totalTypedCharacters, 2);
      expect(engine.accuracy, closeTo(50, 0.001));
      expect(engine.mistakes.length, 1);
      expect(engine.mistakes.first.expectedCharacter, 'a');
      expect(engine.mistakes.first.typedCharacter, 'x');
    });
  });

  group('3. Backspace', () {
    test('backspace count increases on every press, even with an empty buffer',
        () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      engine.typeCharacter('c');
      engine.handleBackspace(); // removes 'c'
      engine.handleBackspace(); // buffer already empty, still counts
      expect(engine.backspaces, 2);
    });

    test('correcting a mistake is recorded as a corrected mistake', () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      engine.typeCharacter('x'); // wrong, expected 'c'
      expect(engine.wrongCharacters, 1);
      engine.handleBackspace();
      expect(engine.wrongCharacters, 0);
      engine.typeCharacter('c'); // now correct
      expect(engine.correctCharacters, 1);
      expect(engine.correctedMistakes, 1);
    });
  });

  group('4. Correct word', () {
    test('a fully and correctly typed word counts as correct', () {
      final engine = TypingEngine(
        targetText: 'cat dog',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      for (final ch in 'cat'.split('')) {
        engine.typeCharacter(ch);
      }
      engine.handleSpace();
      expect(engine.correctWords, 1);
      expect(engine.wordStatuses[0], TypingWordStatus.correct);
      expect(engine.currentWordIndex, 1);
    });
  });

  group('5. Wrong word', () {
    test('a non-empty but incorrect word counts as wrong, not skipped', () {
      final engine = TypingEngine(
        targetText: 'cat dog',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      for (final ch in 'cot'.split('')) {
        engine.typeCharacter(ch); // typo
      }
      engine.handleSpace();
      expect(engine.wrongWords, 1);
      expect(engine.skippedWords, 0);
      expect(engine.wordStatuses[0], TypingWordStatus.wrong);
    });

    test('a wrong word also records a whole-word mistake for analysis', () {
      final engine = TypingEngine(
        targetText: 'cat dog',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      for (final ch in 'cot'.split('')) {
        engine.typeCharacter(ch);
      }
      engine.handleSpace();
      final wordMistake = engine.mistakes.firstWhere((m) => m.isWrongWord);
      expect(wordMistake.expectedCharacter, 'cat');
      expect(wordMistake.typedCharacter, 'cot');
      expect(wordMistake.isSkippedWord, isFalse);
    });
  });

  group('6. Skipped word', () {
    test('pressing space with nothing typed skips the current word', () {
      final engine = TypingEngine(
        targetText: 'The quick brown fox',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      for (final ch in 'The'.split('')) {
        engine.typeCharacter(ch);
      }
      engine.handleSpace(); // commits "The" correctly
      engine.handleSpace(); // nothing typed for "quick" -> skipped
      for (final ch in 'brown'.split('')) {
        engine.typeCharacter(ch);
      }
      engine.handleSpace();

      expect(engine.skippedWords, 1);
      expect(engine.wordStatuses[1], TypingWordStatus.skipped);
      expect(engine.wordStatuses[2], TypingWordStatus.correct);
      expect(
        engine.mistakes
            .any((m) => m.isSkippedWord && m.expectedCharacter == 'quick'),
        isTrue,
      );
      expect(engine.totalErrors, greaterThanOrEqualTo('quick'.length));
    });
  });

  group('7. Multiple skipped words', () {
    test('several consecutive skips are all detected independently', () {
      final engine = TypingEngine(
        targetText: 'alpha beta gamma delta',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      // The clock/word grading only begins at the first keystroke, so
      // start typing (and clear it) before pressing Space on empty words.
      engine.typeCharacter('a');
      engine.handleBackspace();
      engine.handleSpace(); // skip alpha
      engine.handleSpace(); // skip beta
      engine.handleSpace(); // skip gamma
      for (final ch in 'delta'.split('')) {
        engine.typeCharacter(ch);
      }
      engine.handleSpace();

      expect(engine.skippedWords, 3);
      expect(
        engine.wordStatuses.sublist(0, 3),
        everyElement(TypingWordStatus.skipped),
      );
      expect(engine.wordStatuses[3], TypingWordStatus.correct);
      expect(engine.status, TypingTestStatus.completed);
    });
  });

  group('8. Accuracy calculation', () {
    test('accuracy reads 100 before anything has been typed', () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: const Duration(seconds: 30),
      );
      expect(engine.accuracy, 100);
    });

    test('accuracy recovers once a mistake is corrected', () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      engine.typeCharacter('x'); // wrong
      expect(engine.accuracy, 0);
      engine.handleBackspace();
      engine.typeCharacter('c'); // now correct
      expect(engine.accuracy, 100);
    });
  });

  group('8a. Timed test continues past the end of the paragraph', () {
    void typeWord(TypingEngine e, String w) {
      for (final ch in w.split('')) {
        e.typeCharacter(ch);
      }
      e.handleSpace();
    }

    test('finishing the paragraph does not end a timed test', () {
      final engine = TypingEngine(
        targetText: 'cat dog',
        duration: const Duration(seconds: 30),
        continuation: () => 'sun moon',
      );
      engine.start();
      typeWord(engine, 'cat');
      typeWord(engine, 'dog'); // paragraph finished, clock still running

      expect(engine.status, TypingTestStatus.running);
      expect(engine.targetWords, ['cat', 'dog', 'sun', 'moon']);
      expect(engine.currentWordIndex, 2);
      expect(engine.wordStatuses[2], TypingWordStatus.current);

      typeWord(engine, 'sun');
      typeWord(engine, 'moon'); // continuation supplies more again
      expect(engine.status, TypingTestStatus.running);
      expect(engine.correctWords, 4);
    });

    test('stats keep accumulating across paragraphs', () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: const Duration(seconds: 30),
        continuation: () => 'dog',
      );
      engine.start();
      typeWord(engine, 'cat');
      typeWord(engine, 'xog'); // wrong word in the 2nd paragraph
      expect(engine.correctWords, 1);
      expect(engine.wrongWords, 1);
      expect(engine.correctCharacters, 5); // c a t + o g
      expect(engine.wrongCharacters, 1);
      expect(engine.accuracy, closeTo(5 / 6 * 100, 0.001));
    });

    test('the clock ends the test, with elapsed capped at the duration', () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: const Duration(seconds: 30),
        continuation: () => 'dog',
      );
      engine.start();
      typeWord(engine, 'cat');
      typeWord(engine, 'dog');
      engine.advanceTime(const Duration(seconds: 31));
      expect(engine.status, TypingTestStatus.completed);
      expect(engine.elapsed, const Duration(seconds: 30));
    });

    test('progress follows the clock, not the paragraph', () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: const Duration(seconds: 100),
        continuation: () => 'dog',
      );
      engine.start();
      expect(engine.progress, 0);
      typeWord(engine, 'cat'); // clock started
      engine.advanceTime(const Duration(seconds: 25));
      expect(engine.progress, closeTo(25, 0.001));
    });

    test('untimed attempts still complete when the text is finished', () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: null,
        continuation: () => 'dog',
      );
      engine.start();
      typeWord(engine, 'cat');
      expect(engine.status, TypingTestStatus.completed);
    });

    test('blank continuation text completes the test as before', () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: const Duration(seconds: 30),
        continuation: () => '   ',
      );
      engine.start();
      typeWord(engine, 'cat');
      expect(engine.status, TypingTestStatus.completed);
    });

    test('without a continuation a timed test still ends with the text', () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      typeWord(engine, 'cat');
      expect(engine.status, TypingTestStatus.completed);
    });

    test('restart goes back to the original paragraph only', () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: const Duration(seconds: 30),
        continuation: () => 'dog',
      );
      engine.start();
      typeWord(engine, 'cat');
      expect(engine.targetWords.length, 2);
      engine.reset();
      engine.start();
      expect(engine.targetWords, ['cat']);
      expect(engine.currentWordIndex, 0);
    });
  });

  group('8b. Skipped words count against accuracy', () {
    test('a skipped word lowers accuracy instead of being ignored', () {
      final engine = TypingEngine(
        targetText: 'cat dog',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      for (final ch in 'cat'.split('')) {
        engine.typeCharacter(ch);
      }
      engine.handleSpace(); // "cat" correct (3 correct characters)
      engine.handleSpace(); // "dog" skipped (3 characters of error)

      expect(engine.skippedWords, 1);
      expect(engine.totalErrors, 3);
      // 3 correct out of 3 typed + 3 skipped = 50%, not 100%.
      expect(engine.accuracy, closeTo(50, 0.001));
    });

    test('skipping every word gives 0% accuracy, not 100%', () {
      final engine = TypingEngine(
        targetText: 'alpha beta',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      engine.typeCharacter('x'); // starts the clock, wrong
      engine.handleBackspace();
      engine.handleSpace(); // skip alpha
      engine.handleSpace(); // skip beta
      expect(engine.skippedWords, 2);
      expect(engine.accuracy, 0);
    });
  });

  group('9. Gross WPM calculation', () {
    test('gross WPM follows typedCharacters / 5 / elapsedMinutes', () {
      final engine = TypingEngine(
        targetText: 'a' * 50,
        duration: const Duration(seconds: 60),
      );
      engine.start();
      for (int i = 0; i < 50; i++) {
        engine.typeCharacter('a');
      }
      engine.advanceTime(const Duration(seconds: 60));
      // 50 correct characters typed over exactly 1 minute -> 50/5/1 = 10 wpm
      expect(engine.grossWpm, closeTo(10, 0.01));
    });
  });

  group('10. Net WPM calculation', () {
    test('net WPM is lower than gross WPM once there are mistakes', () {
      final engine = TypingEngine(
        targetText: 'a' * 50,
        duration: const Duration(seconds: 60),
      );
      engine.start();
      for (int i = 0; i < 25; i++) {
        engine.typeCharacter('a'); // correct
      }
      for (int i = 0; i < 25; i++) {
        engine.typeCharacter('b'); // wrong for the remaining 'a's
      }
      engine.advanceTime(const Duration(seconds: 60));
      expect(engine.netWpm, closeTo(5, 0.01)); // 25 correct / 5 / 1 min
      expect(engine.grossWpm, closeTo(10, 0.01)); // 50 typed / 5 / 1 min
      expect(engine.netWpm, lessThan(engine.grossWpm));
    });
  });

  group('11. Progress calculation', () {
    test('progress reflects how much of the target text has been passed',
        () {
      final engine = TypingEngine(
        targetText: 'ab cd', // 4 target characters total (spaces excluded)
        duration: const Duration(seconds: 30),
      );
      engine.start();
      engine.typeCharacter('a');
      engine.typeCharacter('b');
      engine.handleSpace();
      // 2 of 4 total target characters consumed -> 50%
      expect(engine.progress, closeTo(50, 0.01));
    });
  });

  group('12. Timer completion', () {
    test('advancing time to the full duration completes the test', () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: const Duration(seconds: 10),
      );
      engine.start();
      engine.typeCharacter('c'); // the timer starts on the first keystroke
      engine.advanceTime(const Duration(seconds: 10));
      expect(engine.status, TypingTestStatus.completed);
      expect(engine.remaining, Duration.zero);
    });

    test('no further typing is accepted once the test has completed', () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: const Duration(seconds: 5),
      );
      engine.start();
      engine.typeCharacter('c'); // starts the timer
      engine.advanceTime(const Duration(seconds: 5));
      engine.typeCharacter('a');
      // Only the first 'c' counted; 'a' was ignored (already completed).
      expect(engine.correctCharacters, 1);
    });
  });

  group('13. Pause and resume', () {
    test('elapsed time does not advance while paused', () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      engine.typeCharacter('c'); // the timer starts on the first keystroke
      engine.advanceTime(const Duration(seconds: 5));
      engine.pause();
      engine.advanceTime(const Duration(seconds: 5)); // ignored while paused
      expect(engine.elapsed, const Duration(seconds: 5));
      engine.resume();
      engine.advanceTime(const Duration(seconds: 5));
      expect(engine.elapsed, const Duration(seconds: 10));
    });

    test('typing is ignored while paused', () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      engine.pause();
      engine.typeCharacter('c');
      expect(engine.correctCharacters, 0);
    });
  });

  group('14. Restart / reset', () {
    test('reset clears every counter and returns to notStarted', () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      engine.typeCharacter('c');
      engine.advanceTime(const Duration(seconds: 5));
      engine.reset();
      expect(engine.status, TypingTestStatus.notStarted);
      expect(engine.correctCharacters, 0);
      expect(engine.elapsed, Duration.zero);
      expect(engine.currentWordIndex, 0);
    });

    test('reset can load a new paragraph and duration for "Try Again"', () {
      final engine = TypingEngine(
        targetText: 'cat',
        duration: const Duration(seconds: 30),
      );
      engine.reset(
        newTargetText: 'a new paragraph',
        newDuration: const Duration(seconds: 60),
      );
      expect(engine.targetWords, ['a', 'new', 'paragraph']);
      expect(engine.duration, const Duration(seconds: 60));
    });
  });

  group('15. Empty text', () {
    test('an empty target text never errors and accepts no typing', () {
      final engine = TypingEngine(
        targetText: '',
        duration: const Duration(seconds: 30),
      );
      expect(engine.targetWords, isEmpty);
      engine.start();
      engine.typeCharacter('a'); // nothing to type against -> no-op
      expect(engine.correctCharacters, 0);
      expect(engine.wrongCharacters, 0);
    });
  });

  group('16. Very short text', () {
    test('a single-character paragraph completes after one correct word',
        () {
      final engine = TypingEngine(
        targetText: 'a',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      engine.typeCharacter('a');
      engine.handleSpace();
      expect(engine.correctWords, 1);
      expect(engine.status, TypingTestStatus.completed);
    });
  });

  group('17. Urdu Unicode text', () {
    test('Urdu characters are compared correctly, one code point at a time',
        () {
      final engine = TypingEngine(
        targetText: 'پاکستان زندہ باد',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      for (final ch in 'پاکستان'.runes.map(String.fromCharCode)) {
        engine.typeCharacter(ch);
      }
      expect(engine.correctCharacters, 'پاکستان'.runes.length);
      expect(engine.wrongCharacters, 0);
      engine.handleSpace();
      expect(engine.correctWords, 1);
    });

    test('a wrong Urdu character is detected exactly like any other', () {
      final engine = TypingEngine(
        targetText: 'سلام',
        duration: const Duration(seconds: 30),
      );
      engine.start();
      engine.typeCharacter('س'); // correct
      engine.typeCharacter('خ'); // wrong, expected 'ل'
      expect(engine.wrongCharacters, 1);
      expect(engine.mistakes.first.expectedCharacter, 'ل');
    });
  });
}
