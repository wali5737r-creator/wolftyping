import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/lessons/service/urdu_phonetic_layout.dart';
import 'package:typing_master/features/lessons/view/widgets/lesson_keyboard.dart';
import 'package:typing_master/features/typing_test/controller/urdu_typing_controller.dart';
import 'package:typing_master/features/typing_test/model/typing_screen_phase.dart';

/// CRULP Urdu Phonetic v1.2 (17 Oct 2019) key map + the on-screen keyboard
/// built on it: taps insert the right rune, Shift is one-shot, Space
/// commits the word, Backspace deletes, and on-screen taps score exactly
/// like physical keys (same controller methods, same engine).
void main() {
  group('CRULP v1.2 layout map', () {
    test('unshifted layer is exactly the v1.2 base layer', () {
      expect(UrduPhoneticLayout.unshifted, <String, String>{
        '1': '\u06F1',
        '2': '\u06F2',
        '3': '\u06F3',
        '4': '\u06F4',
        '5': '\u06F5',
        '6': '\u06F6',
        '7': '\u06F7',
        '8': '\u06F8',
        '9': '\u06F9',
        '0': '\u06F0',
        '-': '\u002D',
        '=': '\u003D',
        'q': '\u0642',
        'w': '\u0648',
        'e': '\u0639',
        'r': '\u0631',
        't': '\u062A',
        'y': '\u06D2',
        'u': '\u0621',
        'i': '\u06CC',
        'o': '\u06C1',
        'p': '\u067E',
        '[': '\u005D',
        ']': '\u005B',
        '\\': '\u005C',
        'a': '\u0627',
        's': '\u0633',
        'd': '\u062F',
        'f': '\u0641',
        'g': '\u06AF',
        'h': '\u062D',
        'j': '\u062C',
        'k': '\u06A9',
        'l': '\u0644',
        ';': '\u061B',
        "'": '\u0027',
        'z': '\u0632',
        'x': '\u0634',
        'c': '\u0686',
        'v': '\u0637',
        'b': '\u0628',
        'n': '\u0646',
        'm': '\u0645',
        ',': '\u060C',
        '.': '\u06D4',
        '/': '\u002F',
      });
    });

    test('shifted layer is exactly the v1.2 shift layer', () {
      expect(UrduPhoneticLayout.shiftedByBase, <String, String>{
        '`': '\u064B',
        '1': '!',
        '9': '(',
        '0': ')',
        '-': '_',
        '=': '+',
        'q': '\u0652',
        'w': '\u0651',
        'e': '\u0670',
        'r': '\u0691',
        't': '\u0679',
        'y': '\u064E',
        'u': '\u0626',
        'i': '\u0650',
        'o': '\u06C3',
        'p': '\u064F',
        '[': '}',
        ']': '{',
        '\\': '|',
        'a': '\u0622',
        's': '\u0635',
        'd': '\u0688',
        'g': '\u063A',
        'h': '\u06BE',
        'j': '\u0636',
        'k': '\u062E',
        'l': '@',
        ';': ':',
        "'": '"',
        'z': '\u0630',
        'x': '\u0698',
        'c': '\u062B',
        'v': '\u0638',
        'n': '\u06BA',
        'm': '\u0658',
        ',': '\u066B',
        '.': '.',
        '/': '\u061F',
      });
    });

    test('empty keys: base `, Shift+F, Shift+B, Shift+2..8 type nothing',
        () {
      expect(UrduPhoneticLayout.unshifted.containsKey('`'), isFalse);
      expect(UrduPhoneticLayout.shiftedFor('f'), isNull);
      expect(UrduPhoneticLayout.shiftedFor('b'), isNull);
      for (final String d in <String>['2', '3', '4', '5', '6', '7', '8']) {
        expect(UrduPhoneticLayout.shiftedFor(d), isNull, reason: 'Shift+$d');
      }
    });

    test('v1.2 moved ح/ھ: base H is ح, Shift+H is ھ', () {
      expect(UrduPhoneticLayout.unshifted['h'], '\u062D');
      expect(UrduPhoneticLayout.shiftedFor('h'), '\u06BE');
    });

    test('Urdu code points, never Arabic look-alikes', () {
      expect(UrduPhoneticLayout.unshifted['i'], '\u06CC'); // ی, not ي
      expect(UrduPhoneticLayout.unshifted['k'], '\u06A9'); // ک, not ك
      expect(UrduPhoneticLayout.unshifted['o'], '\u06C1'); // ہ, not ه
      expect(UrduPhoneticLayout.shiftedFor('h'), '\u06BE'); // ھ
      expect(UrduPhoneticLayout.unshifted['y'], '\u06D2'); // ے
    });

    test('v1.2 additions: Shift+L is @, Shift+. is ., Shift+, is ٫', () {
      expect(UrduPhoneticLayout.shiftedFor('l'), '@');
      expect(UrduPhoneticLayout.shiftedFor('.'), '.');
      expect(UrduPhoneticLayout.shiftedFor(','), '\u066B');
    });

    test('latinFor maps every layout character back to a physical key',
        () {
      for (final String ch in UrduPhoneticLayout.allCharacters) {
        expect(UrduPhoneticLayout.latinFor(ch), isNotNull, reason: ch);
      }
      expect(UrduPhoneticLayout.latinFor('\u0627'), 'a');
      expect(UrduPhoneticLayout.latinFor('\u0635'), 'S');
      expect(UrduPhoneticLayout.latinFor('\u061F'), '?');
      expect(UrduPhoneticLayout.latinFor('!'), '!');
      expect(UrduPhoneticLayout.latinFor('('), '(');
      expect(UrduPhoneticLayout.latinFor(')'), ')');
      expect(UrduPhoneticLayout.latinFor('\u0622'), 'A');
      expect(UrduPhoneticLayout.latinFor('@'), 'L');
      expect(UrduPhoneticLayout.latinFor('.'), '>');
      expect(UrduPhoneticLayout.latinFor('\u06D4'), '.');
      expect(UrduPhoneticLayout.latinFor('\u064B'), '~');
      expect(UrduPhoneticLayout.latinFor('\u066B'), '<');
      expect(UrduPhoneticLayout.latinFor('\u0626'), 'U');
      expect(UrduPhoneticLayout.latinFor('\u06C3'), 'O');
    });

    test('derived shifted map (keyed by English shifted char) agrees', () {
      expect(UrduPhoneticLayout.shifted['S'], '\u0635');
      expect(UrduPhoneticLayout.shifted['!'], '!');
      expect(UrduPhoneticLayout.shifted['>'], '.');
      expect(UrduPhoneticLayout.shifted['L'], '@');
      expect(UrduPhoneticLayout.shifted['~'], '\u064B');
      expect(UrduPhoneticLayout.shifted['?'], '\u061F');
      expect(UrduPhoneticLayout.shifted.containsKey('F'), isFalse);
      expect(UrduPhoneticLayout.shifted.containsKey('B'), isFalse);
    });
  });

  group('on-screen Urdu keyboard widget', () {
    /// Key-cap labels are Text widgets; the tiny Latin corner label is
    /// fontSize 8, so it is excluded and only the main label matches.
    Finder findKey(String label) => find.byWidgetPredicate(
          (Widget w) =>
              w is Text && w.data == label && w.style?.fontSize != 8,
        );

    Future<_Harness> pumpKeyboard(
      WidgetTester tester, {
      double width = 800,
      bool showBackspace = true,
    }) async {
      final _Harness h = _Harness();
      tester.view.physicalSize = const Size(1000, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Focus(
              focusNode: h.focusNode,
              autofocus: true,
              child: Center(
                child: SizedBox(
                  width: width,
                  child: LessonKeyboard(
                    urdu: true,
                    onCharacter: h.chars.add,
                    onSpace: () => h.spaces++,
                    onBackspace: () => h.backspaces++,
                    showBackspace: showBackspace,
                    focusNode: h.focusNode,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return h;
    }

    Future<void> tapShift(WidgetTester tester) async {
      await tester.tap(findKey('Shift').first);
      await tester.pump();
    }

    testWidgets('tapping ق inserts ق', (tester) async {
      final _Harness h = await pumpKeyboard(tester);
      await tester.tap(findKey('\u0642'));
      await tester.pump();
      expect(h.chars, <String>['\u0642']);
    });

    testWidgets('Shift+S inserts ص, then Shift releases for the next key',
        (tester) async {
      final _Harness h = await pumpKeyboard(tester);
      await tapShift(tester);
      await tester.tap(findKey('\u0635'));
      await tester.pump();
      expect(h.chars, <String>['\u0635']);
      // Shift released: س is back on the S key, not ص.
      expect(findKey('\u0633'), findsOneWidget);
      await tester.tap(findKey('\u0633'));
      await tester.pump();
      expect(h.chars, <String>['\u0635', '\u0633']);
    });

    testWidgets('Shift+1/9/0 insert ! ( )', (tester) async {
      final _Harness h = await pumpKeyboard(tester);
      for (final String label in <String>['!', '(', ')']) {
        await tapShift(tester);
        await tester.tap(findKey(label));
        await tester.pump();
      }
      expect(h.chars, <String>['!', '(', ')']);
    });

    testWidgets('every letter, digit and punctuation key types its rune',
        (tester) async {
      final _Harness h = await pumpKeyboard(tester);
      const List<(String, String, bool)> keys = [
        ('\u06F1', '\u06F1', false), // ۱
        ('\u06F9', '\u06F9', false), // ۹
        ('\u061B', '\u061B', false), // ؛
        ('\u06D4', '\u06D4', false), // ۔
        ('\u060C', '\u060C', false), // ،
        ('\u0642', '\u0642', false), // ق
        ('\u06CC', '\u06CC', false), // ی
        ('\u06A9', '\u06A9', false), // ک
        ('\u06C1', '\u06C1', false), // ہ
        ('\u06D2', '\u06D2', false), // ے
        ('\u062D', '\u062D', false), // ح (base H in v1.2)
        ('\u061F', '\u061F', true), // ؟ Shift+/
        ('\u0622', '\u0622', true), // آ Shift+A
        ('@', '@', true), // Shift+L
        ('!', '!', true), // Shift+1
        ('(', '(', true), // Shift+9
        (')', ')', true), // Shift+0
        ('\u0635', '\u0635', true), // ص Shift+S
        ('\u0679', '\u0679', true), // ٹ Shift+T
        ('\u06BA', '\u06BA', true), // ں Shift+N
        ('\u06C3', '\u06C3', true), // ۃ Shift+O
        ('}', '}', true), // Shift+[
        ('{', '{', true), // Shift+]
        ('|', '|', true), // Shift+\
        ('"', '"', true), // Shift+'
        (':', ':', true), // Shift+;
        ('_', '_', true), // Shift+-
        ('+', '+', true), // Shift+=
        ('\u064B', '\u064B', true), // ً Shift+`
        ('\u066B', '\u066B', true), // ٫ Shift+,
        ('\u06BE', '\u06BE', true), // ھ Shift+H in v1.2
      ];
      final List<String> expected = <String>[];
      for (final (String label, String rune, bool shifted) in keys) {
        if (shifted) await tapShift(tester);
        await tester.tap(findKey(label));
        await tester.pump();
        expected.add(rune);
      }
      expect(h.chars, expected);
    });

    testWidgets('Space calls onSpace, never onCharacter', (tester) async {
      final _Harness h = await pumpKeyboard(tester);
      await tester.tap(findKey('Space'));
      await tester.pump();
      expect(h.spaces, 1);
      expect(h.chars, isEmpty);
    });

    testWidgets('Back calls onBackspace', (tester) async {
      final _Harness h = await pumpKeyboard(tester);
      await tester.tap(findKey('Back'));
      await tester.pump();
      expect(h.backspaces, 1);
    });

    testWidgets('Backspace does nothing when showBackspace is false',
        (tester) async {
      final _Harness h = await pumpKeyboard(tester, showBackspace: false);
      await tester.tap(findKey('Back'));
      await tester.pump();
      expect(h.backspaces, 0);
    });

    testWidgets('Shift+F and Shift+B have no key to tap', (tester) async {
      await pumpKeyboard(tester);
      expect(findKey('\u0641'), findsOneWidget); // ف unshifted
      expect(findKey('\u0628'), findsOneWidget); // ب unshifted
      await tapShift(tester);
      expect(findKey('\u0641'), findsNothing);
      expect(findKey('\u0628'), findsNothing);
    });

    testWidgets('taps do not steal focus from the typing area',
        (tester) async {
      final _Harness h = await pumpKeyboard(tester);
      expect(h.focusNode.hasFocus, isTrue);
      await tester.tap(findKey('\u0642'));
      await tester.pump();
      expect(h.focusNode.hasFocus, isTrue);
      await tapShift(tester);
      await tester.tap(findKey('\u0635'));
      await tester.pump();
      expect(h.focusNode.hasFocus, isTrue);
    });

    testWidgets('no overflow at 360px width', (tester) async {
      await pumpKeyboard(tester, width: 360);
      expect(tester.takeException(), isNull);
    });
  });

  group('on-screen taps score like physical keys', () {
    /// Taps the on-screen key for [ch], pressing Shift first when the
    /// character lives on the Shift layer.
    Future<void> tapChar(WidgetTester tester, String ch) async {
      final Finder key = find.byWidgetPredicate(
        (Widget w) => w is Text && w.data == ch && w.style?.fontSize != 8,
      );
      if (key.evaluate().isEmpty) {
        final Finder shift = find.byWidgetPredicate(
          (Widget w) =>
              w is Text && w.data == 'Shift' && w.style?.fontSize != 8,
        );
        await tester.tap(shift.first);
        await tester.pump();
      }
      await tester.tap(key);
      await tester.pump();
    }

    testWidgets('first word by on-screen taps, second by controller calls',
        (tester) async {
      tester.view.physicalSize = const Size(1400, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        GetMaterialApp(
          theme: AppTheme.light,
          initialRoute: AppRoutes.urduTypingTest,
          getPages: AppPages.pages,
        ),
      );
      await tester.pumpAndSettle();

      final UrduTypingController controller =
          Get.find<UrduTypingController>();
      controller.selectDuration(const Duration(seconds: 60));
      await tester.tap(find.text('Start Test'));
      await tester.pumpAndSettle();
      expect(controller.screenPhase.value, TypingScreenPhase.test);
      expect(controller.targetWords.length, greaterThan(1));

      // Word 1: every character + Space through the on-screen keyboard.
      final String firstWord = controller.targetWords.first;
      for (final int rune in firstWord.runes) {
        await tapChar(tester, String.fromCharCode(rune));
      }
      await tester.tap(find.byWidgetPredicate(
        (Widget w) =>
            w is Text && w.data == 'Space' && w.style?.fontSize != 8,
      ));
      await tester.pump();
      expect(controller.committedWordBuffers.first, firstWord);
      expect(controller.snapshot.value.correctWords, 1);
      expect(controller.snapshot.value.totalErrors, 0);
      final int correctAfterScreen =
          controller.snapshot.value.correctCharacters;

      // Word 2: the same characters through the physical-key path
      // (controller.onCharacter / onSpace, as _handleKey calls them).
      final String secondWord = controller.targetWords[1];
      for (final int rune in secondWord.runes) {
        controller.onCharacter(String.fromCharCode(rune));
      }
      controller.onSpace();
      await tester.pump();
      expect(controller.committedWordBuffers[1], secondWord);
      expect(controller.snapshot.value.correctWords, 2);
      expect(controller.snapshot.value.totalErrors, 0);
      expect(controller.snapshot.value.correctCharacters,
          correctAfterScreen + secondWord.runes.length);
    });
  });
}

class _Harness {
  final List<String> chars = <String>[];
  int spaces = 0;
  int backspaces = 0;
  final FocusNode focusNode = FocusNode();
}
