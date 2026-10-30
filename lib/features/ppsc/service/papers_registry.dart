import '../model/paper_test.dart';
import 'papers2026_registry.dart';

/// One year's group of practice papers.
///
/// A group with no papers ([isBuilt] false) is shown honestly as
/// "coming soon" with 0 papers built and is never tappable into a test.
/// No papers are invented for a year: a year only gains papers when a
/// real year registry (e.g. `papers2025_registry.dart`) is added and
/// wired into [papersByYear] below.
class PaperYearGroup {
  const PaperYearGroup({required this.year, required this.papers});

  final int year;

  final List<PaperTest> papers;

  bool get isBuilt => papers.isNotEmpty;

  int get totalQuestions =>
      papers.fold(0, (sum, paper) => sum + paper.questionCount);
}

/// Years covered by the source collection (2019-2026) that have no
/// built papers yet. Shown as "coming soon" only — no paper is ever
/// invented for these years.
const List<int> plannedPaperYears = [2025, 2024, 2023, 2022, 2021, 2020, 2019];

/// Built papers by year. To add a future year, add its registry import
/// and one entry here; the year-grouped list screens need no rewrite.
Map<int, List<PaperTest>> get papersByYear => <int, List<PaperTest>>{
      2026: papers2026,
    };

/// All paper years, newest first: built years, then planned years.
List<int> get allPaperYears => <int>[
      ...papersByYear.keys,
      ...plannedPaperYears.where((year) => !papersByYear.containsKey(year)),
    ]..sort((a, b) => b.compareTo(a));

/// Year groups, newest first, for the year-grouped papers screens.
List<PaperYearGroup> get paperYearGroups => allPaperYears
    .map((year) => PaperYearGroup(year: year, papers: papersForYear(year)))
    .toList(growable: false);

/// Papers built for [year], or an empty list when none are built yet.
/// Never invents papers for an unbuilt year.
List<PaperTest> papersForYear(int year) =>
    List<PaperTest>.unmodifiable(papersByYear[year] ?? const <PaperTest>[]);

/// Whether any papers are built for [year].
bool isPaperYearBuilt(int year) => papersByYear[year]?.isNotEmpty ?? false;

/// Filters [papers] by search [query] and [department]. The query is
/// matched word by word (every word must appear) against paper
/// number, post, department, exam date and title, case-insensitively.
/// [department] null or empty means all departments. Pure function,
/// unit tested — no papers are invented or hidden by the filter
/// except those that do not match.
List<PaperTest> filterPapers(
  List<PaperTest> papers, {
  String query = '',
  String? department,
}) {
  final List<String> words = query
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();
  return papers.where((paper) {
    if (department != null &&
        department.isNotEmpty &&
        paper.department != department) {
      return false;
    }
    if (words.isEmpty) return true;
    final String haystack =
        'paper ${paper.paperNo} ${paper.post} ${paper.department} '
                '${paper.examDate} ${paper.title}'
            .toLowerCase();
    return words.every(haystack.contains);
  }).toList();
}
