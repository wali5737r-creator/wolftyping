import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../typing_test/model/paragraph_difficulty.dart';
import '../../typing_test/model/typing_durations.dart';
import '../../typing_test/model/typing_language.dart';
import '../../typing_test/model/typing_screen_phase.dart';
import '../../typing_test/model/typing_snapshot.dart';
import '../../typing_test/model/typing_test_kind.dart';
import '../../typing_test/model/typing_test_status.dart';
import '../../typing_test/model/typing_word_status.dart';
import '../../typing_test/model/urdu_paragraph.dart';
import '../../typing_test/model/urdu_style_typing_controller.dart';
import '../../typing_test/service/paragraph_continuation.dart';
import '../../typing_test/service/typing_engine.dart';
import '../../settings/controller/settings_controller.dart';
import '../service/engine_clock.dart';
import '../service/typing_input.dart';
import '../../typing_test/service/typing_result_repository.dart';
import '../../typing_test/service/urdu_paragraph_provider.dart';

/// Urdu equivalent of the English `TypingController`. Same wiring, same
/// TypingEngine, same calculation rules — the only differences are the
/// paragraph source (Urdu) and that a completed attempt is saved to the
/// database with `language = ur`, `testType = test`.
class UrduTypingController extends GetxController
    implements UrduStyleTypingController {
  @override
  final FocusNode focusNode = FocusNode();

  @override
  final Rx<TypingScreenPhase> screenPhase = TypingScreenPhase.setup.obs;
  @override
  final Rx<Duration> selectedDuration = TypingDurations.minute1.obs;
  @override
  final Rx<ParagraphDifficulty> selectedDifficulty =
      ParagraphDifficulty.easy.obs;
  @override
  final Rx<UrduParagraph?> selectedParagraph = Rx<UrduParagraph?>(null);

  @override
  final RxnString durationError = RxnString();
  @override
  final RxnString startError = RxnString();

  @override
  void onInit() {
    super.onInit();
    // Settings > Default duration.
    selectedDuration.value = TypingDurations.initialFor(
        SettingsController.currentOrNull?.defaultDurationSeconds);
    final Object? args = Get.arguments;
    if (args is UrduParagraph) {
      selectedParagraph.value = args;
      selectedDifficulty.value = args.difficulty;
    } else {
      selectedParagraph.value =
          UrduParagraphProvider.randomOf(selectedDifficulty.value);
    }
  }

  @override
  void selectDuration(Duration duration) {
    durationError.value = null;
    selectedDuration.value = duration;
  }

  @override
  void selectCustomDurationSeconds(String rawSeconds) {
    final int? seconds = int.tryParse(rawSeconds.trim());
    if (seconds == null || seconds <= 0) {
      durationError.value = 'Enter a whole number of seconds greater than 0.';
      return;
    }
    durationError.value = null;
    selectedDuration.value = Duration(seconds: seconds);
  }

  @override
  void selectDifficulty(ParagraphDifficulty difficulty) {
    selectedDifficulty.value = difficulty;
    selectedParagraph.value = UrduParagraphProvider.randomOf(difficulty);
  }

  @override
  void selectParagraph(UrduParagraph paragraph) {
    selectedParagraph.value = paragraph;
  }

  @override
  void shuffleParagraph() {
    selectedParagraph.value =
        UrduParagraphProvider.randomOf(selectedDifficulty.value);
  }

  TypingEngine? _engine;

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

  @override
  final Rx<TypingSnapshot> snapshot = TypingSnapshot.initial().obs;
  @override
  final RxList<TypingWordStatus> wordStatuses = <TypingWordStatus>[].obs;
  @override
  final RxList<String> targetWords = <String>[].obs;
  @override
  final RxList<String> committedWordBuffers = <String>[].obs;
  @override
  final RxString currentWordBuffer = ''.obs;

  /// True jab test running hai lekin user ne abhi pehla character nahi
  /// likha.
  @override
  final RxBool isWaitingForFirstKey = false.obs;

  @override
  void startTest() {
    final UrduParagraph? paragraph = selectedParagraph.value;
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
      continuation: ParagraphContinuation<UrduParagraph>(
        started: paragraph,
        textOf: (p) => p.text,
        builtInPool: UrduParagraphProvider.byDifficulty(paragraph.difficulty),
      ).next,
    );
    _refreshFromEngine();
    screenPhase.value = TypingScreenPhase.test;
    engine.start();
    _startTicker();
    _requestFocusNextFrame();
  }

  @override
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

  @override
  void tryAgain() {
    // Keep the source of the test: a paragraph from My Paragraphs is run
    // again as-is; a built-in paragraph gets a fresh one of the same
    // difficulty.
    final UrduParagraph? current = selectedParagraph.value;
    final bool isBuiltIn = current != null &&
        UrduParagraphProvider.byDifficulty(current.difficulty)
            .any((p) => p.text == current.text);
    if (isBuiltIn) shuffleParagraph();
    startTest();
  }

  @override
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

  @override
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

  @override
  void backToSetupFromResult() {
    _clock.stop();
    _engine = null;
    isWaitingForFirstKey.value = false;
    screenPhase.value = TypingScreenPhase.setup;
  }

  @override
  void onCharacter(String character) =>
      TypingInput.character(_engine, character);

  @override
  void onSpace() => TypingInput.space(_engine);

  @override
  void onBackspace() => TypingInput.backspace(_engine);

  void _startTicker() => _clock.start();

  void _onEngineUpdate() {
    if (_isStopping) return;
    _refreshFromEngine();
    if (engine.status == TypingTestStatus.completed) {
      _clock.stop();
      screenPhase.value = TypingScreenPhase.result;
      TypingResultRepository.instance.saveCompletedTest(
        snapshot: engine.snapshot,
        language: TypingLanguage.urdu,
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