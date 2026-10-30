import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../controller/progress_controller.dart';
import '../model/progress_models.dart';
import '../model/progress_time_range.dart';
import '../service/progress_calculations.dart';
import 'widgets/simple_line_chart.dart';

/// Progress dashboard: overall + per-language + PPSC stats, WPM/Accuracy
/// charts, best records, improvement, streak, daily goal and lesson
/// progress -- every number computed from real TypingTests/Users/
/// LessonProgress data via ProgressCalculations.
class ProgressView extends GetView<ProgressController> {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.progress,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!controller.hasData) {
          return const _EmptyState();
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                title: 'Progress',
                subtitle: 'Your speed and accuracy over time.',
                trailing: _TimeRangeSelector(controller: controller),
              ),
              const SizedBox(height: 20),
              _OverallStatsSection(controller: controller),
              const SizedBox(height: 24),
              _StreakAndGoalRow(controller: controller),
              const SizedBox(height: 24),
              _LanguageProgressSection(controller: controller),
              const SizedBox(height: 24),
              _ChartsSection(controller: controller),
              const SizedBox(height: 24),
              _BestRecordsSection(controller: controller),
              const SizedBox(height: 24),
              _ImprovementSection(controller: controller),
              const SizedBox(height: 24),
              _LessonProgressSection(controller: controller),
            ],
          ),
        );
      }),
    );
  }
}

class _TimeRangeSelector extends StatelessWidget {
  const _TimeRangeSelector({required this.controller});

  final ProgressController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
          spacing: 8,
          children: [
            for (final r in ProgressTimeRange.values)
              OptionChip(
                label: r.label,
                selected: controller.timeRange.value == r,
                onSelected: () => controller.timeRange.value = r,
              ),
          ],
        ));
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: AppTextStyles.h2),
    );
  }
}

class _OverallStatsSection extends StatelessWidget {
  const _OverallStatsSection({required this.controller});

  final ProgressController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final LanguageStats o = controller.overall;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Overall'),
          Wrap(
            spacing: AppDimensions.gapMedium,
            runSpacing: AppDimensions.gapMedium,
            children: [
              StatCard(label: 'Total Tests', value: '${o.tests}'),
              StatCard(label: 'Total Practice Time', value: ProgressCalculations.formatPracticeTime(o.practiceSeconds)),
              StatCard(label: 'Best WPM', value: o.bestWpm.toStringAsFixed(0)),
              StatCard(label: 'Average WPM', value: o.averageWpm.toStringAsFixed(0)),
              StatCard(label: 'Best Accuracy', value: '${o.bestAccuracy.toStringAsFixed(0)}%'),
              StatCard(label: 'Average Accuracy', value: '${o.averageAccuracy.toStringAsFixed(0)}%'),
              StatCard(label: 'Characters Typed', value: '${controller.totalCharactersTyped}'),
              StatCard(label: 'Words Typed', value: '${controller.totalWordsTyped}'),
              StatCard(label: 'Total Errors', value: '${o.totalErrors}'),
              StatCard(label: 'Skipped Words', value: '${o.skippedWords}'),
            ],
          ),
        ],
      );
    });
  }
}

class _StreakAndGoalRow extends StatelessWidget {
  const _StreakAndGoalRow({required this.controller});

  final ProgressController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final StreakData streak = controller.streak;
      final DailyGoalData goal = controller.dailyGoal;
      return Wrap(
        spacing: AppDimensions.gapMedium,
        runSpacing: AppDimensions.gapMedium,
        children: [
          SizedBox(
            width: 280,
            child: SectionCard(
              title: 'Streak',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('${streak.currentStreak}',
                          style: AppTextStyles.statValue
                              .copyWith(color: AppColors.streakFlame)),
                      const SizedBox(width: 6),
                      const Text('🔥 current'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Longest: ${streak.longestStreak} days · '
                    '${streak.practiceDays} practice days total',
                    style: AppTextStyles.captionOf(context),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 280,
            child: SectionCard(
              title: "Today's Goal",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${ProgressCalculations.formatPracticeTime(goal.practicedSeconds)} '
                    '/ ${ProgressCalculations.formatPracticeTime(goal.goalSeconds)}',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: goal.progressPercent / 100,
                      minHeight: 8,
                      backgroundColor:
                          Theme.of(context).dividerColor.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('${goal.progressPercent.toStringAsFixed(0)}%',
                      style: AppTextStyles.captionOf(context)),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _LanguageProgressSection extends StatelessWidget {
  const _LanguageProgressSection({required this.controller});

  final ProgressController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Language Progress'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: _LanguageCard(
                        title: 'English', stats: controller.englishStats)),
                const SizedBox(width: AppDimensions.gapMedium),
                Expanded(
                    child: _LanguageCard(
                        title: 'Urdu (incl. PPSC)',
                        stats: controller.urduStats)),
                const SizedBox(width: AppDimensions.gapMedium),
                Expanded(
                    child: _LanguageCard(
                        title: 'PPSC Only', stats: controller.ppscStats)),
              ],
            ),
          ],
        ));
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({required this.title, required this.stats});

  final String title;
  final LanguageStats stats;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Line('Tests', '${stats.tests}'),
          _Line('Best WPM', stats.bestWpm.toStringAsFixed(0)),
          _Line('Average WPM', stats.averageWpm.toStringAsFixed(0)),
          _Line('Best Accuracy', '${stats.bestAccuracy.toStringAsFixed(0)}%'),
          _Line('Average Accuracy',
              '${stats.averageAccuracy.toStringAsFixed(0)}%'),
          _Line('Practice Time',
              ProgressCalculations.formatPracticeTime(stats.practiceSeconds)),
          _Line('Errors', '${stats.totalErrors}'),
        ],
      ),
    );
  }
}

