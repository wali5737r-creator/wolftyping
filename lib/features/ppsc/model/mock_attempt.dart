import '../model/mock_question.dart';

/// One recorded mock/paper/custom/bookmarked attempt, saved on the
/// device only (see [MockProgressRepository]). No server, no account.
///
/// The per-subject breakdown lets the weakest-subject hint be computed
/// from real recorded attempts only — never invented.
class MockAttempt {
  const MockAttempt({
    required this.id,
    required this.sourceKind,
    required this.sourceId,
    required this.sourceLabel,
    required this.totalQuestions,
    required this.correct,
    required this.wrong,
    required this.skipped,
    required this.score,
    required this.attemptedAt,
    this.durationSeconds,
    this.actualDurationSeconds,
    this.perSubjectCorrect = const {},
    this.perSubjectTotal = const {},
  });

  /// Unique id for this attempt (time-based).
  final String id;

  /// 'paper', 'full', 'subject', 'custom' or 'bookmarked'.
  final String sourceKind;

  /// Paper id (e.g. '2026-233'), custom set id, subject name, 'full'
  /// or 'bookmarked'.
  final String sourceId;

  /// Human label shown with the attempt, e.g. 'Practice Paper 233'.
  final String sourceLabel;

  final int totalQuestions;
  final int correct;
  final int wrong;
  final int skipped;
  final double score;
  final DateTime attemptedAt;

  /// Planned duration in seconds (e.g. 300 for a 5-minute mock).
  /// Null for attempts recorded before durations were stored.
  final int? durationSeconds;

  /// How long the user actually spent on the test, in seconds.
  /// Null for attempts recorded before durations were stored.
  final int? actualDurationSeconds;

  /// Subject name -> correct count, and subject name -> total count,
  /// for the questions in this attempt.
  final Map<String, int> perSubjectCorrect;
  final Map<String, int> perSubjectTotal;

  String get scoreLabel {
    final String s = score == score.truncateToDouble()
        ? '${score.toInt()}'
        : score.toStringAsFixed(2);
    return '$s / $totalQuestions';
  }

  /// Display label for History / recent attempts, e.g.
  /// 'Full mock test · 5 minutes' or 'Practice Paper 246 · 90 minutes'.
  /// Attempts recorded before durations were stored show the plain
  /// source label, with no invented duration.
  String get displayLabel {
    if (durationSeconds == null) return sourceLabel;
    final int minutes = (durationSeconds! / 60).round();
    return '$sourceLabel · $minutes minute${minutes == 1 ? '' : 's'}';
  }

  double get percentage =>
      totalQuestions == 0 ? 0 : score / totalQuestions * 100;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'sourceKind': sourceKind,
        'sourceId': sourceId,
        'sourceLabel': sourceLabel,
        'totalQuestions': totalQuestions,
        'correct': correct,
        'wrong': wrong,
        'skipped': skipped,
        'score': score,
        'attemptedAt': attemptedAt.toIso8601String(),
        'durationSeconds': durationSeconds,
        'actualDurationSeconds': actualDurationSeconds,
        'perSubjectCorrect': perSubjectCorrect,
        'perSubjectTotal': perSubjectTotal,
      };

  factory MockAttempt.fromJson(Map<String, dynamic> json) {
    Map<String, int> intMap(Object? raw) {
      if (raw is! Map) return const {};
      final Map<String, int> out = {};
      raw.forEach((key, value) {
        if (value is num) out[key.toString()] = value.toInt();
      });
      return out;
    }

    return MockAttempt(
      id: json['id'] as String? ?? '',
      sourceKind: json['sourceKind'] as String? ?? '',
      sourceId: json['sourceId'] as String? ?? '',
      sourceLabel: json['sourceLabel'] as String? ?? '',
      totalQuestions: (json['totalQuestions'] as num?)?.toInt() ?? 0,
      correct: (json['correct'] as num?)?.toInt() ?? 0,
      wrong: (json['wrong'] as num?)?.toInt() ?? 0,
      skipped: (json['skipped'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toDouble() ?? 0,
      attemptedAt: DateTime.tryParse(
            json['attemptedAt'] as String? ?? '',
          ) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
      actualDurationSeconds:
          (json['actualDurationSeconds'] as num?)?.toInt(),
      perSubjectCorrect: intMap(json['perSubjectCorrect']),
      perSubjectTotal: intMap(json['perSubjectTotal']),
    );
  }
}

/// One subject's aggregate across recorded attempts, for the
/// weakest-subject hint. Built only from real attempts.
class SubjectAttemptStats {
  const SubjectAttemptStats({
    required this.subject,
    required this.correct,
    required this.total,
  });

  final MockSubject subject;
  final int correct;
  final int total;

  double get percentage => total == 0 ? 0 : correct / total * 100;
}
