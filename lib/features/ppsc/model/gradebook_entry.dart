import 'dart:convert';

import '../../../core/services/certificate_code.dart';

/// Gradebook: one recorded custom-test result per entry, keyed by its
/// WT1 verification code.
///
/// A custom-test result IS a mock-kind certificate result (score in
/// 0.25 steps, counts adding to the total, accuracy 0), so the
/// gradebook reuses [encodeCertificateCode]/[decodeCertificateCode]
/// as-is instead of inventing a second code scheme: an entry's [code]
/// is a certificate code with kind=mock, testLabel=custom test name,
/// holderName=taker name. The checksum + impossible-result checks in
/// [decodeCertificateCode] are what make a pasted code trustworthy —
/// a tampered code is rejected before it can enter the gradebook.
///
/// Entries live only on this device (SharedPreferences, see
/// [GradebookRepository] in ../service/gradebook_repository.dart).
/// No account, no server. Import is NOT supported — only export
/// (JSON/CSV); a result enters the gradebook by being recorded on
/// this device or by pasting a verified WT1 code.
///
/// Pure Dart: no GetX, no storage here, so this file is unit tested
/// directly (see test/gradebook_test.dart).
class GradebookEntry {
  const GradebookEntry({
    required this.testLabel,
    required this.holderName,
    required this.date,
    required this.score,
    required this.totalQuestions,
    required this.correct,
    required this.wrong,
    required this.skipped,
    required this.recordedAt,
    required this.source,
    required this.code,
  });

  /// Builds an entry from a verified [CertificateData] (kind must be
  /// mock — the caller enforces that) and its WT1 [code].
  factory GradebookEntry.fromCertificateData(
    CertificateData data,
    String code, {
    required String source,
    DateTime? recordedAt,
  }) {
    return GradebookEntry(
      testLabel: data.testLabel,
      holderName: data.holderName,
      date: DateTime(data.date.year, data.date.month, data.date.day),
      score: data.score,
      totalQuestions: data.totalQuestions,
      correct: data.correct,
      wrong: data.wrong,
      skipped: data.skipped,
      recordedAt: recordedAt ?? DateTime.now(),
      source: source,
      code: code,
    );
  }

  /// Custom test name, e.g. the name the teacher gave the set.
  final String testLabel;

  /// Name of the person who took the test.
  final String holderName;

  /// Date the test was taken (date part only).
  final DateTime date;

  /// Marks scored (0.25 steps when negative marking was on).
  final double score;

  final int totalQuestions;
  final int correct;
  final int wrong;
  final int skipped;

  /// When this entry was recorded in the gradebook.
  final DateTime recordedAt;

  /// 'this device' for a test finished here, 'result code' for a
  /// pasted WT1 code.
  final String source;

  /// The WT1 verification code itself, stored so the entry can be
  /// re-verified later. Also the dedupe key: recording the same code
  /// twice must not create a duplicate entry.
  final String code;

  /// Short headline, e.g. `88.5 / 100`.
  String get scoreLabel {
    final String s = score == score.truncateToDouble()
        ? '${score.toInt()}'
        : score.toStringAsFixed(2).replaceAll(RegExp(r'0$'), '');
    return '$s / $totalQuestions';
  }

  /// Score as a percentage of the total, 0 when there is no total.
  double get percentage =>
      totalQuestions == 0 ? 0 : score / totalQuestions * 100;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'testLabel': testLabel,
        'holderName': holderName,
        'date': _dateCode(date),
        'score': score,
        'totalQuestions': totalQuestions,
        'correct': correct,
        'wrong': wrong,
        'skipped': skipped,
        'recordedAt': recordedAt.toIso8601String(),
        'source': source,
        'code': code,
      };

  factory GradebookEntry.fromJson(Map<String, dynamic> json) {
    final String dateCode = json['date'] as String? ?? '';
    final DateTime? date = dateCode.length == 8
        ? DateTime.tryParse(
            '${dateCode.substring(0, 4)}-${dateCode.substring(4, 6)}-'
            '${dateCode.substring(6, 8)}',
          )
        : null;
    if (date == null) {
      throw const FormatException('Gradebook entry is missing its date.');
    }
    return GradebookEntry(
      testLabel: _asString(json['testLabel'], 'testLabel'),
      holderName: _asString(json['holderName'], 'holderName'),
      date: date,
      score: _asNumber(json['score'], 'score'),
      totalQuestions: _asInt(json['totalQuestions'], 'totalQuestions'),
      correct: _asInt(json['correct'], 'correct'),
      wrong: _asInt(json['wrong'], 'wrong'),
      skipped: _asInt(json['skipped'], 'skipped'),
      recordedAt: _asDateTime(json['recordedAt'], 'recordedAt'),
      source: _asString(json['source'], 'source'),
      code: _asString(json['code'], 'code'),
    );
  }

  static String _dateCode(DateTime date) {
    final String y = '${date.year}'.padLeft(4, '0');
    final String m = '${date.month}'.padLeft(2, '0');
    final String d = '${date.day}'.padLeft(2, '0');
    return '$y$m$d';
  }

  static String _asString(Object? value, String field) {
    if (value is String && value.isNotEmpty) return value;
    throw FormatException('Gradebook entry field "$field" is not text.');
  }

  static int _asInt(Object? value, String field) {
    if (value is int) return value;
    throw FormatException('Gradebook entry field "$field" is not a number.');
  }

  static double _asNumber(Object? value, String field) {
    if (value is num) return value.toDouble();
    throw FormatException('Gradebook entry field "$field" is not a number.');
  }

  static DateTime _asDateTime(Object? value, String field) {
    if (value is String) {
      final DateTime? parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw FormatException('Gradebook entry field "$field" is not a date.');
  }
}

