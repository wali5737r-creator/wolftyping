import 'dart:convert';

/// History backup — a plain JSON file the user owns, so their typing
/// history is not trapped in one browser's database.
///
/// A backup holds everything History and Progress read back: every
/// completed test with ALL stored fields (including the ones the
/// on-screen `TypingTestRecord` drops — `keystrokeAccuracy`,
/// `correctedMistakes`, `uncorrectedMistakes`, `paragraphId`, and the
/// raw `testType` string, so 'lesson'/'practice' tests round-trip
/// exactly), the structured mistake rows behind each test, lesson
/// progress, and the daily goal in seconds. The daily goal is exported
/// for reference only and is NOT changed by an import.
///
/// Format (version 1):
/// ```json
/// {
///   "app": "WolfTyping",
///   "formatVersion": 1,
///   "exportedAt": "2026-11-13T10:00:00.000",
///   "dailyGoalSeconds": 600,
///   "tests": [ { ...all stored fields..., "mistakes": [ ... ] } ],
///   "lessons": [ { "lessonId": 3, "completed": true, ... } ]
/// }
/// ```
/// Everything in this file is pure — no GetX, no database — so it is
/// unit tested directly (see test/history_backup_test.dart). The
/// database read/write lives in [HistoryBackupRepository].
class HistoryBackup {
  const HistoryBackup({
    required this.app,
    required this.formatVersion,
    required this.exportedAt,
    required this.dailyGoalSeconds,
    required this.tests,
    required this.lessons,
  });

  static const String expectedApp = 'WolfTyping';
  static const int currentFormatVersion = 1;

  final String app;
  final int formatVersion;
  final DateTime exportedAt;
  final int dailyGoalSeconds;
  final List<BackupTest> tests;
  final List<BackupLesson> lessons;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'app': app,
        'formatVersion': formatVersion,
        'exportedAt': exportedAt.toIso8601String(),
        'dailyGoalSeconds': dailyGoalSeconds,
        'tests': [for (final t in tests) t.toJson()],
        'lessons': [for (final l in lessons) l.toJson()],
      };

  String toJsonString() =>
      const JsonEncoder.withIndent('  ').convert(toJson());

  /// Parses and validates backup text. Throws [FormatException] with a
  /// plain message when the file is not a WolfTyping history backup —
  /// the History screen shows that message, never a stack trace.
  static HistoryBackup parse(String text) {
    final Object? decoded;
    try {
      decoded = jsonDecode(text);
    } on FormatException {
      throw const FormatException(
        'That file is not a valid backup (not JSON).',
      );
    }
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('That file is not a history backup.');
    }
    return HistoryBackup.fromJson(decoded);
  }

  factory HistoryBackup.fromJson(Map<String, dynamic> json) {
    if (json['app'] != expectedApp) {
      throw const FormatException(
        'That file is not a WolfTyping history backup.',
      );
    }
    if (json['formatVersion'] != currentFormatVersion) {
      throw FormatException(
        'Unsupported backup version (${json['formatVersion']}) — '
        'this app writes version $currentFormatVersion.',
      );
    }
    final DateTime? exportedAt =
        _asDateTime(json['exportedAt'], 'exportedAt');
    if (exportedAt == null) {
      throw const FormatException('Backup is missing its export date.');
    }
    final List<dynamic>? testsJson = json['tests'] as List<dynamic>?;
    final List<dynamic>? lessonsJson = json['lessons'] as List<dynamic>?;
    if (testsJson == null || lessonsJson == null) {
      throw const FormatException(
        'Backup is missing its tests or lessons.',
      );
    }
    return HistoryBackup(
      app: expectedApp,
      formatVersion: currentFormatVersion,
      exportedAt: exportedAt,
      dailyGoalSeconds:
          _asNonNegativeInt(json['dailyGoalSeconds'], 'dailyGoalSeconds'),
      tests: [
        for (final t in testsJson)
          BackupTest.fromJson(_asMap(t, 'tests')),
      ],
      lessons: [
        for (final l in lessonsJson)
          BackupLesson.fromJson(_asMap(l, 'lessons')),
      ],
    );
  }
}

