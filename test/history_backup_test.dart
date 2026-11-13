import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/features/history/service/history_backup.dart';

BackupTest _test({
  DateTime? completedAt,
  double netWpm = 42.5,
  double accuracy = 91.0,
  String testType = 'test',
}) {
  return BackupTest(
    language: 'en',
    testType: testType,
    paragraphId: null,
    durationSeconds: 60,
    actualDurationSeconds: 60,
    grossWpm: 45.0,
    netWpm: netWpm,
    accuracy: accuracy,
    keystrokeAccuracy: 89.5,
    correctCharacters: 200,
    wrongCharacters: 18,
    correctWords: 40,
    wrongWords: 4,
    skippedWords: 1,
    backspaces: 7,
    correctedMistakes: 5,
    uncorrectedMistakes: 2,
    totalErrors: 19,
    completedAt: completedAt ?? DateTime(2026, 11, 13, 10, 30),
    mistakes: const <BackupMistake>[
      BackupMistake(
        expectedCharacter: 'a',
        typedCharacter: 's',
        count: 2,
        position: 12,
        wordIndex: 3,
        isSkippedWord: false,
        isWrongWord: false,
      ),
      BackupMistake(
        expectedCharacter: 'the',
        typedCharacter: '',
        count: 1,
        position: 40,
        wordIndex: 9,
        isSkippedWord: true,
        isWrongWord: false,
      ),
    ],
  );
}

HistoryBackup _backup({List<BackupTest>? tests}) {
  return HistoryBackup(
    app: HistoryBackup.expectedApp,
    formatVersion: HistoryBackup.currentFormatVersion,
    exportedAt: DateTime(2026, 11, 13, 11, 0),
    dailyGoalSeconds: 600,
    tests: tests ?? <BackupTest>[_test()],
    lessons: const <BackupLesson>[
      BackupLesson(
        lessonId: 3,
        completed: true,
        bestAccuracy: 95.0,
        bestSpeed: 38.0,
        attempts: 4,
        lastAttemptAt: null,
      ),
    ],
  );
}

