import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'core/constants/app_fonts.dart';
import 'core/database/app_database.dart';
import 'core/database/database_recovery.dart';
import 'core/routes/app_pages.dart';
import 'core/services/data_refresh_service.dart';
import 'core/services/db_change_broadcast.dart';
import 'core/services/theme_service.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/controller/settings_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Warm the Urdu font at app start (UNawaited — never blocks the first
  // frame): without this the 675 KB Noto Nastaliq Urdu file is only
  // fetched when the first Urdu screen paints, and on a slow connection
  // the passage renders blank/tofu for minutes while it downloads.
  // The <link rel="preload"> in web/index.html starts the same download
  // even earlier; this is the belt-and-braces copy for when preload is
  // ignored. A failure here is swallowed — the font still loads on
  // first Urdu paint, exactly as before.
  unawaited(_warmUrduFont());

  // Core services are put here (once, app-wide) rather than lazily per

  // Core services are put here (once, app-wide) rather than lazily per
  // feature, since almost every controller will eventually need the
  // database, and theme must be ready before the first frame.
  Get.put<AppDatabase>(AppDatabase());
  await Get.putAsync<ThemeService>(() => ThemeService().init());

  // App-wide, permanent: the stats-changed signal and the settings.
  // Typing controllers, Dashboard and Settings all share these instances.
  Get.put<DataRefreshService>(DataRefreshService(), permanent: true);

  // Cross-tab database changes (Fix 1): on web each tab holds its own
  // private in-memory snapshot of the SQLite file, so a test saved in
  // another tab is invisible here until this tab re-opens the
  // database. When a message arrives, abandon this tab's stale
  // instance for a fresh one and reload the controllers from it.
  // No-op on non-web platforms (see DbChangeBroadcast).
  DbChangeBroadcast.listen(() {
    DatabaseRecovery().handleExternalChange();
  });

  // Settings are loaded from SQLite (Drift/WASM: worker + OPFS/IndexedDB
  // on web), which can take seconds on a cold load. Do NOT await that
  // before runApp: awaiting it here could leave the page fully blank
  // with no loading state for as long as the database took to open.
  // Register the
  // controller synchronously and load in the background instead;
  // WolfTypingApp shows a loading overlay until settings arrive, and
  // every caller already copes with absent settings via
  // SettingsController.currentOrNull (built-in defaults). If the load
  // fails or never finishes, the app still opens (see the boot timeout
  // in WolfTypingApp) and settings populate if/when the load completes.
  final SettingsController settingsController = SettingsController();
  Get.put<SettingsController>(settingsController, permanent: true);
  unawaited(settingsController.init());

  runApp(const WolfTypingApp());
}

/// Loads Noto Nastaliq Urdu into the font engine before any Urdu screen
/// paints, so the first Urdu passage does not wait on a fresh download.
/// Fire-and-forget by design (see main): never awaited, never throws.
Future<void> _warmUrduFont() async {
  try {
    final FontLoader loader = FontLoader(AppFonts.urdu)
      ..addFont(rootBundle.load('assets/fonts/NotoNastaliqUrdu.ttf'));
    await loader.load();
  } catch (_) {
    // Font still loads on first Urdu paint, as before.
  }
}

class WolfTypingApp extends StatefulWidget {
  const WolfTypingApp({super.key});

  @override
  State<WolfTypingApp> createState() => _WolfTypingAppState();
}

class _WolfTypingAppState extends State<WolfTypingApp> {
  /// Releases the loading overlay if the settings/database load has not
  /// finished within this long, so a hung database open can never leave
  /// the app blank forever. The load keeps running in the background.
  static const Duration _bootTimeout = Duration(seconds: 10);

  bool _bootTimedOut = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(_bootTimeout, () {
      if (!mounted) return;
      setState(() => _bootTimedOut = true);
      // P0-5: if settings still haven't loaded, the database open is
      // probably hung (slow WASM fetch on a slow connection). One bounded
      // background recovery attempt: probe, replace the stuck instance if
      // needed, reload settings. Unawaited — the overlay is already
      // released and the app stays usable either way.
      if (Get.find<SettingsController>().loading.value) {
        unawaited(DatabaseRecovery().ensureHealthy());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Get.find<ThemeService>();

    // FIX (deep links): the Router mounts on the very first frame.
    // An earlier plain-MaterialApp loading screen let its Navigator
    // rewrite the browser URL (its topmost route is '/'), which
    // destroyed cold-start deep links before the Router ever saw them.
    // The loading state is now an overlay inside the router app, so
    // the URL the Router parses is the one the user opened.
    return Obx(() {
      return GetMaterialApp(
        title: 'WolfTyping',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeService.themeMode.value,
        getPages: AppPages.pages,
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 150),
        builder: (BuildContext context, Widget? child) {
          return Stack(
            children: <Widget>[
              child ?? const SizedBox.shrink(),
              // Loading overlay while settings load (released by the
              // 10-second boot timeout if the database never answers).
              Obx(() {
                final SettingsController settings =
                    Get.find<SettingsController>();
                final bool stillLoading =
                    settings.loading.value && !_bootTimedOut;
                if (!stillLoading) return const SizedBox.shrink();
                return const Scaffold(
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
                );
              }),
            ],
          );
        },
      );
    });
  }
}
