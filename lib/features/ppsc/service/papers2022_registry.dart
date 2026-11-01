import '../model/paper_test.dart';
import 'papers2022/paper_84.dart';
import 'papers2022/paper_85.dart';
import 'papers2022/paper_86.dart';
import 'papers2022/paper_87.dart';
import 'papers2022/paper_88.dart';
import 'papers2022/paper_89.dart';
import 'papers2022/paper_90.dart';
import 'papers2022/paper_91.dart';
import 'papers2022/paper_92.dart';
import 'papers2022/paper_93.dart';
import 'papers2022/paper_94.dart';
import 'papers2022/paper_95.dart';
import 'papers2022/paper_96.dart';
import 'papers2022/paper_97.dart';
import 'papers2022/paper_98.dart';
import 'papers2022/paper_99.dart';
import 'papers2022/paper_100.dart';
import 'papers2022/paper_101.dart';
import 'papers2022/paper_102.dart';
import 'papers2022/paper_103.dart';
import 'papers2022/paper_104.dart';
import 'papers2022/paper_105.dart';
import 'papers2022/paper_106.dart';
import 'papers2022/paper_107.dart';
import 'papers2022/paper_108.dart';
import 'papers2022/paper_109.dart';
import 'papers2022/paper_110.dart';
import 'papers2022/paper_111.dart';

/// All 2022 practice papers, in paper-number order.
/// Papers 84-111. Some papers have fewer than 100 questions where items
/// were dropped or unreadable in the source; only the included
/// questions are listed, never guessed. Paper 95 has 72 questions and
/// paper 99 has 94 questions (91 plus 3 newly built items).
///
/// Practice material only: every paper is written in fresh wording and
/// is never presented as an official or verbatim paper. No source book
/// is referenced anywhere in the app.
const List<PaperTest> papers2022 = [
  paper84,
  paper85,
  paper86,
  paper87,
  paper88,
  paper89,
  paper90,
  paper91,
  paper92,
  paper93,
  paper94,
  paper95,
  paper96,
  paper97,
  paper98,
  paper99,
  paper100,
  paper101,
  paper102,
  paper103,
  paper104,
  paper105,
  paper106,
  paper107,
  paper108,
  paper109,
  paper110,
  paper111,
];

/// Total number of questions across all 2022 papers.
int get papers2022TotalQuestions =>
    papers2022.fold(0, (sum, paper) => sum + paper.questionCount);

/// Total number of latest-update notes across all 2022 papers.
int get papers2022TotalLatestUpdates =>
    papers2022.fold(0, (sum, paper) => sum + paper.latestUpdates.length);
