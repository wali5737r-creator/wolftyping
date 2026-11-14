import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:typing_master/core/constants/app_colors.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/features/lessons/controller/lesson_practice_controller.dart';
import 'package:typing_master/features/lessons/model/lesson_definition.dart';
import 'package:typing_master/features/lessons/model/lesson_with_progress.dart';
import 'package:typing_master/features/lessons/service/english_lesson_definitions.dart';
import 'package:typing_master/features/lessons/service/urdu_lesson_definitions.dart';
import 'package:typing_master/features/lessons/view/lesson_practice_view.dart';
import 'package:typing_master/features/typing_test/model/typing_language.dart';
import 'package:typing_master/features/typing_test/model/typing_word_status.dart';
import 'package:typing_master/features/typing_test/service/typing_engine.dart';

/// REPRODUCTION (live fresh-tab check, 2026-11-14 ~09:13–09:39 PKT):
/// Urdu Lesson 1's hint bar allegedly tracked the ENGLISH lesson
/// ("Next: ف" while the drill's word 1 was "جف", "Next: ج" while word 2
/// was "ففج"), the intro preview allegedly listed different words from
/// the active drill, and an unattempted box (word 19) allegedly rendered
/// pink/red after word 1 was completed with errors.
///
/// The invariant under test: for ANY lesson, the intro preview, the
/// drill boxes and the hint bar must all read the SAME word list — the
/// lesson's own drill words. The preview splits
/// `lesson.definition.content` on whitespace; the drill is the
/// [TypingEngine]'s word list built from the same content; the hint bar
/// reads the engine's current word. These tests drive the REAL
/// [LessonPracticeView] (intro → Start → practice) for Urdu Lesson 1
/// and English Lesson 1 and read the rendered boxes/hint back out of
/// the widget tree (RichText plain text — exact strings, no screenshot
/// misreading), plus a data-level sweep over every lesson in both
/// languages.
///
/// NOTE on the live report: the hint letters ف/ج match the Urdu drill's
/// first letters exactly (Urdu L1 content is the CRULP transliteration
/// of English L1, so first letters agree by construction) — they do not
/// by themselves prove an English binding. And Latin keystrokes can
/// never type Urdu here: [TypingInput] feeds runes straight to the
/// engine with no Latin→Urdu translation, so pressing Latin "f"/"j" in
/// an Urdu lesson is an error whatever the drill is. These tests settle
/// what the wiring actually does.
void main() {
  tearDown(Get.reset);

  List<String> wordsOf(LessonDefinition def) =>
      def.content.trim().split(RegExp(r'\s+'));

  LessonWithProgress lessonOf(TypingLanguage language, int dbId) {
    final LessonDefinition definition = language == TypingLanguage.english
        ? EnglishLessonDefinitions.all.first
        : UrduLessonDefinitions.all.first;
    return LessonWithProgress(
      dbId: dbId,
      definition: definition,
      completed: false,
      bestAccuracy: 0,
      bestSpeed: 0,
      attempts: 0,
      lastAttemptAt: null,
      locked: false,
    );
  }

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Get.testMode = true;
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: '/home',
        getPages: [
          GetPage(name: '/home', page: () => const SizedBox()),
          GetPage(
            name: '/lesson-practice',
            page: () => const LessonPracticeView(),
            binding: BindingsBuilder(() {
              Get.lazyPut<LessonPracticeController>(
                () => LessonPracticeController(),
              );
            }),
          ),
        ],
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<LessonPracticeController> openLesson(
    WidgetTester tester,
    TypingLanguage language,
    int dbId,
  ) async {
    await pumpApp(tester);
    await tester.runAsync(() async {
      Get.toNamed('/lesson-practice', arguments: lessonOf(language, dbId));
    });
    await tester.pumpAndSettle();
    return Get.find<LessonPracticeController>();
  }

  /// The rendered box texts, in box-index order, read back out of the
  /// widget tree — RichText plain text (find.text cannot match span
  /// text). Box N's text is the word the learner actually sees.
  List<String> boxTexts(WidgetTester tester) {
    final List<String> texts = [];
    int i = 0;
    while (true) {
      final Finder box = find.byKey(ValueKey('lesson-word-box-$i'));
      if (box.evaluate().isEmpty) break;
      final Finder rich = find.descendant(
        of: box,
        matching: find.byType(RichText),
      );
      texts.add(tester.widget<RichText>(rich.first).text.toPlainText());
      i++;
    }
    return texts;
  }

  Container boxContainer(WidgetTester tester, int index) {
    final Finder box = find.byKey(ValueKey('lesson-word-box-$index'));
    expect(box, findsOneWidget);
    return tester.widget<Container>(box);
  }

  Color? borderColorOf(Container box) {
    final Decoration? decoration = box.decoration;
    if (decoration is! BoxDecoration) return null;
    final BoxBorder? border = decoration.border;
    if (border is! Border) return null;
    return border.left.color;
  }

  Future<void> startPractice(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Start Lesson'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start Lesson'));
    await tester.pump();
    await tester.pump();
  }

  Future<void> exitPractice(WidgetTester tester) async {
    await tester.runAsync(() async {
      Get.back();
    });
    await tester.pumpAndSettle();
  }

  test('every lesson: preview split == engine words (same word list)', () {
    final List<LessonDefinition> defs = [
      ...EnglishLessonDefinitions.all,
      ...UrduLessonDefinitions.all,
    ];
    for (final LessonDefinition def in defs) {
      // The intro preview's split — exactly as _IntroPanel computes it
      // (trim first, like the engine). The pre-fix version split the
      // raw content and disagreed with the drill for English Lesson 14,
      // whose content ends with a space.
      final String trimmed = def.content.trim();
      final List<String> preview =
          trimmed.isEmpty ? <String>[] : trimmed.split(RegExp(r'\s+'));
      final List<String> drill =
          TypingEngine(targetText: def.content).targetWords;
      expect(
        preview,
        drill,
        reason: 'Lesson ${def.orderIndex} (${def.language}) — the intro '
            'preview must list the same words as the drill.',
      );
      expect(
        preview,
        isNot(contains('')),
        reason: 'Lesson ${def.orderIndex} (${def.language}) — no empty '
            'preview word (phantom box).',
      );
    }
  });

  testWidgets('Urdu Lesson 1: preview, drill and hint read the same words',
      (WidgetTester tester) async {
    final LessonPracticeController controller =
        await openLesson(tester, TypingLanguage.urdu, 101);
    final List<String> expected =
        wordsOf(UrduLessonDefinitions.all.first);
    expect(expected.first, 'فف');
    expect(expected[1], 'ججج');
    expect(expected.length, 30);

    // Intro preview: the exact drill words, in order.
    expect(boxTexts(tester), expected);

    await startPractice(tester);
    expect(controller.targetWords, expected);
    expect(boxTexts(tester), expected);

    // Hint bar follows the drill's current word — ف (first letter of
    // فف), via the CRULP mapping, left index finger — NOT the English
    // lesson's word.
    expect(find.text('Next: ف — Index finger'), findsOneWidget);

    // Type word 1 correctly, commit it, and the hint follows word 2.
    controller.onCharacter('ف');
    controller.onCharacter('ف');
    await tester.pump();
    controller.onSpace();
    await tester.pump();
    expect(controller.snapshot.value.currentWordIndex, 1);
    expect(controller.wordStatuses[0], TypingWordStatus.correct);
    expect(find.text('Next: ج — Index finger'), findsOneWidget);
    expect(boxTexts(tester), expected);

    await exitPractice(tester);
  });

  testWidgets('English Lesson 1: preview, drill and hint read the same words',
      (WidgetTester tester) async {
    final LessonPracticeController controller =
        await openLesson(tester, TypingLanguage.english, 1);
    final List<String> expected =
        wordsOf(EnglishLessonDefinitions.all.first);
    expect(expected.first, 'ff');
    expect(expected[1], 'jjj');
    expect(expected.length, 30);

    expect(boxTexts(tester), expected);

    await startPractice(tester);
    expect(controller.targetWords, expected);
    expect(boxTexts(tester), expected);
    expect(find.text('Next: f — Index finger'), findsOneWidget);

    controller.onCharacter('f');
    controller.onCharacter('f');
    await tester.pump();
    controller.onSpace();
    await tester.pump();
    expect(controller.snapshot.value.currentWordIndex, 1);
    expect(controller.wordStatuses[0], TypingWordStatus.correct);
    expect(find.text('Next: j — Index finger'), findsOneWidget);
    expect(boxTexts(tester), expected);

    await exitPractice(tester);
  });

  testWidgets('Urdu Lesson 1: a wrong word 1 leaves word 19 pending, '
      'never pink/red', (WidgetTester tester) async {
    final LessonPracticeController controller =
        await openLesson(tester, TypingLanguage.urdu, 101);
    await startPractice(tester);

    // Word 1 = فف. Type two wrong letters (ج ≠ ف) and commit it.
    controller.onCharacter('ج');
    controller.onCharacter('ج');
    await tester.pump();
    controller.onSpace();
    await tester.pump();

    expect(controller.snapshot.value.currentWordIndex, 1);
    expect(controller.wordStatuses[0], TypingWordStatus.wrong);
    expect(controller.wordStatuses[1], TypingWordStatus.current);
    for (int i = 2; i < controller.wordStatuses.length; i++) {
      expect(
        controller.wordStatuses[i],
        TypingWordStatus.pending,
        reason: 'word ${i + 1} was never attempted and must stay pending',
      );
    }

    // Word 19 (index 18, ججج) renders pending: a teal finger-colour
    // border (right index finger, 0.8 alpha) on a light teal tint —
    // never the wrong (red) border or pink wrong background.
    final Container box18 = boxContainer(tester, 18);
    expect(
      borderColorOf(box18),
      AppColors.primary.withValues(alpha: 0.8),
      reason: 'word 19 must render pending, not wrong',
    );
    expect(
      (box18.decoration as BoxDecoration?)?.color,
      AppColors.primary.withValues(alpha: 0.12),
      reason: 'word 19 must keep the pending tint, not the pink/red '
          'wrong background',
    );

    // And the actually-wrong word 1 DOES render wrong (red border) —
    // the pink/red the live check saw belongs to word 1, not word 19.
    expect(
      borderColorOf(boxContainer(tester, 0)),
      AppColors.wrongCharLight,
    );

    await exitPractice(tester);
  });

  testWidgets('Urdu drill boxes lay out right-to-left (RTL)',
      (WidgetTester tester) async {
    await openLesson(tester, TypingLanguage.urdu, 101);
    await startPractice(tester);

    // In the RTL directionality the first box sits at the RIGHT of the
    // row and later boxes run leftwards — so a reader scanning
    // left-to-right sees the sequence reversed. This pins the layout
    // the live check misread as a different word list.
    final double x0 =
        tester.getCenter(find.byKey(const ValueKey('lesson-word-box-0'))).dx;
    final double x1 =
        tester.getCenter(find.byKey(const ValueKey('lesson-word-box-1'))).dx;
    expect(
      x0,
      greaterThan(x1),
      reason: 'Urdu box 0 must sit right of box 1 (RTL row order)',
    );

    await exitPractice(tester);
  });
}
