import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class SidebarItem {
  const SidebarItem({
    required this.route,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String route;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// Single source of truth for sidebar ordering/labels/icons, matching the
/// Main Navigation list in the spec.
const List<SidebarItem> kSidebarItems = [
  SidebarItem(
    route: AppRoutes.dashboard,
    label: 'Dashboard',
    icon: Icons.space_dashboard_outlined,
    selectedIcon: Icons.space_dashboard,
  ),
  SidebarItem(
    route: AppRoutes.typingTest,
    label: 'Typing Test',
    icon: Icons.keyboard_alt_outlined,
    selectedIcon: Icons.keyboard_alt,
  ),
  SidebarItem(
    route: AppRoutes.urduTypingTest,
    label: 'Urdu Typing Test',
    icon: Icons.language_outlined,
    selectedIcon: Icons.language,
  ),
  SidebarItem(
    route: AppRoutes.lessons,
    label: 'Lessons',
    icon: Icons.school_outlined,
    selectedIcon: Icons.school,
  ),
  SidebarItem(
    route: AppRoutes.practice,
    label: 'Practice',
    icon: Icons.fitness_center_outlined,
    selectedIcon: Icons.fitness_center,
  ),
  SidebarItem(
    route: AppRoutes.ppscUrdu,
    label: 'PPSC Urdu',
    icon: Icons.badge_outlined,
    selectedIcon: Icons.badge,
  ),
  SidebarItem(
    route: AppRoutes.ppscMockTest,
    label: 'PPSC Mock Test',
    icon: Icons.quiz_outlined,
    selectedIcon: Icons.quiz,
  ),
  SidebarItem(
    route: AppRoutes.myParagraphs,
    label: 'My Paragraphs',
    icon: Icons.article_outlined,
    selectedIcon: Icons.article,
  ),
  SidebarItem(
    route: AppRoutes.history,
    label: 'History',
    icon: Icons.history_outlined,
    selectedIcon: Icons.history,
  ),
  SidebarItem(
    route: AppRoutes.progress,
    label: 'Progress',
    icon: Icons.show_chart_outlined,
    selectedIcon: Icons.show_chart,
  ),
  SidebarItem(
    route: AppRoutes.profile,
    label: 'Profile',
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
  ),
  SidebarItem(
    route: AppRoutes.settings,
    label: 'Settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  ),
];
