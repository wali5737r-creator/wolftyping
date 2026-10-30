class ProfileStats {
  const ProfileStats({
    required this.name,
    required this.createdAt,
    required this.totalTests,
    required this.totalPracticeSeconds,
    required this.bestWpm,
    required this.averageWpm,
    required this.bestAccuracy,
    required this.averageAccuracy,
    required this.currentStreak,
    required this.longestStreak,
    required this.englishTests,
    required this.urduTests,
    required this.ppscTests,
    required this.completedLessons,
  });

  final String name;
  final DateTime createdAt;
  final int totalTests;
  final int totalPracticeSeconds;
  final double bestWpm;
  final double averageWpm;
  final double bestAccuracy;
  final double averageAccuracy;
  final int currentStreak;
  final int longestStreak;
  final int englishTests;
  final int urduTests;
  final int ppscTests;
  final int completedLessons;

  static final empty = ProfileStats(
    name: 'Typist',
    createdAt: DateTime.fromMillisecondsSinceEpoch(0),
    totalTests: 0,
    totalPracticeSeconds: 0,
    bestWpm: 0,
    averageWpm: 0,
    bestAccuracy: 0,
    averageAccuracy: 0,
    currentStreak: 0,
    longestStreak: 0,
    englishTests: 0,
    urduTests: 0,
    ppscTests: 0,
    completedLessons: 0,
  );
}
