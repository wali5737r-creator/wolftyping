import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/unicode_chars.dart';
import '../../model/typing_word_status.dart';

/// Renders the target paragraph word by word, coloring every character by
/// its live status (spec section 10/44 "Live Error Display"):
///
///  - words before the current one: colored per-character from what was
///    actually typed for them ([committedWordBuffers]), not just their
///    final correct/wrong verdict — a wrong word still shows exactly
///    which letters were wrong.
///  - the current word: colored live as [currentWordBuffer] grows, with
///    the next character to type underlined so it's unambiguous where
///    typing will land.
///  - words after the current one: plain "pending" color, untouched.
///
/// Consecutive characters that share the same style are emitted as ONE
/// [TextSpan] (a "run"), never one span per character. This matters for
/// Urdu/Arabic-script text: every span boundary is a place where the text
/// engine may re-shape and break the letter joins of Nastaleeq, so spans
/// are only split where the color/underline genuinely has to change
/// (a wrong letter, the cursor letter, the typed/untyped boundary). A
/// fully pending, fully correct or fully skipped word is a single span
/// and therefore always renders with its natural joins.
///
/// This widget only reads state handed to it — no comparison logic beyond
/// simple character-equality for *display purposes* lives here; the
/// authoritative correct/wrong/skipped verdicts all come from
/// TypingEngine via TypingController.
class TypingParagraphText extends StatelessWidget {
  const TypingParagraphText({
    super.key,
    required this.targetWords,
    required this.wordStatuses,
    required this.committedWordBuffers,
    required this.currentWordIndex,
    required this.currentWordBuffer,
    this.baseStyle,
    this.currentWordKey,
  });

  final List<String> targetWords;
  final List<TypingWordStatus> wordStatuses;
  final List<String> committedWordBuffers;
  final int currentWordIndex;
  final String currentWordBuffer;

  /// Base typography for the paragraph text. Defaults to
  /// [AppTextStyles.typingTextEn] (the existing English behavior,
  /// unchanged) — the Urdu screens pass [AppTextStyles.typingTextUr]
  /// instead so Urdu gets its proper line height/size without this widget
  /// needing to know about language at all.
  final TextStyle? baseStyle;

  /// Optional key attached to a zero-size marker placed just before the
  /// current word. Timed tests keep appending paragraphs, so the live
  /// screens use this to scroll the current word into view.
  final GlobalKey? currentWordKey;

  @override
  Widget build(BuildContext context) {
    final _Palette palette =
        _Palette.of(Theme.of(context).brightness == Brightness.dark);

    final List<InlineSpan> spans = [];
    for (int i = 0; i < targetWords.length; i++) {
      if (i > 0) spans.add(const TextSpan(text: ' '));
      if (i < currentWordIndex) {
        spans.add(_committedWordSpan(i, palette));
      } else if (i == currentWordIndex) {
        if (currentWordKey != null) {
          spans.add(WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: SizedBox.shrink(key: currentWordKey),
          ));
        }
        spans.add(_currentWordSpan(palette));
      } else {
        spans.add(TextSpan(
          text: targetWords[i],
          style: TextStyle(color: palette.pending),
        ));
      }
    }

    return SelectionContainer.disabled(
      child: RichText(
        text: TextSpan(
          style: (baseStyle ?? AppTextStyles.typingTextEn)
              .copyWith(color: palette.pending),
          children: spans,
        ),
      ),
    );
  }

  InlineSpan _committedWordSpan(int wordIndex, _Palette palette) {
    final String target = targetWords[wordIndex];

    if (wordStatuses[wordIndex] == TypingWordStatus.skipped) {
      return TextSpan(
        text: target,
        style: TextStyle(
          color: palette.skipped,
          decoration: TextDecoration.lineThrough,
        ),
      );
    }

    final String typed = wordIndex < committedWordBuffers.length
        ? committedWordBuffers[wordIndex]
        : '';
    final List<String> targetChars = splitChars(target);
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
    // Extra characters the user typed beyond the target word's length.
    if (typedChars.length > targetChars.length) {
      pieces.add(_Piece(
        typedChars.sublist(targetChars.length).join(),
        TextStyle(color: palette.wrong, backgroundColor: palette.wrongBg),
      ));
    }
    return TextSpan(children: _mergeRuns(pieces));
  }

  InlineSpan _currentWordSpan(_Palette palette) {
    final String target = targetWords[currentWordIndex];
    final List<String> targetChars = splitChars(target);
    final List<String> typedChars = splitChars(currentWordBuffer);

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
    // Typed further than the target word — extra wrong characters.
    if (typedChars.length > targetChars.length) {
      pieces.add(_Piece(
        typedChars.sublist(targetChars.length).join(),
        TextStyle(color: palette.wrong, backgroundColor: palette.wrongBg),
      ));
    }

    return TextSpan(
      // Subtle highlight behind the whole current word so it's easy to
      // find at a glance, independent of the per-character underline
      // marking the exact next keystroke.
      style: const TextStyle(backgroundColor: AppColors.currentWordBg),
      children: _mergeRuns(pieces),
    );
  }

  /// Joins neighbouring pieces with an identical style into one span.
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

/// The four state colors for the current brightness. Dark keeps the
/// original colors; light uses darker variants so pending / correct /
/// skipped text stays readable on a white surface.
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
