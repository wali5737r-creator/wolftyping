/// Preset durations for the Typing Test duration selector (spec section 8).
///
/// TypingEngine itself accepts any `Duration?` (null = untimed practice) —
/// these are just the values the not-yet-built UI will offer as quick-pick
/// buttons, plus whatever custom Duration the user types in.
class TypingDurations {
  TypingDurations._();

  static const Duration seconds30 = Duration(seconds: 30);
  static const Duration minute1 = Duration(minutes: 1);
  static const Duration minutes2 = Duration(minutes: 2);
  static const Duration minutes5 = Duration(minutes: 5);
  static const Duration minutes10 = Duration(minutes: 10);

  static const List<Duration> presets = [
    seconds30,
    minute1,
    minutes2,
    minutes5,
    minutes10,
  ];

  /// The duration a setup screen should start on, given Settings >
  /// Default duration ([defaultSeconds]). If [allowed] is given (e.g. the
  /// narrower PPSC list) and the default isn't in it, [allowed]'s first
  /// entry is used so a chip is always highlighted.
  static Duration initialFor(int? defaultSeconds, {List<Duration>? allowed}) {
    if (defaultSeconds == null || defaultSeconds <= 0) {
      return allowed?.first ?? minute1;
    }
    final Duration wanted = Duration(seconds: defaultSeconds);
    if (allowed != null && !allowed.contains(wanted)) return allowed.first;
    return wanted;
  }
}
