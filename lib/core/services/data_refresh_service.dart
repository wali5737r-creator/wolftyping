import 'package:get/get.dart';

/// A tiny app-wide "stored data changed" signal.
///
/// Repositories call [notifyChanged] after a completed test is saved, a
/// history record is deleted, history is cleared, or the daily goal /
/// settings reset changes what the stats mean. Controllers that show
/// derived numbers (Dashboard, Progress, History) listen to [revision]
/// and reload, so they never show stale data — even if the save finished
/// after the screen had already loaded.
class DataRefreshService extends GetxService {
  final RxInt revision = 0.obs;

  /// Safe to call from anywhere (including unit tests, where the service
  /// isn't registered — it is then a no-op).
  static void notifyChanged() {
    if (Get.isRegistered<DataRefreshService>()) {
      Get.find<DataRefreshService>().revision.value++;
    }
  }
}
