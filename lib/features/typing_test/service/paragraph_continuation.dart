import 'dart:math';

/// Supplies the text that follows when a TIMED test runs out of paragraph
/// before the clock does (see `TypingEngine.continuation`).
///
///  * Built-in paragraph  -> another built-in paragraph of the same
///    difficulty (never the one just typed, when the pool has more than
///    one), so a 10-minute test doesn't repeat the same 40 words.
///  * Custom paragraph (My Paragraphs) -> the user's own paragraph again.
///    It is never swapped for built-in content.
///
/// A paragraph is "built-in" when its text appears in [builtInPool].
class ParagraphContinuation<T> {
  ParagraphContinuation({
    required T started,
    required String Function(T) textOf,
    required List<T> builtInPool,
  })  : _startedText = textOf(started),
        _textOf = textOf,
        _pool = builtInPool,
        _lastText = textOf(started);

  final String _startedText;
  final String Function(T) _textOf;
  final List<T> _pool;
  final Random _random = Random();
  String _lastText;

  bool get isCustom => !_pool.any((p) => _textOf(p) == _startedText);

  String next() {
    if (isCustom || _pool.length < 2) {
      _lastText = _startedText;
      return _startedText;
    }
    final List<T> candidates =
        _pool.where((p) => _textOf(p) != _lastText).toList();
    final T pick = candidates[_random.nextInt(candidates.length)];
    _lastText = _textOf(pick);
    return _lastText;
  }
}
