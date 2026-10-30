import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/features/typing_test/service/paragraph_continuation.dart';

void main() {
  const pool = ['alpha one', 'beta two', 'gamma three'];

  ParagraphContinuation<String> make(String started) =>
      ParagraphContinuation<String>(
        started: started,
        textOf: (s) => s,
        builtInPool: pool,
      );

  test('a custom paragraph repeats itself and is never replaced', () {
    final c = make('my own custom text');
    expect(c.isCustom, isTrue);
    for (int i = 0; i < 20; i++) {
      expect(c.next(), 'my own custom text');
    }
  });

  test('a built-in paragraph continues with other built-in paragraphs', () {
    final c = make('alpha one');
    expect(c.isCustom, isFalse);
    String previous = 'alpha one';
    for (int i = 0; i < 50; i++) {
      final String next = c.next();
      expect(pool.contains(next), isTrue);
      expect(next, isNot(previous)); // never the same one twice in a row
      previous = next;
    }
  });

  test('a single-paragraph pool just repeats it', () {
    final c = ParagraphContinuation<String>(
      started: 'only one',
      textOf: (s) => s,
      builtInPool: const ['only one'],
    );
    expect(c.next(), 'only one');
  });
}
