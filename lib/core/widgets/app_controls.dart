import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';
import 'app_surfaces.dart';

/// Selectable pill used instead of Material's ChoiceChip so every
/// selection control (duration, language, difficulty, filters, time range)
/// looks and behaves the same: a blue tint + blue border + check mark when
/// selected, a neutral surface otherwise, with hover and keyboard-focus
/// highlights. Purely presentational - [onSelected] is the same callback
/// the old ChoiceChip's onSelected called.
class OptionChip extends StatelessWidget {
  const OptionChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color accent = isDark ? AppColors.primaryDark : AppColors.primary;
    final Color foreground = selected ? accent : theme.colorScheme.onSurface;
    final RoundedRectangleBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.controlRadius),
      side: BorderSide(
        color: selected ? accent : theme.dividerColor,
        width: selected ? 1.5 : 1,
      ),
    );

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected
            ? accent.withValues(alpha: isDark ? 0.22 : 0.12)
            : theme.colorScheme.surface,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onSelected,
          hoverColor: accent.withValues(alpha: 0.08),
          focusColor: accent.withValues(alpha: 0.16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  Icon(Icons.check, size: 16, color: foreground),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Rounded, bordered shell for a bare [DropdownButton] so filter dropdowns
/// look like the app's text fields instead of a naked Flutter control.
class FilterShell extends StatelessWidget {
  const FilterShell({super.key, required this.child});

  /// A [DropdownButton] (its own underline is hidden).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.controlRadius),
        border: Border.all(color: theme.dividerColor),
      ),
      child: DropdownButtonHideUnderline(child: child),
    );
  }
}

/// A [SoftSurface] with a consistent title row (title, optional muted
/// subtitle, optional trailing widget) above its content.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SoftSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.h3),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: AppTextStyles.captionOf(context)),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppDimensions.gapMedium),
                trailing!,
              ],
            ],
          ),
          const SizedBox(height: AppDimensions.gapMedium),
          child,
        ],
      ),
    );
  }
}

/// Standard small statistic tile (label, value, optional caption). Replaces
/// the per-screen private `_StatCard` / `_CountCard` copies. Set [wrapValue]
/// for longer text values that should wrap instead of being scaled down.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.caption,
    this.width = 170,
    this.wrapValue = false,
  });

  final String label;
  final String value;
  final String? caption;
  final double? width;
  final bool wrapValue;

  @override
  Widget build(BuildContext context) {
    final Widget valueText = wrapValue
        ? Text(
            value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium,
          )
        : FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, maxLines: 1, style: AppTextStyles.h2),
          );

    return SizedBox(
      width: width,
      child: SoftSurface(
        radius: 14,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.captionOf(context),
            ),
            const SizedBox(height: 6),
            valueText,
            if (caption != null) ...[
              const SizedBox(height: 2),
              Text(
                caption!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.captionOf(context),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Small rounded label (level, language, category, "Built-in"...).
class TagBadge extends StatelessWidget {
  const TagBadge({super.key, required this.text, this.color});

  final String text;

  /// Optional accent; defaults to a neutral tint of the divider colour.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color base = color ?? theme.dividerColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: base.withValues(alpha: color == null ? 0.35 : 0.14),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.captionOf(context).copyWith(
          color: color ?? theme.textTheme.bodySmall?.color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
