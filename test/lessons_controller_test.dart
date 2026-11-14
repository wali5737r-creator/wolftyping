import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:typing_master/core/database/app_database.dart';
import 'package:typing_master/features/lessons/controller/lessons_controller.dart';
import 'package:typing_master/features/typing_test/model/typing_language.dart';

/// DEFECT 2 (Muhammad, 2026-11-14): with "Urdu Lessons" selected,
/// Lesson 1 still opened with English content. One root cause is a
/// load race in [LessonsController]: tapping a language tab starts a
/// load, and the initial load may still be in flight (first open seeds
/// the lessons into the database, which is slow) — the load that
/// finished LAST used to win, so switching to Urdu before the English
/// load finished could leave the English list under the Urdu tab. A
/// load-generation guard now makes only the newest load write the
/// list, so the outcome is deterministic: the grid always shows the
/// selected language's lessons.
///
/// Runs against a REAL AppDatabase on the VM (the path_provider
/// channel is mocked to a temp dir, same pattern as
/// db_change_broadcast_test.dart) — plain test, so real async runs
/// normally.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late AppDatabase db;

  setUp(() async {
    Get.testMode = true;
    Get.reset();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    SharedPreferences.setMockInitialValues(<String, Object>{});

    tempDir = await Directory.systemTemp.createTemp('wolftyping-lang-load');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall call) async {
        if (call.method == 'getApplicationSupportDirectory') {
          return tempDir.path;
        }
        return null;
      },
    );

    db = AppDatabase();
    Get.put<AppDatabase>(db);
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      null,
    );
    if (Get.isRegistered<AppDatabase>()) {
      try {
        await Get.find<AppDatabase>().close();
      } catch (_) {
        // Already closed by the test under run.
      }
    }
    Get.reset();
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  Future<void> waitForLoad(LessonsController controller) async {
    for (int i = 0; i < 300; i++) {
      if (!controller.isLoading.value && controller.lessons.isNotEmpty) {
        return;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
    fail('Timed out waiting for lessons to load');
  }

  test('switching to Urdu mid-load leaves Urdu lessons, never English',
      () async {
    final LessonsController controller = LessonsController();
    controller.onInit();
    // Switch tabs immediately — before the initial English load (fresh
    // seed) has finished.
    controller.selectLanguage(TypingLanguage.urdu);
    await waitForLoad(controller);

    expect(controller.selectedLanguage.value, TypingLanguage.urdu);
    expect(controller.lessons, isNotEmpty);
    expect(
      controller.lessons.first.definition.language,
      TypingLanguage.urdu,
      reason: 'the grid must show the selected language even when the '
          'previous language load was still in flight',
    );
    expect(controller.lessons.first.definition.content, contains('فف'));
  });

  test('switching back to English mid-load leaves English lessons',
      () async {
    final LessonsController controller = LessonsController();
    controller.onInit();
    await waitForLoad(controller);
    expect(controller.lessons.first.definition.language,
        TypingLanguage.english);

    controller.selectLanguage(TypingLanguage.urdu);
    controller.selectLanguage(TypingLanguage.english);
    await waitForLoad(controller);

    expect(controller.selectedLanguage.value, TypingLanguage.english);
    expect(controller.lessons.first.definition.language,
        TypingLanguage.english);
    expect(controller.lessons.first.definition.content, contains('ff'));
  });
}
