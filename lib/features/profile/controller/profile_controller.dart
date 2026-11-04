import 'package:get/get.dart';

import '../model/profile_stats.dart';
import '../service/profile_repository.dart';
import '../../history/model/typing_test_record.dart';

class ProfileController extends GetxController {
  /// How long a profile read may take before the screen gives up waiting
  /// and shows empty data instead of spinning forever (the database open
  /// can hang on a reload). Tests inject a shorter value.
  static const Duration kLoadTimeout = Duration(seconds: 8);

  ProfileController({
    ProfileRepository? repository,
    Duration loadTimeout = kLoadTimeout,
  })  : _repository = repository ?? ProfileRepository.instance,
        _loadTimeout = loadTimeout;

  final ProfileRepository _repository;
  final Duration _loadTimeout;

  final stats = ProfileStats.empty.obs;
  final bestScores = <TypingTestRecord>[].obs;
  final loading = true.obs;
  final saving = false.obs;

  /// True when the latest load gave up waiting on the database.
  final loadTimedOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    loading.value = true;
    loadTimedOut.value = false;
    try {
      stats.value = await _repository.load().timeout(
        _loadTimeout,
        onTimeout: () {
          loadTimedOut.value = true;
          return ProfileStats.empty;
        },
      );
      bestScores.value = await _repository.bestScores().timeout(
        _loadTimeout,
        onTimeout: () {
          loadTimedOut.value = true;
          return <TypingTestRecord>[];
        },
      );
    } finally {
      loading.value = false;
    }
  }

  Future<bool> saveName(String value) async {
    final name = value.trim();
    if (name.isEmpty) return false;
    saving.value = true;
    await _repository.updateName(name);
    await load();
    saving.value = false;
    return true;
  }
}
