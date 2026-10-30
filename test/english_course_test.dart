import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/features/lessons/model/lesson_definition.dart';
import 'package:typing_master/features/lessons/service/english_lesson_definitions.dart';

void main() {
  const List<LessonDefinition> lessons = EnglishLessonDefinitions.all;

  test('order indexes are 1..N with no gaps or duplicates', () {
    for (int i = 0; i < lessons.length; i++) {
      expect(lessons[i].orderIndex, i + 1);
    }
  });

  test('every lesson has a stage, title and a real drill', () {
    for (final LessonDefinition l in lessons) {
      expect(l.stage, isNotEmpty, reason: 'lesson ${l.orderIndex}');
      expect(l.title.trim(), isNotEmpty);
      expect(l.content.trim().length, greaterThan(80),
          reason: 'lesson ${l.orderIndex} drill is too short');
      expect(l.effectiveRequiredAccuracy, inInclusiveRange(80, 100));
    }
  });

  test('lesson 1 only uses F and J', () {
    final Set<String> chars = lessons.first.content
        .replaceAll(' ', '')
        .split('')
        .toSet();
    expect(chars.difference({'f', 'j'}), isEmpty);
  });

  test('stages 1-3 (lessons 1-21) use lowercase letters and ; , . / only', () {
    final RegExp allowed = RegExp(r'^[a-z;,./ ]+$');
    for (final LessonDefinition l in lessons.take(21)) {
      expect(allowed.hasMatch(l.content), isTrue,
          reason: 'lesson ${l.orderIndex}: ${l.content}');
    }
  });

  test('no digits appear before the number row is taught (lesson 28)', () {
    final RegExp digit = RegExp(r'[0-9]');
    for (final LessonDefinition l in lessons.take(27)) {
      expect(digit.hasMatch(l.content), isFalse,
          reason: 'lesson ${l.orderIndex}');
    }
  });

  test('every focus key can be typed on a US keyboard', () {
    final RegExp typeable = RegExp(r'^[\x21-\x7e]*$');
    for (final LessonDefinition l in lessons) {
      expect(typeable.hasMatch(l.focusKeys), isTrue,
          reason: 'lesson ${l.orderIndex}');
    }
  });

  test('speed lessons ask for a WPM target, others do not', () {
    expect(lessons.where((l) => l.requiredWpm > 0).length, 4);
    expect(lessons.last.requiredWpm, 25);
  });
}
