/// Distinguishes a plain timed typing test from a PPSC-style practice
/// attempt. Stored on `TypingTests.testType`.
///
/// Note: the Drift schema (see core/database/tables/typing_tests_table.dart)
/// was already defined with the convention `testType: 'test' | 'ppsc' |
/// 'lesson' | 'practice'` — [normal] maps to the existing `'test'` value
/// rather than introducing a new `'normal'` string, so the column keeps a
/// single consistent vocabulary across English and Urdu instead of two
/// different words meaning the same thing.
///
/// [mock] is the odd one out: mock MCQ attempts are NOT stored in
/// `TypingTests` at all — they live in `MockProgressRepository` (the
/// subject-stats source) and are only *shown* in History by mapping
/// them onto [TypingTestRecord] (see `TypingTestRecord.fromMockAttempt`).
/// Keeping them out of the table means typing WPM/accuracy averages in
/// Progress and on the Dashboard are never polluted by MCQ scores, and
/// the [mock] dbValue exists only so the in-memory kind stays
/// round-trippable if one ever is written.
enum TypingTestKind {
  normal,
  ppsc,
  mock;

  String get dbValue {
    switch (this) {
      case TypingTestKind.normal:
        return 'test';
      case TypingTestKind.ppsc:
        return 'ppsc';
      case TypingTestKind.mock:
        return 'mock';
    }
  }

  String get label {
    switch (this) {
      case TypingTestKind.normal:
        return 'Normal';
      case TypingTestKind.ppsc:
        return 'PPSC';
      case TypingTestKind.mock:
        return 'Mock test';
    }
  }

  /// Parses a raw `TypingTests.testType` value back into this enum.
  /// Anything other than 'ppsc'/'mock' (e.g. 'test', or an older
  /// 'lesson'/'practice' value that might exist) is treated as [normal]
  /// — History and Progress only ever distinguish "PPSC" from
  /// "everything else".
  static TypingTestKind fromDbValue(String value) {
    if (value == 'ppsc') return TypingTestKind.ppsc;
    if (value == 'mock') return TypingTestKind.mock;
    return TypingTestKind.normal;
  }
}
