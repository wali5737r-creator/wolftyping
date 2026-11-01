import '../model/paper_test.dart';
import 'papers2019/paper_1.dart';
import 'papers2019/paper_2.dart';
import 'papers2019/paper_3.dart';
import 'papers2019/paper_4.dart';
import 'papers2019/paper_5.dart';
import 'papers2019/paper_6.dart';
import 'papers2019/paper_7.dart';
import 'papers2019/paper_8.dart';
import 'papers2019/paper_9.dart';
import 'papers2019/paper_10.dart';
import 'papers2019/paper_11.dart';
import 'papers2019/paper_12.dart';
import 'papers2019/paper_13.dart';
import 'papers2019/paper_14.dart';
import 'papers2019/paper_15.dart';
import 'papers2019/paper_16.dart';
import 'papers2019/paper_17.dart';
import 'papers2019/paper_18.dart';
import 'papers2019/paper_19.dart';
import 'papers2019/paper_20.dart';
import 'papers2019/paper_21.dart';
import 'papers2019/paper_22.dart';
import 'papers2019/paper_23.dart';
import 'papers2019/paper_24.dart';
import 'papers2019/paper_25.dart';
import 'papers2019/paper_26.dart';
import 'papers2019/paper_27.dart';
import 'papers2019/paper_28.dart';
import 'papers2019/paper_29.dart';
import 'papers2019/paper_30.dart';
import 'papers2019/paper_31.dart';

/// All 2019 practice papers, in paper-number order.
/// Papers 1-31. Some papers have fewer than 100 questions where items
/// were dropped or unreadable in the source; only the included
/// questions are listed, never guessed. Paper 12 has 88 questions
/// against a printed total of 90 (gaps at questions 75 and 80).
///
/// Practice material only: every paper is written in fresh wording and
/// is never presented as an official or verbatim paper. No source book
/// is referenced anywhere in the app.
const List<PaperTest> papers2019 = [
  paper1,
  paper2,
  paper3,
  paper4,
  paper5,
  paper6,
  paper7,
  paper8,
  paper9,
  paper10,
  paper11,
  paper12,
  paper13,
  paper14,
  paper15,
  paper16,
  paper17,
  paper18,
  paper19,
  paper20,
  paper21,
  paper22,
  paper23,
  paper24,
  paper25,
  paper26,
  paper27,
  paper28,
  paper29,
  paper30,
  paper31,
];

/// Total number of questions across all 2019 papers.
int get papers2019TotalQuestions =>
    papers2019.fold(0, (sum, paper) => sum + paper.questionCount);

/// Total number of latest-update notes across all 2019 papers.
int get papers2019TotalLatestUpdates =>
    papers2019.fold(0, (sum, paper) => sum + paper.latestUpdates.length);
