import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/certificate_code.dart';
import '../model/custom_set.dart';
import '../model/gradebook_entry.dart';
import '../model/mock_attempt.dart';
import '../model/mock_question.dart';
import '../model/mock_test_draft.dart';
import '../model/paper_test.dart';
import '../service/gradebook_repository.dart';
import '../service/mock_progress_repository.dart';
import '../service/mock_questions.dart';
import '../service/mock_test_engine.dart';

enum MockTestPhase { setup, test, result }

enum MockTestKind { full, subject, paper, custom, bookmarked }

/// Drives the PPSC practice MCQ mock test: setup choices (full vs
/// subject-wise, duration, negative marking), the countdown timer with
/// auto-submit, question navigation/answers, and the result + review.
///
/// The question data comes from the sample bank, a paper, a custom
/// set, or the bookmarked questions; the engine ([MockTestEngine])
/// owns all scoring so the rules are unit tested without this
/// controller. Finished attempts are recorded on the device only
/// (see [MockProgressRepository]).
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

  /// Student name for a custom test run, asked before the test starts.
  /// Empty for sample/paper tests, which never ask for a name. When a
  /// name was typed it is the typed name; when left empty it falls
  /// back to 'Student' at result time (see [displayStudentName]).
  final RxString studentName = ''.obs;

  final MockProgressRepository progress = MockProgressRepository.instance;

  /// Futures for in-flight progress writes, so tests can wait for
  /// persistence with [flushProgress] instead of guessing.
  final List<Future<void>> _progressOps = <Future<void>>[];

  /// On-device key for the last mock duration the user chose, so the
  /// setup page remembers it across reloads. 90 minutes stays the
  /// default when nothing was ever chosen (or the stored value is
  /// not a duration this test offers).
  static const String mockDurationStorageKey =
      'wolftyping_mock_duration_minutes';

  @override
  void onInit() {
    super.onInit();
    unawaited(progress.init());
    unawaited(_restoreDuration());
  }

  /// Restores the last chosen duration. A missing or invalid stored
  /// value leaves the 90-minute default untouched, and a storage
  /// failure never blocks the setup page.
  Future<void> _restoreDuration() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? minutes = prefs.getInt(mockDurationStorageKey);
      if (minutes == null) return;
      final Duration saved = Duration(minutes: minutes);
      if (fullDurations.contains(saved)) {
        selectedDuration.value = saved;
      }
    } catch (_) {
      // Keep the 90-minute default.
    }
  }

  /// Persists a chosen duration. A failed write is swallowed:
  /// remembering the choice is a bonus, never a reason to break
  /// choosing one.
  Future<void> _persistDuration(Duration duration) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(mockDurationStorageKey, duration.inMinutes);
    } catch (_) {
      // Best effort only.
    }
  }

  /// Waits for all progress writes started so far to finish.
  Future<void> flushProgress() => Future.wait(_progressOps);

  final RxInt currentIndex = 0.obs;
  final Rx<Duration> remaining = Duration.zero.obs;
  final RxInt answersTick = 0.obs;
  final RxBool autoSubmitted = false.obs;
  final Rxn<MockTestResult> result = Rxn<MockTestResult>();

  MockTestEngine? _engine;
  Timer? _timer;

  /// Seed for this run's per-question option shuffle. Generated once
  /// per run in [startTest] (or restored from the draft in
  /// [resumeTest]) so a resumed test reproduces the exact option
  /// order the user saw — a restored answer still points at the same
  /// option text.
  int _shuffleSeed = 0;

  /// The option-shuffle seed for the current (or most recent) run.
  int get shuffleSeed => _shuffleSeed;

  /// Full-mock durations: the standard 60/90/120 minutes plus short
  /// 5- and 10-minute quick modes — the same 100-question mock, same
  /// negative-marking and auto-submit rules, just less time. The past
  /// paper setup shares this list, so papers offer the same options.
  static const List<Duration> fullDurations = [
    Duration(minutes: 5),
    Duration(minutes: 10),
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
    if (kind.value == MockTestKind.bookmarked) {
      return progress.bookmarks.toList();
    }
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
      return sampleQuestions.where((q) => q.subject == subject.value).toList();
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
  /// In a 5-minute quick test that is true from the start — the
  /// banner then says so (see [timeWarningLabel]) instead of claiming
  /// "only 5 minutes left" at the moment the test began.
  bool get timeWarning {
    return phase.value == MockTestPhase.test &&
        remaining.value > Duration.zero &&
        remaining.value <= const Duration(minutes: 5);
  }

  /// Banner text for the last-5-minutes warning. A short test (5
  /// minutes or less in total) is in its final stretch from the start,
  /// so it names the quick mode instead of the misleading "only 5
  /// minutes left" wording.
  String get timeWarningLabel {
    if (selectedDuration.value <= const Duration(minutes: 5)) {
      return '${selectedDuration.value.inMinutes}-minute quick test — '
          'the test will submit automatically when time ends.';
    }
    return 'Only 5 minutes left! The test will submit automatically '
        'when time ends.';
  }

  String get remainingLabel {
    final Duration d = remaining.value;
    final int minutes = d.inMinutes;
    final int seconds = d.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void selectKind(MockTestKind value) {
    kind.value = value;
    if (value != MockTestKind.custom) studentName.value = '';
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
    studentName.value = '';
    kind.value = MockTestKind.paper;
    subject.value = null;
    selectedDuration.value = const Duration(minutes: 90);
    phase.value = MockTestPhase.setup;
  }

  /// Selects a teacher-created custom set for the next test run. The
  /// setup panel then shows the set's own setup instead of the
  /// sample-test selectors. Negative marking is reset to OFF, the
  /// default for every new test run.
  void selectBookmarked() {
    activePaper.value = null;
    activeCustomSet.value = null;
    studentName.value = '';
    kind.value = MockTestKind.bookmarked;
    subject.value = null;
    selectedDuration.value = const Duration(minutes: 60);
    phase.value = MockTestPhase.setup;
  }

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
    unawaited(_persistDuration(duration));
  }

  void setNegativeMarking(bool value) {
    negativeMarking.value = value;
  }

  void setDeduction(double value) {
    negativeDeduction.value = value;
  }

  /// Name shown with a custom-test result. 'Student' when no name
  /// was typed — never empty, never blocking.
  String get displayStudentName {
    final String name = studentName.value.trim();
    return name.isEmpty ? 'Student' : name;
  }

  /// Label for the current run, used when recording the attempt.
  String get attemptSourceLabel {
    switch (kind.value) {
      case MockTestKind.paper:
        final PaperTest? paper = activePaper.value;
        return paper == null
            ? 'Practice paper'
            : 'Practice Paper ${paper.paperNo}';
      case MockTestKind.custom:
        return activeCustomSet.value?.name ?? 'Custom test';
      case MockTestKind.subject:
        return '${subject.value?.label ?? ''} test';
      case MockTestKind.bookmarked:
        return 'Bookmarked questions';
      case MockTestKind.full:
        return 'Full mock test';
    }
  }

  String get attemptSourceId {
    switch (kind.value) {
      case MockTestKind.paper:
        return activePaper.value?.id ?? 'paper';
      case MockTestKind.custom:
        return activeCustomSet.value?.id ?? 'custom';
      case MockTestKind.subject:
        return subject.value?.name ?? 'subject';
      case MockTestKind.bookmarked:
        return 'bookmarked';
      case MockTestKind.full:
        return 'full';
    }
  }

  /// Per-subject correct/total counts for [result], used to record
  /// the attempt breakdown for the weakest-subject hint.
  Map<String, Map<String, int>> _subjectBreakdown(MockTestResult result) {
    final Map<String, int> correct = {};
    final Map<String, int> total = {};
    for (final MockQuestion q in result.questions) {
      total[q.subject.name] = (total[q.subject.name] ?? 0) + 1;
      if (q.isCorrect(result.answers[q.id])) {
        correct[q.subject.name] = (correct[q.subject.name] ?? 0) + 1;
      }
    }
    return {'correct': correct, 'total': total};
  }

  void startTest() {
    final List<MockQuestion> questions = availableQuestions;
    if (questions.isEmpty) return;
    // Fresh start for a paper discards any unfinished draft for that
    // paper first: the new run replaces it, it is not resumed. The
    // in-memory removal happens synchronously inside deleteDraft once
    // storage has loaded, so no later autosave can resurrect it; the
    // write itself is tracked in [_progressOps] like every other
    // progress write.
    if (kind.value == MockTestKind.paper && activePaper.value != null) {
      final Future<void> op = progress.deleteDraft(activePaper.value!.id);
      _progressOps.add(op);
      unawaited(op.then((_) => _progressOps.remove(op)));
    }
    // Shuffle each question's option order for this run only, so the
    // correct answer does not sit in a predictable A/B/C/D position
    // (paper keys skew heavily to one position). Question order,
    // paper files and custom-set data are untouched; only the
    // in-session copies are shuffled, with correctIndex remapped.
    // The shuffle is seeded per run ([_shuffleSeed]) so a mid-test
    // draft can reproduce this exact order on resume; the randomness
    // itself is unchanged, just reproducible.
    _shuffleSeed = Random().nextInt(1 << 32);
    final Random random = Random(_shuffleSeed);
    final List<MockQuestion> sessionQuestions = <MockQuestion>[
      for (final MockQuestion q in questions) q.withShuffledOptions(random),
    ];
    _engine = MockTestEngine(
      questions: sessionQuestions,
      negativeMarking: negativeMarking.value,
      negativeDeduction: negativeDeduction.value,
    );
    currentIndex.value = 0;
    answersTick.value = 0;
    autoSubmitted.value = false;
    result.value = null;
    remaining.value = selectedDuration.value;
    phase.value = MockTestPhase.test;
    _startTimer();
  }

  /// Restores a paper test from a mid-test [draft] saved by
  /// [_saveDraft]: same paper, same shuffled option order (via the
  /// draft's seed), same answers, remaining time and current
  /// question. Returns true when the test is running again.
  ///
  /// Returns false — and deletes the stale draft — when the draft is
  /// unusable: no paper is selected, the paper id does not match the
  /// selected paper, or the paper has no questions. (There is no
  /// paper lookup by id in the papers registry, so the caller must
  /// have selected the paper first, e.g. via [selectPaper]; both UI
  /// resume paths do.) A stale draft never crashes: answers for
  /// removed questions are dropped, out-of-range options, question
  /// index and remaining time are clamped to the paper as it is now.
  Future<bool> resumeTest(MockTestDraft draft) async {
    final PaperTest? paper = activePaper.value;
    if (paper == null || paper.id != draft.paperId || paper.questions.isEmpty) {
      final Future<void> op = progress.deleteDraft(draft.paperId);
      _progressOps.add(op);
      unawaited(op.then((_) => _progressOps.remove(op)));
      return false;
    }
    if (phase.value != MockTestPhase.setup) return false;
    // The planned duration may be a custom/paper duration that is
    // not in [fullDurations] — use it as-is, never force it into
    // the list. A missing/invalid planned duration falls back to
    // the 90-minute default.
    final int plannedSeconds = draft.plannedDurationSeconds > 0
        ? draft.plannedDurationSeconds
        : const Duration(minutes: 90).inSeconds;
    kind.value = MockTestKind.paper;
    selectedDuration.value = Duration(seconds: plannedSeconds);
    negativeMarking.value = draft.negativeMarking;
    negativeDeduction.value = draft.negativeDeduction;
    _shuffleSeed = draft.shuffleSeed;
    final Random random = Random(_shuffleSeed);
    final List<MockQuestion> sessionQuestions = <MockQuestion>[
      for (final MockQuestion q in paper.questions)
        q.withShuffledOptions(random),
    ];
    _engine = MockTestEngine(
      questions: sessionQuestions,
      negativeMarking: negativeMarking.value,
      negativeDeduction: negativeDeduction.value,
    );
    final Set<String> ids = <String>{
      for (final MockQuestion q in sessionQuestions) q.id,
    };
    for (final MapEntry<String, int> entry in draft.answers.entries) {
      if (ids.contains(entry.key) && entry.value >= 0 && entry.value <= 3) {
        _engine!.answer(entry.key, entry.value);
      }
    }
    final int clampedIndex = draft.currentIndex < 0
        ? 0
        : (draft.currentIndex >= sessionQuestions.length
            ? sessionQuestions.length - 1
            : draft.currentIndex);
    currentIndex.value = clampedIndex;
    answersTick.value++;
    autoSubmitted.value = false;
    result.value = null;
    final int clampedRemaining = draft.remainingSeconds < 0
        ? 0
        : (draft.remainingSeconds > plannedSeconds
            ? plannedSeconds
            : draft.remainingSeconds);
    remaining.value = Duration(seconds: clampedRemaining);
    phase.value = MockTestPhase.test;
    _startTimer();
    return true;
  }

  /// Starts (or restarts) the 1-second countdown. At zero it
  /// auto-submits, which also clears the paper draft (see [submit]).
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining.value <= const Duration(seconds: 1)) {
        remaining.value = Duration.zero;
        submit(auto: true);
        return;
      }
      remaining.value = remaining.value - const Duration(seconds: 1);
      // Throttled autosave: a draft write every 10 seconds of test
      // time, never on every tick.
      if (remaining.value.inSeconds % 10 == 0) _saveDraft();
    });
  }

  /// Saves the current paper test as a resumable draft — only while
  /// a paper test is running. Writes are async and never block the
  /// caller (or the timer), and never throw into it; they are tracked
  /// in [_progressOps] so tests can await them with [flushProgress].
  void _saveDraft() {
    try {
      if (phase.value != MockTestPhase.test) return;
      if (kind.value != MockTestKind.paper) return;
      final MockTestEngine? engine = _engine;
      final PaperTest? paper = activePaper.value;
      if (engine == null || paper == null) return;
      final MockTestDraft draft = MockTestDraft(
        paperId: paper.id,
        answers: engine.answers,
        remainingSeconds: remaining.value.inSeconds,
        currentIndex: currentIndex.value,
        shuffleSeed: _shuffleSeed,
        plannedDurationSeconds: selectedDuration.value.inSeconds,
        negativeMarking: negativeMarking.value,
        negativeDeduction: negativeDeduction.value,
        totalQuestions: engine.totalQuestions,
        savedAt: DateTime.now().millisecondsSinceEpoch,
      );
      final Future<void> op = progress.saveDraft(draft);
      _progressOps.add(op);
      unawaited(op.then((_) => _progressOps.remove(op)));
    } catch (_) {
      // Autosave is a bonus: a draft failure must never break a
      // running test.
    }
  }

  void goToQuestion(int index) {
    if (_engine == null) return;
    if (index < 0 || index >= engine.totalQuestions) return;
    currentIndex.value = index;
    _saveDraft();
  }

  void nextQuestion() => goToQuestion(currentIndex.value + 1);

  void previousQuestion() => goToQuestion(currentIndex.value - 1);

  void selectOption(int optionIndex) {
    if (_engine == null) return;
    engine.answer(engine.questions[currentIndex.value].id, optionIndex);
    answersTick.value++;
    _saveDraft();
  }

  /// Answers [question] with [optionIndex], for the column view where
  /// every question is visible at once. The one-at-a-time panel uses
  /// [selectOption] (current question) instead; both write to the
  /// same engine answers map.
  void selectOptionFor(MockQuestion question, int optionIndex) {
    if (_engine == null) return;
    engine.answer(question.id, optionIndex);
    answersTick.value++;
    _saveDraft();
  }

  void clearAnswerFor(MockQuestion question) {
    if (_engine == null) return;
    engine.clearAnswer(question.id);
    answersTick.value++;
    _saveDraft();
  }

  bool isBookmarked(MockQuestion question) =>
      progress.isBookmarked(question.id);

  /// Toggles a bookmark for [question] in the end review. Returns
  /// true when the question is bookmarked afterwards.
  Future<bool> toggleBookmark(MockQuestion question) async {
    final Future<bool> op = progress.toggleBookmark(question);
    final bool bookmarked = await op;
    answersTick.value++;
    return bookmarked;
  }

  /// Weakest subjects from recorded attempts, weakest first. Empty
  /// when no attempts have enough questions yet — the UI must show
  /// no hint (or a neutral prompt), never invented data.
  List<SubjectAttemptStats> get weakestSubjects => progress.weakestSubjects();

  void clearCurrentAnswer() {
    if (_engine == null) return;
    engine.clearAnswer(engine.questions[currentIndex.value].id);
    answersTick.value++;
    _saveDraft();
  }

  int? selectedFor(MockQuestion question) => engine.answerFor(question.id);

  List<MockQuestion> get unansweredQuestions => _engine?.unanswered ?? const [];

  /// Finishes the test and computes the result. [auto] is true only
  /// when the countdown reached zero.
  void submit({bool auto = false}) {
    if (_engine == null || phase.value != MockTestPhase.test) return;
    _timer?.cancel();
    _timer = null;
    autoSubmitted.value = auto;
    final MockTestResult finished = engine.result();
    result.value = finished;
    phase.value = MockTestPhase.result;
    final Map<String, Map<String, int>> breakdown = _subjectBreakdown(finished);
    // Planned duration and time actually spent: History shows both,
    // and the planned duration is what its duration filter matches.
    // `remaining` is already zero on an auto-submit, so elapsed is
    // the full planned duration there.
    final int plannedSeconds = selectedDuration.value.inSeconds;
    final int elapsedSeconds =
        (plannedSeconds - remaining.value.inSeconds).clamp(0, plannedSeconds);
    final MockAttempt attempt = MockAttempt(
      id: 'attempt-${DateTime.now().microsecondsSinceEpoch}',
      sourceKind: kind.value.name,
      sourceId: attemptSourceId,
      sourceLabel: attemptSourceLabel,
      totalQuestions: finished.totalQuestions,
      correct: finished.correct,
      wrong: finished.wrong,
      skipped: finished.skipped,
      score: finished.score,
      attemptedAt: DateTime.now(),
      durationSeconds: plannedSeconds,
      actualDurationSeconds: elapsedSeconds,
      perSubjectCorrect: breakdown['correct'] ?? const {},
      perSubjectTotal: breakdown['total'] ?? const {},
    );
    final Future<void> op = progress.recordAttempt(attempt);
    _progressOps.add(op);
    unawaited(op.then((_) => _progressOps.remove(op)));
    // A finished paper test clears its mid-test draft — submitted
    // (manually or automatically) means there is nothing to resume.
    if (kind.value == MockTestKind.paper) {
      final Future<void> draftOp = progress.deleteDraft(attemptSourceId);
      _progressOps.add(draftOp);
      unawaited(draftOp.then((_) => _progressOps.remove(draftOp)));
    }
    // A finished custom test is recorded in the gradebook
    // automatically, under the custom set's name. The entry IS a
    // mock-kind certificate code (WT1), so the same code dedupes:
    // re-taking with the same result never records twice.
    if (kind.value == MockTestKind.custom && activeCustomSet.value != null) {
      unawaited(_recordCustomResultInGradebook(finished));
    }
  }

  /// Builds the WT1 code for a finished custom test and records it.
  /// Never throws into [submit]: a too-long test name (over the
  /// certificate label limit) simply skips the gradebook entry.
  Future<void> _recordCustomResultInGradebook(MockTestResult finished) async {
    final CustomSet? set = activeCustomSet.value;
    if (set == null) return;
    try {
      final CertificateData data = CertificateData(
        kind: CertificateKind.mock,
        testLabel: set.name,
        holderName: displayStudentName,
        date: DateTime.now(),
        score: finished.score,
        totalQuestions: finished.totalQuestions,
        correct: finished.correct,
        wrong: finished.wrong,
        skipped: finished.skipped,
        accuracy: 0,
      );
      final String code = encodeCertificateCode(data);
      await GradebookRepository.instance.recordEntry(
        GradebookEntry.fromCertificateData(
          data,
          code,
          source: 'this device',
        ),
      );
    } catch (_) {
      // Gradebook recording is a bonus, never a reason to fail a
      // finished test.
    }
  }

  /// Leaves the test for the setup panel. The timer stops and the
  /// engine is dropped, but a paper draft is NOT deleted: leaving
  /// mid-test is exactly how a draft is made, and the user can resume
  /// it later from the paper row or the setup panel.
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
