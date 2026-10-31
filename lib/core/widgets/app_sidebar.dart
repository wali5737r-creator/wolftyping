import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../routes/app_routes.dart';
import '../routes/default_typing_route.dart';
import 'sidebar_item.dart';

/// Persistent left sidebar for the desktop shell.
///
/// Auto-collapses to icon-only below [AppDimensions.collapseSidebarBreakpoint]
/// so the layout still works on smaller laptop screens (spec section 59).
class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key, required this.currentRoute});

  /// The route of the page that is hosting this sidebar (each page passes
  /// its own route name in — see AppScaffold). Passed explicitly rather
  /// than read from Get.currentRoute since that getter isn't reactive.
  final String currentRoute;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final double width = MediaQuery.of(context).size.width;
    final bool collapsed = width < AppDimensions.collapseSidebarBreakpoint;

    // The sidebar is dark teal in BOTH themes (report gradients), so its
    // text/divider colors come from the sidebar tokens, not the theme.
    final Color sidebarSecondary =
        isDark ? AppColors.darkSidebarSecondary : AppColors.lightSidebarSecondary;
    return Container(
      width: collapsed
          ? AppDimensions.sidebarCollapsedWidth
          : AppDimensions.sidebarWidth,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            isDark
                ? AppColors.darkSidebarGradientStart
                : AppColors.lightSidebarGradientStart,
            isDark
                ? AppColors.darkSidebarGradientEnd
                : AppColors.lightSidebarGradientEnd,
          ],
        ),
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        // Light: soft side shadow. Dark: depth is tonal — no drop shadow.
        boxShadow: isDark
            ? null
            : <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(3, 0),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Brand(collapsed: collapsed),
          Divider(
            height: 1,
            color: sidebarSecondary.withValues(alpha: 0.25),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 14),
              children: [
                for (final SidebarItem item in kSidebarItems)
                  _SidebarTile(
                    item: item,
                    collapsed: collapsed,
                    selected: item.route == currentRoute,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.collapsed});

  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: collapsed ? 0 : 20,
        vertical: 22,
      ),
      child: Row(
        mainAxisAlignment:
            collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Image.asset(
                'assets/images/logo.png',
                width: 36,
                height: 36,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (!collapsed) ...[
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                'WolfTyping',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkSidebarText
                      : AppColors.lightSidebarText,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({
    required this.item,
    required this.collapsed,
    required this.selected,
  });

  final SidebarItem item;
  final bool collapsed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    // Sidebar is dark in both themes: selected labels use the bright
    // sidebar accent, unselected labels use the sidebar text tokens.
    final Color accent =
        isDark ? AppColors.darkSidebarAccent : AppColors.lightSidebarAccent;
    final Color baseText =
        isDark ? AppColors.darkSidebarText : AppColors.lightSidebarText;
    final Color inactive = isDark
        ? AppColors.darkSidebarSecondary
        : AppColors.lightSidebarSecondary;
    final Color textColor = selected ? accent : inactive;
    final BorderRadius radius = BorderRadius.circular(12);

    final Widget tile = Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: selected ? accent.withValues(alpha: isDark ? 0.16 : 0.10) : null,
        borderRadius: radius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          hoverColor: baseText.withValues(alpha: 0.05),
          onTap: () {
            if (selected) return;
            // "Typing Test" opens the user's default language / test type.
            Get.offNamed(item.route == AppRoutes.typingTest
                ? defaultTypingRoute()
                : item.route);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: collapsed ? 0 : 14,
              vertical: 12,
            ),
            child: Row(
              mainAxisAlignment: collapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Icon(
                  selected ? item.selectedIcon : item.icon,
                  size: 20,
                  color: textColor,
                ),
                if (!collapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selected ? accent : baseText,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                  if (selected)
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    return collapsed ? Tooltip(message: item.label, child: tile) : tile;
  }
}
