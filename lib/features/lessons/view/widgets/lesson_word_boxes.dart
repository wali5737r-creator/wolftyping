import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/unicode_chars.dart';
import '../../../typing_test/model/typing_word_status.dart';
import 'lesson_keyboard.dart';

/// Lesson practice drill rendered as key-style word boxes — one box per
/// word, like keys on a keyboard (Muhammad's redesign, 2026-11-14:
/// "hr word ko aik box mai bnao jsy keyboard mai hota", so that practice
/// sets the learner's hand).
///
/// This widget is LESSONS-ONLY. The typing-test / PPSC / mock screens
/// keep their flowing paragraph ([TypingParagraphText]) — nothing there
/// changes. Same data in, same scoring out: it only reads the state the
/// [LessonPracticeController] already exposes (target words, word
/// statuses, committed buffers, current word + buffer), so lesson
/// content, drill words and grading are untouched.
///
/// How a box looks:
///  - every box has a 3px top edge in the colour of the finger that types
///    the word's FIRST letter — the exact colour the finger-guide board
///    paints that finger ([LessonKeyboard.fingerInfoFor]), so the boxes
///    and the guide page (#/lesson-keyboard-guide) can never disagree;
///  - the current word's box is highlighted (teal accent border +
///    [AppColors.currentWordBg]) and its next character is underlined,
///    so it's unambiguous where typing lands;
///  - a committed word turns green (correct), red (wrong) or amber with
///    a strikethrough (skipped), coloured per character from what was
///    actually typed — the same per-character feedback the paragraph
///    widget gives, so a wrong word still shows exactly which letters
///    were wrong;
///  - pending words stay in the pending colour.
///
/// One box, one word — always. Every caller already splits the drill on
/// whitespace ([TypingEngine] for practice, `content.split` for the intro
/// preview), and no lesson definition contains a multi-word entry, but
/// this widget flattens any entry that ever arrives with spaces anyway,
/// remapping its per-word state by the entry's original index — so a box
/// can never hold two or three words. The boxes are also unmistakably
/// separate: a strong finger-colour border (0.8 alpha) and 12px gaps,
/// so even two-letter words ("ff", "jjj") read as distinct boxes on a
/// real laptop screen, not one box holding "ff jjj jfj" (Muhammad's
/// report, 2026-11-14: "Aik box ma aik word ho tmny 2 3 rkh diye").
///
/// Urdu: the word text uses [AppTextStyles.typingTextUr] (26px, height
/// 2.6 — Noto Nastaliq Urdu's natural line height), so the full glyph —
/// dots above and below the baseline — fits inside its box. Consecutive
/// characters that share a style are emitted as ONE span (a "run"), never
/// one span per character: every span boundary is a place where the text
/// engine may re-shape and break the letter joins of Nastaleeq, so a
/// fully pending, fully correct or fully skipped word is a single span
/// and always renders with its natural joins — same rule as
/// [TypingParagraphText].
///
/// The boxes are DISPLAY/FEEDBACK only — they are not an on-screen
/// keyboard: no key is tappable, nothing types anything. Typing still
/// comes from the physical keyboard only.
class LessonWordBoxes extends StatelessWidget {
  const LessonWordBoxes({
    super.key,
    required this.targetWords,
    required this.wordStatuses,
    required this.committedWordBuffers,
    required this.currentWordIndex,
    required this.currentWordBuffer,
    required this.isUrdu,
    this.baseStyle,
  });

  final List<String> targetWords;
  final List<TypingWordStatus> wordStatuses;
  final List<String> committedWordBuffers;

  /// Index of the word being typed. -1 = preview mode (intro panel):
  /// every word renders pending, no word is highlighted.
  final int currentWordIndex;
  final String currentWordBuffer;
  final bool isUrdu;

  /// Base typography. Defaults to [AppTextStyles.typingTextEn] — or
  /// [AppTextStyles.typingTextUr] when [isUrdu] is true, so Urdu boxes
  /// always get Nastaliq with its 2.6 line height even when the caller
  /// passes no style.
  final TextStyle? baseStyle;

