import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_fonts.dart';
import '../../service/urdu_phonetic_layout.dart';

enum _Finger { pinky, ring, middle, indexFinger, thumb }

/// Which hand types a key (used to pick the opposite-side Shift).
enum _Hand { left, right, both }

class _KeySpec {
  const _KeySpec(this.label, this.finger, this.hand,
      {this.width = 1, this.sub, this.urdu = false});

  final String label;

  /// Small corner label (the Latin key when [label] is an Urdu letter).
  final String? sub;
  final bool urdu;
  final _Finger finger;
  final _Hand hand;
  final double width;
}

/// Standard US QWERTY layout with the usual touch-typing finger map.
///
/// Presentation only: it is told which character is expected next and
/// lights up the key, the Shift key when needed, and (optionally) the
/// Backspace key. It never reads or changes typing state.
class LessonKeyboard extends StatelessWidget {
  const LessonKeyboard({
    super.key,
    this.nextChar,
    this.needsBackspace = false,
    this.focusKeys = '',
    this.urdu = false,
  });

  /// Show the Urdu phonetic layout labels (and translate [nextChar] /
  /// [focusKeys] from Urdu characters to physical keys). Finger colours and
  /// positions are the same as English because the layout is phonetic.
  final bool urdu;

  /// The character the learner must type next (' ' for space). Null = no
  /// "next key" highlight (intro preview).
  final String? nextChar;

  /// Highlight Backspace instead of [nextChar] (the learner typed a wrong
  /// character that should be deleted first).
  final bool needsBackspace;

  /// Keys the lesson introduces; outlined on the intro preview.
  final String focusKeys;

  static const List<String> _base = [
    '`1234567890-=',
    'qwertyuiop[]\\',
    "asdfghjkl;'",
    'zxcvbnm,./',
  ];
  static const List<String> _shifted = [
    '~!@#\$%^&*()_+',
    'QWERTYUIOP{}|',
    'ASDFGHJKL:"',
    'ZXCVBNM<>?',
  ];

  static const List<List<_Finger>> _fingers = [
    [
      _Finger.pinky, _Finger.pinky, _Finger.ring, _Finger.middle,
      _Finger.indexFinger, _Finger.indexFinger, _Finger.indexFinger, _Finger.indexFinger,
      _Finger.middle, _Finger.ring, _Finger.pinky, _Finger.pinky,
      _Finger.pinky,
    ],
    [
      _Finger.pinky, _Finger.ring, _Finger.middle, _Finger.indexFinger,
      _Finger.indexFinger, _Finger.indexFinger, _Finger.indexFinger, _Finger.middle,
      _Finger.ring, _Finger.pinky, _Finger.pinky, _Finger.pinky,
      _Finger.pinky,
    ],
    [
      _Finger.pinky, _Finger.ring, _Finger.middle, _Finger.indexFinger,
      _Finger.indexFinger, _Finger.indexFinger, _Finger.indexFinger, _Finger.middle,
      _Finger.ring, _Finger.pinky, _Finger.pinky,
    ],
    [
      _Finger.pinky, _Finger.ring, _Finger.middle, _Finger.indexFinger,
      _Finger.indexFinger, _Finger.indexFinger, _Finger.indexFinger, _Finger.middle,
      _Finger.ring, _Finger.pinky,
    ],
  ];

  // Number of keys on each row typed by the LEFT hand.
  static const List<int> _leftCount = [6, 5, 5, 5];

  static _Hand _handOf(int row, int col) =>
      col < _leftCount[row] ? _Hand.left : _Hand.right;

  /// Finds [char] on the layout: row, column and whether Shift is needed.
  static ({int row, int col, bool shift})? _locate(String char) {
    for (int r = 0; r < _base.length; r++) {
      final int c = _base[r].indexOf(char);
      if (c >= 0) return (row: r, col: c, shift: false);
      final int s = _shifted[r].indexOf(char);
      if (s >= 0) return (row: r, col: s, shift: true);
    }
    return null;
  }

