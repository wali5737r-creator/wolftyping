import 'app_routes.dart';

/// The route paths the app can open, mirroring [AppRoutes].
/// Used only to validate a cold-start deep link before trusting it.
const Set<String> _knownRoutes = <String>{
  AppRoutes.dashboard,
  AppRoutes.typingTest,
  AppRoutes.urduTypingTest,
  AppRoutes.lessons,
  AppRoutes.lessonPractice,
  AppRoutes.practice,
  AppRoutes.mistakePractice,
  AppRoutes.mistakeAnalysis,
  AppRoutes.keyboardHeatmap,
  AppRoutes.ppscUrdu,
  AppRoutes.ppscMockTest,
  AppRoutes.ppscPastPapers,
  AppRoutes.ppscPastPapersYear,
  AppRoutes.ppscCustomTests,
  AppRoutes.ppscCustomTestEditor,
  AppRoutes.myParagraphs,
  AppRoutes.paragraphForm,
  AppRoutes.paragraphPreview,
  AppRoutes.history,
  AppRoutes.historyDetail,
  AppRoutes.progress,
  AppRoutes.profile,
  AppRoutes.settings,
  AppRoutes.feedback,
  AppRoutes.about,
};

/// Resolves the app's first route from the browser URL's hash fragment.
///
/// GetX ignores the URL hash on a cold start unless initialRoute carries
/// it: the original `initialRoute: AppRoutes.dashboard` always opened
/// the dashboard, and removing initialRoute entirely (Option A) still
/// booted to '/' and dropped the hash. So main.dart feeds the fragment
/// back in as the initial route. The full fragment is returned,
/// including any query string, so Get.parameters keeps working
/// (e.g. `?year=2025` on the year route). Empty, unknown, or malformed
/// fragments fall back to the dashboard and never invent a route.
String resolveInitialRoute(String fragment) {
  if (fragment.isEmpty) return AppRoutes.dashboard;
  final Uri? uri = Uri.tryParse(fragment);
  if (uri == null) return AppRoutes.dashboard;
  var path = uri.path;
  if (!path.startsWith('/')) path = '/$path';
  if (path.length > 1 && path.endsWith('/')) {
    path = path.substring(0, path.length - 1);
  }
  if (!_knownRoutes.contains(path)) return AppRoutes.dashboard;
  return uri.hasQuery ? '$path?${uri.query}' : path;
}
