/// Difficulty tier for a lesson (spec: Beginner / Intermediate / Advanced
/// tracks). [defaultRequiredAccuracy] is what each lesson definition uses
/// unless it overrides it explicitly — this lives here (a model), never
/// hard-coded inside a widget, per spec section 5.
enum LessonLevel {
  beginner,
  intermediate,
  advanced;

  String get label {
    switch (this) {
      case LessonLevel.beginner:
        return 'Beginner';
      case LessonLevel.intermediate:
        return 'Intermediate';
      case LessonLevel.advanced:
        return 'Advanced';
    }
  }

  double get defaultRequiredAccuracy {
    switch (this) {
      case LessonLevel.beginner:
        return 80;
      case LessonLevel.intermediate:
        return 85;
      case LessonLevel.advanced:
        return 90;
    }
  }
}
