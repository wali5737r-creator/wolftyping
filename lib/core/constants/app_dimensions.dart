/// Layout constants for the responsive desktop shell.
///
/// Target resolutions per spec: 1366x768, 1920x1080, 2560x1440, and smaller
/// laptop screens. The sidebar has a fixed width; the content area is
/// flexible and the typing area always gets the largest share of space.
class AppDimensions {
  AppDimensions._();

  static const double sidebarWidth = 240;
  static const double sidebarCollapsedWidth = 76;

  /// Below this width the sidebar auto-collapses to icons only.
  static const double collapseSidebarBreakpoint = 1100;

  /// Minimum supported window width (set on the Windows app window).
  static const double minWindowWidth = 1024;
  static const double minWindowHeight = 700;

  static const double pagePadding = 24;
  static const double cardRadius = 16;
  static const double clayRadius = 22;
  static const double controlRadius = 12;
  static const double cardPadding = 20;
  static const double gapSmall = 8;
  static const double gapMedium = 16;
  static const double gapLarge = 24;
}
