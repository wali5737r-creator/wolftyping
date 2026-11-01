import '../model/paper_test.dart';
import 'papers2024/paper_138.dart';
import 'papers2024/paper_139.dart';
import 'papers2024/paper_140.dart';
import 'papers2024/paper_141.dart';
import 'papers2024/paper_142.dart';
import 'papers2024/paper_143.dart';
import 'papers2024/paper_144.dart';
import 'papers2024/paper_145.dart';
import 'papers2024/paper_146.dart';
import 'papers2024/paper_147.dart';
import 'papers2024/paper_148.dart';
import 'papers2024/paper_149.dart';
import 'papers2024/paper_150.dart';
import 'papers2024/paper_151.dart';
import 'papers2024/paper_152.dart';
import 'papers2024/paper_153.dart';
import 'papers2024/paper_154.dart';
import 'papers2024/paper_155.dart';
import 'papers2024/paper_156.dart';
import 'papers2024/paper_157.dart';
import 'papers2024/paper_158.dart';
import 'papers2024/paper_159.dart';
import 'papers2024/paper_160.dart';
import 'papers2024/paper_161.dart';

/// All 2024 practice papers, in paper-number order.
/// Papers 138-161. There is no paper 137 anywhere in the source
/// collection, so no paper-137 entry is invented here. Some papers have
/// fewer than 100 questions where items were dropped or unreadable in
/// the source; only the included questions are listed, never guessed.
///
/// Practice material only: every paper is written in fresh wording and
/// is never presented as an official or verbatim paper. No source book
/// is referenced anywhere in the app.
const List<PaperTest> papers2024 = [
  paper138,
  paper139,
  paper140,
  paper141,
  paper142,
  paper143,
  paper144,
  paper145,
  paper146,
  paper147,
  paper148,
  paper149,
  paper150,
  paper151,
  paper152,
  paper153,
  paper154,
  paper155,
  paper156,
  paper157,
  paper158,
  paper159,
  paper160,
  paper161,
];

/// Total number of questions across all 2024 papers.
int get papers2024TotalQuestions =>
    papers2024.fold(0, (sum, paper) => sum + paper.questionCount);

/// Total number of latest-update notes across all 2024 papers.
int get papers2024TotalLatestUpdates =>
    papers2024.fold(0, (sum, paper) => sum + paper.latestUpdates.length);
