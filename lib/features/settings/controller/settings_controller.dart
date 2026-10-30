import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/app_settings.dart';
import '../service/settings_repository.dart';
import '../../../core/services/data_refresh_service.dart';
import '../../../core/services/theme_service.dart';

/// App-wide settings holder. Registered once (permanent) in `main.dart`
/// so every typing controller and the Settings screen
/// all read the same reactive [settings] value — saving or resetting a
/// setting updates all of them immediately, with no screen re-entry.
class SettingsController extends GetxController {
  final settings = Rxn<AppSettings>();
  final loading = true.obs;

  /// Used by `main.dart` (`Get.putAsync`) so settings are loaded from
  /// SQLite before the first frame.
  Future<SettingsController> init() async {
    await load();
    return this;
  }

  /// The current settings, or null if the controller isn't registered or
  /// hasn't finished loading (callers fall back to built-in defaults).
  static AppSettings? get currentOrNull {
    if (!Get.isRegistered<SettingsController>()) return null;
    return Get.find<SettingsController>().settings.value;
  }

  Future<void> load() async {
    loading.value = true;

    settings.value = await SettingsRepository.instance.load();

    loading.value = false;
  }

  // Save settings and apply theme.
  Future<void> saveSettings(AppSettings value) async {
    final AppSettings? previous = settings.value;
    settings.value = value;

    await SettingsRepository.instance.save(value);

    await Get.find<ThemeService>().setMode(value.themeMode);

    // The daily goal feeds Dashboard / Progress, so tell them to reload.
    if (previous != null &&
        previous.dailyGoalSeconds != value.dailyGoalSeconds) {
      DataRefreshService.notifyChanged();
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    final current = settings.value;

    if (current == null) return;

    await saveSettings(
      current.copyWith(themeMode: mode),
    );
  }

  Future<void> clearHistory() async {
    await SettingsRepository.instance.clearHistory();
    DataRefreshService.notifyChanged();
  }

  Future<void> reset() async {
    await SettingsRepository.instance.resetSettings();

    // Reload from SQLite into the shared reactive value so every active
    // controller / screen sees the defaults straight away.
    await load();

    final current = settings.value;

    if (current != null) {
      await Get.find<ThemeService>().setMode(current.themeMode);
    }

    DataRefreshService.notifyChanged();
  }
}
