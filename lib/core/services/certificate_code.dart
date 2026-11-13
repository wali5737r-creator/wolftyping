import 'dart:convert';

/// Free, server-free practice certificates: the verification code IS
/// the result, plus a tamper-evidence checksum.
///
/// # The scheme (plain words)
///
/// A certificate code looks like:
///
///   `WT1.<base64url payload>.<8-hex checksum>`
///
/// The payload is a compact `|`-separated list of fields — version,
/// test kind (`mock` or `typing`), test label, date (YYYYMMDD), holder
/// name, headline score, total questions (0 for a typing test),
/// correct / wrong / skipped counts, and accuracy in hundredths of a
/// percent (0 for a mock test). The label and name are base64url-encoded
/// inside the payload so they can contain any characters, including
/// `|`, spaces and Urdu text.
///
/// The checksum is FNV-1a (32-bit) over the fixed salt
/// `WolfTyping-cert-v1|` plus the payload, written as 8 lowercase hex
/// characters. [decodeCertificateCode] recomputes it and rejects any
/// code whose checksum does not match, so changing the score, the name
/// or any other field after the code was created is detected.
///
/// # What this does NOT prove
///
/// This is a checksum, not a cryptographic signature and not a
/// server record: anyone with the app can generate a code for any
/// numbers they type in. Verification therefore proves only that the
/// code was not altered after it was created — it does NOT prove the
/// test was really taken or supervised. The certificate and the
/// verification screen both say this plainly, and the certificate is
/// always labelled a WolfTyping *practice* certificate, never an
/// official PPSC or government certificate.
///
/// No account, no login, no server, no network: the code is created
/// and verified entirely on the device.

/// The two kinds of result a certificate can carry.
enum CertificateKind { mock, typing }

/// The data printed on a practice certificate and encoded in its
/// verification code.
class CertificateData {
  const CertificateData({
    required this.kind,
    required this.testLabel,
    required this.holderName,
    required this.date,
    required this.score,
    required this.totalQuestions,
    required this.correct,
    required this.wrong,
    required this.skipped,
    required this.accuracy,
  });

  /// Maximum characters for the holder name (matches the profile
  /// name limit, so a certificate name never outgrows the UI).
  static const int maxNameLength = 40;

  /// Maximum characters for the test label.
  static const int maxLabelLength = 80;

  final CertificateKind kind;

  /// Human label, e.g. `Full mock test · 5 minutes` or
  /// `Typing Test — English`.
  final String testLabel;

  /// Name entered by the user, stored only on their device.
  final String holderName;

  /// Date the test was completed (date part only).
  final DateTime date;

  /// Headline number: the mock score (marks) for a mock test, the
  /// net WPM for a typing test.
  final double score;

  /// Questions in the mock test; 0 for a typing test.
  final int totalQuestions;

  /// Correct / wrong / skipped counts. For a typing test these are
  /// correct / wrong characters and skipped is 0.
  final int correct;
  final int wrong;
  final int skipped;

  /// 0–100. The typing accuracy; 0 for a mock test.
  final double accuracy;

  /// Short human-readable headline, e.g. `88.5 / 100` or `42 WPM`.
  String get headline {
    final String s = _formatNumber(score);
    return kind == CertificateKind.mock ? '$s / $totalQuestions' : '$s WPM';
  }
}

/// Salt mixed into the checksum so a code from another scheme cannot
/// accidentally validate here. It is public by design — the checksum
/// is tamper-evidence, not a secret (see the file doc comment).
const String _certificateChecksumSalt = 'WolfTyping-cert-v1|';

/// 32-bit FNV-1a hash, written as 8 lowercase hex characters.
/// Implemented here (a dozen lines) instead of adding a dependency.
String _checksumHex(String payload) {
  var hash = 0x811c9dc5;
  final List<int> bytes = utf8.encode('$_certificateChecksumSalt$payload');
  for (final int byte in bytes) {
    hash ^= byte;
    hash = (hash * 0x01000193) & 0xffffffff;
  }
  return hash.toRadixString(16).padLeft(8, '0');
}

String _formatNumber(double value) {
  if (value == value.truncateToDouble()) return '${value.toInt()}';
  // Two decimals at most: mock scores use at most 2 (negative marking
  // is 0.25 steps), typing WPM is shown to 1 decimal.
  final String fixed = value.toStringAsFixed(2);
  return fixed.endsWith('0') ? fixed.substring(0, fixed.length - 1) : fixed;
}

String _dateCode(DateTime date) {
  final String y = '${date.year}'.padLeft(4, '0');
  final String m = '${date.month}'.padLeft(2, '0');
  final String d = '${date.day}'.padLeft(2, '0');
  return '$y$m$d';
}

