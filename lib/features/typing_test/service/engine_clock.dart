import 'dart:async';

/// Drives a `TypingEngine`'s clock from *real* elapsed time.
///
/// The old approach added a fixed 200 ms on every `Timer.periodic` tick,
/// which silently loses time whenever Windows delivers a timer late (UI
/// busy, window dragged, etc.). This measures each tick with a
/// [Stopwatch] and passes the true delta, so the on-screen timer, WPM and
/// the saved duration match wall-clock time. Paused time is never counted
/// because [stop] halts the stopwatch and [start] begins a fresh interval.
///
/// The engine itself still ignores deltas until the first character is
/// typed, so the timer only starts on the first keystroke.
class EngineClock {
  EngineClock(this._advance);

  final void Function(Duration delta) _advance;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  Duration _last = Duration.zero;

  void start() {
    stop();
    _stopwatch
      ..reset()
      ..start();
    _last = Duration.zero;
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      final Duration now = _stopwatch.elapsed;
      final Duration delta = now - _last;
      _last = now;
      if (delta > Duration.zero) _advance(delta);
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _stopwatch.stop();
  }
}
