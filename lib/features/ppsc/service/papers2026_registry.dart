import '../model/paper_test.dart';
import 'papers2026/paper_219.dart';
import 'papers2026/paper_220.dart';
import 'papers2026/paper_221.dart';
import 'papers2026/paper_222.dart';
import 'papers2026/paper_223.dart';
import 'papers2026/paper_224.dart';
import 'papers2026/paper_225.dart';
import 'papers2026/paper_226.dart';
import 'papers2026/paper_227.dart';
import 'papers2026/paper_228.dart';
import 'papers2026/paper_229.dart';
import 'papers2026/paper_230.dart';
import 'papers2026/paper_231.dart';
import 'papers2026/paper_232.dart';
import 'papers2026/paper_233.dart';
import 'papers2026/paper_234.dart';
import 'papers2026/paper_235.dart';
import 'papers2026/paper_236.dart';
import 'papers2026/paper_237.dart';
import 'papers2026/paper_238.dart';
import 'papers2026/paper_239.dart';

/// All 2026 practice papers, in paper-number order.
///
/// Practice material only: every paper is written in fresh wording and
/// is never presented as an official or verbatim paper. No source book
/// is referenced anywhere in the app.
const List<PaperTest> papers2026 = [
  paper219,
  paper220,
  paper221,
  paper222,
  paper223,
  paper224,
  paper225,
  paper226,
  paper227,
  paper228,
  paper229,
  paper230,
  paper231,
  paper232,
  paper233,
  paper234,
  paper235,
  paper236,
  paper237,
  paper238,
  paper239,
];

/// Total number of questions across all 2026 papers.
int get papers2026TotalQuestions =>
    papers2026.fold(0, (sum, paper) => sum + paper.questionCount);

/// Total number of latest-update notes across all 2026 papers.
int get papers2026TotalLatestUpdates =>
    papers2026.fold(0, (sum, paper) => sum + paper.latestUpdates.length);