void main() {
  group('history backup round-trip', () {
    test('export contains the completed test with all its fields', () {
      final String json = _backup().toJsonString();
      final HistoryBackup parsed = HistoryBackup.parse(json);

      expect(parsed.tests.length, 1);
      final BackupTest t = parsed.tests.single;
      expect(t.language, 'en');
      expect(t.testType, 'test');
      expect(t.netWpm, 42.5);
      expect(t.accuracy, 91.0);
      expect(t.keystrokeAccuracy, 89.5);
      expect(t.correctedMistakes, 5);
      expect(t.uncorrectedMistakes, 2);
      expect(t.completedAt, DateTime(2026, 11, 13, 10, 30));
      expect(t.mistakes.length, 2);
      expect(t.mistakes.first.expectedCharacter, 'a');
      expect(t.mistakes.first.count, 2);
      expect(t.mistakes.last.isSkippedWord, isTrue);
      expect(parsed.lessons.single.lessonId, 3);
      expect(parsed.lessons.single.completed, isTrue);
      expect(parsed.dailyGoalSeconds, 600);
    });

    test('raw test type survives — lesson and practice stay distinct', () {
      final HistoryBackup parsed = HistoryBackup.parse(
        _backup(tests: <BackupTest>[
          _test(testType: 'lesson'),
          _test(
            testType: 'practice',
            completedAt: DateTime(2026, 11, 13, 11, 0),
          ),
        ]).toJsonString(),
      );
      expect(parsed.tests.map((t) => t.testType), <String>['lesson', 'practice']);
    });

    test('empty history still exports as a valid backup', () {
      final HistoryBackup parsed =
          HistoryBackup.parse(_backup(tests: <BackupTest>[]).toJsonString());
      expect(parsed.tests, isEmpty);
      expect(parsed.lessons.length, 1);
    });
  });

  group('history CSV', () {
    test('header plus one row per test', () {
      final String csv = buildHistoryCsv(<BackupTest>[_test()]);
      final List<String> lines = csv.split('\n');
      expect(lines.length, 2);
      expect(
        lines.first,
        'completedAt,language,testType,durationSeconds,'
        'actualDurationSeconds,grossWpm,netWpm,accuracy,keystrokeAccuracy,'
        'correctCharacters,wrongCharacters,correctWords,wrongWords,'
        'skippedWords,backspaces,correctedMistakes,uncorrectedMistakes,'
        'totalErrors,mistakeRows',
      );
      expect(lines.last, contains('42.5'));
      expect(lines.last, contains('2026-11-13T10:30:00.000'));
      expect(lines.last, endsWith(',2'));
    });
  });

  group('backup parsing rejects bad files', () {
    test('not JSON', () {
      expect(() => HistoryBackup.parse('hello'), throwsFormatException);
    });

    test('not a WolfTyping backup', () {
      expect(
        () => HistoryBackup.parse('{"app": "Other", "formatVersion": 1}'),
        throwsFormatException,
      );
    });

    test('unsupported version', () {
      expect(
        () => HistoryBackup.parse(
          '{"app": "WolfTyping", "formatVersion": 99, '
          '"exportedAt": "2026-11-13T11:00:00.000", '
          '"dailyGoalSeconds": 600, "tests": [], "lessons": []}',
        ),
        throwsFormatException,
      );
    });

    test('bad language, negative speed, accuracy over 100', () {
      final Map<String, dynamic> json = _backup().toJson();
      final Map<String, dynamic> badLanguage =
          Map<String, dynamic>.from(json);
      badLanguage['tests'] = <Map<String, dynamic>>[
        <String, dynamic>{..._test().toJson(), 'language': 'xx'},
      ];
      expect(() => HistoryBackup.fromJson(badLanguage), throwsFormatException);

      final Map<String, dynamic> badSpeed =
          Map<String, dynamic>.from(json);
      badSpeed['tests'] = <Map<String, dynamic>>[
        <String, dynamic>{..._test().toJson(), 'netWpm': -1},
      ];
      expect(() => HistoryBackup.fromJson(badSpeed), throwsFormatException);

      final Map<String, dynamic> badAccuracy =
          Map<String, dynamic>.from(json);
      badAccuracy['tests'] = <Map<String, dynamic>>[
        <String, dynamic>{..._test().toJson(), 'accuracy': 101},
      ];
      expect(() => HistoryBackup.fromJson(badAccuracy), throwsFormatException);
    });
  });

  group('duplicate detection', () {
    test('same test, same key; different moment, different key', () {
      final BackupTest a = _test();
      final BackupTest same = _test();
      final BackupTest different = _test(
        completedAt: DateTime(2026, 11, 13, 10, 31),
      );
      expect(a.duplicateKey, same.duplicateKey);
      expect(a.duplicateKey, isNot(different.duplicateKey));
    });
  });

  group('lesson merge keeps the better side', () {
    test('incoming better wins; existing better survives', () {
      const BackupLesson existing = BackupLesson(
        lessonId: 3,
        completed: false,
        bestAccuracy: 90.0,
        bestSpeed: 40.0,
        attempts: 5,
        lastAttemptAt: null,
      );
      const BackupLesson incoming = BackupLesson(
        lessonId: 3,
        completed: true,
        bestAccuracy: 80.0,
        bestSpeed: 30.0,
        attempts: 2,
        lastAttemptAt: null,
      );
      final BackupLesson merged = existing.mergedWith(incoming);
      expect(merged.completed, isTrue);
      expect(merged.bestAccuracy, 90.0);
      expect(merged.bestSpeed, 40.0);
      expect(merged.attempts, 5);

      final BackupLesson mergedBack = incoming.mergedWith(existing);
      expect(mergedBack.completed, isTrue);
      expect(mergedBack.bestAccuracy, 90.0);
      expect(mergedBack.bestSpeed, 40.0);
      expect(mergedBack.attempts, 5);
    });

    test('latest attempt date wins', () {
      final BackupLesson merged = const BackupLesson(
        lessonId: 3,
        completed: true,
        bestAccuracy: 90.0,
        bestSpeed: 40.0,
        attempts: 5,
        lastAttemptAt: null,
      ).mergedWith(
        BackupLesson(
          lessonId: 3,
          completed: true,
          bestAccuracy: 80.0,
          bestSpeed: 30.0,
          attempts: 2,
          lastAttemptAt: DateTime(2026, 11, 13, 9, 0),
        ),
      );
      expect(merged.lastAttemptAt, DateTime(2026, 11, 13, 9, 0));
    });
  });
}