/// One completed test, exactly as stored — every `TypingTests` column
/// plus its `Mistakes` rows. The raw `testType` string is kept (not
/// mapped to an enum) so 'lesson' and 'practice' tests survive a
/// round-trip instead of being folded into 'test'.
class BackupTest {
  const BackupTest({
    required this.language,
    required this.testType,
    required this.paragraphId,
    required this.durationSeconds,
    required this.actualDurationSeconds,
    required this.grossWpm,
    required this.netWpm,
    required this.accuracy,
    required this.keystrokeAccuracy,
    required this.correctCharacters,
    required this.wrongCharacters,
    required this.correctWords,
    required this.wrongWords,
    required this.skippedWords,
    required this.backspaces,
    required this.correctedMistakes,
    required this.uncorrectedMistakes,
    required this.totalErrors,
    required this.completedAt,
    required this.mistakes,
  });

  /// 'en' or 'ur', as stored.
  final String language;

  /// Raw stored value: 'test' | 'ppsc' | 'lesson' | 'practice'.
  final String testType;
  final int? paragraphId;
  final int? durationSeconds;
  final int actualDurationSeconds;
  final double grossWpm;
  final double netWpm;
  final double accuracy;
  final double keystrokeAccuracy;
  final int correctCharacters;
  final int wrongCharacters;
  final int correctWords;
  final int wrongWords;
  final int skippedWords;
  final int backspaces;
  final int correctedMistakes;
  final int uncorrectedMistakes;
  final int totalErrors;
  final DateTime completedAt;
  final List<BackupMistake> mistakes;

  /// Identity used to skip tests that are already in the database on
  /// import: same moment, language, type and headline result means the
  /// same test. The database id is deliberately NOT part of the key —
  /// ids differ between devices, so an id-based check would import
  /// every test twice.
  String get duplicateKey =>
      '$language|$testType|${completedAt.toIso8601String()}|'
      '$netWpm|$accuracy';

  Map<String, dynamic> toJson() => <String, dynamic>{
        'language': language,
        'testType': testType,
        'paragraphId': paragraphId,
        'durationSeconds': durationSeconds,
        'actualDurationSeconds': actualDurationSeconds,
        'grossWpm': grossWpm,
        'netWpm': netWpm,
        'accuracy': accuracy,
        'keystrokeAccuracy': keystrokeAccuracy,
        'correctCharacters': correctCharacters,
        'wrongCharacters': wrongCharacters,
        'correctWords': correctWords,
        'wrongWords': wrongWords,
        'skippedWords': skippedWords,
        'backspaces': backspaces,
        'correctedMistakes': correctedMistakes,
        'uncorrectedMistakes': uncorrectedMistakes,
        'totalErrors': totalErrors,
        'completedAt': completedAt.toIso8601String(),
        'mistakes': [for (final m in mistakes) m.toJson()],
      };

  factory BackupTest.fromJson(Map<String, dynamic> json) {
    final String language = _asString(json['language'], 'language');
    if (language != 'en' && language != 'ur') {
      throw FormatException(
        'Invalid test language "$language" — expected "en" or "ur".',
      );
    }
    final String testType = _asString(json['testType'], 'testType');
    if (testType.isEmpty) {
      throw const FormatException('A test is missing its test type.');
    }
    final DateTime? completedAt =
        _asDateTime(json['completedAt'], 'completedAt');
    if (completedAt == null) {
      throw const FormatException('A test is missing its completion date.');
    }
    final List<dynamic>? mistakesJson =
        json['mistakes'] as List<dynamic>?;
    if (mistakesJson == null) {
      throw const FormatException('A test is missing its mistakes.');
    }
    return BackupTest(
      language: language,
      testType: testType,
      paragraphId: _asNullableInt(json['paragraphId'], 'paragraphId'),
      durationSeconds:
          _asNullableInt(json['durationSeconds'], 'durationSeconds'),
      actualDurationSeconds:
          _asNonNegativeInt(json['actualDurationSeconds'], 'actualDurationSeconds'),
      grossWpm: _asNonNegativeDouble(json['grossWpm'], 'grossWpm'),
      netWpm: _asNonNegativeDouble(json['netWpm'], 'netWpm'),
      accuracy: _asPercentage(json['accuracy'], 'accuracy'),
      keystrokeAccuracy:
          _asPercentage(json['keystrokeAccuracy'], 'keystrokeAccuracy'),
      correctCharacters:
          _asNonNegativeInt(json['correctCharacters'], 'correctCharacters'),
      wrongCharacters:
          _asNonNegativeInt(json['wrongCharacters'], 'wrongCharacters'),
      correctWords:
          _asNonNegativeInt(json['correctWords'], 'correctWords'),
      wrongWords: _asNonNegativeInt(json['wrongWords'], 'wrongWords'),
      skippedWords:
          _asNonNegativeInt(json['skippedWords'], 'skippedWords'),
      backspaces: _asNonNegativeInt(json['backspaces'], 'backspaces'),
      correctedMistakes:
          _asNonNegativeInt(json['correctedMistakes'], 'correctedMistakes'),
      uncorrectedMistakes: _asNonNegativeInt(
        json['uncorrectedMistakes'],
        'uncorrectedMistakes',
      ),
      totalErrors: _asNonNegativeInt(json['totalErrors'], 'totalErrors'),
      completedAt: completedAt,
      mistakes: [
        for (final m in mistakesJson)
          BackupMistake.fromJson(_asMap(m, 'mistakes')),
      ],
    );
  }
}

