import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/mock_attempt.dart';
import '../model/mock_question.dart';

/// On-device progress for mock/paper/custom tests: recorded attempts,
/// bookmarked questions, and the last-used student name. No login, no
/// backend, no server — everything lives only on this device, in
/// shared_preferences, exactly like custom sets.
///
/// A corrupt stored blob never crashes the app: loading skips entries
/// it cannot parse and returns the rest. Writes are best-effort: a
/// storage failure keeps the in-memory state (so the current session
/// still shows the attempt/bookmark) and records [lastSaveFailed].
class MockProgressRepository {
  MockProgressRepository._();

  static final MockProgressRepository instance = MockProgressRepository._();

  static const String attemptsKey = 'typing_master_mock_attempts_v1';
  static const String bookmarksKey = 'typing_master_bookmarked_questions_v1';
  static const String lastStudentNameKey = 'typing_master_last_student_name';

  /// Cap on stored attempts: old attempts beyond this are dropped so
  /// the stored blob cannot grow without bound.
  static const int maxStoredAttempts = 200;

  /// Cap on bookmarked questions.
  static const int maxBookmarks = 200;

  /// Attempts, newest last. Reactive so every view observing progress
  /// (papers list, year pages, mock setup) updates when an attempt is
  /// recorded, whichever controller instance recorded it.
  final RxList<MockAttempt> attempts = <MockAttempt>[].obs;

  /// Bookmarked questions, in the order bookmarked.
  final RxList<MockQuestion> bookmarks = <MockQuestion>[].obs;

  /// Last student name typed for a custom test, if any.
  final RxString lastStudentName = ''.obs;

  /// True when the most recent persist failed (e.g. storage full).
  /// The in-memory state is still correct for this session.
  final RxBool lastSaveFailed = false.obs;

  bool _loaded = false;
  Future<void>? _loading;

  /// Loads stored progress once. Safe to call repeatedly and from
  /// several places; concurrent calls share one load.
  Future<void> init() {
    _loading ??= _load();
    return _loading!;
  }

