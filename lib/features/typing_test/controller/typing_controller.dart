import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../model/english_paragraph.dart';
import '../model/paragraph_difficulty.dart';
import '../model/typing_durations.dart';
import '../model/typing_language.dart';
import '../model/typing_snapshot.dart';
import '../model/typing_test_kind.dart';
import '../model/typing_test_status.dart';
import '../model/typing_word_status.dart';
import '../service/english_paragraph_provider.dart';
import '../service/paragraph_continuation.dart';
import '../service/typing_engine.dart';
import '../../settings/controller/settings_controller.dart';
import '../service/engine_clock.dart';
import '../service/typing_input.dart';
import '../service/typing_result_repository.dart';

/// Which panel of the Typing Test screen is currently shown. This is a
/// screen-navigation concept, distinct from [TypingTestStatus] (which is
/// the *engine's* running/paused/completed state) — [screenPhase] only
/// flips to [TypingScreenPhase.result] once the engine reaches
/// [TypingTestStatus.completed].
enum TypingScreenPhase { setup, test, result }

/// Bridges physical keyboard input and the UI to [TypingEngine].
///
/// This class intentionally does NO typing math itself — every number it
/// exposes is copied straight from `TypingEngine.snapshot`. Its only jobs
/// are: own the engine instance for this attempt, drive its clock with a
/// `Timer.periodic`, translate key events into engine calls, and expose
/// GetX-reactive state so the view can rebuild.
class TypingController extends GetxController {
  /// Focus node the live typing screen attaches its keyboard listener to.
  /// Kept here (not local State) so `startTest`/`restartTest` can request
  /// focus after the view has rebuilt into the test phase.
  final FocusNode focusNode = FocusNode();

  // ---------------------------------------------------------------------
  // Setup state
  // ---------------------------------------------------------------------

  final Rx<TypingScreenPhase> screenPhase = TypingScreenPhase.setup.obs;
  final Rx<Duration> selectedDuration = TypingDurations.minute1.obs;
  final Rx<ParagraphDifficulty> selectedDifficulty =
      ParagraphDifficulty.easy.obs;
  final Rx<EnglishParagraph?> selectedParagraph = Rx<EnglishParagraph?>(null);

  /// Shown under the duration presets when the user picks "Custom" and
  /// types something that isn't a valid positive number of seconds.
  final RxnString durationError = RxnString();
  final RxnString startError = RxnString();

  @override
  void onInit() {
    super.onInit();
    // Settings > Default duration.
    selectedDuration.value = TypingDurations.initialFor(
        SettingsController.currentOrNull?.defaultDurationSeconds);
    final Object? args = Get.arguments;
    if (args is EnglishParagraph) {
      // Came from "Use for Test" (My Paragraphs) — load that paragraph
      // instead of picking a random one.
      selectedParagraph.value = args;
      selectedDifficulty.value = args.difficulty;
    } else {
      // Sensible default so the setup screen never shows an empty state.
      selectedParagraph.value =
          EnglishParagraphProvider.randomOf(selectedDifficulty.value);
    }
  }

  void selectDuration(Duration duration) {
    durationError.value = null;
    selectedDuration.value = duration;
  }

  /// Parses a custom duration typed as whole seconds. Handles the "Invalid
  /// duration" error case explicitly rather than throwing.
  void selectCustomDurationSeconds(String rawSeconds) {
    final int? seconds = int.tryParse(rawSeconds.trim());
    if (seconds == null || seconds <= 0) {
      durationError.value = 'Enter a whole number of seconds greater than 0.';
      return;
    }
    durationError.value = null;
    selectedDuration.value = Duration(seconds: seconds);
  }

  void selectDifficulty(ParagraphDifficulty difficulty) {
    selectedDifficulty.value = difficulty;
    selectedParagraph.value = EnglishParagraphProvider.randomOf(difficulty);
  }

  void selectParagraph(EnglishParagraph paragraph) {
    selectedParagraph.value = paragraph;
  }

  void shuffleParagraph() {
    selectedParagraph.value =
        EnglishParagraphProvider.randomOf(selectedDifficulty.value);
  }

  // ---------------------------------------------------------------------
  // Engine ownership + live state
  // ---------------------------------------------------------------------

  TypingEngine? _engine;

  /// Only valid once [screenPhase] is [TypingScreenPhase.test] or
  /// [TypingScreenPhase.result]. Guarded getters below check for null so a
  /// stray keystroke before setup can never crash the app.
  TypingEngine get engine {
    final TypingEngine? e = _engine;
    if (e == null) {
      throw StateError('TypingEngine accessed before startTest() was called');
    }
    return e;
  }

  late final EngineClock _clock =
      EngineClock((Duration delta) => _engine?.advanceTime(delta));

  /// True only while [stopTest] is calling engine.stop(). Stops the
  /// engine's "completed" callback from saving a half-finished test.
  bool _isStopping = false;

  final Rx<TypingSnapshot> snapshot = TypingSnapshot.initial().obs;
  final RxList<TypingWordStatus> wordStatuses = <TypingWordStatus>[].obs;
  final RxList<String> targetWords = <String>[].obs;
  final RxList<String> committedWordBuffers = <String>[].obs;
  final RxString currentWordBuffer = ''.obs;

  /// True jab test running hai lekin user ne abhi pehla character nahi
  /// likha. UI isse "Start typing to begin" dikhane ke liye use karti hai.
  final RxBool isWaitingForFirstKey = false.obs;

