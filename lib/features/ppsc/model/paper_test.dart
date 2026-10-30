import 'mock_question.dart';

/// One practice mock-test paper: identity metadata (year, post,
/// department, exam date) plus its questions and any latest-update notes.
///
/// Practice material only: the questions are written in fresh wording
/// and the paper is never presented as an official or verbatim paper.
/// The [questions] list is a compile-time constant like the sample bank,
/// so each paper lives in one editable Dart file.
class PaperTest {
  const PaperTest({
    required this.id,
    required this.paperNo,
    required this.year,
    required this.post,
    required this.department,
    required this.examDate,
    required this.questions,
    this.latestUpdates = const [],
  });

  /// Stable identifier, e.g. '2026-219'.
  final String id;

  /// Paper number in the printed contents listing.
  final int paperNo;

  final int year;

  /// Post/title as printed, e.g. 'ESE General (BS-14)'.
  final String post;

  final String department;

  /// Exam date as printed, e.g. '15.02.2026'.
  final String examDate;

  final List<MockQuestion> questions;

  /// Short "Latest update" notes for current-affairs questions in this
  /// paper (e.g. who holds an office now), shown in the end review.
  /// Empty when the paper has no current-affairs items needing one.
  final List<String> latestUpdates;

  int get questionCount => questions.length;

  String get title => '$post, $department';
}
