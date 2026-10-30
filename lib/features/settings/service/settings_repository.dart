import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/database/app_database.dart';
import '../model/app_settings.dart';

class SettingsRepository {
  SettingsRepository._();
  static final instance = SettingsRepository._();
  AppDatabase get _db => Get.find<AppDatabase>();
  static const _prefix = 'typing_master_';

  Future<int> _ensureUser() async {
    final users = await _db.select(_db.users).get();
    if (users.isNotEmpty) return users.first.id;
    return _db.into(_db.users).insert(const UsersCompanion());
  }

  Future<AppSettings> load() async {
    final userId = await _ensureUser();
    final user = (await (_db.select(_db.users)..where((u) => u.id.equals(userId))).get()).first;
    final rows = await (_db.select(_db.settings)..where((s) => s.userId.equals(userId))).get();
    if (rows.isEmpty) await _db.into(_db.settings).insert(SettingsCompanion(userId: Value(userId)));
    final row = rows.isEmpty ? (await (_db.select(_db.settings)..where((s) => s.userId.equals(userId))).get()).first : rows.first;
    final prefs = await SharedPreferences.getInstance();
    final theme = switch (prefs.getString('${_prefix}theme') ?? row.theme) { 'light' => ThemeMode.light, 'dark' => ThemeMode.dark, _ => ThemeMode.system };
    return AppSettings(
      themeMode: theme,
      showLiveWpm: row.showLiveWpm,
      showLiveAccuracy: row.showLiveAccuracy,
      showErrors: row.showErrors,
      autoScroll: row.autoScroll,
      countBackspaces: row.countBackspaces,
      strictSkipDetection: row.strictSkipDetection,
      defaultDurationSeconds: user.preferredTestDurationSeconds,
      defaultLanguage: user.preferredLanguage,
      defaultTestType: prefs.getString('${_prefix}test_type') ?? 'normal',
      autoFocus: prefs.getBool('${_prefix}autofocus') ?? true,
      showTimer: prefs.getBool('${_prefix}show_timer') ?? true,
      allowBackspace: prefs.getBool('${_prefix}allow_backspace') ?? true,
      urduRtl: prefs.getBool('${_prefix}urdu_rtl') ?? true,
      practiceDifficulty: prefs.getString('${_prefix}difficulty') ?? 'beginner',
      dailyGoalSeconds: user.dailyGoalSeconds,
    );
  }

  Future<void> save(AppSettings s) async {
    final userId = await _ensureUser();
    final existing = await (_db.select(_db.settings)..where((x) => x.userId.equals(userId))).get();
    final companion = SettingsCompanion(
      userId: Value(userId), theme: Value(s.themeMode.name), showLiveWpm: Value(s.showLiveWpm), showLiveAccuracy: Value(s.showLiveAccuracy), showErrors: Value(s.showErrors), autoScroll: Value(s.autoScroll), countBackspaces: Value(s.countBackspaces), strictSkipDetection: Value(s.strictSkipDetection), defaultTestDurationSeconds: Value(s.defaultDurationSeconds), defaultLanguage: Value(s.defaultLanguage),
    );
    if (existing.isEmpty) { await _db.into(_db.settings).insert(companion); } else { await (_db.update(_db.settings)..where((x) => x.userId.equals(userId))).write(companion); }
    await (_db.update(_db.users)..where((u) => u.id.equals(userId))).write(UsersCompanion(preferredLanguage: Value(s.defaultLanguage), preferredTestDurationSeconds: Value(s.defaultDurationSeconds), dailyGoalSeconds: Value(s.dailyGoalSeconds), updatedAt: Value(DateTime.now())));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_prefix}theme', s.themeMode.name);
    await prefs.setString('${_prefix}test_type', s.defaultTestType);
    await prefs.remove('${_prefix}countdown'); // legacy pre-test countdown, no longer used
    // Legacy sound preferences (sound feature removed) - drop leftovers.
    await prefs.remove('${_prefix}keypress_volume');
    await prefs.remove('${_prefix}error_sound');
    await prefs.remove('${_prefix}completion_sound');
    await prefs.setBool('${_prefix}autofocus', s.autoFocus);
    await prefs.setBool('${_prefix}show_timer', s.showTimer);
    await prefs.setBool('${_prefix}allow_backspace', s.allowBackspace);
    await prefs.setBool('${_prefix}urdu_rtl', s.urduRtl);
    await prefs.setString('${_prefix}difficulty', s.practiceDifficulty);
  }

  Future<void> clearHistory() async {
    await _db.transaction(() async {
      await _db.delete(_db.mistakes).go();
      await _db.delete(_db.typingTests).go();
    });
  }

  Future<void> resetSettings() async {
    final current = await load();
    await save(current.copyWith(themeMode: ThemeMode.system, showLiveWpm: true, showLiveAccuracy: true, showErrors: true, autoScroll: true, countBackspaces: true, strictSkipDetection: true, defaultDurationSeconds: 120, defaultLanguage: 'en', defaultTestType: 'normal', autoFocus: true, showTimer: true, allowBackspace: true, urduRtl: true, practiceDifficulty: 'beginner', dailyGoalSeconds: 1200));
  }
}
