import '../model/mistake_record.dart';
import '../model/typing_snapshot.dart';
import '../model/typing_test_status.dart';
import '../model/typing_word_status.dart';

/// The core typing engine — pure Dart, zero Flutter/GetX imports.
///
/// This is the ONLY place typing calculations happen. English Typing Test,
/// Urdu Typing Test, PPSC Urdu Practice, Lessons and Practice Mode all
/// drive the *same* engine class; none of them get their own copy of this
/// logic. The intended wiring is:
///
/// ```
/// Keyboard Input  ->  TypingEngine  ->  TypingController (GetX)  ->  UI
/// ```
///
/// A future `TypingController` will:
///  1. Capture raw key events (Flutter's `KeyEvent`/`HardwareKeyboard`).
///  2. Call [typeCharacter] for a printable character, [handleSpace] for
///     the space bar, and [handleBackspace] for backspace.
///  3. Call [advanceTime] every ~200ms from a `Timer.periodic` to drive
///     the countdown.
///  4. Read [snapshot] inside its own `onUpdate` callback and copy it into
///     a single reactive field.
///
/// None of that wiring lives here — this class never imports
/// `package:flutter` or `package:get`, which is what makes it trivial to
/// unit test (see test/typing_engine_test.dart) and reusable across every
/// screen that needs typing logic.
class TypingEngine {
  TypingEngine({
    required String targetText,
    Duration? duration,
    this.onUpdate,
    this.continuation,
  })  : _targetText = targetText.trim(),
        _duration = duration {
    _initWords();
  }

  /// Fired after every state change (keystroke, space, backspace, tick,
  /// start/pause/resume/reset/complete) so a controller can refresh its
  /// reactive state. Never call into Flutter from here — keep this plain.
  final void Function()? onUpdate;

  /// Supplies more text when the user reaches the end of the target text.
  ///
  /// Only used for TIMED tests (a non-null [duration]): the test must run
  /// until the clock ends, so finishing the paragraph early appends the
  /// next chunk of text instead of completing. Untimed attempts (Lessons,
  /// Practice) and engines created without a [continuation] keep the
  /// original behavior - typing through the whole text completes the test.
  /// If the supplier returns blank text the test completes as before.
  final String Function()? continuation;

  bool get _isContinuous => continuation != null && _duration != null;

  // ---------------------------------------------------------------------
  // Target text / word model
  // ---------------------------------------------------------------------

  String _targetText;

  /// The paragraph/text the user must type. English or Urdu — the engine
  /// only ever compares Unicode strings, it never looks at language.
  String get targetText => _targetText;

  late List<String> _targetWords;
  late List<TypingWordStatus> _wordStatuses;
  late int _totalTargetCharacters; // sum of word lengths; spaces excluded

  void _initWords() {
    // Growable: a timed test appends words when the paragraph runs out.
    _targetWords = _targetText.isEmpty
        ? <String>[]
        : List<String>.of(_targetText.split(RegExp(r'\s+')));
    _wordStatuses = List<TypingWordStatus>.filled(
      _targetWords.length,
      TypingWordStatus.pending,
      growable: true,
    );
    if (_targetWords.isNotEmpty) {
      _wordStatuses[0] = TypingWordStatus.current;
    }
    _totalTargetCharacters =
        _targetWords.fold<int>(0, (sum, w) => sum + _chars(w).length);
  }

  /// Splits a string into individual Unicode *code points* (runes) rather
  /// than UTF-16 code units, so Urdu characters are each treated as one
  /// character for position/progress tracking — this is what makes Urdu
  /// "just work" without any language-specific logic in this engine (see
  /// the class doc for the full explanation of Urdu support).
  static List<String> _chars(String s) =>
      s.runes.map(String.fromCharCode).toList();