  @override
  Widget build(BuildContext context) {
    // One box per word — hard guarantee: flatten any entry that arrives
    // with spaces (see the class doc). In practice every caller already
    // splits, so this is normally the identity mapping; the per-word
    // state (status, committed buffer, current word + buffer) is remapped
    // by the entry's original index, so nothing can drift out of step.
    final List<_BoxWord> boxes = <_BoxWord>[];
    for (int i = 0; i < targetWords.length; i++) {
      final List<String> parts = targetWords[i]
          .split(RegExp(r'\s+'))
          .where((String w) => w.isNotEmpty)
          .toList();
      for (int p = 0; p < parts.length; p++) {
        boxes.add(_BoxWord(
          word: parts[p],
          originalIndex: i,
          isFirstPiece: p == 0,
        ));
      }
    }
    return SelectionContainer.disabled(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (int j = 0; j < boxes.length; j++)
            _WordBox(
              index: j,
              word: boxes[j].word,
              status: boxes[j].originalIndex < wordStatuses.length
                  ? wordStatuses[boxes[j].originalIndex]
                  : TypingWordStatus.pending,
              typed: boxes[j].originalIndex < committedWordBuffers.length
                  ? committedWordBuffers[boxes[j].originalIndex]
                  : '',
              isCurrent: boxes[j].originalIndex == currentWordIndex &&
                  boxes[j].isFirstPiece,
              currentBuffer: boxes[j].originalIndex == currentWordIndex &&
                      boxes[j].isFirstPiece
                  ? currentWordBuffer
                  : '',
              isUrdu: isUrdu,
              baseStyle: baseStyle ??
                  (isUrdu
                      ? AppTextStyles.typingTextUr
                      : AppTextStyles.typingTextEn),
            ),
        ],
      ),
    );
  }
}

/// One flattened word for [_WordBox]: the word itself plus which entry
/// of [LessonWordBoxes.targetWords] it came from (for remapping the
/// per-word state) and whether it is that entry's first piece (only the
/// first piece of the current word is the current box).
class _BoxWord {
  const _BoxWord({
    required this.word,
    required this.originalIndex,
    required this.isFirstPiece,
  });

  final String word;
  final int originalIndex;
  final bool isFirstPiece;
}

class _WordBox extends StatelessWidget {
  const _WordBox({
    required this.index,
    required this.word,
    required this.status,
    required this.typed,
    required this.isCurrent,
    required this.currentBuffer,
    required this.isUrdu,
    required this.baseStyle,
  });

  final int index;
  final String word;
  final TypingWordStatus status;
  final String typed;
  final bool isCurrent;
  final String currentBuffer;
  final bool isUrdu;
  final TextStyle baseStyle;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final _Palette palette = _Palette.of(isDark);
    final Color accent = isDark ? AppColors.primaryDark : AppColors.primary;