/// One structured `Mistakes` row — the same fields "Practice My
/// Mistakes" reads, so an imported test's mistakes work exactly like a
/// test taken on this device.
class BackupMistake {
  const BackupMistake({
    required this.expectedCharacter,
    required this.typedCharacter,
    required this.count,
    required this.position,
    required this.wordIndex,
    required this.isSkippedWord,
    required this.isWrongWord,
  });

  final String expectedCharacter;
  final String typedCharacter;
  final int count;
  final int position;
  final int wordIndex;
  final bool isSkippedWord;
  final bool isWrongWord;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'expectedCharacter': expectedCharacter,
        'typedCharacter': typedCharacter,
        'count': count,
        'position': position,
        'wordIndex': wordIndex,
        'isSkippedWord': isSkippedWord,
        'isWrongWord': isWrongWord,
      };

  factory BackupMistake.fromJson(Map<String, dynamic> json) {
    return BackupMistake(
      expectedCharacter:
          _asString(json['expectedCharacter'], 'expectedCharacter'),
      typedCharacter:
          _asString(json['typedCharacter'], 'typedCharacter'),
      count: _asPositiveInt(json['count'], 'count'),
      position: _asNonNegativeInt(json['position'], 'position'),
      wordIndex: _asNonNegativeInt(json['wordIndex'], 'wordIndex'),
      isSkippedWord: _asBool(json['isSkippedWord'], 'isSkippedWord'),
      isWrongWord: _asBool(json['isWrongWord'], 'isWrongWord'),
    );
  }
}

/// One `LessonProgress` row. Merging keeps the better of the two
/// sides — a restore never lowers a best score or un-completes a
/// lesson the user already finished on this device.
class BackupLesson {
  const BackupLesson({
    required this.lessonId,
    required this.completed,
    required this.bestAccuracy,
    required this.bestSpeed,
    required this.attempts,
    required this.lastAttemptAt,
  });

  final int lessonId;
  final bool completed;
  final double bestAccuracy;
  final double bestSpeed;
  final int attempts;
  final DateTime? lastAttemptAt;

