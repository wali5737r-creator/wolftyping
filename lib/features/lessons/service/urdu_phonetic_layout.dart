/// The Urdu phonetic keyboard layout the Urdu lessons are written for
/// (InPage-style phonetic: the Latin key you press decides the letter).
///
/// CLE/CRULP Urdu Phonetic v1.2 (17 Oct 2019, Pak Urdu Installer —
/// https://www.cle.org.pk/Downloads/localization/keyboards/CLE%20keybord%20v1.2.pdf).
/// There is NO distinct exam layout: TezType's "Exam Phonetic (CRULP)" is
/// this same CRULP layout, and no PPSC/FPSC official layout source exists.
/// Only ONE layout is built; there is no layout switcher.
///
/// This is the ONLY place that describes the layout. If a key on your
/// Windows keyboard types a different letter, fix it here (and regenerate
/// the lesson text), nothing else needs to change.
///
/// Because the layout is phonetic, finger positions are exactly the QWERTY
/// ones, so the on-screen keyboard reuses the English finger map and only
/// swaps the labels.
///
/// v1.1 -> v1.2 (from the v1.2 revision note: "Only shift version of
/// layout 1.1 is modified. Characters like dot(.) and at(@) are added in
/// empty spaces of shift version. Position of only one character is
/// changed."): the one moved character is ح/ھ — ح moved from Shift+H to
/// base H, ھ the other way. The Shift layer gained @ (Shift+L), . (Shift+.),
/// and the diacritics/punctuation that were empty in v1.1. Shift+F and
/// Shift+B type nothing; base ` types nothing. There is no ZWNJ/ZWJ key
/// in CRULP. The AltGr layer is intentionally not mapped here: it is
/// unreachable on phones (no Right Alt) and out of scope for v1.
///
/// Digit-row note: the research brief for this change read the v1.2
/// diagram as putting Western digits 1..0 on Shift+1..0, but that would
/// delete '!', '(' and ')' from the layout — and shipped Lesson 25 teaches
/// "'!' is Shift + 1" and Lesson 26 teaches "'(' is Shift + 9, ')' is
/// Shift + 0", with drills that need them. A ten-key digit change also
/// contradicts the revision note quoted above (only ONE character changed
/// position). So Shift+1/9/0 keep the v1.1 punctuation and Shift+2..8 stay
/// empty, as in v1.1. If Muhammad's Windows Pak Urdu keyboard types
/// Western digits on Shift+digits instead, flip these three keys and fix
/// Lessons 25/26 — one map change.
///
/// Urdu forms are the Urdu code points throughout — ی U+06CC, ک U+06A9,
/// ہ U+06C1, ھ U+06BE, ے U+06D2 — never the Arabic look-alikes ي ك ه.
class UrduPhoneticLayout {
  UrduPhoneticLayout._();

  /// Latin key (as printed on the keycap, lower case) -> Urdu character
  /// typed WITHOUT Shift. Keys with no character on this layer are absent
  /// (base ` types nothing).
  static const Map<String, String> unshifted = {
    '1': '\u06F1', // ۱
    '2': '\u06F2',
    '3': '\u06F3',
    '4': '\u06F4',
    '5': '\u06F5',
    '6': '\u06F6',
    '7': '\u06F7',
    '8': '\u06F8',
    '9': '\u06F9',
    '0': '\u06F0', // ۰
    '-': '\u002D', // hyphen
    '=': '\u003D', // equals
    'q': '\u0642', // ق
    'w': '\u0648', // و
    'e': '\u0639', // ع
    'r': '\u0631', // ر
    't': '\u062A', // ت
    'y': '\u06D2', // ے
    'u': '\u0621', // ء
    'i': '\u06CC', // ی
    'o': '\u06C1', // ہ
    'p': '\u067E', // پ
    '[': '\u005D', // ] (reversed pair, deliberate)
    ']': '\u005B', // [
    '\\': '\u005C', // backslash
    'a': '\u0627', // ا
    's': '\u0633', // س
    'd': '\u062F', // د
    'f': '\u0641', // ف
    'g': '\u06AF', // گ
    'h': '\u062D', // ح (v1.2 moved it here from Shift+H)
    'j': '\u062C', // ج
    'k': '\u06A9', // ک
    'l': '\u0644', // ل
    ';': '\u061B', // ؛
    "'": '\u0027', // apostrophe
    'z': '\u0632', // ز
    'x': '\u0634', // ش
    'c': '\u0686', // چ
    'v': '\u0637', // ط
    'b': '\u0628', // ب
    'n': '\u0646', // ن
    'm': '\u0645', // م
    ',': '\u060C', // ،
    '.': '\u06D4', // ۔
    '/': '\u002F', // slash
  };

