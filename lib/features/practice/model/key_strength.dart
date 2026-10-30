/// Classification of a key's typing strength, based on mistake frequency
/// (spec section 10: Heatmap Logic).
enum KeyStrength {
  strong,
  good,
  needsPractice,
  weak;

  String get label {
    switch (this) {
      case KeyStrength.strong:
        return 'Strong';
      case KeyStrength.good:
        return 'Good';
      case KeyStrength.needsPractice:
        return 'Needs Practice';
      case KeyStrength.weak:
        return 'Weak';
    }
  }
}

/// Configurable thresholds mapping a mistake count to a [KeyStrength].
/// Kept as named constants in one place — spec explicitly requires these
/// not be hard-coded throughout widgets.
class KeyStrengthThresholds {
  KeyStrengthThresholds._();

  static const int goodMax = 3; // 0 mistakes: strong; 1-3: good
  static const int needsPracticeMax = 7; // 4-7: needs practice; 8+: weak

  static KeyStrength classify(int mistakeCount) {
    if (mistakeCount <= 0) return KeyStrength.strong;
    if (mistakeCount <= goodMax) return KeyStrength.good;
    if (mistakeCount <= needsPracticeMax) return KeyStrength.needsPractice;
    return KeyStrength.weak;
  }
}
