/// The Urdu phonetic keyboard layout the Urdu lessons are written for
/// (InPage-style phonetic: the Latin key you press decides the letter).
///
/// This is the ONLY place that describes the layout. If a key on your
/// Windows keyboard types a different letter, fix it here (and regenerate
/// the lesson text), nothing else needs to change.
///
/// Because the layout is phonetic, finger positions are exactly the QWERTY
/// ones, so the on-screen keyboard reuses the English finger map and only
/// swaps the labels.
class UrduPhoneticLayout {
  UrduPhoneticLayout._();

  /// Latin key (as printed on the keycap, lower case) -> Urdu character
  /// typed WITHOUT Shift.
  static const Map<String, String> unshifted = {
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
    'a': '\u0627', // ا
    's': '\u0633', // س
    'd': '\u062F', // د
    'f': '\u0641', // ف
    'g': '\u06AF', // گ
    'h': '\u06BE', // ھ
    'j': '\u062C', // ج
    'k': '\u06A9', // ک
    'l': '\u0644', // ل
    ';': '\u061B', // ؛
    'z': '\u0632', // ز
    'x': '\u0634', // ش
    'c': '\u0686', // چ
    'v': '\u0637', // ط
    'b': '\u0628', // ب
    'n': '\u0646', // ن
    'm': '\u0645', // م
    ',': '\u060C', // ،
    '.': '\u06D4', // ۔
    '1': '\u06F1', // ۱
    '2': '\u06F2',
    '3': '\u06F3',
    '4': '\u06F4',
    '5': '\u06F5',
    '6': '\u06F6',
    '7': '\u06F7',
    '8': '\u06F8',
    '9': '\u06F9',
    '0': '\u06F0',
  };

  /// What the same physical key types WITH Shift, keyed by the character
  /// an English keyboard would type for that Shift+key (so it can be
  /// located on the same key map).
  static const Map<String, String> shifted = {
    'S': '\u0635', // ص
    'D': '\u0688', // ڈ
    'G': '\u063A', // غ
    'H': '\u062D', // ح
    'J': '\u0636', // ض
    'K': '\u062E', // خ
    'T': '\u0679', // ٹ
    'R': '\u0691', // ڑ
    'N': '\u06BA', // ں
    'Z': '\u0630', // ذ
    'X': '\u0698', // ژ
    'C': '\u062B', // ث
    'V': '\u0638', // ظ
    '?': '\u061F', // ؟
    '!': '!',
    '(': '(',
    ')': ')',
  };

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
