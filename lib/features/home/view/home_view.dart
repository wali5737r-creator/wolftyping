import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/routes/default_typing_route.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../../history/model/typing_test_record.dart';
import '../../progress/model/progress_models.dart';
import '../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.dashboard,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!controller.hasTests) {
          return const _EmptyState();
        }
        return const _DashboardBody();
      }),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return EmptyStateView(
      icon: Icons.keyboard_alt_outlined,
      title: 'No completed tests yet',
      message: 'Finish a typing test and your speed, accuracy and daily '
          'progress will show up here.',
      actions: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: () => Get.offNamed(defaultTypingRoute()),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start a typing test'),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => Get.offNamed(AppRoutes.lessons),
            icon: const Icon(Icons.school_outlined),
            label: const Text('View lessons'),
          ),
        ],
      ),
    );
  }
}

class _DashboardBody extends GetView<HomeController> {
  const _DashboardBody();

  // Obx so the numbers rebuild whenever the controller reloads (this
  // widget is const, so the parent's Obx alone would never rebuild it).
  @override
  Widget build(BuildContext context) => Obx(() => _content());

  Widget _content() {
    // Every reactive value is read HERE, inside the Obx builder, and then
    // handed down as plain data - a LayoutBuilder's own builder runs later
    // (at layout time) and would not be tracked by Obx.
    final LanguageStats today = controller.today;
    final LanguageStats overall = controller.overall;
    final DailyGoalData goal = controller.dailyGoal;
    final List<TypingTestRecord> recent = controller.recentTests;
    final int totalTests = controller.allTests.length;
    final bool practicedToday = today.tests > 0;

    final List<_StatSpec> stats = <_StatSpec>[
      _StatSpec(
        label: 'Average WPM',
        caption: 'Today',
        value: practicedToday ? today.averageWpm.toStringAsFixed(1) : '—',
        icon: Icons.speed_outlined,
        accent: AppColors.clayBlue,
      ),
      _StatSpec(
        label: 'Average accuracy',
        caption: 'Today',
        value: practicedToday
            ? '${today.averageAccuracy.toStringAsFixed(1)}%'
            : '—',
        icon: Icons.gps_fixed,
        accent: AppColors.clayTeal,
      ),
      _StatSpec(
        label: 'Tests completed',
        caption: 'Today',
        value: '${today.tests}',
        icon: Icons.keyboard_alt_outlined,
        accent: AppColors.clayViolet,
      ),
      _StatSpec(
        label: 'Best WPM',
        caption: 'All time',
        value: overall.bestWpm.toStringAsFixed(1),
        icon: Icons.emoji_events_outlined,
        accent: AppColors.clayAmber,
      ),
      _StatSpec(
        label: 'Overall average WPM',
        caption: 'All tests',
        value: overall.averageWpm.toStringAsFixed(1),
        icon: Icons.trending_up,
        accent: AppColors.clayBlue,
      ),
      _StatSpec(
        label: 'Practice time',
        caption: 'Today',
        value: _formatSeconds(today.practiceSeconds),
        icon: Icons.timer_outlined,
        accent: AppColors.clayTeal,
      ),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final int columns = width >= 900 ? 3 : 2;
        final double cardWidth =
            (width - AppDimensions.gapLarge * (columns - 1)) / columns;
        final bool sideBySide = width >= 900;

        final Widget goalCard = _DailyGoalCard(goal: goal);
        final Widget summaryCard = _ProgressSummaryCard(
          totalTests: totalTests,
          overall: overall,
        );

        return ListView(
          padding: const EdgeInsets.only(bottom: AppDimensions.gapLarge),
          children: [
            PageHeader(
              title: 'Welcome back',
              subtitle: "Here's your typing summary · "
                  '${_formatToday(DateTime.now())}',
              trailing: ElevatedButton.icon(
                onPressed: () => Get.offNamed(defaultTypingRoute()),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start typing test'),
              ),
            ),
            const SizedBox(height: AppDimensions.gapLarge),
            Wrap(
              spacing: AppDimensions.gapLarge,
              runSpacing: AppDimensions.gapLarge,
              children: [
                for (final _StatSpec s in stats)
                  SizedBox(
                    width: cardWidth,
                    child: ClayCard(
                      label: s.label,
                      caption: s.caption,
                      value: s.value,
                      icon: s.icon,
                      accent: s.accent,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppDimensions.gapLarge),
            if (sideBySide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: goalCard),
                  const SizedBox(width: AppDimensions.gapLarge),
                  Expanded(child: summaryCard),
                ],
              )
            else ...[
              goalCard,
              const SizedBox(height: AppDimensions.gapLarge),
              summaryCard,
            ],
            const SizedBox(height: AppDimensions.gapLarge),
            Row(
              children: [
                const Expanded(
                  child: Text('Recent tests', style: AppTextStyles.h3),
                ),
                TextButton(
                  onPressed: () => Get.offNamed(AppRoutes.history),
                  child: const Text('View all'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _RecentTestsCard(records: recent),
          ],
        );
      },
    );
  }
}

class _StatSpec {
  const _StatSpec({
    required this.label,
    required this.caption,
    required this.value,
    required this.icon,
    required this.accent,
  });

  final String label;
  final String caption;
  final String value;
  final IconData icon;
  final Color accent;
}

class _DailyGoalCard extends StatelessWidget {
  const _DailyGoalCard({required this.goal});

  final DailyGoalData goal;

  @override
  Widget build(BuildContext context) {
    final bool reached =
        goal.goalSeconds > 0 && goal.practicedSeconds >= goal.goalSeconds;
    final Color barColor = reached ? AppColors.success : AppColors.primary;
    return SoftSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Daily goal', style: AppTextStyles.h3),
              ),
              Text(
                '${goal.progressPercent.toStringAsFixed(0)}%',
                style: AppTextStyles.h3.copyWith(color: barColor),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${_formatSeconds(goal.practicedSeconds)} of '
            '${_formatSeconds(goal.goalSeconds)} practiced today',
            style: AppTextStyles.captionOf(context),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (goal.progressPercent / 100).clamp(0, 1).toDouble(),
              minHeight: 10,
              color: barColor,
              backgroundColor:
                  Theme.of(context).dividerColor.withValues(alpha: 0.7),
            ),
          ),
          if (reached) ...[
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.check_circle, size: 18, color: AppColors.success),
                SizedBox(width: 6),
                Text(
                  'Daily goal reached',
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ProgressSummaryCard extends StatelessWidget {
  const _ProgressSummaryCard({
    required this.totalTests,
    required this.overall,
  });

  final int totalTests;
  final LanguageStats overall;

  @override
  Widget build(BuildContext context) {
    return SoftSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Progress summary', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          _SummaryLine(label: 'Total tests', value: '$totalTests'),
          _SummaryLine(
            label: 'Average accuracy',
            value: '${overall.averageAccuracy.toStringAsFixed(1)}%',
          ),
          _SummaryLine(
            label: 'Best accuracy',
            value: '${overall.bestAccuracy.toStringAsFixed(1)}%',
          ),
          _SummaryLine(
            label: 'Total practice time',
            value: _formatSeconds(overall.practiceSeconds),
            last: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.last = false,
  });

  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: last
            ? null
            : Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.6),
                ),
              ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: AppTextStyles.captionOf(context)),
          ),
          Text(value, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

class _RecentTestsCard extends StatelessWidget {
  const _RecentTestsCard({required this.records});

  final List<TypingTestRecord> records;

  @override
  Widget build(BuildContext context) {
    return SoftSurface(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius - 1),
        child: Column(
          children: [
            for (int i = 0; i < records.length; i++) ...[
              if (i > 0) const Divider(height: 1),
              _RecentTestRow(record: records[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecentTestRow extends StatelessWidget {
  const _RecentTestRow({required this.record});

  final TypingTestRecord record;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.historyDetail, arguments: record),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record.languageAndTypeLabel,
                        style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 2),
                    Text(_formatDateTime(record.completedAt),
                        style: AppTextStyles.captionOf(context)),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: _Figure(
                  value: record.netWpm.toStringAsFixed(0),
                  label: 'WPM',
                ),
              ),
              Expanded(
                flex: 2,
                child: _Figure(
                  value: '${record.accuracy.toStringAsFixed(0)}%',
                  label: 'Accuracy',
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  '${record.totalErrors} errors · '
                  '${_formatSeconds(record.actualDurationSeconds)}',
                  style: AppTextStyles.captionOf(context),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: AppTextStyles.h3),
        Text(label, style: AppTextStyles.captionOf(context)),
      ],
    );
  }
}

/// "45s", "12m 30s", "1h 05m" - readable, never raw seconds.
String _formatSeconds(int totalSeconds) {
  if (totalSeconds < 60) return '${totalSeconds}s';
  final int hours = totalSeconds ~/ 3600;
  final int minutes = (totalSeconds % 3600) ~/ 60;
  final int seconds = totalSeconds % 60;
  if (hours > 0) return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  return seconds == 0 ? '${minutes}m' : '${minutes}m ${seconds}s';
}

String _formatDateTime(DateTime d) {
  final String date =
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  final String time =
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  return '$date $time';
}

const List<String> _weekdayNames = <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const List<String> _monthNames = <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

String _formatToday(DateTime d) =>
    '${_weekdayNames[d.weekday - 1]}, ${d.day} ${_monthNames[d.month - 1]} ${d.year}';
