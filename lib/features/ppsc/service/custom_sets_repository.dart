import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/custom_set.dart';

/// On-device storage for teacher-created custom MCQ sets, via
/// shared_preferences. No login, no backend, no server: sets live only
/// on this device until the teacher shares one as a code or file.
///
/// A corrupt stored blob never crashes the app: [load] skips entries
/// it cannot parse and returns the rest (an empty list when nothing
/// parses), so one bad entry cannot wipe the list UI.
class CustomSetsRepository {
  CustomSetsRepository._();

  static final CustomSetsRepository instance = CustomSetsRepository._();

  static const String storageKey = 'typing_master_custom_sets_v1';

  /// Fresh id for a new or imported set. Time-based, so two sets made
  /// in the same session still differ.
  static String newId() =>
      'custom-${DateTime.now().microsecondsSinceEpoch}';

  Future<List<CustomSet>> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(storageKey);
    if (raw == null || raw.trim().isEmpty) return <CustomSet>[];
    try {
      final Object? parsed = jsonDecode(raw);
      if (parsed is! List) return <CustomSet>[];
      final List<CustomSet> sets = <CustomSet>[];
      for (final Object? entry in parsed) {
        try {
          if (entry is Map) {
            sets.add(
              CustomSet.fromJson(Map<String, dynamic>.from(entry)),
            );
          }
        } catch (_) {
          // Skip one bad entry; keep the rest.
        }
      }
      return sets;
    } catch (_) {
      return <CustomSet>[];
    }
  }

  /// Persists [sets]. Throws a readable error instead of a raw
  /// storage exception when the device store is full or unavailable,
  /// so callers can show 'could not save — storage full' visibly.
  Future<void> saveAll(List<CustomSet> sets) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        storageKey,
        jsonEncode(sets.map((s) => s.toJson()).toList()),
      );
    } catch (_) {
      throw Exception(
        'Could not save — storage full. Free up space in this browser '
        'and try again.',
      );
    }
  }

  /// Inserts [set], or replaces the set with the same id. Returns the
  /// stored set.
  Future<CustomSet> upsert(CustomSet set) async {
    CustomSet.validate(set);
    final List<CustomSet> sets = await load();
    final int index = sets.indexWhere((s) => s.id == set.id);
    if (index >= 0) {
      sets[index] = set;
    } else {
      sets.add(set);
    }
    await saveAll(sets);
    return set;
  }

  Future<void> delete(String id) async {
    final List<CustomSet> sets = await load();
    sets.removeWhere((s) => s.id == id);
    await saveAll(sets);
  }

  /// Imports [code] (see [CustomSet.decode]). When the imported id
  /// already exists on this device, a fresh id is assigned so the
  /// import never silently overwrites a teacher's own set.
  Future<CustomSet> importCode(String code) async {
    final CustomSet decoded = CustomSet.decode(code);
    final List<CustomSet> sets = await load();
    final CustomSet stored = sets.any((s) => s.id == decoded.id)
        ? decoded.copyWith(id: newId())
        : decoded;
    await upsert(stored);
    return stored;
  }
}
