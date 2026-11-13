import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/services/certificate_code.dart';
import 'package:typing_master/features/ppsc/model/gradebook_entry.dart';
import 'package:typing_master/features/ppsc/service/gradebook_repository.dart';

/// Gradebook: a custom-test result IS a mock-kind certificate code
/// (WT1) — encode it, record it by code, and the entry fields match;
/// tampered, bad-checksum and typing-test codes are rejected; the
/// same code twice records once; per-test stats and JSON/CSV export
/// hold the full entries incl. codes.
void main() {
  const String storageKey = GradebookRepository.storageKey;

  CertificateData customResult({
    String testLabel = 'My Urdu Quiz',
    String name = 'Ayesha',
    double score = 88.5,
    int total = 100,
    int correct = 90,
    int wrong = 7,
    int skipped = 3,
  }) =>
      CertificateData(
        kind: CertificateKind.mock,
        testLabel: testLabel,
        holderName: name,
        date: DateTime(2026, 11, 13),
        score: score,
        totalQuestions: total,
        correct: correct,
        wrong: wrong,
        skipped: skipped,
        accuracy: 0,
      );

  String forgedCode(String original, String tampered) {
    final List<String> originalParts = original.split('.');
    final List<String> tamperedParts = tampered.split('.');
    return 'WT1.${tamperedParts[1]}.${originalParts[2]}';
  }

  group('record by result code', () {
    test('encode → recordCode → entry fields match', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final GradebookRepository repo = GradebookRepository.instance;
      final String code = encodeCertificateCode(customResult());
      final GradebookEntry? entry = await repo.recordCode(code);
      expect(entry, isNotNull);
      expect(entry!.testLabel, 'My Urdu Quiz');
      expect(entry.holderName, 'Ayesha');
      expect(entry.date, DateTime(2026, 11, 13));
      expect(entry.score, 88.5);
      expect(entry.totalQuestions, 100);
      expect(entry.correct, 90);
      expect(entry.wrong, 7);
      expect(entry.skipped, 3);
      expect(entry.source, 'result code');
      expect(entry.code, code);
      expect(entry.scoreLabel, '88.5 / 100');
      expect(entry.percentage, closeTo(88.5, 0.001));
    });

    test('recording the same code twice creates no duplicate', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final GradebookRepository repo = GradebookRepository.instance;
      final String code = encodeCertificateCode(customResult());
      expect(await repo.recordCode(code), isNotNull);
      expect(await repo.recordCode(code), isNull);
      expect((await repo.load()).length, 1);
    });

    test('recordEntry dedupes by code too', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final GradebookRepository repo = GradebookRepository.instance;
      final CertificateData data = customResult();
      final String code = encodeCertificateCode(data);
      final GradebookEntry entry = GradebookEntry.fromCertificateData(
        data,
        code,
        source: 'this device',
      );
      expect(await repo.recordEntry(entry), true);
      expect(await repo.recordEntry(entry), false);
      expect((await repo.load()).length, 1);
    });

    test('tampered score is rejected', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final GradebookRepository repo = GradebookRepository.instance;
      final String code = encodeCertificateCode(customResult());
      final String forged = forgedCode(
        code,
        encodeCertificateCode(customResult(score: 100, correct: 100, wrong: 0, skipped: 0)),
      );
      expect(() => repo.recordCode(forged), throwsFormatException);
      expect((await repo.load()), isEmpty);
    });

    test('bad checksum is rejected', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final GradebookRepository repo = GradebookRepository.instance;
      final List<String> parts =
          encodeCertificateCode(customResult()).split('.');
      final String bad = 'WT1.${parts[1]}.00000000';
      expect(() => repo.recordCode(bad), throwsFormatException);
    });

    test('typing-test code is rejected with a plain message', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final GradebookRepository repo = GradebookRepository.instance;
      final String typingCode = encodeCertificateCode(
        CertificateData(
          kind: CertificateKind.typing,
          testLabel: 'Typing Test — English',
          holderName: 'Ayesha',
          date: DateTime(2026, 11, 13),
          score: 42,
          totalQuestions: 0,
          correct: 512,
          wrong: 18,
          skipped: 0,
          accuracy: 96.5,
        ),
      );
      expect(
        () => repo.recordCode(typingCode),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains('custom MCQ tests'),
          ),
        ),
      );
      expect((await repo.load()), isEmpty);
    });

    test('a code for a deleted/unknown test is still accepted', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final GradebookRepository repo = GradebookRepository.instance;
      final GradebookEntry? entry = await repo.recordCode(
        encodeCertificateCode(customResult(testLabel: 'Deleted Test')),
      );
      expect(entry, isNotNull);
      expect(entry!.testLabel, 'Deleted Test');
    });
  });

  group('persistence', () {
    test('entries survive a reload and a corrupt entry is skipped', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final GradebookRepository repo = GradebookRepository.instance;
      await repo.recordCode(encodeCertificateCode(customResult()));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<Object?> stored =
          jsonDecode(prefs.getString(storageKey)!) as List<Object?>;
      await prefs.setString(
        storageKey,
        jsonEncode(<Object?>[...stored, <String, Object>{'broken': true}]),
      );
      final List<GradebookEntry> loaded = await repo.load();
      expect(loaded.length, 1);
      expect(loaded.first.holderName, 'Ayesha');
    });

    test('deleteEntry removes one entry; clearGroup removes a test',
        () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final GradebookRepository repo = GradebookRepository.instance;
      final String codeA = encodeCertificateCode(customResult(name: 'Ayesha'));
      final String codeB = encodeCertificateCode(customResult(name: 'Bilal'));
      await repo.recordCode(codeA);
      await repo.recordCode(codeB);
      await repo.deleteEntry(codeA);
      List<GradebookEntry> loaded = await repo.load();
      expect(loaded.length, 1);
      expect(loaded.first.holderName, 'Bilal');
      await repo.clearGroup('My Urdu Quiz');
      expect(await repo.load(), isEmpty);
    });
  });

  group('entry JSON round-trip', () {
    test('toJson → fromJson keeps every field incl. code', () {
      final CertificateData data = customResult();
      final GradebookEntry entry = GradebookEntry.fromCertificateData(
        data,
        encodeCertificateCode(data),
        source: 'this device',
        recordedAt: DateTime(2026, 11, 13, 10, 30),
      );
      final GradebookEntry back = GradebookEntry.fromJson(entry.toJson());
      expect(back.testLabel, entry.testLabel);
      expect(back.holderName, entry.holderName);
      expect(back.date, entry.date);
      expect(back.score, entry.score);
      expect(back.totalQuestions, entry.totalQuestions);
      expect(back.correct, entry.correct);
      expect(back.wrong, entry.wrong);
      expect(back.skipped, entry.skipped);
      expect(back.recordedAt, entry.recordedAt);
      expect(back.source, entry.source);
      expect(back.code, entry.code);
    });
  });

  group('per-test aggregation', () {
    List<GradebookEntry> entries() {
      GradebookEntry entry(String name, double score, int correct) {
        final CertificateData data = customResult(
          name: name,
          score: score,
          correct: correct,
          wrong: 100 - correct,
          skipped: 0,
        );
        return GradebookEntry.fromCertificateData(
          data,
          encodeCertificateCode(data),
          source: 'this device',
          recordedAt: DateTime(2026, 11, 13, 10, correct),
        );
      }

      return <GradebookEntry>[
        entry('Ayesha', 90, 90),
        entry('Bilal', 80, 80),
        entry('Sara', 70, 70),
      ];
    }

    test('count, average score, average %, best', () {
      final List<GradebookGroup> groups = groupGradebookEntries(entries());
      expect(groups.length, 1);
      final GradebookGroup group = groups.first;
      expect(group.testLabel, 'My Urdu Quiz');
      expect(group.attempts, 3);
      expect(group.averageScore, 80);
      expect(group.averagePercentage, 80);
      expect(group.bestScore, 90);
      expect(group.bestEntry?.holderName, 'Ayesha');
    });

    test('two tests group separately', () {
      final CertificateData other = customResult(
        testLabel: 'English Quiz',
        name: 'Ayesha',
        score: 50,
        correct: 50,
        wrong: 50,
        skipped: 0,
      );
      final List<GradebookEntry> all = <GradebookEntry>[
        ...entries(),
        GradebookEntry.fromCertificateData(
          other,
          encodeCertificateCode(other),
          source: 'result code',
          recordedAt: DateTime(2026, 11, 14),
        ),
      ];
      final List<GradebookGroup> groups = groupGradebookEntries(all);
      expect(groups.length, 2);
      expect(groups.map((g) => g.testLabel).toSet(),
          {'My Urdu Quiz', 'English Quiz'});
    });
  });

  group('export', () {
    List<GradebookEntry> entries() {
      final CertificateData data = customResult(name: 'Ayesha, "Top"');
      return <GradebookEntry>[
        GradebookEntry.fromCertificateData(
          data,
          encodeCertificateCode(data),
          source: 'this device',
          recordedAt: DateTime(2026, 11, 13, 10, 30),
        ),
      ];
    }

    test('JSON export holds full entries incl. codes', () {
      final List<GradebookEntry> list = entries();
      final Map<String, dynamic> doc =
          jsonDecode(buildGradebookJson(list)) as Map<String, dynamic>;
      expect(doc['app'], 'WolfTyping');
      expect(doc['formatVersion'], 1);
      final List<dynamic> exported = doc['entries'] as List<dynamic>;
      expect(exported.length, 1);
      final Map<String, dynamic> row = exported.first as Map<String, dynamic>;
      expect(row['holderName'], 'Ayesha, "Top"');
      expect(row['score'], 88.5);
      expect(row['code'], list.first.code);
    });

    test('CSV export has one row per entry with escaped names', () {
      final String csv = buildGradebookCsv(entries());
      final List<String> lines = csv.split('\n');
      expect(lines.length, 2);
      expect(
        lines.first,
        'testLabel,holderName,date,score,totalQuestions,correct,wrong,'
        'skipped,percentage,recordedAt,source,code',
      );
      expect(lines[1], contains('"Ayesha, ""Top"""'));
      expect(lines[1], contains('88.5'));
      expect(lines[1], contains('WT1.'));
    });
  });
}
