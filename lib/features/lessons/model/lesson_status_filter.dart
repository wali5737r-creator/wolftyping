/// Status filter shown on the Lessons Dashboard (spec section 14).
enum LessonStatusFilter {
  all,
  completed,
  inProgress,
  locked;

  String get label {
    switch (this) {
      case LessonStatusFilter.all:
        return 'Show All';
      case LessonStatusFilter.completed:
        return 'Completed';
      case LessonStatusFilter.inProgress:
        return 'In Progress';
      case LessonStatusFilter.locked:
        return 'Locked';
    }
  }
}
