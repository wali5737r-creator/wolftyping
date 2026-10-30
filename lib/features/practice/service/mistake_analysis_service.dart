import 'package:get/get.dart';

import '../../../core/database/app_database.dart';
import '../../typing_test/model/typing_language.dart';
import '../model/character_mistake_stat.dart';
import '../model/mistake_analysis_input.dart';
import '../model/mistake_analysis_summary.dart';
import '../model/word_mistake_stat.dart';

/// Turns raw `TypingTests`/`Mistakes` rows into the aggregated stats the
/// Practice Dashboard and Keyboard Heatmap display.
///
/// The actual aggregation logic lives in the static [aggregate] method,
/// which takes plain [TestMistakeInput]/[MistakeRowInput] DTOs instead of
/// Drift row types -- this is what lets it be unit tested (see
/// test/mistake_analysis_service_test.dart) without a live database.
/// [analyze] is the thin, database-backed wrapper the app actually calls.
///
/// `Mistakes` has no timestamp of its own -- "last mistake" is
/// approximated from the parent test's `completedAt`, which is accurate
/// enough for display purposes without adding another column (spec:
/// "smallest possible schema change" -- we already added `isWrongWord`).
class MistakeAnalysisService {
  MistakeAnalysisService._();
  static final MistakeAnalysisService instance = MistakeAnalysisService._();

  AppDatabase get _db => Get.find<AppDatabase>();

  static const int maxWeakCharacters = 40;
  static const int maxWeakWords = 30;
  static const int maxRecentMistakes = 15;

  /// Analyzes every completed test for [language]. PPSC Urdu tests share
  /// `language = 'ur'` with the plain Urdu Typing Test, so they are
  /// naturally included together here -- never mixed with English (spec
  /// section 14).
  Future<MistakeAnalysisSummary> analyze(TypingLanguage language) async {
    final testRows = await (_db.select(_db.typingTests)
          ..where((t) => t.language.equals(language.code)))
        .get();

    if (testRows.isEmpty) {
      return MistakeAnalysisService.aggregate(const [], const []);
    }

    final Set<int> testIds = testRows.map((t) => t.id).toSet();
    final mistakeRows = await (_db.select(_db.mistakes)
          ..where((m) => m.testId.isIn(testIds)))
        .get();

    return MistakeAnalysisService.aggregate(
      [
        for (final t in testRows)
          TestMistakeInput(
            id: t.id,
            backspaces: t.backspaces,
            wrongWords: t.wrongWords,
            skippedWords: t.skippedWords,
            completedAt: t.completedAt,
          ),
      ],
      [
        for (final m in mistakeRows)
          MistakeRowInput(
            id: m.id,
            testId: m.testId,
            expectedCharacter: m.expectedCharacter,
            typedCharacter: m.typedCharacter,
            isSkippedWord: m.isSkippedWord,
            isWrongWord: m.isWrongWord,
          ),
      ],
    );
  }

