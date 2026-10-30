import 'package:get/get.dart';

import '../model/profile_stats.dart';
import '../service/profile_repository.dart';
import '../../history/model/typing_test_record.dart';

class ProfileController extends GetxController {
  final stats = ProfileStats.empty.obs;
  final bestScores = <TypingTestRecord>[].obs;
  final loading = true.obs;
  final saving = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    stats.value = await ProfileRepository.instance.load();
    bestScores.value = await ProfileRepository.instance.bestScores();
    loading.value = false;
  }

  Future<bool> saveName(String value) async {
    final name = value.trim();
    if (name.isEmpty) return false;
    saving.value = true;
    await ProfileRepository.instance.updateName(name);
    await load();
    saving.value = false;
    return true;
  }
}
