import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/core/services/custom_set_share_link.dart';
import 'package:typing_master/features/ppsc/model/custom_set.dart';
import 'package:typing_master/features/ppsc/model/mock_question.dart';

/// Shareable links: offered only when the full URL fits in 4000
/// characters; the hash-fragment import parameter round-trips for a
/// small set; oversized sets get no link.
void main() {
  CustomSet setWith(int count) => CustomSet(
        id: 'custom-link',
        name: 'Link Quiz',
        questions: List.generate(
          count,
          (i) => MockQuestion(
            id: 'lq-$i',
            subject: MockSubject.english,
            question: 'Question number $i with some text to make it real?',
            options: const ['A', 'B', 'C', 'D'],
            correctIndex: 0,
          ),
        ),
      );

  test('small set builds a link that round-trips through the fragment',
      () {
    final set = setWith(3);
    final link = buildCustomSetShareLink(
      origin: 'https://wolftyping.pages.dev',
      set: set,
    );
    expect(link, isNotNull);
    expect(link!.length, lessThanOrEqualTo(maxShareUrlLength));
    expect(
      link.startsWith('https://wolftyping.pages.dev/#/ppsc-custom-tests?import='),
      isTrue,
    );
    final fragment = Uri.parse(link).fragment;
    final code = extractImportCodeFromFragment(fragment);
    expect(code, isNotNull);
    final decoded = CustomSet.decode(code!);
    expect(decoded.name, set.name);
    expect(decoded.questionCount, set.questionCount);
    expect(decoded.questions.first.id, 'lq-0');
  });

  test('oversized set gets no link', () {
    final set = setWith(200);
    final link = buildCustomSetShareLink(
      origin: 'https://wolftyping.pages.dev',
      set: set,
    );
    expect(link, isNull);
  });

  test('fragment parsing ignores fragments without an import parameter',
      () {
    expect(extractImportCodeFromFragment('/ppsc-custom-tests'), isNull);
    expect(extractImportCodeFromFragment('/dashboard'), isNull);
    expect(
      extractImportCodeFromFragment('/ppsc-custom-tests?import='),
      isNull,
    );
    expect(
      extractImportCodeFromFragment('/ppsc-custom-tests?foo=bar&import=ABC123'),
      'ABC123',
    );
    expect(
      extractImportCodeFromFragment('#/ppsc-custom-tests?import=XYZ'),
      'XYZ',
    );
  });

  test('malformed import code fails with a readable error, never a crash',
      () {
    expect(
      () => CustomSet.decode('!!!not-a-code!!!'),
      throwsA(isA<FormatException>()),
    );
    expect(() => CustomSet.decode(''), throwsA(isA<FormatException>()));
  });
}
