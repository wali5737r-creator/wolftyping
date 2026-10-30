/// One multiple-choice question for the PPSC practice mock test.
///
/// The question bank is deliberately a plain data list
/// (`mock_questions.dart`) so questions can be added, edited or replaced
/// without touching the test engine or UI: one [MockQuestion] per entry,
/// with the question text, exactly four options, the index of the correct
/// option (0-3), a subject, and an optional topic label.
///
/// The shipped questions are clearly-labelled PRACTICE SAMPLES. They are
/// not real PPSC past papers and do not predict the real exam.
class MockQuestion {
  /// NOTE: this constructor is `const` so the question list in
  /// `mock_questions.dart` can be a compile-time constant that users edit
  /// as plain data. Const constructors cannot assert on `options.length`,
  /// so the 4-options / valid-index checks live in [MockTestEngine],
  /// which throws an [ArgumentError] when a test is started with bad data.
  const MockQuestion({
    required this.id,
    required this.subject,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.topic,
    this.explanation,
  });

  /// Stable identifier (e.g. 'eng-1'). Used as the map key for answers.
  final String id;

  final MockSubject subject;

  final String question;

  /// Exactly four answer options, shown in order as A, B, C, D.
  final List<String> options;

  /// Index into [options] of the correct answer.
  final int correctIndex;

  /// Optional sub-topic shown in review, e.g. 'Grammar', 'Arithmetic'.
  final String? topic;

  /// Optional verified explanation shown in the end review, under the
  /// correct answer, explaining why the correct answer is correct.
  /// Only researched, authentic facts — never invented dates, names,
  /// figures, or rules. Null when no explanation has been written yet.
  final String? explanation;

  bool isCorrect(int? selectedIndex) => selectedIndex == correctIndex;
}

/// Subjects for the subject-wise short tests. The full mock test uses
/// every subject together.
enum MockSubject {
  english,
  generalKnowledge,
  pakistanStudies,
  islamiat,
  mathematics,
  everydayScience;

  String get label {
    switch (this) {
      case MockSubject.english:
        return 'English';
      case MockSubject.generalKnowledge:
        return 'General Knowledge';
      case MockSubject.pakistanStudies:
        return 'Pakistan Studies';
      case MockSubject.islamiat:
        return 'Islamiat';
      case MockSubject.mathematics:
        return 'Mathematics';
      case MockSubject.everydayScience:
        return 'Everyday Science';
    }
  }
}
