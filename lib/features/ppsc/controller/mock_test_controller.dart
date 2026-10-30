import 'dart:async';

import 'package:get/get.dart';

import '../model/custom_set.dart';
import '../model/mock_question.dart';
import '../model/paper_test.dart';
import '../service/mock_questions.dart';
import '../service/mock_test_engine.dart';

enum MockTestPhase { setup, test, result }

enum MockTestKind { full, subject, paper, custom }

/// Drives the PPSC practice MCQ mock test: setup choices (full vs
/// subject-wise, duration, negative marking), the countdown timer with
/// auto-submit, question navigation/answers, and the result + review.
///
/// The question data comes only from [sampleQuestions]; the engine
/// ([MockTestEngine]) owns all scoring so the rules are unit tested
/// without this controller.
class MockTestController extends GetxController {
  final Rx<MockTestPhase> phase = MockTestPhase.setup.obs;
  final Rx<MockTestKind> kind = MockTestKind.full.obs;
  final Rxn<MockSubject> subject = Rxn<MockSubject>();

  /// The past paper selected from the papers list, when [kind] is
  /// [MockTestKind.paper]. Null for sample (full/subject) tests.
  final Rxn<PaperTest> activePaper = Rxn<PaperTest>();

  /// The teacher-created custom set selected from the custom tests
  /// list, when [kind] is [MockTestKind.custom]. Null otherwise. Runs
  /// through the same engine, timer, palette and review as every
  /// other kind.
  final Rxn<CustomSet> activeCustomSet = Rxn<CustomSet>();
  final Rx<Duration> selectedDuration = const Duration(minutes: 90).obs;
  final RxBool negativeMarking = false.obs;
  final RxDouble negativeDeduction = 0.25.obs;

  final RxInt currentIndex = 0.obs;
  final Rx<Duration> remaining = Duration.zero.obs;
  final RxInt answersTick = 0.obs;
  final RxBool autoSubmitted = false.obs;
  final Rxn<MockTestResult> result = Rxn<MockTestResult>();

  MockTestEngine? _engine;
  Timer? _timer;

  static const List<Duration> fullDurations = [
    Duration(minutes: 60),
    Duration(minutes: 90),
    Duration(minutes: 120),
  ];

  static const List<Duration> subjectDurations = [
    Duration(minutes: 60),
    Duration(minutes: 90),
    Duration(minutes: 120),
  ];

  static const List<double> deductionOptions = [0.25, 0.5, 1.0];

  /// Durations offered for custom sets: short teacher sets suit the
  /// short options, longer ones the full-test options.
  static const List<Duration> customDurations = [
    Duration(minutes: 15),
    Duration(minutes: 20),
    Duration(minutes: 30),
    Duration(minutes: 60),
    Duration(minutes: 90),
    Duration(minutes: 120),
  ];

  /// Balanced 100-question set for the full mock test: questions are
  /// taken round-robin across the 6 subjects in bank order, so each
  /// subject contributes 16–17 questions and no question repeats.
  static List<MockQuestion> get fullTestQuestions {
    final Map<MockSubject, List<MockQuestion>> bySubject = {
      for (final s in MockSubject.values)
        s: sampleQuestions.where((q) => q.subject == s).toList(),
    };
    final List<MockQuestion> result = [];
    var index = 0;
    while (result.length < 100) {
      var progressed = false;
      for (final s in MockSubject.values) {
        if (result.length >= 100) break;
        final List<MockQuestion> list = bySubject[s]!;
        if (index < list.length) {
          result.add(list[index]);
          progressed = true;
        }
      }
      if (!progressed) break;
      index++;
    }
    return result;
  }

  /// Questions available for the currently selected kind/subject/paper
  /// /custom set. The full test draws the balanced 100, not the whole bank.
  List<MockQuestion> get availableQuestions {
    if (kind.value == MockTestKind.paper) {
      return activePaper.value?.questions ?? const [];
    }
    if (kind.value == MockTestKind.custom) {
      return activeCustomSet.value?.questions ?? const [];
    }
    if (kind.value == MockTestKind.full) {
      return fullTestQuestions;
    }
    if (kind.value == MockTestKind.subject && subject.value != null) {
      return sampleQuestions
          .where((q) => q.subject == subject.value)
          .toList();
    }
    return sampleQuestions;
  }

  /// Latest-update notes for the active paper, if any. Shown in the end
  /// review so current-affairs answers carry the latest position.
  List<String> get activeLatestUpdates =>
      activePaper.value?.latestUpdates ?? const [];

