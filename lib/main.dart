import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/database/app_database.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/services/data_refresh_service.dart';
import 'core/services/theme_service.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/controller/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Core services are put here (once, app-wide) rather than lazily per
  // feature, since almost every controller will eventually need the
  // database, and theme must be ready before the first frame.
  Get.put<AppDatabase>(AppDatabase());
  await Get.putAsync<ThemeService>(() => ThemeService().init());

  // App-wide, permanent: the stats-changed signal and the settings.
  // Typing controllers, Dashboard and Settings all share these instances.
  Get.put<DataRefreshService>(DataRefreshService(), permanent: true);

  // Settings are loaded from SQLite (Drift/WASM: worker + OPFS/IndexedDB
  // on web), which can take seconds on a cold load. Do NOT await that
  // before runApp: awaiting it here could leave the page fully blank
  // with no loading state for as long as the database took to open.
  // Register the
  // controller synchronously and load in the background instead;
  // WolfTypingApp shows a loading screen until settings arrive, and
  // every caller already copes with absent settings via
  // SettingsController.currentOrNull (built-in defaults). If the load
  // fails or never finishes, the app still opens (see the boot timeout
  // in WolfTypingApp) and settings populate if/when the load completes.
  final SettingsController settingsController = SettingsController();
  Get.put<SettingsController>(settingsController, permanent: true);
  unawaited(settingsController.init());

  runApp(const WolfTypingApp());
}

class WolfTypingApp extends StatefulWidget {
  const WolfTypingApp({super.key});

  @override
  State<WolfTypingApp> createState() => _WolfTypingAppState();
}

class _WolfTypingAppState extends State<WolfTypingApp> {
  /// Releases the loading screen if the settings/database load has not
  /// finished within this long, so a hung database open can never leave
  /// the app blank forever. The load keeps running in the background.
  static const Duration _bootTimeout = Duration(seconds: 10);

  bool _bootTimedOut = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(_bootTimeout, () {
      if (mounted) setState(() => _bootTimedOut = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Get.find<ThemeService>();

    return Obx(() {
      final SettingsController settings = Get.find<SettingsController>();
      final bool stillLoading = settings.loading.value && !_bootTimedOut;
      if (stillLoading) {
        return MaterialApp(
          title: 'WolfTyping',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeService.themeMode.value,
          home: const Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading WolfTyping…'),
                ],
              ),
            ),
          ),
        );
      }
      return GetMaterialApp(
        title: 'WolfTyping',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeService.themeMode.value,
        initialRoute: AppRoutes.dashboard,
        getPages: AppPages.pages,
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 150),
      );
    });
  }
}
