import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../settings/controller/settings_controller.dart';
import '../../typing_test/model/paragraph_difficulty.dart';
import '../../typing_test/model/typing_language.dart';
import '../model/character_mistake_stat.dart';
import '../model/key_strength.dart';
import '../model/mistake_analysis_summary.dart';
import '../model/mistake_practice_args.dart';
import '../model/practice_mode.dart';
import '../service/mistake_analysis_service.dart';
import '../service/practice_content_generator.dart';

/// Drives the Practice Dashboard: language filter, the loaded mistake
/// analysis summary, keyboard heatmap lookups, and starting any of the
/// five practice modes. All aggregation happens in
/// MistakeAnalysisService; all drill-content generation happens in
/// PracticeContentGenerator — this controller only wires the two
/// together and holds the reactive state the view reads.
class PracticeController extends GetxController {
  final Rx<TypingLanguage> selectedLanguage = TypingLanguage.english.obs;
  final RxBool isLoading = false.obs;
  final Rx<MistakeAnalysisSummary> summary = Rx<MistakeAnalysisSummary>(
    const MistakeAnalysisSummary(
      totalMistakes: 0,
      wrongCharacters: 0,
      wrongWords: 0,
      skippedWords: 0,
      backspaces: 0,
      weakestCharacters: [],
      weakestWords: [],
      mostSkippedWords: [],
      recentMistakes: [],
      completedTestCount: 0,
    ),
  );

  @override
  void onInit() {
    super.onInit();
    loadAnalysis();
    ever(selectedLanguage, (_) => loadAnalysis());
  }

  Future<void> loadAnalysis() async {
    isLoading.value = true;
    try {
      summary.value = await MistakeAnalysisService.instance
          .analyze(selectedLanguage.value);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Future<void> refresh() => loadAnalysis();

  void selectLanguage(TypingLanguage language) {
    if (selectedLanguage.value == language) return;
    selectedLanguage.value = language;
  }

  // ---------------------------------------------------------------------
  // Keyboard heatmap lookups
  // ---------------------------------------------------------------------

  CharacterMistakeStat? statForKey(String keyLabel) {
    final String target = keyLabel.toLowerCase();
    for (final CharacterMistakeStat c in summary.value.weakestCharacters) {
      if (c.character.toLowerCase() == target) return c;
    }
    return null;
  }

  KeyStrength strengthForKey(String keyLabel) =>
      KeyStrengthThresholds.classify(statForKey(keyLabel)?.count ?? 0);

  // ---------------------------------------------------------------------
  // Starting a practice attempt
  // ---------------------------------------------------------------------

  Future<void> startQuickPractice() async {
    final String content = PracticeContentGenerator.quickPractice(
        summary.value, selectedLanguage.value);
    await _navigateToPractice(
      PracticeMode.quick,
      content,
      summary.value.weakestCharacters
          .take(3)
          .map((c) => c.character)
          .toList(),
    );
  }

  Future<void> startCharacterPractice() async {
    final List<String> chars = summary.value.weakestCharacters
        .take(6)
        .map((c) => c.character)
        .toList();
    final String content = PracticeContentGenerator.characterPractice(
        summary.value.weakestCharacters, selectedLanguage.value);
    await _navigateToPractice(PracticeMode.character, content, chars);
  }

  Future<void> startWordPractice() async {
    final String content = PracticeContentGenerator.wordPractice(
        summary.value.weakestWords, selectedLanguage.value);
    await _navigateToPractice(PracticeMode.word, content, const []);
  }

  Future<void> startSkippedWordPractice() async {
    final String content = PracticeContentGenerator.wordPractice(
        summary.value.mostSkippedWords, selectedLanguage.value);
    await _navigateToPractice(PracticeMode.skippedWord, content, const []);
  }

  /// Settings > Practice difficulty -> paragraph tier for General Practice.
  ParagraphDifficulty _practiceDifficulty() {
    switch (SettingsController.currentOrNull?.practiceDifficulty) {
      case 'intermediate':
        return ParagraphDifficulty.medium;
      case 'advanced':
        return ParagraphDifficulty.hard;
      default:
        return ParagraphDifficulty.easy;
    }
  }

  Future<void> startGeneralPractice() async {
    final String content = PracticeContentGenerator.generalPractice(
      selectedLanguage.value,
      difficulty: _practiceDifficulty(),
    );
    await _navigateToPractice(PracticeMode.general, content, const []);
  }

  /// Practices exactly one character (spec section 11: "[Practice This
  /// Key]" from the mistake detail view) rather than the dashboard's
  /// usual top-6 weak characters.
  Future<void> startPracticeForCharacter(String character) async {
    final CharacterMistakeStat? existing = statForKey(character);
    final List<CharacterMistakeStat> single = [
      existing ??
          CharacterMistakeStat(
            character: character,
            count: 0,
            lastMistakeAt: null,
            commonWrongInputs: const {},
          ),
    ];
    final String content =
        PracticeContentGenerator.characterPractice(single, selectedLanguage.value);
    await _navigateToPractice(PracticeMode.character, content, [character]);
  }

  Future<void> _navigateToPractice(
    PracticeMode mode,
    String content,
    List<String> practicedCharacters,
  ) async {
    await Get.toNamed(
      AppRoutes.mistakePractice,
      arguments: MistakePracticeArgs(
        language: selectedLanguage.value,
        mode: mode,
        content: content,
        practicedCharacters: practicedCharacters,
      ),
    );
    refresh();
  }
}