  MockTestEngine get engine {
    final MockTestEngine? e = _engine;
    if (e == null) {
      throw StateError('MockTestEngine accessed before startTest()');
    }
    return e;
  }

  /// True while the test is running and 5 minutes or less remain.
  bool get timeWarning {
    return phase.value == MockTestPhase.test &&
        remaining.value > Duration.zero &&
        remaining.value <= const Duration(minutes: 5);
  }

  String get remainingLabel {
    final Duration d = remaining.value;
    final int minutes = d.inMinutes;
    final int seconds = d.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void selectKind(MockTestKind value) {
    kind.value = value;
    if (value == MockTestKind.paper || value == MockTestKind.custom) return;
    activePaper.value = null;
    activeCustomSet.value = null;
    if (value == MockTestKind.full) {
      subject.value = null;
      selectedDuration.value = const Duration(minutes: 90);
    } else {
      subject.value ??= MockSubject.english;
      selectedDuration.value = const Duration(minutes: 90);
    }
  }

  /// Selects a past paper for the next test run. The setup panel then
  /// shows the paper's own setup (title, date, question count) instead
  /// of the sample-test selectors.
  void selectPaper(PaperTest paper) {
    activePaper.value = paper;
    activeCustomSet.value = null;
    kind.value = MockTestKind.paper;
    subject.value = null;
    selectedDuration.value = const Duration(minutes: 90);
    phase.value = MockTestPhase.setup;
  }

  /// Selects a teacher-created custom set for the next test run. The
  /// setup panel then shows the set's own setup instead of the
  /// sample-test selectors. Negative marking is reset to OFF, the
  /// default for every new test run.
  void selectCustomSet(CustomSet set) {
    activeCustomSet.value = set;
    activePaper.value = null;
    kind.value = MockTestKind.custom;
    subject.value = null;
    selectedDuration.value = set.questions.length <= 20
        ? const Duration(minutes: 20)
        : const Duration(minutes: 60);
    negativeMarking.value = false;
    negativeDeduction.value = 0.25;
    phase.value = MockTestPhase.setup;
  }

  void selectSubject(MockSubject value) {
    subject.value = value;
    kind.value = MockTestKind.subject;
    if (!subjectDurations.contains(selectedDuration.value)) {
      selectedDuration.value = const Duration(minutes: 90);
    }
  }

  void selectDuration(Duration duration) {
    selectedDuration.value = duration;
  }

  void setNegativeMarking(bool value) {
    negativeMarking.value = value;
  }

  void setDeduction(double value) {
    negativeDeduction.value = value;
  }

  void startTest() {
    final List<MockQuestion> questions = availableQuestions;
    if (questions.isEmpty) return;
    _engine = MockTestEngine(
      questions: questions,
      negativeMarking: negativeMarking.value,
      negativeDeduction: negativeDeduction.value,
    );
    currentIndex.value = 0;
    answersTick.value = 0;
    autoSubmitted.value = false;
    result.value = null;
    remaining.value = selectedDuration.value;
    phase.value = MockTestPhase.test;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining.value <= const Duration(seconds: 1)) {
        remaining.value = Duration.zero;
        submit(auto: true);
        return;
      }
      remaining.value = remaining.value - const Duration(seconds: 1);
    });
  }

  void goToQuestion(int index) {
    if (_engine == null) return;
    if (index < 0 || index >= engine.totalQuestions) return;
    currentIndex.value = index;
  }

  void nextQuestion() => goToQuestion(currentIndex.value + 1);

  void previousQuestion() => goToQuestion(currentIndex.value - 1);

  void selectOption(int optionIndex) {
    if (_engine == null) return;
    engine.answer(engine.questions[currentIndex.value].id, optionIndex);
    answersTick.value++;
  }

  void clearCurrentAnswer() {
    if (_engine == null) return;
    engine.clearAnswer(engine.questions[currentIndex.value].id);
    answersTick.value++;
  }

  int? selectedFor(MockQuestion question) => engine.answerFor(question.id);

  List<MockQuestion> get unansweredQuestions =>
      _engine?.unanswered ?? const [];

  /// Finishes the test and computes the result. [auto] is true only
  /// when the countdown reached zero.
  void submit({bool auto = false}) {
    if (_engine == null || phase.value != MockTestPhase.test) return;
    _timer?.cancel();
    _timer = null;
    autoSubmitted.value = auto;
    result.value = engine.result();
    phase.value = MockTestPhase.result;
  }

  void backToSetup() {
    _timer?.cancel();
    _timer = null;
    _engine = null;
    phase.value = MockTestPhase.setup;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
