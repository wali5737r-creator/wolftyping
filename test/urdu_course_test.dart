import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/features/lessons/model/lesson_definition.dart';
import 'package:typing_master/features/lessons/service/urdu_lesson_definitions.dart';

/// The on-screen keyboard and its UrduPhoneticLayout map were removed
/// 2026-11-14, so these guards no longer consult the layout. The lessons
/// still teach the phonetic layout (finger guides name the physical keys),
/// so the drill-content guards stay — pinned against the Unicode ranges
/// a physical Urdu keyboard can actually type, plus the three ASCII
/// punctuation keys the Shift lessons use (! ( ) on Shift+1/9/0).
void main() {
  const List<LessonDefinition> lessons = UrduLessonDefinitions.all;

  /// A character a physical Urdu keyboard can type: Arabic-script
  /// (including Urdu digits and punctuation) or the ASCII punctuation
  /// taught in the Shift lessons.
  bool isTypeable(String ch) {
    if (ch == ' ') return true;
    if (ch == '!' || ch == '(' || ch == ')') return true;
    final int cp = ch.codeUnitAt(0);
    return (cp >= 0x0600 && cp <= 0x06FF) ||
        (cp >= 0x0750 && cp <= 0x077F) ||
        (cp >= 0xFB50 && cp <= 0xFDFF) ||
        (cp >= 0xFE70 && cp <= 0xFEFF);
  }

  test('order indexes are 1..N with no gaps', () {
    for (int i = 0; i < lessons.length; i++) {
      expect(lessons[i].orderIndex, i + 1);
    }
  });

  test('every lesson has a stage, a title and a real drill', () {
    for (final LessonDefinition l in lessons) {
      expect(l.stage, isNotEmpty, reason: 'lesson ${l.orderIndex}');
      expect(l.title.trim(), isNotEmpty);
      expect(l.content.trim().length, greaterThan(80),
          reason: 'lesson ${l.orderIndex}');
    }
  });

  test('every character in every drill is typeable on a physical keyboard',
      () {
    for (final LessonDefinition l in lessons) {
      for (final String ch in l.content.split('')) {
        expect(isTypeable(ch), isTrue,
            reason: 'lesson ${l.orderIndex} uses U+'
                '${ch.codeUnitAt(0).toRadixString(16)} which no physical '
                'Urdu keyboard key types');
      }
    }
  });

  test('lesson 1 only uses the F and J keys (ف and ج)', () {
    final Set<String> chars =
        lessons.first.content.replaceAll(' ', '').split('').toSet();
    expect(chars, {'\u0641', '\u062C'});
  });

  test('speed lessons ask for a WPM target', () {
    expect(lessons.where((l) => l.requiredWpm > 0).length, 4);
  });
}