  /// Appends [text] after the current target words (timed-test
  /// continuation). Returns false when [text] has no words.
  bool _appendWords(String text) {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) return false;
    final List<String> words = trimmed.split(RegExp(r'\s+'));
    _targetWords.addAll(words);
    _wordStatuses.addAll(List<TypingWordStatus>.filled(
        words.length, TypingWordStatus.pending));
    _totalTargetCharacters +=
        words.fold<int>(0, (sum, w) => sum + _chars(w).length);
    return true;
  }

  // ---------------------------------------------------------------------
  // Lifecycle state
  // ---------------------------------------------------------------------

  TypingTestStatus _status = TypingTestStatus.notStarted;
  TypingTestStatus get status => _status;

  Duration? _duration;

  /// Total time allowed. `null` means untimed (free practice) — the test
  /// then only ends when the user finishes the paragraph or [stop] is
  /// called manually.
  Duration? get duration => _duration;

  Duration _elapsed = Duration.zero;

  /// Time spent actively typing. Paused time is never added to this.
  Duration get elapsed => _elapsed;

  Duration get remaining {
    if (_duration == null) return Duration.zero;
    final Duration left = _duration! - _elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  /// False until the user types their first printable character. While
  /// false, the clock does not advance, so the timer only starts on the
  /// first keystroke (also after restart/reset).
  bool _hasTypingStarted = false;
  bool get hasTypingStarted => _hasTypingStarted;

  /// Starts the test. No-op if it's already running/paused/completed —
  /// call [reset] first to start a fresh attempt.
  void start() {
    if (_status != TypingTestStatus.notStarted) return;
    _status = TypingTestStatus.running;
    onUpdate?.call();
  }

  void pause() {
    if (_status != TypingTestStatus.running) return;
    _status = TypingTestStatus.paused;
    onUpdate?.call();
  }

  void resume() {
    if (_status != TypingTestStatus.paused) return;
    _status = TypingTestStatus.running;
    onUpdate?.call();
  }

  /// Manually ends the test early — e.g. the user clicks "Stop"/"Exit" —
  /// as opposed to the timer running out or the paragraph being finished.
  void stop() {
    if (_status == TypingTestStatus.completed) return;
    _complete();
  }

  void _complete() {
    _status = TypingTestStatus.completed;
    onUpdate?.call();
  }

  /// Advances the internal clock by [delta]. Ignored unless the test is
  /// currently running (so paused time truly doesn't count, per spec).
  ///
  /// The controller calls this from a `Timer.periodic` in production.
  /// Unit tests call it directly with whatever [delta] they want to
  /// simulate — no real waiting required, which is what keeps the test
  /// suite fast and deterministic.
  void advanceTime(Duration delta) {
    if (_status != TypingTestStatus.running) return;
    if (!_hasTypingStarted) return; // first character ka wait
    _elapsed += delta;
    if (_duration != null && _elapsed >= _duration!) {
      _elapsed = _duration!;
      _complete();
      return;
    }
    onUpdate?.call();
  }

  /// Starts a fresh attempt, clearing every counter. Pass [newTargetText]
  /// / [newDuration] to reuse the same engine instance for "Try Again"
  /// with different content; omit both to restart the exact same test.
  void reset({String? newTargetText, Duration? newDuration}) {
    _status = TypingTestStatus.notStarted;
    _elapsed = Duration.zero;
    _hasTypingStarted = false;
    _currentWordIndex = 0;
    _currentWordBuffer = '';
    _pendingCorrectionPos = null;
    correctCharacters = 0;
    wrongCharacters = 0;
    backspaces = 0;
    correctedMistakes = 0;
    correctWords = 0;
    wrongWords = 0;
    skippedWords = 0;
    _skippedCharacterPenalty = 0;
    _committedWordBuffers.clear();
    mistakes.clear();

    if (newDuration != null) _duration = newDuration;
    if (newTargetText != null) _targetText = newTargetText.trim();
    _initWords();

    onUpdate?.call();
  }

  // ---------------------------------------------------------------------
  // Live typing state
  // ---------------------------------------------------------------------

  int _currentWordIndex = 0;
  int get currentWordIndex => _currentWordIndex;

  String _currentWordBuffer = '';

  /// What's been typed for the word currently in progress (not yet
  /// committed with Space).
  String get currentWordBuffer => _currentWordBuffer;

  final List<String> _committedWordBuffers = [];

  /// The literal typed text for every word committed so far (index-aligned
  /// with [targetWords]/[wordStatuses] for indices < [currentWordIndex]).
  /// Empty string for a skipped word. This is what the UI uses to render
  /// per-character correct/wrong coloring for words already typed, not
  /// just their final correct/wrong/skipped verdict.
  List<String> get committedWordBuffers =>
      List.unmodifiable(_committedWordBuffers);

  /// Reconstructs everything the user has typed so far — every committed
  /// word (correct, wrong, or empty-for-skipped) plus the in-progress
  /// word buffer, joined with single spaces. This is the "current typed
  /// text" the UI can mirror; it is not used for grading.
  String get typedTextSoFar {
    final String committed = _committedWordBuffers.join(' ');
    if (committed.isEmpty) return _currentWordBuffer;
    if (_currentWordBuffer.isEmpty) return committed;
    return '$committed $_currentWordBuffer';
  }

  /// Set by [handleBackspace] to the in-word position of a character that
  /// was wrong and just got deleted. If the very next keystroke at that
  /// same position is correct, it's a "corrected mistake" — see
  /// [correctedMistakes].
  int? _pendingCorrectionPos;

  // ---------------------------------------------------------------------
  // Counters (see class doc for how these feed the formulas below)
  // ---------------------------------------------------------------------

  int correctCharacters = 0;
  int wrongCharacters = 0;
  int backspaces = 0;
  int correctedMistakes = 0;
  int correctWords = 0;
  int wrongWords = 0;
  int skippedWords = 0;

  /// Character-length penalty contributed by fully skipped words. Kept
  /// separate from wrongCharacters because no keystroke was ever made for
  /// these — they must not be counted in [totalTypedCharacters] (which
  /// backs the accuracy formula) but they must still count as errors.
  int _skippedCharacterPenalty = 0;

  final List<MistakeRecord> mistakes = [];

  List<TypingWordStatus> get wordStatuses => List.unmodifiable(_wordStatuses);
  List<String> get targetWords => List.unmodifiable(_targetWords);

  /// correctCharacters + wrongCharacters. This is "typedCharacters" in the
  /// WPM/accuracy formulas — it reflects the *current* state of what's
  /// typed, so backspacing a mistake away and retyping it correctly moves
  /// this (and accuracy) back toward 100%, matching "the displayed
  /// accuracy must match the final calculation".
  int get totalTypedCharacters => correctCharacters + wrongCharacters;

  /// wrongCharacters plus the word-length penalty from skipped words.
  /// This is the single "Errors" number shown on the result screen; it is
  /// intentionally NOT part of the accuracy formula below (see class doc).
  int get totalErrors => wrongCharacters + _skippedCharacterPenalty;

  // ---------------------------------------------------------------------
  // Input handling
  // ---------------------------------------------------------------------

  /// Handles one printable keystroke. [char] must be a single Unicode
  /// character — exactly what a Flutter `KeyEvent.character` delivers,
  /// whether it's English or Urdu (typed via the OS's Urdu keyboard
  /// layout). No translation or transliteration ever happens here.
  void typeCharacter(String char) {
    if (_status != TypingTestStatus.running) return;
    if (_currentWordIndex >= _targetWords.length) return;

    _hasTypingStarted = true; // pehla character = timer start

    final List<String> targetChars = _chars(_targetWords[_currentWordIndex]);
    final int posInWord = _chars(_currentWordBuffer).length;
    final bool isCorrect =
        posInWord < targetChars.length && targetChars[posInWord] == char;

    if (_pendingCorrectionPos == posInWord) {
      if (isCorrect) correctedMistakes++;
      _pendingCorrectionPos = null;
    }

    if (isCorrect) {
      correctCharacters++;
    } else {
      wrongCharacters++;
      mistakes.add(MistakeRecord(
        expectedCharacter:
            posInWord < targetChars.length ? targetChars[posInWord] : '',
        typedCharacter: char,
        position: _absoluteCharPosition(),
        wordIndex: _currentWordIndex,
      ));
    }

    _currentWordBuffer += char;
    onUpdate?.call();
  }

  /// Handles a Backspace press. Always increments [backspaces], even if
  /// there's nothing left to delete (spec: "every backspace press must
  /// increase backspace count").
  void handleBackspace() {
    if (_status != TypingTestStatus.running) return;
    if (!_hasTypingStarted) return; // pehle character se pehle ignore
    backspaces++;

    if (_currentWordBuffer.isEmpty) {
      onUpdate?.call();
      return;
    }

    final List<String> bufferChars = _chars(_currentWordBuffer);
    final String removed = bufferChars.removeLast();
    final int posInWord = bufferChars.length;

    final List<String> targetChars = _chars(_targetWords[_currentWordIndex]);
    final bool wasCorrect =
        posInWord < targetChars.length && targetChars[posInWord] == removed;

    if (wasCorrect) {
      correctCharacters--;
      _pendingCorrectionPos = null;
    } else {
      wrongCharacters--;
      _pendingCorrectionPos = posInWord;
    }

    _currentWordBuffer = bufferChars.join();
    onUpdate?.call();
  }

  /// Handles the Space bar — commits the current word buffer against the
  /// current target word and moves on. This is the Anti-Skip Logic: Space
  /// is never just "another character", it's the moment a word gets
  /// graded.
  void handleSpace() {
    if (_status != TypingTestStatus.running) return;
    if (!_hasTypingStarted) return; // warna pehla word skip ho jayega
    if (_currentWordIndex >= _targetWords.length) return;

    final String targetWord = _targetWords[_currentWordIndex];

    if (_currentWordBuffer.isEmpty) {
      // Nothing was typed for this word at all before Space was pressed —
      // the whole word is skipped, never silently ignored (spec: Anti-Skip
      // Logic / Skipped Word Rule).
      skippedWords++;
      _skippedCharacterPenalty += _chars(targetWord).length;
      _wordStatuses[_currentWordIndex] = TypingWordStatus.skipped;
      mistakes.add(MistakeRecord(
        expectedCharacter: targetWord,
        typedCharacter: '',
        position: _absoluteCharPosition(),
        wordIndex: _currentWordIndex,
        isSkippedWord: true,
      ));
    } else if (_currentWordBuffer == targetWord) {
      correctWords++;
      _wordStatuses[_currentWordIndex] = TypingWordStatus.correct;
    } else {
      wrongWords++;
      _wordStatuses[_currentWordIndex] = TypingWordStatus.wrong;
      // Word-level record (in addition to the per-character mistakes
      // already recorded live as the user typed this word) so Word
      // Mistake Analysis knows which target word text was gotten wrong —
      // character-level records alone don't carry the whole word.
      mistakes.add(MistakeRecord(
        expectedCharacter: targetWord,
        typedCharacter: _currentWordBuffer,
        position: _absoluteCharPosition(),
        wordIndex: _currentWordIndex,
        isWrongWord: true,
      ));
    }

    _committedWordBuffers.add(_currentWordBuffer);
    _currentWordBuffer = '';
    _pendingCorrectionPos = null;
    _currentWordIndex++;

    if (_currentWordIndex >= _wordStatuses.length && _isContinuous) {
      // Timed test and the paragraph ran out: keep going with more text.
      // Counters, elapsed time and mistakes simply keep accumulating.
      _appendWords(continuation!.call());
    }

    if (_currentWordIndex < _wordStatuses.length) {
      _wordStatuses[_currentWordIndex] = TypingWordStatus.current;
      onUpdate?.call();
    } else {
      // Typed through the entire text and there is nothing more to type
      // (untimed attempt, or no continuation text) — the test is done.
      _complete();
    }
  }

  int _absoluteCharPosition() {
    int pos = 0;
    for (int i = 0; i < _currentWordIndex; i++) {
      pos += _chars(_targetWords[i]).length + 1; // +1 for the joining space
    }
    return pos + _chars(_currentWordBuffer).length;
  }

  // ---------------------------------------------------------------------
  // Derived stats — WPM / accuracy / progress
  // ---------------------------------------------------------------------

  /// Standard formula: (typed characters / 5) / elapsed minutes. Uses
  /// [totalTypedCharacters] (correct + wrong), i.e. raw typing speed
  /// regardless of mistakes.
  double get grossWpm {
    final double minutes = _elapsed.inMilliseconds / 60000.0;
    if (minutes <= 0) return 0;
    return (totalTypedCharacters / 5) / minutes;
  }

  /// Same formula as [grossWpm] but counting only [correctCharacters], so
  /// mistakes directly reduce it. Always <= grossWpm.
  double get netWpm {
    final double minutes = _elapsed.inMilliseconds / 60000.0;
    if (minutes <= 0) return 0;
    return (correctCharacters / 5) / minutes;
  }

  /// correctCharacters / (totalTypedCharacters + characters of skipped
  /// words) * 100. Before anything is typed this reads 100 (nothing to be wrong about yet), matching the
  /// "Live Accuracy: Start: 100%" behavior from the spec.
  double get accuracy {
    // Skipped words never produced a keystroke, but they are still errors:
    // their characters are added to the denominator so skipping a word
    // lowers accuracy instead of being silently ignored.
    final int denominator = totalTypedCharacters + _skippedCharacterPenalty;
    if (denominator == 0) return 100;
    final double raw = correctCharacters / denominator * 100;
    return raw.clamp(0, 100).toDouble();
  }

  /// 0-100: how much of the target text (word characters only, spaces
  /// excluded) has been passed — correctly, wrongly, or skipped all count
  /// as "passed", since progress tracks position, not correctness.
  double get progress {
    if (_isContinuous) {
      // The text keeps growing, so "how much of the paragraph" is not
      // meaningful; a timed test's progress is how much of the clock has
      // been used (0 until the first character starts the timer).
      final int totalMs = _duration!.inMilliseconds;
      if (totalMs <= 0) return 0;
      return (_elapsed.inMilliseconds / totalMs * 100)
          .clamp(0, 100)
          .toDouble();
    }
    if (_totalTargetCharacters == 0) return 0;
    int consumed = 0;
    for (int i = 0; i < _currentWordIndex; i++) {
      consumed += _chars(_targetWords[i]).length;
    }
    consumed += _chars(_currentWordBuffer).length;
    return (consumed / _totalTargetCharacters * 100).clamp(0, 100).toDouble();
  }

  /// One consistent snapshot of every derived stat. See the class doc for
  /// how the controller is expected to use this.
  TypingSnapshot get snapshot => TypingSnapshot(
        status: _status,
        elapsed: _elapsed,
        remaining: remaining,
        correctCharacters: correctCharacters,
        wrongCharacters: wrongCharacters,
        totalTypedCharacters: totalTypedCharacters,
        correctWords: correctWords,
        wrongWords: wrongWords,
        skippedWords: skippedWords,
        backspaces: backspaces,
        correctedMistakes: correctedMistakes,
        totalErrors: totalErrors,
        grossWpm: grossWpm,
        netWpm: netWpm,
        accuracy: accuracy,
        progress: progress,
        currentWordIndex: _currentWordIndex,
      );
}