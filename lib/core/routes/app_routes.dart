/// Route name constants. Keep these in sync with the sidebar items in
/// AppSidebar and the GetPage list in app_pages.dart.
abstract class AppRoutes {
  AppRoutes._();

  static const String dashboard = '/dashboard';
  static const String typingTest = '/typing-test';
  static const String urduTypingTest = '/urdu-typing-test';
  static const String lessons = '/lessons';
  static const String lessonPractice = '/lesson-practice';
  static const String practice = '/practice';
  static const String mistakePractice = '/mistake-practice';
  static const String mistakeAnalysis = '/mistake-analysis';
  static const String keyboardHeatmap = '/keyboard-heatmap';
  static const String ppscUrdu = '/ppsc-urdu';
  static const String ppscMockTest = '/ppsc-mock-test';
  static const String ppscPastPapers = '/ppsc-past-papers';
  static const String ppscCustomTests = '/ppsc-custom-tests';
  static const String ppscCustomTestEditor = '/ppsc-custom-test-editor';
  static const String myParagraphs = '/my-paragraphs';
  static const String paragraphForm = '/paragraph-form';
  static const String paragraphPreview = '/paragraph-preview';
  static const String history = '/history';
  static const String historyDetail = '/history-detail';
  static const String progress = '/progress';
  static const String profile = '/profile';
  static const String settings = '/settings';
}
