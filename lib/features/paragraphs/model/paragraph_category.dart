/// Category tags for paragraphs (spec section 2/10). The [label] is
/// stored directly in the `Paragraphs.category` text column.
enum ParagraphCategory {
  general,
  practice,
  exam,
  ppsc,
  personal,
  custom;

  String get label {
    switch (this) {
      case ParagraphCategory.general:
        return 'General';
      case ParagraphCategory.practice:
        return 'Practice';
      case ParagraphCategory.exam:
        return 'Exam';
      case ParagraphCategory.ppsc:
        return 'PPSC';
      case ParagraphCategory.personal:
        return 'Personal';
      case ParagraphCategory.custom:
        return 'Custom';
    }
  }

  /// Parses a raw `Paragraphs.category` value back into this enum,
  /// case-insensitively. Falls back to [general] for any unrecognized
  /// value (e.g. one of the older built-in category strings like
  /// "Pakistan Studies") rather than crashing.
  static ParagraphCategory fromDbValue(String value) {
    for (final ParagraphCategory c in ParagraphCategory.values) {
      if (c.label.toLowerCase() == value.toLowerCase()) return c;
    }
    return ParagraphCategory.general;
  }
}
