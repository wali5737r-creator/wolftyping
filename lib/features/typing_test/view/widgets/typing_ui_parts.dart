import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_surfaces.dart';

/// Presentation-only building blocks shared by the English, Urdu and PPSC
/// live typing screens and their result screens. Nothing here reads a
/// controller or touches typing logic - values are passed in.

/// Caps the live typing screen width so a line of text stays readable on
/// very wide monitors, and keeps it centred.
class TypingScreenFrame extends StatelessWidget {
  const TypingScreenFrame({super.key, required this.child});

  final Widget child;

  static const double maxWidth = 1200;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// The bordered typing area. The border turns blue while the typing area
/// has keyboard focus and a short hint appears when it does not, so it is
/// always obvious whether keystrokes will be captured. No animation.
class TypingAreaFrame extends StatelessWidget {
  const TypingAreaFrame({
    super.key,
    required this.focusNode,
    required this.child,
  });

  final FocusNode focusNode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color accent = isDark ? AppColors.primaryDark : AppColors.primary;

    return ListenableBuilder(
      listenable: focusNode,
      child: child,
      builder: (BuildContext context, Widget? typingArea) {
        final bool focused = focusNode.hasFocus;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            border: Border.all(
              color: focused ? accent : theme.dividerColor,
              width: focused ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: typingArea!),
              if (!focused)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Click here to continue typing',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.captionOf(context),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// One figure in the live stats header.
class LiveStat {
  const LiveStat({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;
}

/// Clean stats row (time, WPM, accuracy, mistakes, progress) with a slim
/// progress bar, plus the existing paused / waiting notices.
class LiveStatsHeader extends StatelessWidget {
  const LiveStatsHeader({
    super.key,
    required this.stats,
    required this.progressPercent,
    required this.paused,
    required this.waitingForFirstKey,
  });

  final List<LiveStat> stats;
  final double progressPercent;
  final bool paused;
  final bool waitingForFirstKey;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color muted = theme.textTheme.bodySmall?.color ?? Colors.grey;

    return SoftSurface(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              for (final LiveStat s in stats)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.label.toUpperCase(),
                        style: AppTextStyles.statLabel.copyWith(color: muted),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s.value,
                        style: AppTextStyles.h2.copyWith(
                          color: s.highlight ? AppColors.warning : null,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (progressPercent / 100).clamp(0, 1).toDouble(),
              minHeight: 6,
              backgroundColor: theme.dividerColor.withValues(alpha: 0.7),
            ),
          ),
          if (paused) ...[
            const SizedBox(height: 10),
            const Text(
              'PAUSED — typing is disabled until you resume.',
              style: TextStyle(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (waitingForFirstKey) ...[
            const SizedBox(height: 10),
            const Text(
              'Start typing to begin the timer',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }
}

/// Quiet one-block summary of the secondary live numbers (gross WPM,
/// word counts, backspaces...). Replaces a grid of eight separate cards
/// so it does not compete with the typing text for attention.
class CompactStatsStrip extends StatelessWidget {
  const CompactStatsStrip({super.key, required this.entries});

  final List<MapEntry<String, String>> entries;

  @override
  Widget build(BuildContext context) {
    return SoftSurface(
      raised: false,
      radius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Wrap(
        spacing: 28,
        runSpacing: 8,
        children: [
          for (final MapEntry<String, String> e in entries)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(e.key, style: AppTextStyles.captionOf(context)),
                const SizedBox(width: 8),
                Text(e.value, style: AppTextStyles.bodyMedium),
              ],
            ),
        ],
      ),
    );
  }
}

/// Result layout shared by the English and Urdu/PPSC result screens:
/// two large headline figures (Net WPM, Accuracy) followed by the detail
/// figures as a tidy grid of tiles. Values are passed in already formatted.
class ResultSummaryBlock extends StatelessWidget {
  const ResultSummaryBlock({
    super.key,
    required this.netWpm,
    required this.accuracy,
    required this.details,
  });

  final String netWpm;
  final String accuracy;
  final List<MapEntry<String, String>> details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _Headline(
                label: 'Net WPM',
                value: netWpm,
                color: AppColors.clayBlue,
              ),
            ),
            const SizedBox(width: AppDimensions.gapMedium),
            Expanded(
              child: _Headline(
                label: 'Accuracy',
                value: accuracy,
                color: AppColors.clayTeal,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.gapLarge),
        Wrap(
          spacing: AppDimensions.gapMedium,
          runSpacing: AppDimensions.gapMedium,
          children: [
            for (final MapEntry<String, String> e in details)
              SizedBox(
                width: 160,
                child: MetricTile(label: e.key, value: e.value),
              ),
          ],
        ),
      ],
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SoftSurface(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.statLabel.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.statValue.copyWith(
              fontSize: 44,
              // Lighter tint on dark so the figure keeps its contrast.
              color: isDark ? Color.alphaBlend(Colors.white24, color) : color,
            ),
          ),
        ],
      ),
    );
  }
}
