import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'paragraph_difficulty.dart';
import 'typing_screen_phase.dart';
import 'typing_snapshot.dart';
import 'typing_word_status.dart';
import 'urdu_paragraph.dart';

/// The contract both `UrduTypingController` and `PpscTypingController`
/// satisfy. Dart treats matching fields/methods as automatically
/// satisfying an interface's getters/methods, so this exists purely so the
/// Urdu-style setup/live/result widgets can be written once and reused by
/// both the Urdu Typing Test and PPSC Urdu Practice screens instead of
/// being duplicated.
abstract class UrduStyleTypingController {
  FocusNode get focusNode;

  Rx<TypingScreenPhase> get screenPhase;
  Rx<Duration> get selectedDuration;
  Rx<ParagraphDifficulty> get selectedDifficulty;
  Rx<UrduParagraph?> get selectedParagraph;
  RxnString get durationError;
  RxnString get startError;

  Rx<TypingSnapshot> get snapshot;
  RxList<TypingWordStatus> get wordStatuses;
  RxList<String> get targetWords;
  RxList<String> get committedWordBuffers;
  RxString get currentWordBuffer;
  RxBool get isWaitingForFirstKey;

  void selectDuration(Duration duration);
  void selectCustomDurationSeconds(String rawSeconds);
  void selectDifficulty(ParagraphDifficulty difficulty);
  void selectParagraph(UrduParagraph paragraph);
  void shuffleParagraph();

  void startTest();
  void restartTest();
  void tryAgain();
  void stopTest();
  void togglePauseResume();
  void backToSetupFromResult();

  void onCharacter(String character);
  void onSpace();
  void onBackspace();
}