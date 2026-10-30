/// Splits a string into individual Unicode code points (runes) rather than
/// UTF-16 code units, so multi-byte characters (Urdu included) are each
/// treated as one visual "character" when rendering text letter by letter.
///
/// TypingEngine keeps its own private copy of this same logic (it can't
/// depend on `core/` without breaking its "zero Flutter deps" rule) — this
/// public version is for UI widgets that need to do the same character
/// splitting to render text (e.g. TypingParagraphText).
List<String> splitChars(String s) =>
    s.runes.map(String.fromCharCode).toList(growable: false);
