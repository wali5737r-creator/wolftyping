/// Language filter shown at the top of the My Paragraphs dashboard.
enum ParagraphLanguageFilter {
  all,
  english,
  urdu;

  String get label {
    switch (this) {
      case ParagraphLanguageFilter.all:
        return 'All';
      case ParagraphLanguageFilter.english:
        return 'English';
      case ParagraphLanguageFilter.urdu:
        return 'Urdu';
    }
  }
}

/// Sort options for the paragraph list (spec section 10).
enum ParagraphSort {
  newest,
  oldest,
  titleAZ,
  titleZA;

  String get label {
    switch (this) {
      case ParagraphSort.newest:
        return 'Newest';
      case ParagraphSort.oldest:
        return 'Oldest';
      case ParagraphSort.titleAZ:
        return 'Title A-Z';
      case ParagraphSort.titleZA:
        return 'Title Z-A';
    }
  }
}
