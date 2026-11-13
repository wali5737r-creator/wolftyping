import 'package:get/get.dart';

import '../../../core/services/history_file_share.dart';
import '../model/gradebook_entry.dart';
import '../service/gradebook_repository.dart';
import 'custom_sets_controller.dart';

/// Owns the gradebook screen state: the recorded entries, adding a
/// pasted WT1 result code, deleting one entry or a whole test group,
/// and exporting JSON/CSV (web download, same as History export).
class GradebookController extends GetxController {
  GradebookController({GradebookRepository? repository})
      : _repository = repository ?? GradebookRepository.instance;

  final GradebookRepository _repository;

  final RxList<GradebookEntry> entries = <GradebookEntry>[].obs;
  final RxBool loaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshEntries();
  }

  Future<void> refreshEntries() async {
    entries.assignAll(await _repository.load());
    loaded.value = true;
  }

  List<GradebookGroup> get groups => groupGradebookEntries(entries.toList());

  /// Names of the custom tests saved on this device, when the
  /// custom-tests controller is registered (it is on the gradebook
  /// route). Used to flag groups whose test no longer exists here —
  /// the set may have been deleted, which never blocks recording.
  Set<String> get knownTestNames {
    if (!Get.isRegistered<CustomSetsController>()) return <String>{};
    return Get.find<CustomSetsController>()
        .sets
        .map((s) => s.name)
        .toSet();
  }

  bool hasMatchingSet(String testLabel) {
    // When the sets controller is not registered we cannot know, so
    // never show the "no matching test" note on a guess.
    if (!Get.isRegistered<CustomSetsController>()) return true;
    return knownTestNames.contains(testLabel);
  }

  /// Records a pasted WT1 result code. Returns the recorded entry,
  /// or null when that code is already in the gradebook. Throws
  /// [FormatException] with a readable message for bad, tampered or
  /// non-mock codes; the caller shows it.
  Future<GradebookEntry?> recordCode(String code) async {
    final GradebookEntry? entry = await _repository.recordCode(code);
    if (entry != null) await refreshEntries();
    return entry;
  }

  /// Records an entry built on this device (auto-recorded custom-test
  /// result). Returns false when the code is already recorded.
  Future<bool> recordEntry(GradebookEntry entry) async {
    final bool added = await _repository.recordEntry(entry);
    if (added) await refreshEntries();
    return added;
  }

  Future<void> deleteEntry(String code) async {
    await _repository.deleteEntry(code);
    await refreshEntries();
  }

  Future<void> clearGroup(String testLabel) async {
    await _repository.clearGroup(testLabel);
    await refreshEntries();
  }

  /// Downloads the full gradebook as JSON (entries incl. codes).
  /// Returns a message for the screen to show, or null when
  /// downloads are unavailable on this platform.
  Future<String?> exportJson() async {
    final String fileName = _exportFileName('json');
    final bool ok = await downloadHistoryFile(
      fileName,
      buildGradebookJson(entries.toList()),
      'application/json',
    );
    if (!ok) return null;
    return 'Downloaded $fileName — ${entries.length} '
        'result${entries.length == 1 ? '' : 's'}.';
  }

  /// Downloads the same entries as a CSV file (one row per entry).
  Future<String?> exportCsv() async {
    final String fileName = _exportFileName('csv');
    final bool ok = await downloadHistoryFile(
      fileName,
      buildGradebookCsv(entries.toList()),
      'text/csv',
    );
    if (!ok) return null;
    return 'Downloaded $fileName — ${entries.length} '
        'result${entries.length == 1 ? '' : 's'}.';
  }

  String _exportFileName(String extension) {
    final DateTime now = DateTime.now();
    final String stamp = '${now.year}${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}';
    return 'wolftyping-gradebook-$stamp.$extension';
  }
}
