import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/lessons/view/widgets/lesson_keyboard.dart';
import 'package:typing_master/features/lessons/view/widgets/lesson_word_boxes.dart';
import 'package:typing_master/features/typing_test/model/typing_word_status.dart';

/// Lesson practice redesign (Muhammad, 2026-11-14): the drill no longer
/// shows as plain flowing text ("aaaa ssss") — every word sits in its own
/// key-style box, edged in the colour of the finger that types its first
/// letter, so practice sets the learner's hand. These tests pin down:
///
///  * each target word renders in its own box (one box per word);
///  * the current word's box is highlighted (teal accent border);
///  * committed words show green (correct) / red (wrong) / amber +
///    strikethrough (skipped), coloured per character from what was typed;
///  * preview mode (intro panel, currentWordIndex -1) renders every word
///    pending with no highlight;
///  * the finger colour/label behind the boxes is the guide board's own
///    mapping ([LessonKeyboard.fingerInfoFor]) — English and Urdu — so
///    the boxes can never disagree with the #/lesson-keyboard-guide page.
///
/// The boxes are display/feedback only (no on-screen keyboard): nothing
/// here is tappable and nothing types anything — that is covered by the
/// practice view itself (no InkWell inside LessonWordBoxes).
void main() {
  Future<void> pumpBoxes(
    WidgetTester tester, {
    List<String> words = const ['ff', 'jjj', 'fjf'],
    List<TypingWordStatus> statuses = const [
      TypingWordStatus.correct,
      TypingWordStatus.current,
      TypingWordStatus.pending,
    ],
    List<String> buffers = const ['ff', ''],
    int currentIndex = 1,
    String currentBuffer = '',
    bool isUrdu = false,
  }) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: LessonWordBoxes(
            targetWords: words,
            wordStatuses: statuses,
            committedWordBuffers: buffers,
            currentWordIndex: currentIndex,
            currentWordBuffer: currentBuffer,
            isUrdu: isUrdu,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Container boxDecoration(WidgetTester tester, int index) {
    final Finder box = find.byKey(ValueKey('lesson-word-box-$index'));
    expect(box, findsOneWidget);
    return tester.widget<Container>(box);
  }

  Color? borderColorOf(Container box) {
    final Decoration? decoration = box.decoration;
    if (decoration is! BoxDecoration) return null;
    final BoxBorder? border = decoration.border;
    if (border is! Border) return null;
    // The box's side borders carry the state colour; the top edge is
    // always the finger colour.
    return border.left.color;
  }

  /// Finds the RichText whose whole plain text is [plain] — the word
  /// text lives in RichText spans (one span per style run, so Urdu joins
  /// survive), which find.text does not match.
  Finder richTextWith(String plain) => find.byWidgetPredicate(
        (Widget w) => w is RichText && w.text.toPlainText() == plain,
      );

  group('lesson word boxes', () {
    testWidgets('one box per word, each showing its word',
        (tester) async {
      await pumpBoxes(tester);
      for (int i = 0; i < 3; i++) {
        expect(find.byKey(ValueKey('lesson-word-box-$i')), findsOneWidget);
      }
      expect(richTextWith('ff'), findsOneWidget);
      expect(richTextWith('jjj'), findsOneWidget);
      expect(richTextWith('fjf'), findsOneWidget);
    });

    testWidgets('current word box is highlighted with the accent border',
        (tester) async {
      await pumpBoxes(tester);
      // Light theme accent: AppColors.primary teal.
      expect(borderColorOf(boxDecoration(tester, 1)),
          const Color(0xFF0F766E));
      // The pending word next to it is not highlighted.
      expect(borderColorOf(boxDecoration(tester, 2)),
          isNot(const Color(0xFF0F766E)));
    });

    testWidgets('correct word box is green, wrong word box is red',
        (tester) async {
      await pumpBoxes(
        tester,
        statuses: const [
          TypingWordStatus.correct,
          TypingWordStatus.wrong,
          TypingWordStatus.pending,
        ],
        buffers: const ['ff', 'jxj'],
        currentIndex: 2,
      );
      expect(borderColorOf(boxDecoration(tester, 0)),
          const Color(0xFF15803D)); // correctCharLight
      expect(borderColorOf(boxDecoration(tester, 1)),
          const Color(0xFFC81443)); // wrongCharLight
    });

    testWidgets('skipped word box is amber', (tester) async {
      await pumpBoxes(
        tester,
        statuses: const [
          TypingWordStatus.skipped,
          TypingWordStatus.current,
          TypingWordStatus.pending,
        ],
        buffers: const ['', ''],
        currentIndex: 1,
      );
      expect(borderColorOf(boxDecoration(tester, 0)),
          const Color(0xFFB45309)); // skippedWordLight
    });

    testWidgets('top strip is the finger colour of the first letter',
        (tester) async {
      await pumpBoxes(
        tester,
        words: const ['asdf', 'lkjh'],
        statuses: const [
          TypingWordStatus.pending,
          TypingWordStatus.pending,
        ],
        buffers: const [],
        currentIndex: -1,
      );
      // 'a' is the left little finger (violet); 'l' the right ring
      // finger (cyan) — the strip, not the border, carries the finger.
      final Container stripA = tester.widget<Container>(
          find.byKey(const ValueKey('lesson-word-box-finger-0')));
      expect(stripA.color, const Color(0xFF8B5CF6));
      final Container stripL = tester.widget<Container>(
          find.byKey(const ValueKey('lesson-word-box-finger-1')));
      expect(stripL.color, const Color(0xFF0891B2));
    });

    testWidgets('preview mode renders every word pending, none highlighted',
        (tester) async {
      await pumpBoxes(
        tester,
        statuses: const [
          TypingWordStatus.pending,
          TypingWordStatus.pending,
          TypingWordStatus.pending,
        ],
        buffers: const [],
        currentIndex: -1,
      );
      for (int i = 0; i < 3; i++) {
        expect(borderColorOf(boxDecoration(tester, i)),
            isNot(const Color(0xFF0F766E)));
      }
      expect(richTextWith('ff'), findsOneWidget);
      expect(richTextWith('jjj'), findsOneWidget);
    });

    testWidgets('boxes are display-only: no tappable key inside',
        (tester) async {
      await pumpBoxes(tester);
      expect(
        find.descendant(
          of: find.byType(LessonWordBoxes),
          matching: find.byType(InkWell),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byType(LessonWordBoxes),
          matching: find.byType(GestureDetector),
        ),
        findsNothing,
      );
    });

    testWidgets('Urdu boxes render with the Urdu font', (tester) async {
      await pumpBoxes(
        tester,
        words: const ['پاکستان', 'خوبصورت'],
        statuses: const [
          TypingWordStatus.current,
          TypingWordStatus.pending,
        ],
        buffers: const [],
        currentIndex: 0,
        isUrdu: true,
      );
      expect(richTextWith('پاکستان'), findsOneWidget);
      expect(richTextWith('خوبصورت'), findsOneWidget);
      final RichText text = tester.widget<RichText>(
        find.descendant(
          of: find.byKey(const ValueKey('lesson-word-box-0')),
          matching: find.byType(RichText),
        ),
      );
      // Nastaliq, not Inter: the box picks typingTextUr for Urdu.
      expect(text.text.style?.fontFamily, 'Noto Nastaliq Urdu');
    });
  });

  group('fingerInfoFor — the board mapping behind the boxes', () {
    test('home-row keys map to their fingers', () {
      expect(LessonKeyboard.fingerInfoFor('f'),
          (color: const Color(0xFF0F766E), label: 'Index finger'));
      expect(LessonKeyboard.fingerInfoFor('j'),
          (color: const Color(0xFF0F766E), label: 'Index finger'));
      expect(LessonKeyboard.fingerInfoFor('d'),
          (color: const Color(0xFFD97706), label: 'Middle finger'));
      expect(LessonKeyboard.fingerInfoFor('k'),
          (color: const Color(0xFFD97706), label: 'Middle finger'));
      expect(LessonKeyboard.fingerInfoFor('s'),
          (color: const Color(0xFF0891B2), label: 'Ring finger'));
      expect(LessonKeyboard.fingerInfoFor('l'),
          (color: const Color(0xFF0891B2), label: 'Ring finger'));
      expect(LessonKeyboard.fingerInfoFor('a'),
          (color: const Color(0xFF8B5CF6), label: 'Little finger'));
      expect(LessonKeyboard.fingerInfoFor(';'),
          (color: const Color(0xFF8B5CF6), label: 'Little finger'));
    });

    test('space is the thumb', () {
      expect(LessonKeyboard.fingerInfoFor(' '),
          (color: const Color(0xFF64748B), label: 'Thumb (Space bar)'));
    });

    test('shifted keys keep their finger (F is still the index finger)',
        () {
      expect(LessonKeyboard.fingerInfoFor('F'),
          (color: const Color(0xFF0F766E), label: 'Index finger'));
      expect(LessonKeyboard.fingerInfoFor('!'),
          (color: const Color(0xFF8B5CF6), label: 'Little finger'));
    });

    test('Urdu letters map through the phonetic layout', () {
      // ق is typed with Q (left little finger), ف with F (left index).
      expect(LessonKeyboard.fingerInfoFor('ق', urdu: true),
          (color: const Color(0xFF8B5CF6), label: 'Little finger'));
      expect(LessonKeyboard.fingerInfoFor('ف', urdu: true),
          (color: const Color(0xFF0F766E), label: 'Index finger'));
      // س is typed with S (left ring finger).
      expect(LessonKeyboard.fingerInfoFor('س', urdu: true),
          (color: const Color(0xFF0891B2), label: 'Ring finger'));
    });

    test('a character on no key returns null', () {
      expect(LessonKeyboard.fingerInfoFor('€'), isNull);
    });
  });
}