    // The finger that types this word's first letter — the box's top
    // edge is painted in that finger's colour. A character on no key
    // (should not happen in a lesson drill) falls back to neutral.
    final String firstChar =
        word.isEmpty ? '' : String.fromCharCode(word.runes.first);
    final ({Color color, String label})? finger =
        firstChar.isEmpty
            ? null
            : LessonKeyboard.fingerInfoFor(firstChar, urdu: isUrdu);
    final Color fingerColor =
        finger?.color ?? (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8));

    final Color background;
    final Color borderColor;
    final double borderWidth;
    if (isCurrent) {
      background = AppColors.currentWordBg;
      borderColor = accent;
      borderWidth = 2;
    } else if (status == TypingWordStatus.correct) {
      background = AppColors.correctCharBg;
      borderColor = palette.correct;
      borderWidth = 1.5;
    } else if (status == TypingWordStatus.wrong) {
      background = AppColors.wrongCharBg;
      borderColor = palette.wrong;
      borderWidth = 1.5;
    } else if (status == TypingWordStatus.skipped) {
      background = AppColors.skippedWordBg;
      borderColor = palette.skipped;
      borderWidth = 1.5;
    } else {
      // Pending: a clearly visible finger-colour border (0.8 alpha) and
      // a 2px edge — the old 0.45-alpha 1.5px edge on a 0.08-alpha
      // background was so faint that adjacent two-letter boxes ("ff",
      // "jjj") read as one box holding several words on a real laptop
      // screen. The border is the box's outline; the background stays
      // light so the pending text keeps its contrast.
      background = fingerColor.withValues(alpha: isDark ? 0.18 : 0.12);
      borderColor = fingerColor.withValues(alpha: 0.8);
      borderWidth = 2;
    }

    // One rounded box: the body carries the state border/background and
    // the word text; a 3px strip of the finger colour sits on its top
    // edge. (A single Border with different side colours cannot carry a
    // borderRadius in Flutter — "A borderRadius can only be given on
    // borders with uniform colors" — hence the strip as a separate
    // positioned bar, clipped to the same rounded shape.)
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          Container(
            key: ValueKey('lesson-word-box-$index'),
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              // Nastaliq glyphs are tall (line height 2.6em): the extra
              // vertical room keeps dots and tails inside the box.
              vertical: isUrdu ? 2 : 5,
            ),
            decoration: BoxDecoration(
              color: background,
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: RichText(
              text: TextSpan(
                style: baseStyle.copyWith(color: palette.pending),
                children: _spans(palette),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              key: ValueKey('lesson-word-box-finger-$index'),
              height: 3,
              color: fingerColor,
            ),
          ),
        ],
      ),
    );
  }

  List<InlineSpan> _spans(_Palette palette) {
    if (isCurrent) return _currentWordSpans(palette);
    if (status == TypingWordStatus.skipped) {
      return [
        TextSpan(
          text: word,
          style: TextStyle(
            color: palette.skipped,
            decoration: TextDecoration.lineThrough,
          ),
        ),
      ];
    }
    if (status == TypingWordStatus.correct ||
        status == TypingWordStatus.wrong) {
      return _committedWordSpans(palette);
    }
    // Pending (and preview): one span, natural joins preserved.
    return [TextSpan(text: word, style: TextStyle(color: palette.pending))];
  }

  List<InlineSpan> _committedWordSpans(_Palette palette) {
    final List<String> targetChars = splitChars(word);
    final List<String> typedChars = splitChars(typed);
    final List<_Piece> pieces = [];
    for (int i = 0; i < targetChars.length; i++) {
      final bool hasTyped = i < typedChars.length;
      final bool correct = hasTyped && typedChars[i] == targetChars[i];
      pieces.add(_Piece(
        targetChars[i],
        !hasTyped
            ? TextStyle(color: palette.pending)
            : (correct
                ? TextStyle(color: palette.correct)
                : TextStyle(
                    color: palette.wrong,
                    backgroundColor: palette.wrongBg,
                  )),
      ));
    }
    if (typedChars.length > targetChars.length) {
      pieces.add(_Piece(
        typedChars.sublist(targetChars.length).join(),
        TextStyle(color: palette.wrong, backgroundColor: palette.wrongBg),
      ));
    }
    return _mergeRuns(pieces);
  }

  List<InlineSpan> _currentWordSpans(_Palette palette) {
    final List<String> targetChars = splitChars(word);
    final List<String> typedChars = splitChars(currentBuffer);
    final List<_Piece> pieces = [];
    for (int i = 0; i < targetChars.length; i++) {
      final bool hasTyped = i < typedChars.length;
      final bool isCursor = i == typedChars.length;
      Color color;
      Color? background;
      if (!hasTyped) {
        color = palette.pending;
      } else if (typedChars[i] == targetChars[i]) {
        color = palette.correct;
      } else {
        color = palette.wrong;
        background = palette.wrongBg;
      }
      pieces.add(_Piece(
        targetChars[i],
        TextStyle(
          color: color,
          backgroundColor: background,
          decoration: isCursor ? TextDecoration.underline : null,
          decorationThickness: 2,
        ),
      ));
    }
    if (typedChars.length > targetChars.length) {
      pieces.add(_Piece(
        typedChars.sublist(targetChars.length).join(),
        TextStyle(color: palette.wrong, backgroundColor: palette.wrongBg),
      ));
    }
    return _mergeRuns(pieces);
  }

  /// Joins neighbouring pieces with an identical style into one span —
  /// same rule as TypingParagraphText, so Urdu joins survive.
  static List<InlineSpan> _mergeRuns(List<_Piece> pieces) {
    final List<InlineSpan> runs = [];
    final StringBuffer buffer = StringBuffer();
    TextStyle? current;
    for (final _Piece p in pieces) {
      if (current != null && current == p.style) {
        buffer.write(p.text);
        continue;
      }
      if (current != null) {
        runs.add(TextSpan(text: buffer.toString(), style: current));
        buffer.clear();
      }
      current = p.style;
      buffer.write(p.text);
    }
    if (current != null) {
      runs.add(TextSpan(text: buffer.toString(), style: current));
    }
    return runs;
  }
}

class _Piece {
  const _Piece(this.text, this.style);

  final String text;
  final TextStyle style;
}

/// The state colors for the current brightness — same palette as
/// TypingParagraphText, so a word means the same colour everywhere.
class _Palette {
  const _Palette({
    required this.pending,
    required this.correct,
    required this.wrong,
    required this.wrongBg,
    required this.skipped,
  });

  final Color pending;
  final Color correct;
  final Color wrong;
  final Color wrongBg;
  final Color skipped;

  static const _Palette _dark = _Palette(
    pending: AppColors.pendingText,
    correct: AppColors.correctChar,
    wrong: AppColors.wrongCharDark,
    wrongBg: AppColors.wrongCharBg,
    skipped: AppColors.skippedWord,
  );

  static const _Palette _light = _Palette(
    pending: AppColors.pendingTextLight,
    correct: AppColors.correctCharLight,
    wrong: AppColors.wrongCharLight,
    wrongBg: AppColors.wrongCharBg,
    skipped: AppColors.skippedWordLight,
  );

  static _Palette of(bool isDark) => isDark ? _dark : _light;
}
