import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/core/services/certificate_code.dart';

/// Free verifiable certificate: the code carries the result plus a
/// checksum the app recomputes — no server, no account. These tests
/// cover the encode → decode round-trip, tamper rejection, and the
/// code staying short enough to copy/share.
void main() {
  CertificateData mockData({String name = 'Muhammad'}) => CertificateData(
        kind: CertificateKind.mock,
        testLabel: 'Full mock test · 5 minutes',
        holderName: name,
        date: DateTime(2026, 11, 13),
        score: 88.5,
        totalQuestions: 100,
        correct: 90,
        wrong: 7,
        skipped: 3,
        accuracy: 0,
      );

  CertificateData typingData() => CertificateData(
        kind: CertificateKind.typing,
        testLabel: 'Typing Test — English',
        holderName: 'Muhammad',
        date: DateTime(2026, 11, 13),
        score: 42,
        totalQuestions: 0,
        correct: 512,
        wrong: 18,
        skipped: 0,
        accuracy: 96.5,
      );

  group('certificate code round-trip', () {
    test('mock attempt encodes and decodes to the same fields', () {
      final String code = encodeCertificateCode(mockData());
      final CertificateData decoded = decodeCertificateCode(code);
      expect(decoded.kind, CertificateKind.mock);
      expect(decoded.testLabel, 'Full mock test · 5 minutes');
      expect(decoded.holderName, 'Muhammad');
      expect(decoded.date, DateTime(2026, 11, 13));
      expect(decoded.score, 88.5);
      expect(decoded.totalQuestions, 100);
      expect(decoded.correct, 90);
      expect(decoded.wrong, 7);
      expect(decoded.skipped, 3);
      expect(decoded.headline, '88.5 / 100');
    });

    test('typing result encodes and decodes to the same fields', () {
      final String code = encodeCertificateCode(typingData());
      final CertificateData decoded = decodeCertificateCode(code);
      expect(decoded.kind, CertificateKind.typing);
      expect(decoded.testLabel, 'Typing Test — English');
      expect(decoded.score, 42);
      expect(decoded.accuracy, 96.5);
      expect(decoded.correct, 512);
      expect(decoded.wrong, 18);
      expect(decoded.headline, '42 WPM');
    });

    test('code is short enough to copy/share', () {
      expect(encodeCertificateCode(mockData()).length, lessThan(200));
      expect(encodeCertificateCode(typingData()).length, lessThan(200));
      // A 40-character name (the maximum) still stays shareable.
      expect(
        encodeCertificateCode(mockData(name: 'A' * 40)).length,
        lessThan(250),
      );
    });

    test('Urdu name and label round-trip', () {
      final CertificateData data = CertificateData(
        kind: CertificateKind.mock,
        testLabel: 'Full mock test · 10 minutes',
        holderName: 'محمد علی',
        date: DateTime(2026, 11, 13),
        score: 75,
        totalQuestions: 100,
        correct: 75,
        wrong: 20,
        skipped: 5,
        accuracy: 0,
      );
      final CertificateData decoded =
          decodeCertificateCode(encodeCertificateCode(data));
      expect(decoded.holderName, 'محمد علی');
    });

    test('whole-number score round-trips exactly', () {
      final CertificateData decoded = decodeCertificateCode(
        encodeCertificateCode(mockData().copyWithScore(90)),
      );
      expect(decoded.score, 90);
      expect(decoded.headline, '90 / 100');
    });
  });

  group('certificate code tamper rejection', () {
    test('changed score is rejected', () {
      final String code = encodeCertificateCode(mockData());
      // Re-encode the same result with a better score, then splice
      // the tampered payload under the ORIGINAL checksum.
      final String tampered = encodeCertificateCode(
        mockData().copyWithScore(100),
      );
      final List<String> originalParts = code.split('.');
      final List<String> tamperedParts = tampered.split('.');
      final String forged =
          'WT1.${tamperedParts[1]}.${originalParts[2]}';
      expect(() => decodeCertificateCode(forged), throwsFormatException);
    });

    test('changed name is rejected', () {
      final String code = encodeCertificateCode(mockData());
      final String tampered = encodeCertificateCode(
        mockData(name: 'Someone Else'),
      );
      final List<String> originalParts = code.split('.');
      final List<String> tamperedParts = tampered.split('.');
      final String forged =
          'WT1.${tamperedParts[1]}.${originalParts[2]}';
      expect(() => decodeCertificateCode(forged), throwsFormatException);
    });

    test('bad checksum is rejected', () {
      final String code = encodeCertificateCode(mockData());
      final List<String> parts = code.split('.');
      final String bad = 'WT1.${parts[1]}.00000000';
      expect(() => decodeCertificateCode(bad), throwsFormatException);
    });

    test('garbage, wrong prefix and truncated codes are rejected', () {
      for (final String bad in <String>[
        '',
        'hello',
        'WT1.onlyonepart',
        'WT2.${encodeCertificateCode(mockData()).split('.')[1]}.00000000',
        encodeCertificateCode(mockData()).substring(
          0,
          encodeCertificateCode(mockData()).length - 5,
        ),
      ]) {
        expect(
          () => decodeCertificateCode(bad),
          throwsFormatException,
          reason: 'should reject: $bad',
        );
      }
    });

    test('impossible results are rejected even with a valid checksum', () {
      // Score above the total, and counts that do not add up — both
      // encode fine, but decode must refuse them.
      final String tooHigh = encodeCertificateCode(
        mockData().copyWithScore(101),
      );
      expect(() => decodeCertificateCode(tooHigh), throwsFormatException);
      final String wrongCounts = encodeCertificateCode(
        CertificateData(
          kind: CertificateKind.mock,
          testLabel: 'Full mock test · 5 minutes',
          holderName: 'Muhammad',
          date: DateTime(2026, 11, 13),
          score: 50,
          totalQuestions: 100,
          correct: 50,
          wrong: 10,
          skipped: 10,
          accuracy: 0,
        ),
      );
      expect(() => decodeCertificateCode(wrongCounts), throwsFormatException);
    });
  });

  group('certificate code input validation', () {
    test('empty name cannot be encoded', () {
      expect(
        () => encodeCertificateCode(mockData(name: '   ')),
        throwsArgumentError,
      );
    });

    test('over-long name cannot be encoded', () {
      expect(
        () => encodeCertificateCode(mockData(name: 'A' * 41)),
        throwsArgumentError,
      );
    });
  });
}

extension on CertificateData {
  CertificateData copyWithScore(double newScore) => CertificateData(
        kind: kind,
        testLabel: testLabel,
        holderName: holderName,
        date: date,
        score: newScore,
        totalQuestions: totalQuestions,
        correct: correct,
        wrong: wrong,
        skipped: skipped,
        accuracy: accuracy,
      );
}
