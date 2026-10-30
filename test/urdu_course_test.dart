import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/features/lessons/model/lesson_definition.dart';
import 'package:typing_master/features/lessons/service/urdu_lesson_definitions.dart';
import 'package:typing_master/features/lessons/service/urdu_phonetic_layout.dart';

void main() {
  const List<LessonDefinition> lessons = UrduLessonDefinitions.all;
  final Set<String> typeable = UrduPhoneticLayout.allCharacters;

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

  test('every character in every drill exists on the phonetic layout', () {
    for (final LessonDefinition l in lessons) {
      for (final String ch in l.content.split('')) {
        if (ch == ' ') continue;
        expect(typeable.contains(ch), isTrue,
            reason: 'lesson ${l.orderIndex} uses U+'
                '${ch.codeUnitAt(0).toRadixString(16)} which the layout '
                'cannot type');
      }
    }
  });

  test('lesson 1 only uses the F and J keys', () {
    final Set<String> chars =
        lessons.first.content.replaceAll(' ', '').split('').toSet();
    expect(chars, {
      UrduPhoneticLayout.unshifted['f']!,
      UrduPhoneticLayout.unshifted['j']!,
    });
  });

  test('layout maps Urdu characters back to the right physical key', () {
    expect(UrduPhoneticLayout.latinFor('\u0627'), 'a');
    expect(UrduPhoneticLayout.latinFor('\u0635'), 'S');
    expect(UrduPhoneticLayout.latinFor('\u061F'), '?');
  });

  test('speed lessons ask for a WPM target', () {
    expect(lessons.where((l) => l.requiredWpm > 0).length, 4);
  });
}