  BackupLesson mergedWith(BackupLesson other) {
    DateTime? latest = lastAttemptAt;
    if (other.lastAttemptAt != null &&
        (latest == null || other.lastAttemptAt!.isAfter(latest))) {
      latest = other.lastAttemptAt;
    }
    return BackupLesson(
      lessonId: lessonId,
      completed: completed || other.completed,
      bestAccuracy:
          bestAccuracy > other.bestAccuracy ? bestAccuracy : other.bestAccuracy,
      bestSpeed: bestSpeed > other.bestSpeed ? bestSpeed : other.bestSpeed,
      attempts: attempts > other.attempts ? attempts : other.attempts,
      lastAttemptAt: latest,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'lessonId': lessonId,
        'completed': completed,
        'bestAccuracy': bestAccuracy,
        'bestSpeed': bestSpeed,
        'attempts': attempts,
        'lastAttemptAt': lastAttemptAt?.toIso8601String(),
      };

  factory BackupLesson.fromJson(Map<String, dynamic> json) {
    final int lessonId =
        _asPositiveInt(json['lessonId'], 'lessonId');
    return BackupLesson(
      lessonId: lessonId,
      completed: _asBool(json['completed'], 'completed'),
      bestAccuracy:
          _asPercentage(json['bestAccuracy'], 'bestAccuracy'),
      bestSpeed: _asNonNegativeDouble(json['bestSpeed'], 'bestSpeed'),
      attempts: _asNonNegativeInt(json['attempts'], 'attempts'),
      lastAttemptAt:
          _asDateTime(json['lastAttemptAt'], 'lastAttemptAt'),
    );
  }
}

/// One row per test, the same data as the JSON, for opening in a
/// spreadsheet. Mistakes are summarised as a row count — the full
/// mistake rows live in the JSON backup.
String buildHistoryCsv(List<BackupTest> tests) {
  const String header = 'completedAt,language,testType,durationSeconds,'
      'actualDurationSeconds,grossWpm,netWpm,accuracy,keystrokeAccuracy,'
      'correctCharacters,wrongCharacters,correctWords,wrongWords,'
      'skippedWords,backspaces,correctedMistakes,uncorrectedMistakes,'
      'totalErrors,mistakeRows';
  final StringBuffer out = StringBuffer(header);
  for (final BackupTest t in tests) {
    out
      ..write('\n')
      ..write(t.completedAt.toIso8601String())
      ..write(',')
      ..write(_csvCell(t.language))
      ..write(',')
      ..write(_csvCell(t.testType))
      ..write(',')
      ..write(t.durationSeconds?.toString() ?? '')
      ..write(',')
      ..write(t.actualDurationSeconds)
      ..write(',')
      ..write(t.grossWpm)
      ..write(',')
      ..write(t.netWpm)
      ..write(',')
      ..write(t.accuracy)
      ..write(',')
      ..write(t.keystrokeAccuracy)
      ..write(',')
      ..write(t.correctCharacters)
      ..write(',')
      ..write(t.wrongCharacters)
      ..write(',')
      ..write(t.correctWords)
      ..write(',')
      ..write(t.wrongWords)
      ..write(',')
      ..write(t.skippedWords)
      ..write(',')
      ..write(t.backspaces)
      ..write(',')
      ..write(t.correctedMistakes)
      ..write(',')
      ..write(t.uncorrectedMistakes)
      ..write(',')
      ..write(t.totalErrors)
      ..write(',')
      ..write(t.mistakes.length);
  }
  return out.toString();
}

String _csvCell(String value) {
  if (value.contains(',') ||
      value.contains('"') ||
      value.contains('\n')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}

Map<String, dynamic> _asMap(Object? value, String field) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map(
      (k, v) => MapEntry(k.toString(), v),
    );
  }
  throw FormatException('Backup field "$field" is not an object.');
}

String _asString(Object? value, String field) {
  if (value is String) return value;
  throw FormatException('Backup field "$field" is not text.');
}

bool _asBool(Object? value, String field) {
  if (value is bool) return value;
  throw FormatException('Backup field "$field" is not true/false.');
}

DateTime? _asDateTime(Object? value, String field) {
  if (value == null) return null;
  if (value is String) {
    final DateTime? parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed;
  }
  throw FormatException('Backup field "$field" is not a valid date.');
}

int _asNonNegativeInt(Object? value, String field) {
  if (value is int && value >= 0) return value;
  throw FormatException('Backup field "$field" is not a whole number.');
}

int _asPositiveInt(Object? value, String field) {
  if (value is int && value > 0) return value;
  throw FormatException('Backup field "$field" is not a positive number.');
}

int? _asNullableInt(Object? value, String field) {
  if (value == null) return null;
  if (value is int && value >= 0) return value;
  throw FormatException('Backup field "$field" is not a whole number.');
}

double _asNonNegativeDouble(Object? value, String field) {
  if (value is num && value >= 0) return value.toDouble();
  throw FormatException('Backup field "$field" is not a number.');
}

double _asPercentage(Object? value, String field) {
  if (value is num && value >= 0 && value <= 100) return value.toDouble();
  throw FormatException('Backup field "$field" is not a 0–100 number.');
}
