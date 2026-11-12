import '../model/paper_test.dart';
import 'papers2019_registry.dart' deferred as papers2019_lib;
import 'papers2020_registry.dart' deferred as papers2020_lib;
import 'papers2021_registry.dart' deferred as papers2021_lib;
import 'papers2022_registry.dart' deferred as papers2022_lib;
import 'papers2023_registry.dart' deferred as papers2023_lib;
import 'papers2024_registry.dart' deferred as papers2024_lib;
import 'papers2025_registry.dart' deferred as papers2025_lib;
import 'papers2026_registry.dart' deferred as papers2026_lib;

/// One year's group of practice papers, for the year-grouped list
/// screen.
///
/// The counts are small constants compiled into the app so the year
/// list can render immediately; the full paper data (all questions)
/// lives in deferred year libraries and is only downloaded when a
/// year's page is opened — see [loadPapersForYear]. The counts here
/// must match the deferred data exactly; [paper_years_test.dart]
/// loads every year and checks them, so a new paper that changes a
/// count fails the test until this table is updated with it.
///
/// A group with no papers ([isBuilt] false) is shown honestly as
/// "coming soon" with 0 papers built and is never tappable into a test.
/// No papers are invented for a year: a year only gains papers when a
/// real year registry (e.g. `papers2025_registry.dart`) is added and
/// wired in below.
class PaperYearGroup {
  const PaperYearGroup({
    required this.year,
    required this.paperCount,
    required this.totalQuestions,
  });

  final int year;

  /// Number of built papers for the year.
  final int paperCount;

  /// Total number of questions across the year's papers.
  final int totalQuestions;

  bool get isBuilt => paperCount > 0;
}

/// Built years, newest first, with their paper and question counts.
/// These are the same counts the year registries report; see the
/// class doc on [PaperYearGroup] for why they are constants here.
const List<PaperYearGroup> paperYearGroups = <PaperYearGroup>[
  PaperYearGroup(year: 2026, paperCount: 25, totalQuestions: 1812),
  PaperYearGroup(year: 2025, paperCount: 56, totalQuestions: 3179),
  PaperYearGroup(year: 2024, paperCount: 24, totalQuestions: 2175),
  PaperYearGroup(year: 2023, paperCount: 25, totalQuestions: 2381),
  PaperYearGroup(year: 2022, paperCount: 28, totalQuestions: 2712),
  PaperYearGroup(year: 2021, paperCount: 23, totalQuestions: 2051),
  PaperYearGroup(year: 2020, paperCount: 29, totalQuestions: 2866),
  PaperYearGroup(year: 2019, paperCount: 31, totalQuestions: 2987),
];

/// Years covered by the source collection (2019-2026) that have no
/// built papers yet. Shown as "coming soon" only — no paper is ever
/// invented for these years. Every year in the collection now has
/// built papers, so this list is empty.
const List<int> plannedPaperYears = <int>[];

/// All paper years, newest first: built years, then planned years.
List<int> get allPaperYears => <int>[
      ...paperYearGroups.map((group) => group.year),
      ...plannedPaperYears.where(
        (year) => !paperYearGroups.any((group) => group.year == year),
      ),
    ]..sort((a, b) => b.compareTo(a));

/// The year group for [year], or null when the year has no built
/// papers and is not a planned year.
PaperYearGroup? paperYearGroupFor(int year) {
  for (final group in paperYearGroups) {
    if (group.year == year) return group;
  }
  return null;
}

/// Whether any papers are built for [year].
bool isPaperYearBuilt(int year) => paperYearGroupFor(year)?.isBuilt ?? false;

/// Total number of built papers across all years.
int get totalBuiltPapers =>
    paperYearGroups.fold(0, (sum, group) => sum + group.paperCount);

/// Total number of questions across all built papers.
int get totalBuiltQuestions =>
    paperYearGroups.fold(0, (sum, group) => sum + group.totalQuestions);

/// Loads one year's papers, downloading that year's deferred library
/// on first use and reusing it afterwards. Returns an empty list for
/// a year with no built papers. Callers show a loading state while
/// the returned future is pending and render exactly as before once
/// it completes; the paper data itself is unchanged.
Future<List<PaperTest>> loadPapersForYear(int year) async {
  switch (year) {
    case 2026:
      await papers2026_lib.loadLibrary();
      return List<PaperTest>.unmodifiable(papers2026_lib.papers2026);
    case 2025:
      await papers2025_lib.loadLibrary();
      return List<PaperTest>.unmodifiable(papers2025_lib.papers2025);
    case 2024:
      await papers2024_lib.loadLibrary();
      return List<PaperTest>.unmodifiable(papers2024_lib.papers2024);
    case 2023:
      await papers2023_lib.loadLibrary();
      return List<PaperTest>.unmodifiable(papers2023_lib.papers2023);
    case 2022:
      await papers2022_lib.loadLibrary();
      return List<PaperTest>.unmodifiable(papers2022_lib.papers2022);
    case 2021:
      await papers2021_lib.loadLibrary();
      return List<PaperTest>.unmodifiable(papers2021_lib.papers2021);
    case 2020:
      await papers2020_lib.loadLibrary();
      return List<PaperTest>.unmodifiable(papers2020_lib.papers2020);
    case 2019:
      await papers2019_lib.loadLibrary();
      return List<PaperTest>.unmodifiable(papers2019_lib.papers2019);
    default:
      return const <PaperTest>[];
  }
}

/// Loads every built year's papers, newest first. Used by tests to
/// verify the counts in [paperYearGroups] against the real data.
Future<List<PaperTest>> loadAllPapers() async {
  final List<PaperTest> all = <PaperTest>[];
  for (final group in paperYearGroups) {
    all.addAll(await loadPapersForYear(group.year));
  }
  return List<PaperTest>.unmodifiable(all);
}

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
