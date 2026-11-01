import '../model/paper_test.dart';
import 'papers2021/paper_61.dart';
import 'papers2021/paper_62.dart';
import 'papers2021/paper_63.dart';
import 'papers2021/paper_64.dart';
import 'papers2021/paper_65.dart';
import 'papers2021/paper_66.dart';
import 'papers2021/paper_67.dart';
import 'papers2021/paper_68.dart';
import 'papers2021/paper_69.dart';
import 'papers2021/paper_70.dart';
import 'papers2021/paper_71.dart';
import 'papers2021/paper_72.dart';
import 'papers2021/paper_73.dart';
import 'papers2021/paper_74.dart';
import 'papers2021/paper_75.dart';
import 'papers2021/paper_76.dart';
import 'papers2021/paper_77.dart';
import 'papers2021/paper_78.dart';
import 'papers2021/paper_79.dart';
import 'papers2021/paper_80.dart';
import 'papers2021/paper_81.dart';
import 'papers2021/paper_82.dart';
import 'papers2021/paper_83.dart';

/// All 2021 practice papers, in paper-number order.
/// Papers 61-83. Some papers have fewer than 100 questions where items
/// were dropped or unreadable in the source; only the included
/// questions are listed, never guessed.
///
/// Practice material only: every paper is written in fresh wording and
/// is never presented as an official or verbatim paper. No source book
/// is referenced anywhere in the app.
const List<PaperTest> papers2021 = [
  paper61,
  paper62,
  paper63,
  paper64,
  paper65,
  paper66,
  paper67,
  paper68,
  paper69,
  paper70,
  paper71,
  paper72,
  paper73,
  paper74,
  paper75,
  paper76,
  paper77,
  paper78,
  paper79,
  paper80,
  paper81,
  paper82,
  paper83,
];

/// Total number of questions across all 2021 papers.
int get papers2021TotalQuestions =>
    papers2021.fold(0, (sum, paper) => sum + paper.questionCount);

/// Total number of latest-update notes across all 2021 papers.
int get papers2021TotalLatestUpdates =>
    papers2021.fold(0, (sum, paper) => sum + paper.latestUpdates.length);
