/// Distinguishes a plain timed typing test from a PPSC-style practice
/// attempt. Stored on `TypingTests.testType`.
///
/// Note: the Drift schema (see core/database/tables/typing_tests_table.dart)
/// was already defined with the convention `testType: 'test' | 'ppsc' |
/// 'lesson' | 'practice'` — [normal] maps to the existing `'test'` value
/// rather than introducing a new `'normal'` string, so the column keeps a
/// single consistent vocabulary across English and Urdu instead of two
/// different words meaning the same thing.
enum TypingTestKind {
  normal,
  ppsc;

  String get dbValue {
    switch (this) {
      case TypingTestKind.normal:
        return 'test';
      case TypingTestKind.ppsc:
        return 'ppsc';
    }
  }

  String get label {
    switch (this) {
      case TypingTestKind.normal:
        return 'Normal';
      case TypingTestKind.ppsc:
        return 'PPSC';
    }
  }

  /// Parses a raw `TypingTests.testType` value back into this enum.
  /// Anything other than 'ppsc' (e.g. 'test', or an older 'lesson'/
  /// 'practice' value that might exist) is treated as [normal] — History
  /// and Progress only ever distinguish "PPSC" from "everything else".
  static TypingTestKind fromDbValue(String value) =>
      value == 'ppsc' ? TypingTestKind.ppsc : TypingTestKind.normal;
}