  /// What the same physical key types WITH Shift, keyed by the BASE key
  /// (so a tap on the on-screen keyboard can look it up directly).
  /// Keys with no character on this layer are absent: Shift+F and
  /// Shift+B type nothing, and Shift+2..8 are empty (see digit-row note).
  static const Map<String, String> shiftedByBase = {
    '`': '\u064B', // ً fathatan
    '1': '!', // kept from v1.1 — see digit-row note
    '9': '(', // kept from v1.1 — see digit-row note
    '0': ')', // kept from v1.1 — see digit-row note
    '-': '_',
    '=': '+',
    'q': '\u0652', // ْ sukun
    'w': '\u0651', // ّ shadda
    'e': '\u0670', // ٰ superscript alef
    'r': '\u0691', // ڑ
    't': '\u0679', // ٹ
    'y': '\u064E', // َ fatha
    'u': '\u0626', // ئ
    'i': '\u0650', // ٖ kasra
    'o': '\u06C3', // ۃ
    'p': '\u064F', // ُ damma
    '[': '}',
    ']': '{',
    '\\': '|',
    'a': '\u0622', // آ
    's': '\u0635', // ص
    'd': '\u0688', // ڈ
    'g': '\u063A', // غ
    'h': '\u06BE', // ھ (v1.2 moved it here from base H)
    'j': '\u0636', // ض
    'k': '\u062E', // خ
    'l': '@', // added in v1.2
    ';': ':',
    "'": '"',
    'z': '\u0630', // ذ
    'x': '\u0698', // ژ
    'c': '\u062B', // ث
    'v': '\u0638', // ظ
    'n': '\u06BA', // ں
    'm': '\u0658', // ٘
    ',': '\u066B', // ٫ (v1.2)
    '.': '.', // added in v1.2
    '/': '\u061F', // ؟
  };

  /// US-QWERTY Shift: the character an English keyboard types for
  /// Shift+`baseKey`. Letters shift to upper case; the rest follow the
  /// number/symbol rows.
  static const Map<String, String> _englishShift = {
    '`': '~',
    '1': '!',
    '2': '@',
    '3': '#',
    '4': r'$',
    '5': '%',
    '6': '^',
    '7': '&',
    '8': '*',
    '9': '(',
    '0': ')',
    '-': '_',
    '=': '+',
    '[': '{',
    ']': '}',
    '\\': '|',
    ';': ':',
    "'": '"',
    ',': '<',
    '.': '>',
    '/': '?',
  };

  static String _shiftKey(String base) =>
      _englishShift[base] ?? base.toUpperCase();

  /// What the same physical key types WITH Shift, keyed by the character
  /// an English keyboard would type for that Shift+key (so it can be
  /// located on the same key map). Derived from [shiftedByBase] so the
  /// two can never drift apart.
  static final Map<String, String> shifted = {
    for (final MapEntry<String, String> e in shiftedByBase.entries)
      _shiftKey(e.key): e.value,
  };

  /// The character [baseKey] types with Shift held, or null if the key
  /// types nothing with Shift (Shift+F, Shift+B, Shift+2..8).
  static String? shiftedFor(String baseKey) => shiftedByBase[baseKey];

  static final Map<String, String> _urduToLatin = {
    for (final MapEntry<String, String> e in unshifted.entries) e.value: e.key,
    for (final MapEntry<String, String> e in shifted.entries) e.value: e.key,
  };

  /// Every Urdu character the course may use.
  static Set<String> get allCharacters => _urduToLatin.keys.toSet();

  /// The English-keyboard character that types [urdu] on this layout
  /// (e.g. ص -> "S"), or null if the layout has no such character.
  static String? latinFor(String urdu) => _urduToLatin[urdu];
}