  /// Starts a brand-new attempt using whatever is currently selected on
  /// the setup screen. Handles "empty paragraph" / "starting without a
  /// paragraph" by refusing to start and surfacing [startError] instead.
  void startTest() {
    final EnglishParagraph? paragraph = selectedParagraph.value;
    if (paragraph == null || paragraph.text.trim().isEmpty) {
      startError.value = 'Please choose a paragraph before starting.';
      return;
    }
    if (durationError.value != null) {
      startError.value = 'Fix the custom duration before starting.';
      return;
    }
    startError.value = null;

    _clock.stop();
    _engine = TypingEngine(
      targetText: paragraph.text,
      duration: selectedDuration.value,
      onUpdate: _onEngineUpdate,
      // Timed test: keep going with more text until the clock ends.
      continuation: ParagraphContinuation<EnglishParagraph>(
        started: paragraph,
        textOf: (p) => p.text,
        builtInPool: EnglishParagraphProvider.byDifficulty(paragraph.difficulty),
      ).next,
    );
    _refreshFromEngine();
    screenPhase.value = TypingScreenPhase.test;
    engine.start();
    _startTicker();
    _requestFocusNextFrame();
  }

  /// Same paragraph, same duration, from zero. Timer dobara first
  /// character ka wait karega (engine.reset() flag clear karta hai).
  void restartTest() {
    if (_engine == null) return;
    _clock.stop();
    engine.reset();
    _refreshFromEngine();
    screenPhase.value = TypingScreenPhase.test;
    engine.start();
    _startTicker();
    _requestFocusNextFrame();
  }

  /// A new random paragraph at the same difficulty/duration, started
  /// immediately — "Try Again" on the result screen.
  void tryAgain() {
    // Keep the source of the test: a paragraph from My Paragraphs is run
    // again as-is; a built-in paragraph gets a fresh one of the same
    // difficulty.
    final EnglishParagraph? current = selectedParagraph.value;
    final bool isBuiltIn = current != null &&
        EnglishParagraphProvider.byDifficulty(current.difficulty)
            .any((p) => p.text == current.text);
    if (isBuiltIn) shuffleParagraph();
    startTest();
  }

  /// Manually ends the attempt early. Per spec: an incomplete test is
  /// never saved as a completed result, so this just tears down the
  /// engine and returns to setup.
  void stopTest() {
    if (_engine == null) return;
    _clock.stop();
    _isStopping = true;
    engine.stop();
    _isStopping = false;
    _engine = null;
    isWaitingForFirstKey.value = false;
    screenPhase.value = TypingScreenPhase.setup;
  }

  void togglePauseResume() {
    if (_engine == null) return;
    if (engine.status == TypingTestStatus.running) {
      engine.pause();
      _clock.stop();
    } else if (engine.status == TypingTestStatus.paused) {
      engine.resume();
      _startTicker();
    }
    _refreshFromEngine();
    _requestFocusNextFrame();
  }

  /// Leaves the result screen and returns to this test's setup panel.
  void backToSetupFromResult() {
    _clock.stop();
    _engine = null;
    isWaitingForFirstKey.value = false;
    screenPhase.value = TypingScreenPhase.setup;
  }

  /// Resets this screen to setup (so it's clean if the user returns); the
  /// caller then navigates to the Dashboard.
  void backToDashboardFromResult() => backToSetupFromResult();

  // ---------------------------------------------------------------------
  // Keyboard input — the only place raw key events get translated into
  // engine calls. Guards against typing before start / after completion /
  // while paused are all enforced inside TypingEngine itself; the extra
  // null-checks here just protect against a stray event arriving before
  // an engine exists at all.
  // ---------------------------------------------------------------------

  void onCharacter(String character) =>
      TypingInput.character(_engine, character);

  void onSpace() => TypingInput.space(_engine);

  void onBackspace() => TypingInput.backspace(_engine);

  // ---------------------------------------------------------------------
  // Timer
  // ---------------------------------------------------------------------

  void _startTicker() => _clock.start();

  // ---------------------------------------------------------------------
  // Engine -> controller sync
  // ---------------------------------------------------------------------

  void _onEngineUpdate() {
    if (_isStopping) return;
    _refreshFromEngine();
    if (engine.status == TypingTestStatus.completed) {
      _clock.stop();
      screenPhase.value = TypingScreenPhase.result;
      // Added for Practice + Mistake Analysis, which needs real saved
      // English data to analyze — does not change any existing typing,
      // timer, or result-screen behavior above.
      TypingResultRepository.instance.saveCompletedTest(
        snapshot: engine.snapshot,
        language: TypingLanguage.english,
        kind: TypingTestKind.normal,
        plannedDuration: engine.duration,
        mistakes: engine.mistakes,
      );
    }
  }

  void _refreshFromEngine() {
    final TypingEngine e = engine;
    snapshot.value = e.snapshot;
    wordStatuses.value = e.wordStatuses;
    targetWords.value = e.targetWords;
    committedWordBuffers.value = e.committedWordBuffers;
    currentWordBuffer.value = e.currentWordBuffer;
    isWaitingForFirstKey.value =
        e.status == TypingTestStatus.running && !e.hasTypingStarted;
  }

  void _requestFocusNextFrame() {
    // Settings > Auto Focus: when off, the user clicks the text area.
    if (SettingsController.currentOrNull?.autoFocus == false) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!focusNode.hasFocus) focusNode.requestFocus();
    });
  }

  @override
  void onClose() {
    _clock.stop();
    focusNode.dispose();
    super.onClose();
  }
}