/// One custom test's results: every attempt under that test name,
/// with the summary numbers the gradebook shows.
class GradebookGroup {
  const GradebookGroup({
    required this.testLabel,
    required this.entries,
  });

  final String testLabel;

  /// Newest first.
  final List<GradebookEntry> entries;

  int get attempts => entries.length;

  double get averageScore => entries.isEmpty
      ? 0
      : entries.map((e) => e.score).reduce((a, b) => a + b) / entries.length;

  double get averagePercentage => entries.isEmpty
      ? 0
      : entries.map((e) => e.percentage).reduce((a, b) => a + b) /
          entries.length;

  double get bestScore => entries.isEmpty
      ? 0
      : entries.map((e) => e.score).reduce((a, b) => a > b ? a : b);

  GradebookEntry? get bestEntry => entries.isEmpty
      ? null
      : entries.reduce((a, b) => a.score >= b.score ? a : b);
}

/// Groups [entries] by custom test name. Groups are ordered by their
/// newest entry first; entries inside a group are newest first too.
List<GradebookGroup> groupGradebookEntries(List<GradebookEntry> entries) {
  final Map<String, List<GradebookEntry>> byLabel = {};
  for (final GradebookEntry entry in entries) {
    byLabel.putIfAbsent(entry.testLabel, () => <GradebookEntry>[]).add(entry);
  }
  final List<GradebookGroup> groups = <GradebookGroup>[
    for (final MapEntry<String, List<GradebookEntry>> group in byLabel.entries)
      GradebookGroup(
        testLabel: group.key,
        entries: (group.value.toList()
              ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt)))
            .toList(),
      ),
  ];
  groups.sort(
    (a, b) => b.entries.first.recordedAt.compareTo(a.entries.first.recordedAt),
  );
  return groups;
}

/// Full gradebook export as JSON (version 1): every entry with ALL
/// fields, including the WT1 codes, so a re-import elsewhere can
/// re-verify each result. Same shape discipline as the history
/// backup (app + formatVersion + exportedAt).
String buildGradebookJson(List<GradebookEntry> entries, {DateTime? now}) {
  final Map<String, dynamic> doc = <String, dynamic>{
    'app': 'WolfTyping',
    'formatVersion': 1,
    'exportedAt': (now ?? DateTime.now()).toIso8601String(),
    'entries': [for (final GradebookEntry e in entries) e.toJson()],
  };
  return const JsonEncoder.withIndent('  ').convert(doc);
}

/// One row per entry, for a spreadsheet. Codes are included (they
/// are the verifiable record); names and labels are CSV-escaped.
String buildGradebookCsv(List<GradebookEntry> entries) {
  const String header = 'testLabel,holderName,date,score,totalQuestions,'
      'correct,wrong,skipped,percentage,recordedAt,source,code';
  final StringBuffer out = StringBuffer(header);
  for (final GradebookEntry e in entries) {
    out
      ..write('\n')
      ..write(_csvCell(e.testLabel))
      ..write(',')
      ..write(_csvCell(e.holderName))
      ..write(',')
      ..write(e.date.toIso8601String().substring(0, 10))
      ..write(',')
      ..write(e.score)
      ..write(',')
      ..write(e.totalQuestions)
      ..write(',')
      ..write(e.correct)
      ..write(',')
      ..write(e.wrong)
      ..write(',')
      ..write(e.skipped)
      ..write(',')
      ..write(e.percentage.toStringAsFixed(1))
      ..write(',')
      ..write(e.recordedAt.toIso8601String())
      ..write(',')
      ..write(_csvCell(e.source))
      ..write(',')
      ..write(_csvCell(e.code));
  }
  return out.toString();
}

String _csvCell(String value) {
  if (value.contains(',') || value.contains('"') || value.contains('\n')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}