  static Color _fingerColor(_Finger f) {
    switch (f) {
      case _Finger.pinky:
        return const Color(0xFF8B5CF6);
      case _Finger.ring:
        return const Color(0xFF0891B2);
      case _Finger.middle:
        return const Color(0xFFD97706);
      case _Finger.indexFinger:
        return AppColors.primary;
      case _Finger.thumb:
        return const Color(0xFF64748B);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? next = nextChar;
    if (urdu && next != null && next != ' ') {
      next = UrduPhoneticLayout.latinFor(next) ?? next;
    }
    final ({int row, int col, bool shift})? target =
        (next == null || next == ' ' || needsBackspace) ? null : _locate(next);
    final bool spaceNext = !needsBackspace && next == ' ';
    // Shift is pressed by the little finger of the hand NOT typing the key.
    final _Hand? shiftSide = (target != null && target.shift)
        ? (_handOf(target.row, target.col) == _Hand.left
            ? _Hand.right
            : _Hand.left)
        : null;
    final Set<String> focus = {
      for (final int r in focusKeys.runes)
        if (_locate(urdu
                ? (UrduPhoneticLayout.latinFor(String.fromCharCode(r)) ??
                    String.fromCharCode(r))
                : String.fromCharCode(r))
            case final loc?)
          '${loc.row}:${loc.col}',
    };

    return LayoutBuilder(builder: (context, constraints) {
      final double unit =
          ((constraints.maxWidth - 4) / 15).clamp(18.0, 40.0).toDouble();
      final double keyHeight = unit * 0.92;

      Widget key(_KeySpec spec,
          {bool next = false, bool outlined = false, bool bump = false}) {
        return _KeyCap(
          spec: spec,
          width: unit * spec.width,
          height: keyHeight,
          isNext: next,
          isFocus: outlined,
          homeBump: bump,
        );
      }

      Widget row(List<Widget> children) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          );

      List<Widget> letterRow(int r) {
        return [
          for (int c = 0; c < _base[r].length; c++)
            key(
              _KeySpec(
                urdu && UrduPhoneticLayout.unshifted[_base[r][c]] != null
                    ? UrduPhoneticLayout.unshifted[_base[r][c]]!
                    : _base[r][c].toUpperCase(),
                _fingers[r][c],
                _handOf(r, c),
                width: 1,
                sub: urdu && UrduPhoneticLayout.unshifted[_base[r][c]] != null
                    ? _base[r][c].toUpperCase()
                    : null,
                urdu: urdu && UrduPhoneticLayout.unshifted[_base[r][c]] != null,
              ),
              next: target != null &&
                  target.row == r &&
                  target.col == c,
              outlined: focus.contains('$r:$c'),
              bump: r == 2 && (c == 3 || c == 6),
            ),
        ];
      }

      _KeySpec special(String label, double w, _Finger f, _Hand h) =>
          _KeySpec(label, f, h, width: w);

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          row([
            ...letterRow(0),
            key(special('Back', 2, _Finger.pinky, _Hand.right),
                next: needsBackspace),
          ]),
          row([
            key(special('Tab', 1.5, _Finger.pinky, _Hand.left)),
            ...letterRow(1),
          ]),
          row([
            key(special('Caps', 1.75, _Finger.pinky, _Hand.left)),
            ...letterRow(2),
            key(special('Enter', 2.25, _Finger.pinky, _Hand.right)),
          ]),
          row([
            key(special('Shift', 2.25, _Finger.pinky, _Hand.left),
                next: shiftSide == _Hand.left),
            ...letterRow(3),
            key(special('Shift', 2.75, _Finger.pinky, _Hand.right),
                next: shiftSide == _Hand.right),
          ]),
          row([
            key(special('Space', 7, _Finger.thumb, _Hand.both),
                next: spaceNext),
          ]),
        ],
      );
    });
  }
}

class _KeyCap extends StatelessWidget {
  const _KeyCap({
    required this.spec,
    required this.width,
    required this.height,
    required this.isNext,
    required this.isFocus,
    required this.homeBump,
  });

  final _KeySpec spec;
  final double width;
  final double height;
  final bool isNext;
  final bool isFocus;
  final bool homeBump;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color accent = isDark ? AppColors.primaryDark : AppColors.primary;
    final Color onAccent = isDark ? const Color(0xFF042F2E) : Colors.white;
    final Color finger = LessonKeyboard._fingerColor(spec.finger);

    final Color background = isNext
        ? accent
        : finger.withValues(alpha: isDark ? 0.22 : 0.16);
    final Color border = isNext
        ? accent
        : isFocus
            ? accent
            : finger.withValues(alpha: 0.45);
    final Color textColor = isNext ? onAccent : theme.colorScheme.onSurface;
    final bool small = spec.label.length > 1;

    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: Container(
        width: width - 3,
        height: height - 3,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: border,
            width: isNext || isFocus ? 2 : 1,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              spec.label,
              maxLines: 1,
              style: TextStyle(
                fontSize: spec.urdu ? 17 : (small ? 10 : 13),
                height: spec.urdu ? 1.0 : null,
                fontFamily: spec.urdu ? AppFonts.urdu : null,
                fontWeight: isNext || isFocus ? FontWeight.w700 : FontWeight.w500,
                color: textColor,
              ),
            ),
            if (spec.sub != null)
              Positioned(
                left: 3,
                top: 1,
                child: Text(
                  spec.sub!,
                  style: TextStyle(
                    fontSize: 8,
                    color: textColor.withValues(alpha: 0.65),
                  ),
                ),
              ),
            if (homeBump)
              Positioned(
                bottom: 3,
                child: Container(
                  width: 10,
                  height: 2,
                  color: textColor.withValues(alpha: 0.7),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