  Future<void> _load() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      attempts.assignAll(_readAttempts(prefs.getString(attemptsKey)));
      bookmarks.assignAll(_readBookmarks(prefs.getString(bookmarksKey)));
      lastStudentName.value = prefs.getString(lastStudentNameKey) ?? '';
    } catch (_) {
      // Storage unavailable: keep empty in-memory state; the app
      // still runs and shows attempts/bookmarks for this session.
    } finally {
      _loaded = true;
    }
  }

  List<MockAttempt> _readAttempts(String? raw) {
    if (raw == null || raw.trim().isEmpty) return <MockAttempt>[];
    try {
      final Object? parsed = jsonDecode(raw);
      if (parsed is! List) return <MockAttempt>[];
      final List<MockAttempt> out = [];
      for (final Object? entry in parsed) {
        try {
          if (entry is Map) {
            final MockAttempt attempt = MockAttempt.fromJson(
              Map<String, dynamic>.from(entry),
            );
            if (attempt.id.isNotEmpty && attempt.totalQuestions > 0) {
              out.add(attempt);
            }
          }
        } catch (_) {
          // Skip one corrupt entry; keep the rest.
        }
      }
      return out;
    } catch (_) {
      return <MockAttempt>[];
    }
  }

  List<MockQuestion> _readBookmarks(String? raw) {
    if (raw == null || raw.trim().isEmpty) return <MockQuestion>[];
    try {
      final Object? parsed = jsonDecode(raw);
      if (parsed is! List) return <MockQuestion>[];
      final List<MockQuestion> out = [];
      for (final Object? entry in parsed) {
        try {
          if (entry is Map) {
            out.add(
              MockQuestion.fromJson(Map<String, dynamic>.from(entry)),
            );
          }
        } catch (_) {
          // Skip one corrupt entry; keep the rest.
        }
      }
      return out;
    } catch (_) {
      return <MockQuestion>[];
    }
  }

  Future<bool> _persist() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        attemptsKey,
        jsonEncode(attempts.map((a) => a.toJson()).toList()),
      );
      await prefs.setString(
        bookmarksKey,
        jsonEncode(bookmarks.map((q) => q.toJson()).toList()),
      );
      await prefs.setString(lastStudentNameKey, lastStudentName.value);
      lastSaveFailed.value = false;
      return true;
    } catch (_) {
      lastSaveFailed.value = true;
      return false;
    }
  }

  /// Records an attempt. Updates the in-memory list synchronously
  /// once storage has loaded, then persists in the background.
  Future<void> recordAttempt(MockAttempt attempt) async {
    if (!_loaded) await init();
    attempts.add(attempt);
    if (attempts.length > maxStoredAttempts) {
      attempts.removeRange(0, attempts.length - maxStoredAttempts);
    }
    await _persist();
  }

  /// Best (highest-score) attempt for a source, or null when the
  /// source has never been attempted.
  MockAttempt? bestAttemptFor(String sourceId) {
    MockAttempt? best;
    for (final MockAttempt attempt in attempts) {
      if (attempt.sourceId != sourceId) continue;
      if (best == null || attempt.score > best.score) best = attempt;
    }
    return best;
  }

  /// How many distinct papers (by paper id) in [paperIds] have at
  /// least one recorded attempt.
  int completedCount(Iterable<String> paperIds) {
    final Set<String> attempted = {
      for (final MockAttempt a in attempts) a.sourceId,
    };
    return paperIds.where(attempted.contains).length;
  }

  bool isBookmarked(String questionId) =>
      bookmarks.any((q) => q.id == questionId);

  /// Toggles a bookmark. Returns true when the question is bookmarked
  /// afterwards. Enforces the bookmark cap with a readable result:
  /// when full and adding, returns false and leaves state unchanged.
  Future<bool> toggleBookmark(MockQuestion question) async {
    if (!_loaded) await init();
    final int index =
        bookmarks.indexWhere((q) => q.id == question.id);
    if (index >= 0) {
      bookmarks.removeAt(index);
      await _persist();
      return false;
    }
    if (bookmarks.length >= maxBookmarks) return false;
    bookmarks.add(question);
    await _persist();
    return true;
  }

  Future<void> setLastStudentName(String name) async {
    if (!_loaded) await init();
    lastStudentName.value = name;
    await _persist();
  }

  /// Aggregate per-subject stats across all recorded attempts,
  /// weakest (lowest percentage) first. Only subjects with at least
  /// [minQuestions] answered questions are included, so a hint is
  /// never built from one or two questions.
  List<SubjectAttemptStats> weakestSubjects({int minQuestions = 5}) {
    final Map<MockSubject, int> correctBy = {};
    final Map<MockSubject, int> totalBy = {};
    for (final MockAttempt attempt in attempts) {
      attempt.perSubjectTotal.forEach((name, total) {
        final MockSubject? subject = _subjectByName(name);
        if (subject == null) return;
        totalBy[subject] = (totalBy[subject] ?? 0) + total;
        correctBy[subject] = (correctBy[subject] ?? 0) +
            (attempt.perSubjectCorrect[name] ?? 0);
      });
    }
    final List<SubjectAttemptStats> stats = [];
    for (final MockSubject subject in MockSubject.values) {
      final int total = totalBy[subject] ?? 0;
      if (total < minQuestions) continue;
      stats.add(
        SubjectAttemptStats(
          subject: subject,
          correct: correctBy[subject] ?? 0,
          total: total,
        ),
      );
    }
    stats.sort((a, b) => a.percentage.compareTo(b.percentage));
    return stats;
  }

  MockSubject? _subjectByName(String name) {
    for (final MockSubject subject in MockSubject.values) {
      if (subject.name == name) return subject;
    }
    return null;
  }

  /// Test-only: clears in-memory state and the load guard so a fresh
  /// load can be exercised. Does not touch stored preferences.
  void resetForTest() {
    attempts.clear();
    bookmarks.clear();
    lastStudentName.value = '';
    lastSaveFailed.value = false;
    _loaded = false;
    _loading = null;
  }
}
