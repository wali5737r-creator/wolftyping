import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_text_styles.dart';

/// Very soft neumorphic shadow pair (one darker, one lighter) shared by
/// every raised surface. Kept deliberately subtle: low alpha, small blur.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> raised(bool isDark) => <BoxShadow>[
        BoxShadow(
          color: (isDark
                  ? AppColors.darkShadowDark
                  : AppColors.lightShadowDark)
              .withValues(alpha: isDark ? 0.55 : 0.35),
          blurRadius: 10,
          offset: const Offset(3, 3),
        ),
        BoxShadow(
          color: (isDark
                  ? AppColors.darkShadowHighlight
                  : AppColors.lightShadowHighlight)
              .withValues(alpha: isDark ? 0.45 : 0.85),
          blurRadius: 10,
          offset: const Offset(-3, -3),
        ),
      ];

  /// Slightly deeper pair, used only by [ClayCard].
  static List<BoxShadow> clay(bool isDark) => <BoxShadow>[
        BoxShadow(
          color: (isDark
                  ? AppColors.darkShadowDark
                  : AppColors.lightShadowDark)
              .withValues(alpha: isDark ? 0.60 : 0.45),
          blurRadius: 16,
          offset: const Offset(5, 6),
        ),
        BoxShadow(
          color: (isDark
                  ? AppColors.darkShadowHighlight
                  : AppColors.lightShadowHighlight)
              .withValues(alpha: isDark ? 0.50 : 0.95),
          blurRadius: 14,
          offset: const Offset(-4, -4),
        ),
      ];
}

/// The app's standard card: theme surface colour, thin border, soft
/// neumorphic shadow. Use [raised] = false for flat, in-card sub-tiles.
class SoftSurface extends StatelessWidget {
  const SoftSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppDimensions.cardPadding),
    this.margin,
    this.radius = AppDimensions.cardRadius,
    this.color,
    this.raised = true,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final Color? color;
  final bool raised;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final BorderRadius borderRadius = BorderRadius.circular(radius);

    Widget content = Padding(padding: padding, child: child);
    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: content,
        ),
      );
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? theme.colorScheme.surface,
        borderRadius: borderRadius,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.7)),
        boxShadow: raised ? AppShadows.raised(isDark) : null,
      ),
      child: content,
    );
  }
}

/// Clay-style statistic card - used ONLY for the Dashboard's main stats.
/// Larger radius, a soft tint of [accent], a faint highlight edge and a
/// slightly deeper shadow pair than [SoftSurface]. No saturated fills.
class ClayCard extends StatelessWidget {
  const ClayCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.accent,
    this.caption,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accent;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color muted =
        theme.textTheme.bodySmall?.color ?? AppColors.lightTextSecondary;
    final Color tint = Color.alphaBlend(
      accent.withValues(alpha: isDark ? 0.14 : 0.09),
      theme.colorScheme.surface,
    );
    final Color topLeft = Color.alphaBlend(
      Colors.white.withValues(alpha: isDark ? 0.04 : 0.45),
      tint,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[topLeft, tint],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.clayRadius),
        border: Border.all(
          color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.7),
        ),
        boxShadow: AppShadows.clay(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: isDark ? 0.22 : 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 13,
                    color: muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: AppTextStyles.statValue.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          if (caption != null) ...[
            const SizedBox(height: 4),
            Text(
              caption!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.captionOf(context),
            ),
          ],
        ],
      ),
    );
  }
}

/// Compact label/value tile for live typing stats and result summaries.
class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.dense = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return SoftSurface(
      radius: 12,
      raised: !dense,
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 12 : 16,
        vertical: dense ? 8 : 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.captionOf(context)),
          SizedBox(height: dense ? 2 : 4),
          Text(
            value,
            style: (dense ? AppTextStyles.bodyMedium : AppTextStyles.h3)
                .copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}

/// Standard page title block: title, optional muted subtitle, optional
/// trailing widget (usually the primary action button).
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.h1),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: AppTextStyles.body.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppDimensions.gapMedium),
          trailing!,
        ],
      ],
    );
  }
}

/// Professional empty state: soft icon badge, title, muted message and an
/// optional row of actions. Same look on every screen.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actions,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    final Color muted =
        Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SoftSurface(
              radius: 28,
              padding: const EdgeInsets.all(20),
              child: Icon(icon, size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(title, style: AppTextStyles.h2, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.body.copyWith(color: muted),
              textAlign: TextAlign.center,
            ),
            if (actions != null) ...[
              const SizedBox(height: 24),
              actions!,
            ],
          ],
        ),
      ),
    );
  }
}
