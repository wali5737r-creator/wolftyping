import 'package:get/get.dart';

import '../model/custom_set.dart';
import '../service/custom_sets_repository.dart';

/// Owns the teacher's saved custom MCQ sets: loading them from the
/// device, creating/updating/deleting them, and importing a shared
/// code. The test run itself is owned by [MockTestController] — this
/// controller only hands it a set to run.
class CustomSetsController extends GetxController {
  CustomSetsController({CustomSetsRepository? repository})
      : _repository = repository ?? CustomSetsRepository.instance;

  final CustomSetsRepository _repository;

  final RxList<CustomSet> sets = <CustomSet>[].obs;
  final RxBool loaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshSets();
  }

  Future<void> refreshSets() async {
    sets.assignAll(await _repository.load());
    loaded.value = true;
  }

  Future<CustomSet> saveSet(CustomSet set) async {
    final CustomSet stored = await _repository.upsert(set);
    await refreshSets();
    return stored;
  }

  Future<void> deleteSet(String id) async {
    await _repository.delete(id);
    await refreshSets();
  }

  /// Imports a shared code (or plain JSON). Throws [FormatException]
  /// with a readable message for bad input; the caller shows it.
  Future<CustomSet> importCode(String code) async {
    final CustomSet stored = await _repository.importCode(code);
    await refreshSets();
    return stored;
  }

  String exportCode(CustomSet set) => set.encode();

  /// Suggested file name for a set's JSON export.
  static String fileNameFor(CustomSet set) {
    final String slug = set.name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return '${slug.isEmpty ? 'custom-test' : slug}.json';
  }
}