/// Encodes [data] as a verification code (see the file doc comment).
/// Throws [ArgumentError] when the name or label is empty or too long.
String encodeCertificateCode(CertificateData data) {
  final String name = data.holderName.trim();
  if (name.isEmpty) {
    throw ArgumentError('Certificate holder name cannot be empty.');
  }
  if (name.length > CertificateData.maxNameLength) {
    throw ArgumentError(
      'Certificate holder name is over '
      '${CertificateData.maxNameLength} characters.',
    );
  }
  if (data.testLabel.trim().isEmpty ||
      data.testLabel.length > CertificateData.maxLabelLength) {
    throw ArgumentError('Certificate test label is empty or too long.');
  }
  final String payload = <String>[
    '1',
    data.kind.name,
    base64Url.encode(utf8.encode(data.testLabel)),
    _dateCode(data.date),
    base64Url.encode(utf8.encode(name)),
    _formatNumber(data.score),
    '${data.totalQuestions}',
    '${data.correct}',
    '${data.wrong}',
    '${data.skipped}',
    '${(data.accuracy * 100).round()}',
  ].join('|');
  final String encoded = base64Url.encode(utf8.encode(payload));
  return 'WT1.$encoded.${_checksumHex(payload)}';
}

/// Decodes a code produced by [encodeCertificateCode] and verifies its
/// checksum. Returns the decoded result, or throws a [FormatException]
/// with a readable message when the code is malformed, tampered with,
/// or describes an impossible result (for example a score above the
/// total, or counts that do not add up to the total).
CertificateData decodeCertificateCode(String code) {
  const String invalid = 'This certificate code is not valid.';
  final String trimmed = code.trim();
  final List<String> parts = trimmed.split('.');
  if (parts.length != 3 || parts[0] != 'WT1') {
    throw const FormatException(invalid);
  }
  final String encodedPayload = parts[1];
  final String checksum = parts[2];
  if (encodedPayload.isEmpty ||
      checksum.length != 8 ||
      int.tryParse(checksum, radix: 16) == null) {
    throw const FormatException(invalid);
  }
  late final String payload;
  try {
    payload = utf8.decode(base64Url.decode(encodedPayload));
  } catch (_) {
    throw const FormatException(invalid);
  }
  if (_checksumHex(payload) != checksum.toLowerCase()) {
    throw const FormatException(
      'This certificate code was changed after it was created.',
    );
  }
  final List<String> fields = payload.split('|');
  if (fields.length != 11 || fields[0] != '1') {
    throw const FormatException(invalid);
  }
  final CertificateKind? kind = switch (fields[1]) {
    'mock' => CertificateKind.mock,
    'typing' => CertificateKind.typing,
    _ => null,
  };
  if (kind == null) throw const FormatException(invalid);
  late final String label;
  late final String name;
  try {
    label = utf8.decode(base64Url.decode(fields[2]));
    name = utf8.decode(base64Url.decode(fields[4]));
  } catch (_) {
    throw const FormatException(invalid);
  }
  final String dateCode = fields[3];
  final DateTime? date = dateCode.length == 8
      ? DateTime.tryParse(
          '${dateCode.substring(0, 4)}-${dateCode.substring(4, 6)}-'
          '${dateCode.substring(6, 8)}',
        )
      : null;
  final double? score = double.tryParse(fields[5]);
  final int? total = int.tryParse(fields[6]);
  final int? correct = int.tryParse(fields[7]);
  final int? wrong = int.tryParse(fields[8]);
  final int? skipped = int.tryParse(fields[9]);
  final int? accuracyHundredths = int.tryParse(fields[10]);
  if (date == null ||
      score == null ||
      total == null ||
      correct == null ||
      wrong == null ||
      skipped == null ||
      accuracyHundredths == null) {
    throw const FormatException(invalid);
  }
  if (label.trim().isEmpty ||
      label.length > CertificateData.maxLabelLength ||
      name.trim().isEmpty ||
      name.length > CertificateData.maxNameLength) {
    throw const FormatException(invalid);
  }
  if (date.year < 2020 || date.year > 2100) {
    throw const FormatException(invalid);
  }
  if (score < 0 ||
      total < 0 ||
      correct < 0 ||
      wrong < 0 ||
      skipped < 0 ||
      accuracyHundredths < 0 ||
      accuracyHundredths > 10000) {
    throw const FormatException(invalid);
  }
  if (kind == CertificateKind.mock) {
    if (total == 0 ||
        score > total ||
        correct + wrong + skipped != total ||
        accuracyHundredths != 0) {
      throw const FormatException(
        'This certificate code describes an impossible mock result.',
      );
    }
  } else {
    if (total != 0 || skipped != 0 || score > 300) {
      throw const FormatException(
        'This certificate code describes an impossible typing result.',
      );
    }
  }
  return CertificateData(
    kind: kind,
    testLabel: label,
    holderName: name,
    date: DateTime(date.year, date.month, date.day),
    score: score,
    totalQuestions: total,
    correct: correct,
    wrong: wrong,
    skipped: skipped,
    accuracy: accuracyHundredths / 100,
  );
}
