import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/features/lessons/model/lesson_definition.dart';
import 'package:typing_master/features/lessons/service/english_lesson_definitions.dart';
import 'package:typing_master/features/lessons/service/urdu_lesson_definitions.dart';
import 'package:typing_master/features/typing_test/model/typing_language.dart';

/// The lesson-content data behind the word boxes (Muhammad, 2026-11-14:
/// "Aik box ma aik word ho tmny 2 3 rkh diye"): every drill's content
/// must split into single-word tokens — no entry may ever hold two or
/// three words — and the Urdu course must actually contain Urdu content
/// (its Lesson 1 title is English, "F and J: Anchor Keys", by design —
/// the titles stay English while the drill is Urdu — so the content,
/// not the title, is what proves the Urdu wiring).
void main() {
  void checkDefinitions(List<LessonDefinition> defs, String course) {
    expect(defs, isNotEmpty, reason: '$course must define lessons');
    final Set<int> orders = <int>{};
    for (final LessonDefinition d in defs) {
      expect(orders.add(d.orderIndex), isTrue,
          reason: '$course has two lessons with orderIndex ${d.orderIndex}');
      expect(d.content, isNotEmpty,
          reason: '$course lesson ${d.orderIndex} has no drill content');
      // No double spaces, no non-breaking spaces: the engine and the
      // intro preview both split on \s+, so a token can never contain
      // a space — and a U+00A0 would be the one whitespace the split
      // must not miss. Leading/trailing whitespace is tolerated (the
      // engine trims before splitting and the word boxes drop empty
      // parts), so an empty token from a trailing space — English
      // Lesson 14 ends with one — is not a failure here.
      expect(d.content.contains('  '), isFalse,
          reason: '$course lesson ${d.orderIndex} has a double space');
      expect(d.content.contains('\u00a0'), isFalse,
          reason: '$course lesson ${d.orderIndex} has a non-breaking space');
      for (final String token in d.content.split(RegExp(r'\s+'))) {
        if (token.isEmpty) continue;
        expect(token.contains(' '), isFalse);
      }
    }
  }

  test('English lesson contents split into single words', () {
    checkDefinitions(EnglishLessonDefinitions.all, 'English');
  });

  test('Urdu lesson contents split into single words', () {
    checkDefinitions(UrduLessonDefinitions.all, 'Urdu');
  });

  test('Urdu Lesson 1 exists and its drill is Urdu, not Latin', () {
    final LessonDefinition first = UrduLessonDefinitions.all.first;
    expect(first.orderIndex, 1);
    expect(first.language, TypingLanguage.urdu);
    expect(first.content, startsWith('فف'));
    expect(first.content.contains('ff'), isFalse,
        reason: 'the Urdu drill must not contain Latin drill words');
  });
}
