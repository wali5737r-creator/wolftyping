import '../../typing_test/model/typing_language.dart';
import 'lesson_level.dart';

/// The built-in, static definition of one lesson — title, drill content,
/// level and pass requirements. This is content data, not a database row:
/// [LessonRepository] seeds one `Lessons` table row per definition so
/// `LessonProgress` (which has a real foreign key to `Lessons`) has
/// something to point at, but the actual text/rules live here, in code,
/// organized and readable — never scattered across UI widgets.
class LessonDefinition {
  const LessonDefinition({
    required this.language,
    required this.level,
    required this.orderIndex,
    required this.title,
    required this.description,
    required this.content,
    double? requiredAccuracy,
    this.requiredWpm = 0,
    this.stage = '',
    this.focusKeys = '',
    this.fingerGuide = '',
    this.tip = '',
  }) : requiredAccuracy = requiredAccuracy ?? -1;

  final TypingLanguage language;
  final LessonLevel level;

  /// 1-based position within this language's full course. Determines
  /// display order AND the unlock sequence (lesson N unlocks once lesson
  /// N-1, same language, is completed).
  final int orderIndex;

  final String title;
  final String description;

  /// The actual text the user types. Real content, never placeholder
  /// text — for English this is plain text; for Urdu it's proper Unicode
  /// Urdu, typed directly (never transliterated).
  final String content;

  /// -1 sentinel means "use [LessonLevel.defaultRequiredAccuracy]" — set
  /// via the constructor's optional `requiredAccuracy` param so most
  /// lessons don't need to repeat their level's default explicitly.
  final double requiredAccuracy;

  /// 0 means no minimum WPM requirement — most lessons only require
  /// accuracy; a handful of "Speed Practice" lessons set this.
  final int requiredWpm;

  /// Course stage this lesson belongs to (e.g. "Stage 1 · Home Row"). Used
  /// to group the Lessons list. Empty = group by [level] instead.
  final String stage;

  /// Keys introduced by this lesson (e.g. "fj"). Highlighted on the intro
  /// keyboard preview. Empty when the lesson introduces no new key.
  final String focusKeys;

  /// Short "which finger types which key" line shown before the lesson.
  final String fingerGuide;

  /// One teaching tip shown before the lesson. Empty = no guide card.
  final String tip;

  double get effectiveRequiredAccuracy =>
      requiredAccuracy < 0 ? level.defaultRequiredAccuracy : requiredAccuracy;
}
