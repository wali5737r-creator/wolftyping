import '../../features/settings/controller/settings_controller.dart';
import 'app_routes.dart';

/// Where "Typing Test" should take the user, based on Settings > Default
/// language and Default test type: English -> English test; Urdu -> Urdu
/// test, or PPSC Urdu when the default test type is PPSC.
String defaultTypingRoute() {
  final settings = SettingsController.currentOrNull;
  if (settings != null && settings.defaultLanguage == 'ur') {
    return settings.defaultTestType == 'ppsc'
        ? AppRoutes.ppscUrdu
        : AppRoutes.urduTypingTest;
  }
  return AppRoutes.typingTest;
}
