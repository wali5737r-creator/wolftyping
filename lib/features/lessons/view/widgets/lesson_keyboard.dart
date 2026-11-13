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
/// Display-only by default: it is told which character is expected next
/// and lights up the key, the Shift key when needed, and (optionally) the
/// Backspace key. It never reads or changes typing state.
///
/// Tappable in Urdu mode: pass [onCharacter]/[onSpace]/[onBackspace] and
/// the board becomes the in-browser Urdu phonetic keyboard (CRULP v1.2 —
/// see [UrduPhoneticLayout]). Each tap inserts exactly one rune through
/// the same controller methods the physical keyboard uses, so scoring,
/// timer, mistakes and history are byte-identical. Shift is held
/// on-screen (one-shot: it releases after the next key tap) and Space
/// calls [onSpace], never `onCharacter(' ')`, so the word commits.
/// The board is wrapped in [ExcludeFocus] and re-requests [focusNode]
/// after every tap, so taps never steal focus from the typing area and
/// the physical keyboard keeps working unchanged. Tab, Caps and Enter
/// stay inert; the board itself stays in physical QWERTY order (never
/// mirrored for RTL — the paragraph stays RTL as today).
class LessonKeyboard extends StatefulWidget {
  const LessonKeyboard({
    super.key,
    this.nextChar,
    this.needsBackspace = false,
    this.focusKeys = '',
    this.urdu = false,
    this.onCharacter,
    this.onSpace,
    this.onBackspace,
    this.showBackspace = true,
    this.focusNode,
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

  /// Called with exactly one Urdu rune per letter-key tap. Null = the
  /// board is display-only. Taps are only enabled when [urdu] is true.
  final ValueChanged<String>? onCharacter;

  /// Called when the Space key is tapped (the word commits).
  final VoidCallback? onSpace;

  /// Called when the Backspace key is tapped.
  final VoidCallback? onBackspace;

  /// When false the Backspace key is shown disabled and does nothing
  /// (Settings > Allow backspace off — TypingInput drops it anyway).
  final bool showBackspace;

  /// The typing area's focus node, re-requested after every tap so the
  /// physical keyboard keeps working after on-screen taps.
  final FocusNode? focusNode;

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
  State<LessonKeyboard> createState() => _LessonKeyboardState();
}

class _LessonKeyboardState extends State<LessonKeyboard> {
  /// On-screen Shift held down (one-shot: releases after the next key tap).
  bool _shifted = false;

  /// Taps only exist in Urdu mode with callbacks.
  bool get _tappable => widget.urdu && widget.onCharacter != null;

  /// What physical key [base] types in the current Shift state, or null
  /// if it types nothing right now (base `, Shift+F, Shift+B, Shift+2..8).
  String? _typedChar(String base) => widget.urdu
      ? (_shifted
          ? UrduPhoneticLayout.shiftedFor(base)
          : UrduPhoneticLayout.unshifted[base])
      : null;

  void _refocus() => widget.focusNode?.requestFocus();

  void _tapLetter(String char) {
    widget.onCharacter?.call(char);
    if (!mounted) return;
    if (_shifted) setState(() => _shifted = false);
    _refocus();
  }

  void _tapSpace() {
    widget.onSpace?.call();
    if (!mounted) return;
    if (_shifted) setState(() => _shifted = false);
    _refocus();
  }

  void _tapBackspace() {
    widget.onBackspace?.call();
    if (!mounted) return;
    if (_shifted) setState(() => _shifted = false);
    _refocus();
  }

  void _tapShift() {
    setState(() => _shifted = !_shifted);
    _refocus();
  }

  @override
  Widget build(BuildContext context) {
    String? next = widget.nextChar;
    if (widget.urdu && next != null && next != ' ') {
      next = UrduPhoneticLayout.latinFor(next) ?? next;
    }
    final ({int row, int col, bool shift})? target =
        (next == null || next == ' ' || widget.needsBackspace)
            ? null
            : LessonKeyboard._locate(next);
    final bool spaceNext =
        !widget.needsBackspace && next == ' ';
    // Shift is pressed by the little finger of the hand NOT typing the key.
    // When the on-screen Shift is already held and the next key does NOT
    // need Shift, Shift must be released first: light up both Shift keys.
    final _Hand? shiftSide = (target != null && target.shift && !_shifted)
        ? (LessonKeyboard._handOf(target.row, target.col) == _Hand.left
            ? _Hand.right
            : _Hand.left)
        : null;
    final bool shiftReleaseNeeded =
        target != null && !target.shift && _shifted;
    final Set<String> focus = {
      for (final int r in widget.focusKeys.runes)
        if (LessonKeyboard._locate(widget.urdu
                ? (UrduPhoneticLayout.latinFor(String.fromCharCode(r)) ??
                    String.fromCharCode(r))
                : String.fromCharCode(r))
            case final loc?)
          '${loc.row}:${loc.col}',
    };

    return ExcludeFocus(
      child: LayoutBuilder(builder: (context, constraints) {
        final double unit =
            ((constraints.maxWidth - 4) / 15).clamp(18.0, 40.0).toDouble();
        final double keyHeight = unit * 0.92;

        Widget key(_KeySpec spec,
            {bool next = false,
            bool outlined = false,
            bool bump = false,
            VoidCallback? onTap,
            bool enabled = true}) {
          return _KeyCap(
            spec: spec,
            width: unit * spec.width,
            height: keyHeight,
            isNext: next,
            isFocus: outlined,
            homeBump: bump,
            onTap: onTap,
            enabled: enabled,
          );
        }

        Widget row(List<Widget> children) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            );

        List<Widget> letterRow(int r) {
          return [
            for (int c = 0; c < LessonKeyboard._base[r].length; c++)
              key(
                _KeySpec(
                  _labelFor(LessonKeyboard._base[r][c]),
                  LessonKeyboard._fingers[r][c],
                  LessonKeyboard._handOf(r, c),
                  width: 1,
                  sub: widget.urdu
                      ? LessonKeyboard._base[r][c].toUpperCase()
                      : null,
                  urdu: widget.urdu &&
                      _typedChar(LessonKeyboard._base[r][c]) != null,
                ),
                next: target != null && target.row == r && target.col == c,
                outlined: focus.contains('$r:$c'),
                bump: r == 2 && (c == 3 || c == 6),
                onTap: _tappable &&
                        _typedChar(LessonKeyboard._base[r][c]) != null
                    ? () => _tapLetter(
                        _typedChar(LessonKeyboard._base[r][c])!)
                    : null,
                // Display-only boards keep every key at full opacity;
                // only tappable boards dim keys that type nothing.
                enabled: !_tappable ||
                    _typedChar(LessonKeyboard._base[r][c]) != null,
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
                  next: widget.needsBackspace,
                  onTap: _tappable ? _tapBackspace : null,
                  enabled: widget.showBackspace),
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
                  next: shiftSide == _Hand.left || shiftReleaseNeeded,
                  onTap: _tappable ? _tapShift : null),
              ...letterRow(3),
              key(special('Shift', 2.75, _Finger.pinky, _Hand.right),
                  next: shiftSide == _Hand.right || shiftReleaseNeeded,
                  onTap: _tappable ? _tapShift : null),
            ]),
            row([
              key(special('Space', 7, _Finger.thumb, _Hand.both),
                  next: spaceNext,
                  onTap: _tappable ? _tapSpace : null),
            ]),
          ],
        );
      }),
    );
  }

  /// Label for physical key [base] in the current Shift state. Urdu mode
  /// shows the Urdu letter (blank when the key types nothing right now);
  /// otherwise the Latin keycap, as before.
  String _labelFor(String base) {
    if (!widget.urdu) return base.toUpperCase();
    final String? typed = _typedChar(base);
    if (typed != null) return typed;
    // Unshifted: a key with no Urdu mapping shows its Latin keycap (as
    // before — only base ` has no mapping). Shifted: it types nothing,
    // so it shows blank rather than a letter it cannot type.
    return _shifted ? '' : base.toUpperCase();
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
    this.onTap,
    this.enabled = true,
  });

  final _KeySpec spec;
  final double width;
  final double height;
  final bool isNext;
  final bool isFocus;
  final bool homeBump;

  /// Null = display-only key. Non-null = tappable (InkWell).
  final VoidCallback? onTap;

  /// False = shown dimmed and does not respond (e.g. Backspace when
  /// Settings > Allow backspace is off, or a key with no mapping).
  final bool enabled;

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

    final Widget cap = Container(
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
    );

    final Widget padded = onTap == null
        ? Padding(padding: const EdgeInsets.all(1.5), child: cap)
        : Padding(
            padding: const EdgeInsets.all(1.5),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: enabled ? onTap : null,
                borderRadius: BorderRadius.circular(6),
                child: cap,
              ),
            ),
          );
    return enabled ? padded : Opacity(opacity: 0.38, child: padded);
  }
}
