/// Status of one target word, used by the UI to color/highlight words as
/// the user moves through the paragraph (spec sections 10 and 13).
enum TypingWordStatus {
  /// Not reached yet.
  pending,

  /// The word the user is actively typing right now.
  current,

  /// Committed (Space pressed) and typed exactly as the target word.
  correct,

  /// Committed, but the typed text didn't match the target word.
  wrong,

  /// Space was pressed with nothing typed for this word at all — see
  /// TypingEngine's Anti-Skip Logic. Distinct from [wrong] because the
  /// spec tracks "skipped words" as its own statistic, separate from
  /// "wrong words".
  skipped,
}