/// One label/value line inside a language card.
class _Line extends StatelessWidget {
  const _Line(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.captionOf(context))),
          Text(value, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

class _ChartsSection extends StatelessWidget {
  const _ChartsSection({required this.controller});

  final ProgressController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Charts'),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final f in ChartLanguageFilter.values)
                  OptionChip(
                    label: f.label,
                    selected: controller.chartLanguage.value == f,
                    onSelected: () => controller.chartLanguage.value = f,
                  ),
              ],
            )),
        const SizedBox(height: 16),
        SectionCard(
          title: 'WPM Over Time',
          child: Obx(() => SimpleLineChart(
                points: controller.wpmChartPoints,
                lineColor: AppColors.primary,
              )),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Accuracy Over Time',
          child: Obx(() => SimpleLineChart(
                points: controller.accuracyChartPoints,
                lineColor: AppColors.secondary,
                maxY: 100,
              )),
        ),
      ],
    );
  }
}

class _BestRecordsSection extends StatelessWidget {
  const _BestRecordsSection({required this.controller});

  final ProgressController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final BestRecords r = controller.bestRecords;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Best Records'),
          Wrap(
            spacing: AppDimensions.gapMedium,
            runSpacing: AppDimensions.gapMedium,
            children: [
              if (r.bestWpmTest != null)
                StatCard(
                  label: 'Best WPM',
                  value: r.bestWpmTest!.netWpm.toStringAsFixed(0),
                  caption: r.bestWpmTest!.languageAndTypeLabel,
                  width: 190,
                ),
              if (r.bestAccuracyTest != null)
                StatCard(
                  label: 'Best Accuracy',
                  value: '${r.bestAccuracyTest!.accuracy.toStringAsFixed(1)}%',
                  caption: r.bestAccuracyTest!.languageAndTypeLabel,
                  width: 190,
                ),
              if (r.longestPracticeTest != null)
                StatCard(
                  label: 'Longest Practice',
                  value: ProgressCalculations.formatPracticeTime(
                      r.longestPracticeTest!.actualDurationSeconds),
                  caption: r.longestPracticeTest!.languageAndTypeLabel,
                  width: 190,
                ),
              if (r.mostErrorsTest != null)
                StatCard(
                  label: 'Most Errors',
                  value: '${r.mostErrorsTest!.totalErrors}',
                  caption: r.mostErrorsTest!.languageAndTypeLabel,
                  width: 190,
                ),
            ],
          ),
        ],
      );
    });
  }
}

class _ImprovementSection extends StatelessWidget {
  const _ImprovementSection({required this.controller});

  final ProgressController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ImprovementData imp = controller.improvement;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Improvement'),
          if (!imp.hasEnoughData)
            const Text('Complete more tests to see your improvement.')
          else
            SoftSurface(
                child: Wrap(
                  spacing: AppDimensions.gapLarge,
                  runSpacing: 12,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('WPM', style: AppTextStyles.captionOf(context)),
                        Text(
                          '${imp.firstWpm!.toStringAsFixed(0)} → ${imp.latestWpm!.toStringAsFixed(0)}',
                          style: AppTextStyles.h3,
                        ),
                        Text(
                          '${imp.wpmChange >= 0 ? '+' : ''}${imp.wpmChange.toStringAsFixed(0)} WPM',
                          style: TextStyle(
                              color: imp.wpmChange >= 0
                                  ? AppColors.success
                                  : AppColors.danger),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Accuracy', style: AppTextStyles.captionOf(context)),
                        Text(
                          '${imp.firstAccuracy!.toStringAsFixed(0)}% → ${imp.latestAccuracy!.toStringAsFixed(0)}%',
                          style: AppTextStyles.h3,
                        ),
                        Text(
                          '${imp.accuracyChange >= 0 ? '+' : ''}${imp.accuracyChange.toStringAsFixed(0)}%',
                          style: TextStyle(
                              color: imp.accuracyChange >= 0
                                  ? AppColors.success
                                  : AppColors.danger),
                        ),
                      ],
                    ),
                  ],
                ),
            ),
        ],
      );
    });
  }
}

class _LessonProgressSection extends StatelessWidget {
  const _LessonProgressSection({required this.controller});

  final ProgressController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final s = controller.lessonSummary.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle('Lesson Progress'),
          Wrap(
            spacing: AppDimensions.gapMedium,
            runSpacing: AppDimensions.gapMedium,
            children: [
              StatCard(label: 'Lessons Completed', value: '${s.completedCount}'),
              StatCard(label: 'Lessons In Progress', value: '${s.inProgressCount}'),
              StatCard(label: 'Best Lesson WPM', value: s.bestLessonWpm.toStringAsFixed(0)),
              StatCard(label: 'Best Lesson Accuracy', value: '${s.bestLessonAccuracy.toStringAsFixed(0)}%'),
            ],
          ),
        ],
      );
    });
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return EmptyStateView(
      icon: Icons.show_chart,
      title: 'No typing data yet',
      message: 'Complete your first typing test to start tracking progress.',
      actions: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.typingTest),
            child: const Text('Start English Test'),
          ),
          OutlinedButton(
            onPressed: () => Get.toNamed(AppRoutes.urduTypingTest),
            child: const Text('Start Urdu Test'),
          ),
        ],
      ),
    );
  }
}
