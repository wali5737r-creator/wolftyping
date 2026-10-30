/// Which language a typing attempt is in. Stored on `TypingTests.language`
/// as [code] ('en' / 'ur') — this enum exists so the rest of the app never
/// has to compare raw strings.
enum TypingLanguage {
  english,
  urdu;

  /// The value written to the `TypingTests.language` Drift column.
  String get code {
    switch (this) {
      case TypingLanguage.english:
        return 'en';
      case TypingLanguage.urdu:
        return 'ur';
    }
  }

  String get label {
    switch (this) {
      case TypingLanguage.english:
        return 'English';
      case TypingLanguage.urdu:
        return 'Urdu';
    }
  }
}
