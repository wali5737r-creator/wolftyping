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

  // App-wide, permanent: the stats-changed signal and the settings
  // (loaded from SQLite before the first frame). Typing controllers,
  // Dashboard and Settings all share these instances.
  Get.put<DataRefreshService>(DataRefreshService(), permanent: true);
  await Get.putAsync<SettingsController>(
    () => SettingsController().init(),
    permanent: true,
  );

  runApp(const TypingMasterApp());
}

class TypingMasterApp extends StatelessWidget {
  const TypingMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Get.find<ThemeService>();

    return Obx(
      () => GetMaterialApp(
        title: 'Typing Master',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeService.themeMode.value,
        initialRoute: AppRoutes.dashboard,
        getPages: AppPages.pages,
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 150),
      ),
    );
  }
}
