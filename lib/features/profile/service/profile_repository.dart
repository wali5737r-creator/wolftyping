import 'package:drift/drift.dart';
import 'package:get/get.dart' hide Value;

import '../../../core/database/app_database.dart';
import '../../history/model/typing_test_record.dart';
import '../../typing_test/model/typing_language.dart';
import '../../typing_test/model/typing_test_kind.dart';
import '../model/profile_stats.dart';

class ProfileRepository {
  ProfileRepository._();
  static final instance = ProfileRepository._();

  AppDatabase get _db => Get.find<AppDatabase>();

  Future<int> ensureUser() async {
    final rows = await _db.select(_db.users).get();
    if (rows.isNotEmpty) return rows.first.id;
    return _db.into(_db.users).insert(const UsersCompanion());
  }

  Future<ProfileStats> load() async {
    final userId = await ensureUser();
    final users = await (_db.select(_db.users)..where((u) => u.id.equals(userId))).get();
    final user = users.first;
    final tests = await (_db.select(_db.typingTests)
          ..where((t) => t.userId.equals(userId)))
        .get();
    final lessons = await (_db.select(_db.lessonProgress)
          ..where((l) => l.userId.equals(userId)))
        .get();

    final bestWpm = tests.isEmpty ? 0.0 : tests.map((e) => e.netWpm).reduce((a, b) => a > b ? a : b);
    final avgWpm = tests.isEmpty ? 0.0 : tests.map((e) => e.netWpm).reduce((a, b) => a + b) / tests.length;
    final bestAccuracy = tests.isEmpty ? 0.0 : tests.map((e) => e.accuracy).reduce((a, b) => a > b ? a : b);
    final avgAccuracy = tests.isEmpty ? 0.0 : tests.map((e) => e.accuracy).reduce((a, b) => a + b) / tests.length;
    final practiceSeconds = tests.fold<int>(0, (sum, e) => sum + e.actualDurationSeconds);

    final completedLessons = lessons.where((e) => e.completed).length;
    final activeDates = tests.map((e) {
      final d = e.completedAt;
      return DateTime(d.year, d.month, d.day);
    }).toSet();
    final sortedDates = activeDates.toList()..sort();
    int longest = 0;
    int run = 0;
    DateTime? previous;
    for (final date in sortedDates) {
      if (previous != null && date.difference(previous).inDays == 1) {
        run++;
      } else {
        run = 1;
      }
      if (run > longest) longest = run;
      previous = date;
    }
    int current = 0;
    if (sortedDates.isNotEmpty) {
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      DateTime cursor = sortedDates.last;
      if (cursor == todayDate || cursor == todayDate.subtract(const Duration(days: 1))) {
        current = 1;
        while (activeDates.contains(cursor.subtract(const Duration(days: 1)))) {
          cursor = cursor.subtract(const Duration(days: 1));
          current++;
        }
      }
    }

    return ProfileStats(
      name: user.name.trim().isEmpty ? 'Typist' : user.name,
      createdAt: user.createdAt,
      totalTests: tests.length,
      totalPracticeSeconds: practiceSeconds,
      bestWpm: bestWpm,
      averageWpm: avgWpm,
      bestAccuracy: bestAccuracy,
      averageAccuracy: avgAccuracy,
      currentStreak: current,
      longestStreak: longest,
      englishTests: tests.where((e) => e.language == 'en').length,
      urduTests: tests.where((e) => e.language == 'ur').length,
      ppscTests: tests.where((e) => e.testType == TypingTestKind.ppsc.dbValue).length,
      completedLessons: completedLessons,
    );
  }

  Future<void> updateName(String name) async {
    final id = await ensureUser();
    await (_db.update(_db.users)..where((u) => u.id.equals(id))).write(
      UsersCompanion(name: Value(name.trim()), updatedAt: Value(DateTime.now())),
    );
  }

  /// On-device best scores: the user's own top completed tests, ranked
  /// by net WPM. This is NOT a shared/global leaderboard — there are no
  /// accounts and no backend in this build, so only scores stored on
  /// this device (this browser's database on web) can be shown. A shared
  /// leaderboard would need accounts + a backend; see WEB_NOTES.md.
  Future<List<TypingTestRecord>> bestScores({int limit = 10}) async {
    final userId = await ensureUser();
    final rows = await (_db.select(_db.typingTests)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.netWpm)])
          ..limit(limit))
        .get();
    return [
      for (final r in rows)
        TypingTestRecord(
          id: r.id,
          language: r.language == TypingLanguage.urdu.code
              ? TypingLanguage.urdu
              : TypingLanguage.english,
          testType: TypingTestKind.fromDbValue(r.testType),
          durationSeconds: r.durationSeconds,
          actualDurationSeconds: r.actualDurationSeconds,
          grossWpm: r.grossWpm,
          netWpm: r.netWpm,
          accuracy: r.accuracy,
          correctCharacters: r.correctCharacters,
          wrongCharacters: r.wrongCharacters,
          correctWords: r.correctWords,
          wrongWords: r.wrongWords,
          skippedWords: r.skippedWords,
          backspaces: r.backspaces,
          totalErrors: r.totalErrors,
          completedAt: r.completedAt,
        ),
    ];
  }
}
