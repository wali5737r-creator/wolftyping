import '../model/paper_test.dart';
import 'papers2025/paper_162.dart';
import 'papers2025/paper_163.dart';
import 'papers2025/paper_164.dart';
import 'papers2025/paper_165.dart';
import 'papers2025/paper_166.dart';
import 'papers2025/paper_167.dart';
import 'papers2025/paper_168.dart';
import 'papers2025/paper_169.dart';
import 'papers2025/paper_170.dart';
import 'papers2025/paper_171.dart';
import 'papers2025/paper_172.dart';
import 'papers2025/paper_173.dart';
import 'papers2025/paper_174.dart';
import 'papers2025/paper_175.dart';
import 'papers2025/paper_176.dart';
import 'papers2025/paper_177.dart';
import 'papers2025/paper_178.dart';
import 'papers2025/paper_179.dart';
import 'papers2025/paper_180.dart';
import 'papers2025/paper_181.dart';
import 'papers2025/paper_182.dart';
import 'papers2025/paper_183.dart';
import 'papers2025/paper_184.dart';
import 'papers2025/paper_185.dart';
import 'papers2025/paper_186.dart';
import 'papers2025/paper_187.dart';
import 'papers2025/paper_188.dart';
import 'papers2025/paper_189.dart';
import 'papers2025/paper_190.dart';
import 'papers2025/paper_191.dart';
import 'papers2025/paper_192.dart';
import 'papers2025/paper_193.dart';
import 'papers2025/paper_194.dart';
import 'papers2025/paper_195.dart';
import 'papers2025/paper_196.dart';
import 'papers2025/paper_197.dart';
import 'papers2025/paper_198.dart';
import 'papers2025/paper_199.dart';
import 'papers2025/paper_200.dart';
import 'papers2025/paper_201.dart';
import 'papers2025/paper_202.dart';
import 'papers2025/paper_203.dart';
import 'papers2025/paper_204.dart';
import 'papers2025/paper_205.dart';
import 'papers2025/paper_206.dart';
import 'papers2025/paper_207.dart';
import 'papers2025/paper_208.dart';
import 'papers2025/paper_209.dart';
import 'papers2025/paper_210.dart';
import 'papers2025/paper_211.dart';
import 'papers2025/paper_212.dart';
import 'papers2025/paper_213.dart';
import 'papers2025/paper_214.dart';
import 'papers2025/paper_215.dart';
import 'papers2025/paper_216.dart';
import 'papers2025/paper_217.dart';

/// All 2025 practice papers, in paper-number order: 162-217 except
/// paper 218, which does not appear anywhere in the source file, so
/// no entry is invented for it. Papers 209 and 217 are incomplete in
/// the source (unreadable/missing leaves); only the readable
/// questions are included, never guessed.
///
/// Practice material only: every paper is written in fresh wording and
/// is never presented as an official or verbatim paper. No source book
/// is referenced anywhere in the app.
const List<PaperTest> papers2025 = [
  paper162,
  paper163,
  paper164,
  paper165,
  paper166,
  paper167,
  paper168,
  paper169,
  paper170,
  paper171,
  paper172,
  paper173,
  paper174,
  paper175,
  paper176,
  paper177,
  paper178,
  paper179,
  paper180,
  paper181,
  paper182,
  paper183,
  paper184,
  paper185,
  paper186,
  paper187,
  paper188,
  paper189,
  paper190,
  paper191,
  paper192,
  paper193,
  paper194,
  paper195,
  paper196,
  paper197,
  paper198,
  paper199,
  paper200,
  paper201,
  paper202,
  paper203,
  paper204,
  paper205,
  paper206,
  paper207,
  paper208,
  paper209,
  paper210,
  paper211,
  paper212,
  paper213,
  paper214,
  paper215,
  paper216,
  paper217,
];

/// Total number of questions across all 2025 papers.
int get papers2025TotalQuestions =>
    papers2025.fold(0, (sum, paper) => sum + paper.questionCount);

/// Total number of latest-update notes across all 2025 papers.
int get papers2025TotalLatestUpdates =>
    papers2025.fold(0, (sum, paper) => sum + paper.latestUpdates.length);
