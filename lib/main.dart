import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/database/app_database.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/initial_route.dart';
import 'core/services/data_refresh_service.dart';
import 'core/services/theme_service.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/controller/settings_controller.dart';

// TEMPORARY DIAGNOSTIC (remove before merge): frozen at the very start of
// main(), before anything in the app can rewrite the URL.
String _startupFragment = '';
String _startupDefaultRoute = '';
// TEMPORARY DIAGNOSTIC (remove before merge): frozen snapshots of the URL
// fragment at each boot stage, so the banner shows WHEN it changes.
String _loadFrag = '';
String _routerFrag = '';
// FIX (Option C): the first route, frozen in main() before the loading
// screen's plain-MaterialApp Navigator can strip the URL hash. Fed to the
// Router as its initial route information, so a cold-start deep link
// survives boot. Validated (known route or dashboard fallback).
String _frozenInitialLocation = '/dashboard';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TEMPORARY DIAGNOSTIC (remove before merge): cold-start deep links
  // still land on the dashboard on the preview, so log what the app
  // actually sees at startup.
  _startupFragment = Uri.base.fragment;
  _startupDefaultRoute =
      WidgetsBinding.instance.platformDispatcher.defaultRouteName;
  // FIX (Option C): freeze the deep link now — see _frozenInitialLocation.
  _frozenInitialLocation = resolveInitialRoute(Uri.base.fragment);
  debugPrint(
      'WOLFDIAG main uri.base=${Uri.base} fragment=${Uri.base.fragment}');

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

  // TEMPORARY DIAGNOSTIC (remove before merge): shown on screen because
  // the test browser cannot open DevTools to read console logs.
  String _diagRoute3s = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(_bootTimeout, () {
      if (mounted) setState(() => _bootTimedOut = true);
    });
    // TEMPORARY DIAGNOSTIC (remove before merge).
    Future.delayed(const Duration(seconds: 3), () {
      try {
        debugPrint('WOLFDIAG after3s currentRoute=${Get.currentRoute}');
        if (mounted) {
          setState(() => _diagRoute3s = Get.currentRoute);
        }
      } catch (e) {
        debugPrint('WOLFDIAG after3s currentRoute error: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeService themeService = Get.find<ThemeService>();

    return Obx(() {
      final SettingsController settings = Get.find<SettingsController>();
      final bool stillLoading = settings.loading.value && !_bootTimedOut;
      if (stillLoading) {
        // TEMPORARY DIAGNOSTIC (remove before merge): freeze the fragment
        // seen while the loading screen is up.
        if (_loadFrag.isEmpty) {
          _loadFrag = Uri.base.fragment;
        }
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
      // TEMPORARY DIAGNOSTIC (remove before merge): freeze the fragment
      // seen the first time the router app is built.
      if (_routerFrag.isEmpty) {
        _routerFrag = Uri.base.fragment;
      }
      debugPrint(
          'WOLFDIAG build fragment=${Uri.base.fragment} resolved=${resolveInitialRoute(Uri.base.fragment)}');
      final String diag =
          'WOLFDIAG start=$_startupFragment defroute=$_startupDefaultRoute loadFrag=$_loadFrag routerFrag=$_routerFrag route3s=$_diagRoute3s';
      return GetMaterialApp(
        title: 'WolfTyping',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeService.themeMode.value,
        // Cold-start deep links: GetX drops the URL hash unless the
        // initial route carries it, so resolve it from Uri.base.fragment
        // (dashboard fallback for empty/unknown fragments).
        initialRoute: resolveInitialRoute(Uri.base.fragment),
        // FIX (Option C): the Router's initial route information comes
        // from the location frozen in main(), not from the live URL —
        // the loading screen's Navigator rewrites the live URL before
        // the Router mounts, so reading it here would be too late.
        routeInformationProvider: PlatformRouteInformationProvider(
          initialRouteInformation: RouteInformation(
            uri: Uri.parse(_frozenInitialLocation),
          ),
        ),
        getPages: AppPages.pages,
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 150),
        // TEMPORARY DIAGNOSTIC (remove before merge): yellow banner with
        // the startup values, readable on screen without DevTools.
        builder: (BuildContext context, Widget? child) {
          return Stack(
            children: <Widget>[
              child ?? const SizedBox.shrink(),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.yellow,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Text(
                    diag,
                    style: const TextStyle(fontSize: 11, color: Colors.black),
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
