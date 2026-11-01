import '../model/paper_test.dart';
import 'papers2020/paper_32.dart';
import 'papers2020/paper_33.dart';
import 'papers2020/paper_34.dart';
import 'papers2020/paper_35.dart';
import 'papers2020/paper_36.dart';
import 'papers2020/paper_37.dart';
import 'papers2020/paper_38.dart';
import 'papers2020/paper_39.dart';
import 'papers2020/paper_40.dart';
import 'papers2020/paper_41.dart';
import 'papers2020/paper_42.dart';
import 'papers2020/paper_43.dart';
import 'papers2020/paper_44.dart';
import 'papers2020/paper_45.dart';
import 'papers2020/paper_46.dart';
import 'papers2020/paper_47.dart';
import 'papers2020/paper_48.dart';
import 'papers2020/paper_49.dart';
import 'papers2020/paper_50.dart';
import 'papers2020/paper_51.dart';
import 'papers2020/paper_52.dart';
import 'papers2020/paper_53.dart';
import 'papers2020/paper_54.dart';
import 'papers2020/paper_55.dart';
import 'papers2020/paper_56.dart';
import 'papers2020/paper_57.dart';
import 'papers2020/paper_58.dart';
import 'papers2020/paper_59.dart';
import 'papers2020/paper_60.dart';

/// All 2020 practice papers, in paper-number order.
/// Papers 32-60. Some papers have fewer than 100 questions where items
/// were dropped or unreadable in the source; only the included
/// questions are listed, never guessed.
///
/// Practice material only: every paper is written in fresh wording and
/// is never presented as an official or verbatim paper. No source book
/// is referenced anywhere in the app.
const List<PaperTest> papers2020 = [
  paper32,
  paper33,
  paper34,
  paper35,
  paper36,
  paper37,
  paper38,
  paper39,
  paper40,
  paper41,
  paper42,
  paper43,
  paper44,
  paper45,
  paper46,
  paper47,
  paper48,
  paper49,
  paper50,
  paper51,
  paper52,
  paper53,
  paper54,
  paper55,
  paper56,
  paper57,
  paper58,
  paper59,
  paper60,
];

/// Total number of questions across all 2020 papers.
int get papers2020TotalQuestions =>
    papers2020.fold(0, (sum, paper) => sum + paper.questionCount);

/// Total number of latest-update notes across all 2020 papers.
int get papers2020TotalLatestUpdates =>
    papers2020.fold(0, (sum, paper) => sum + paper.latestUpdates.length);
