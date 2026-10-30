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

    return Container(
      width: collapsed
          ? AppDimensions.sidebarCollapsedWidth
          : AppDimensions.sidebarWidth,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSidebar : AppColors.lightSidebar,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark
                    ? AppColors.darkShadowDark
                    : AppColors.lightShadowDark)
                .withValues(alpha: isDark ? 0.5 : 0.25),
            blurRadius: 14,
            offset: const Offset(3, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Brand(collapsed: collapsed),
          const Divider(height: 1),
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
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.keyboard, color: Colors.white, size: 20),
          ),
          if (!collapsed) ...[
            const SizedBox(width: 12),
            const Flexible(
              child: Text(
                'WolfTyping',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
    // Lighter blue on dark so the selected label keeps its contrast.
    final Color accent = isDark ? AppColors.primaryDark : AppColors.primary;
    final Color baseText = theme.colorScheme.onSurface;
    final Color inactive = theme.textTheme.bodySmall?.color ?? baseText;
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
