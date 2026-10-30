import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles Light / Dark / System theme switching.
///
/// This is intentionally kept separate from [Settings] (the Drift table)
/// because theme needs to be readable synchronously at app boot, before the
/// database is guaranteed to be open. SettingsController (Step 28) will
/// keep the Drift `Settings` row as the source of truth for the *rest* of
/// preferences and call [setMode] here to keep both in sync.
class ThemeService extends GetxService {
  static const String _prefsKey = 'theme_mode';

  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  Future<ThemeService> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? stored = prefs.getString(_prefsKey);
    themeMode.value = _fromString(stored);
    return this;
  }

  Future<void> setMode(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, mode.name);
  }

  ThemeMode _fromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
