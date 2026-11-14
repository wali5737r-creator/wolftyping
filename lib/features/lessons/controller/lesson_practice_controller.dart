import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../typing_test/model/typing_snapshot.dart';
import '../../typing_test/model/typing_test_status.dart';
import '../../typing_test/model/typing_word_status.dart';
import '../../typing_test/service/typing_engine.dart';
import '../../settings/controller/settings_controller.dart';
import '../../typing_test/service/engine_clock.dart';
import '../../typing_test/service/typing_input.dart';
import '../model/lesson_with_progress.dart';
import '../service/english_lesson_definitions.dart';
import '../service/lesson_repository.dart';

/// Which panel of the Lesson Practice screen is shown.
enum LessonPracticePhase { intro, practice, result }

/// Drives one lesson attempt. Same TypingEngine, same wiring pattern as
/// the Typing Test controllers — the only real differences are: no
/// timer/duration (a lesson completes when its drill text is finished,
/// not when a clock runs out), and on completion the attempt is graded
/// against the lesson's own required accuracy/WPM and saved via
/// [LessonRepository].
class LessonPracticeController extends GetxController {
  final FocusNode focusNode = FocusNode();

  /// The lesson this screen was opened for — passed in as `Get.arguments`
  /// by the Lessons Dashboard when navigating here. NOT final on purpose:
  /// the controller is normally created fresh per navigation (the page
  /// binding disposes it on pop), but if an instance is ever reused
  /// across navigations, [ensureLesson] re-binds it to the lesson the
  /// screen was actually opened for — a stale controller must never
  /// show the previous lesson's content (Urdu Lesson 1 opening with
  /// the English drill, 2026-11-14).
  late LessonWithProgress lesson;

  final Rx<LessonPracticePhase> phase = LessonPracticePhase.intro.obs;
  final RxBool lastAttemptPassed = false.obs;

  @override
  void onInit() {
    super.onInit();
    _bindLessonFromArguments();
  }

  /// Reads the lesson from the current navigation arguments. Falls back
  /// to English Lesson 1 only when no lesson was passed (a bare deep
  /// link) — the same defensive fallback as before.
  void _bindLessonFromArguments() {
    final Object? args = Get.arguments;
    if (args is LessonWithProgress) {
      lesson = args;
    } else {
      // Defensive fallback so a missing/incorrect navigation argument
      // never hard-crashes this screen — should not happen in normal use
      // since the Dashboard always passes a lesson.
      lesson = LessonWithProgress(
        dbId: -1,
        definition: EnglishLessonDefinitions.all.first,
        completed: false,
        bestAccuracy: 0,
        bestSpeed: 0,
        attempts: 0,
        lastAttemptAt: null,
        locked: false,
      );
    }
  }

  /// Re-binds the screen to the lesson of the CURRENT navigation, if it
  /// differs from the one bound at [onInit]. Called from the view's
  /// build — a no-op on every rebuild while the same lesson is open
  /// (same dbId), so mid-practice rebuilds never reset anything. When
  /// the arguments name a different lesson, the in-progress attempt is
  /// discarded (clock stopped, engine dropped, phase back to intro) so
  /// the screen opens the new lesson's intro instead of showing the
  /// old lesson's drill.
  void ensureLesson() {
    final Object? args = Get.arguments;
    if (args is! LessonWithProgress) return;
    if (args.dbId == lesson.dbId) return;
    _clock.stop();
    _engine = null;
    _savedThisAttempt = false;
    snapshot.value = TypingSnapshot.initial();
    wordStatuses.clear();
    targetWords.clear();
    committedWordBuffers.clear();
    currentWordBuffer.value = '';
    lastAttemptPassed.value = false;
    lesson = args;
    phase.value = LessonPracticePhase.intro;
  }

  TypingEngine? _engine;

  TypingEngine get engine {
    final TypingEngine? e = _engine;
    if (e == null) {
      throw StateError(
          'TypingEngine accessed before startPractice() was called');
    }
    return e;
  }

  late final EngineClock _clock =
      EngineClock((Duration delta) => _engine?.advanceTime(delta));
  bool _savedThisAttempt = false;

  final Rx<TypingSnapshot> snapshot = TypingSnapshot.initial().obs;
  final RxList<TypingWordStatus> wordStatuses = <TypingWordStatus>[].obs;
  final RxList<String> targetWords = <String>[].obs;
  final RxList<String> committedWordBuffers = <String>[].obs;
  final RxString currentWordBuffer = ''.obs;

  void startPractice() {
    _clock.stop();
    _savedThisAttempt = false;
    _engine = TypingEngine(
      targetText: lesson.definition.content,
      duration: null, // lessons are untimed — finishing the drill ends it
      onUpdate: _onEngineUpdate,
    );
    _refreshFromEngine();
    phase.value = LessonPracticePhase.practice;
    engine.start();
    _startTicker();
    _requestFocusNextFrame();
  }

  void restartPractice() => startPractice();

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

  void onCharacter(String character) =>
      TypingInput.character(_engine, character);

  void onSpace() => TypingInput.space(_engine);

  void onBackspace() => TypingInput.backspace(_engine);

  void _startTicker() => _clock.start();

  void _onEngineUpdate() {
    _refreshFromEngine();
    if (engine.status == TypingTestStatus.completed && !_savedThisAttempt) {
      _savedThisAttempt = true;
      _clock.stop();

      final bool passed = engine.accuracy >=
              lesson.definition.effectiveRequiredAccuracy &&
          (lesson.definition.requiredWpm == 0 ||
              engine.netWpm >= lesson.definition.requiredWpm);
      lastAttemptPassed.value = passed;

      LessonRepository.instance.saveAttempt(
        lesson: lesson,
        accuracy: engine.accuracy,
        wpm: engine.netWpm,
      );
      phase.value = LessonPracticePhase.result;
    }
  }

  void _refreshFromEngine() {
    final TypingEngine e = engine;
    snapshot.value = e.snapshot;
    wordStatuses.value = e.wordStatuses;
    targetWords.value = e.targetWords;
    committedWordBuffers.value = e.committedWordBuffers;
    currentWordBuffer.value = e.currentWordBuffer;
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
