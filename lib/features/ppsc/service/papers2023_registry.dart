import '../model/paper_test.dart';
import 'papers2023/paper_112.dart';
import 'papers2023/paper_113.dart';
import 'papers2023/paper_114.dart';
import 'papers2023/paper_115.dart';
import 'papers2023/paper_116.dart';
import 'papers2023/paper_117.dart';
import 'papers2023/paper_118.dart';
import 'papers2023/paper_119.dart';
import 'papers2023/paper_120.dart';
import 'papers2023/paper_121.dart';
import 'papers2023/paper_122.dart';
import 'papers2023/paper_123.dart';
import 'papers2023/paper_124.dart';
import 'papers2023/paper_125.dart';
import 'papers2023/paper_126.dart';
import 'papers2023/paper_127.dart';
import 'papers2023/paper_128.dart';
import 'papers2023/paper_129.dart';
import 'papers2023/paper_130.dart';
import 'papers2023/paper_131.dart';
import 'papers2023/paper_132.dart';
import 'papers2023/paper_133.dart';
import 'papers2023/paper_134.dart';
import 'papers2023/paper_135.dart';
import 'papers2023/paper_136.dart';

/// All 2023 practice papers, in paper-number order.
/// Papers 112-136. Some papers have fewer than 100 questions where items
/// were dropped or unreadable in the source; only the included
/// questions are listed, never guessed. There is no paper 137 in this
/// year group; no entry is invented for it.
///
/// Practice material only: every paper is written in fresh wording and
/// is never presented as an official or verbatim paper. No source book
/// is referenced anywhere in the app.
const List<PaperTest> papers2023 = [
  paper112,
  paper113,
  paper114,
  paper115,
  paper116,
  paper117,
  paper118,
  paper119,
  paper120,
  paper121,
  paper122,
  paper123,
  paper124,
  paper125,
  paper126,
  paper127,
  paper128,
  paper129,
  paper130,
  paper131,
  paper132,
  paper133,
  paper134,
  paper135,
  paper136,
];

/// Total number of questions across all 2023 papers.
int get papers2023TotalQuestions =>
    papers2023.fold(0, (sum, paper) => sum + paper.questionCount);

/// Total number of latest-update notes across all 2023 papers.
int get papers2023TotalLatestUpdates =>
    papers2023.fold(0, (sum, paper) => sum + paper.latestUpdates.length);