  /// Pure aggregation -- no database, no Flutter, no GetX. Given every
  /// completed test and every mistake row for one language, produces the
  /// full dashboard summary: character frequency, word frequency, skipped
  /// word frequency, and recent-mistakes ordering.
  static MistakeAnalysisSummary aggregate(
    List<TestMistakeInput> tests,
    List<MistakeRowInput> mistakes,
  ) {
    if (tests.isEmpty) {
      return const MistakeAnalysisSummary(
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
      );
    }

    final Map<int, DateTime> completedAtByTestId = {
      for (final t in tests) t.id: t.completedAt,
    };

    final int backspaces = tests.fold<int>(0, (sum, t) => sum + t.backspaces);
    final int wrongWordsTotal =
        tests.fold<int>(0, (sum, t) => sum + t.wrongWords);
    final int skippedWordsTotal =
        tests.fold<int>(0, (sum, t) => sum + t.skippedWords);

    final Map<String, int> charCounts = {};
    final Map<String, Map<String, int>> charWrongInputs = {};
    final Map<String, DateTime> charLast = {};

    final Map<String, int> wordMistakeCounts = {};
    final Map<String, int> wordSkipCounts = {};
    final Map<String, DateTime> wordLast = {};

    final List<_TimedMistakeLine> recentLines = [];

    for (final m in mistakes) {
      final DateTime? testTime = completedAtByTestId[m.testId];

      if (m.isSkippedWord) {
        wordSkipCounts[m.expectedCharacter] =
            (wordSkipCounts[m.expectedCharacter] ?? 0) + 1;
        _bumpLast(wordLast, m.expectedCharacter, testTime);
        recentLines.add(_TimedMistakeLine(
          time: testTime,
          id: m.id,
          text: 'Skipped word: "${m.expectedCharacter}"',
        ));
      } else if (m.isWrongWord) {
        wordMistakeCounts[m.expectedCharacter] =
            (wordMistakeCounts[m.expectedCharacter] ?? 0) + 1;
        _bumpLast(wordLast, m.expectedCharacter, testTime);
        recentLines.add(_TimedMistakeLine(
          time: testTime,
          id: m.id,
          text:
              'Wrong word: expected "${m.expectedCharacter}", typed "${m.typedCharacter}"',
        ));
      } else {
        if (m.expectedCharacter.isEmpty) continue; // overflow keystroke
        charCounts[m.expectedCharacter] =
            (charCounts[m.expectedCharacter] ?? 0) + 1;
        _bumpLast(charLast, m.expectedCharacter, testTime);
        if (m.typedCharacter.isNotEmpty) {
          final Map<String, int> wrongMap =
              charWrongInputs.putIfAbsent(m.expectedCharacter, () => {});
          wrongMap[m.typedCharacter] = (wrongMap[m.typedCharacter] ?? 0) + 1;
        }
        recentLines.add(_TimedMistakeLine(
          time: testTime,
          id: m.id,
          text:
              'Expected "${m.expectedCharacter}", typed "${m.typedCharacter}"',
        ));
      }
    }

    final List<CharacterMistakeStat> weakestCharacters = charCounts.entries
        .map((e) => CharacterMistakeStat(
              character: e.key,
              count: e.value,
              lastMistakeAt: charLast[e.key],
              commonWrongInputs: _sortedByValueDesc(
                  charWrongInputs[e.key] ?? const <String, int>{}),
            ))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));

    final Set<String> allWords = {
      ...wordMistakeCounts.keys,
      ...wordSkipCounts.keys,
    };
    final List<WordMistakeStat> allWordStats = allWords
        .map((w) => WordMistakeStat(
              word: w,
              mistakeCount: wordMistakeCounts[w] ?? 0,
              skippedCount: wordSkipCounts[w] ?? 0,
              lastMistakeAt: wordLast[w],
            ))
        .toList();

    final List<WordMistakeStat> weakestWords = [...allWordStats]
      ..sort((a, b) => b.mistakeCount.compareTo(a.mistakeCount));
    final List<WordMistakeStat> mostSkippedWords = [...allWordStats]
      ..sort((a, b) => b.skippedCount.compareTo(a.skippedCount));

    recentLines.sort((a, b) {
      final int timeCompare =
          (b.time ?? DateTime(0)).compareTo(a.time ?? DateTime(0));
      if (timeCompare != 0) return timeCompare;
      return b.id.compareTo(a.id);
    });

    return MistakeAnalysisSummary(
      totalMistakes: mistakes.length,
      wrongCharacters: charCounts.values.fold(0, (a, b) => a + b),
      wrongWords: wrongWordsTotal,
      skippedWords: skippedWordsTotal,
      backspaces: backspaces,
      weakestCharacters:
          weakestCharacters.take(maxWeakCharacters).toList(),
      weakestWords: weakestWords
          .where((w) => w.mistakeCount > 0)
          .take(maxWeakWords)
          .toList(),
      mostSkippedWords: mostSkippedWords
          .where((w) => w.skippedCount > 0)
          .take(maxWeakWords)
          .toList(),
      recentMistakes:
          recentLines.take(maxRecentMistakes).map((l) => l.text).toList(),
      completedTestCount: tests.length,
    );
  }

  static void _bumpLast(Map<String, DateTime> map, String key, DateTime? time) {
    if (time == null) return;
    final DateTime? existing = map[key];
    if (existing == null || time.isAfter(existing)) {
      map[key] = time;
    }
  }

  static Map<String, int> _sortedByValueDesc(Map<String, int> input) {
    final entries = input.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return {for (final e in entries) e.key: e.value};
  }
}

class _TimedMistakeLine {
  _TimedMistakeLine(
      {required this.time, required this.id, required this.text});

  final DateTime? time;
  final int id;
  final String text;
}
