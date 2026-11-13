import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/certificate_code.dart';
import '../model/gradebook_entry.dart';

/// On-device storage for the custom-test gradebook, via
/// shared_preferences — the same pattern as
/// [CustomSetsRepository]. No login, no backend, no server: results
/// live only on this device until the teacher exports them.
///
/// A corrupt stored blob never crashes the app: [load] skips entries
/// it cannot parse and returns the rest, so one bad entry cannot
/// wipe the gradebook.
class GradebookRepository {
  GradebookRepository._();

  static final GradebookRepository instance = GradebookRepository._();

  static const String storageKey = 'wolftyping_gradebook_v1';

  Future<List<GradebookEntry>> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(storageKey);
    if (raw == null || raw.trim().isEmpty) return <GradebookEntry>[];
    try {
      final Object? parsed = jsonDecode(raw);
      if (parsed is! List) return <GradebookEntry>[];
      final List<GradebookEntry> entries = <GradebookEntry>[];
      for (final Object? item in parsed) {
        try {
          if (item is Map) {
            entries.add(
              GradebookEntry.fromJson(Map<String, dynamic>.from(item)),
            );
          }
        } catch (_) {
          // Skip one bad entry; keep the rest.
        }
      }
      return entries;
    } catch (_) {
      return <GradebookEntry>[];
    }
  }

  /// Persists [entries]. Throws a readable error instead of a raw
  /// storage exception when the device store is full or unavailable.
  Future<void> saveAll(List<GradebookEntry> entries) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        storageKey,
        jsonEncode(entries.map((e) => e.toJson()).toList()),
      );
    } catch (_) {
      throw Exception(
        'Could not save — storage full. Free up space in this browser '
        'and try again.',
      );
    }
  }

  /// Records [entry]. Returns true when it was added, false when an
  /// entry with the same WT1 code is already recorded — re-taking
  /// the same test with the same result never spams duplicates.
  Future<bool> recordEntry(GradebookEntry entry) async {
    final List<GradebookEntry> entries = await load();
    if (entries.any((e) => e.code == entry.code)) return false;
    entries.add(entry);
    await saveAll(entries);
    return true;
  }

  /// Verifies a pasted WT1 [code] and records it as a gradebook
  /// entry (source 'result code'). Returns the recorded entry, or
  /// null when that code is already in the gradebook.
  ///
  /// Throws [FormatException] with a readable message when the code
  /// is malformed, tampered with, describes an impossible result
  /// (all from [decodeCertificateCode]), or is not a mock-kind code:
  /// this gradebook is for custom MCQ tests, not typing tests.
  Future<GradebookEntry?> recordCode(String code) async {
    final CertificateData data = decodeCertificateCode(code);
    if (data.kind != CertificateKind.mock) {
      throw const FormatException(
        'That code is for a typing test — this gradebook is for '
        'custom MCQ tests only.',
      );
    }
    final GradebookEntry entry = GradebookEntry.fromCertificateData(
      data,
      code.trim(),
      source: 'result code',
    );
    final bool added = await recordEntry(entry);
    return added ? entry : null;
  }

  /// Deletes the single entry with this WT1 [code].
  Future<void> deleteEntry(String code) async {
    final List<GradebookEntry> entries = await load();
    entries.removeWhere((e) => e.code == code);
    await saveAll(entries);
  }

  /// Deletes every entry recorded under [testLabel].
  Future<void> clearGroup(String testLabel) async {
    final List<GradebookEntry> entries = await load();
    entries.removeWhere((e) => e.testLabel == testLabel);
    await saveAll(entries);
  }
}
