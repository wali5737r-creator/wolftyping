import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../../history/model/typing_test_record.dart';
import '../controller/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.profile,
      body: Obx(() {
        if (controller.loading.value) return const Center(child: CircularProgressIndicator());
        final s = controller.stats.value;
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              PageHeader(
                title: 'Profile',
                subtitle: 'Your local typing profile and real performance summary.',
                trailing: FilledButton.icon(onPressed: () => _editName(context, s.name), icon: const Icon(Icons.edit_outlined), label: const Text('Edit name')),
              ),
              const SizedBox(height: 22),
              SoftSurface(padding: const EdgeInsets.all(24), child: Row(children: [
                CircleAvatar(radius: 32, backgroundColor: AppColors.primary, foregroundColor: Colors.white, child: Text(String.fromCharCode(s.name.runes.first).toUpperCase(), style: AppTextStyles.h2.copyWith(color: Colors.white))),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.name, style: AppTextStyles.h2),
                  const SizedBox(height: 4),
                  Text('Local profile • ${s.createdAt.year > 1970 ? 'Since ${s.createdAt.day}/${s.createdAt.month}/${s.createdAt.year}' : 'New profile'}', style: AppTextStyles.captionOf(context)),
                ])),
              ])),
              const SizedBox(height: 16),
              _Grid(children: [
                _Stat('Tests', '${s.totalTests}', Icons.keyboard_alt_outlined),
                _Stat('Best WPM', s.bestWpm.toStringAsFixed(1), Icons.speed_outlined),
                _Stat('Average WPM', s.averageWpm.toStringAsFixed(1), Icons.trending_up),
                _Stat('Best Accuracy', '${s.bestAccuracy.toStringAsFixed(1)}%', Icons.gps_fixed),
                _Stat('Practice Time', _formatTime(s.totalPracticeSeconds), Icons.timer_outlined),
                _Stat('Current Streak', '${s.currentStreak} days', Icons.local_fire_department_outlined),
                _Stat('Longest Streak', '${s.longestStreak} days', Icons.emoji_events_outlined),
                _Stat('Lessons Completed', '${s.completedLessons}', Icons.school_outlined),
              ]),
              const SizedBox(height: 18),
              const Text('Language & Test Summary', style: AppTextStyles.h3),
              const SizedBox(height: 10),
              _SummaryRow('English', s.englishTests, Icons.language),
              _SummaryRow('Urdu (incl. PPSC)', s.urduTests, Icons.translate),
              _SummaryRow('PPSC only', s.ppscTests, Icons.assignment_outlined),
              const SizedBox(height: 18),
              if (s.totalTests == 0)
                const EmptyStateView(
                  icon: Icons.insights_outlined,
                  title: 'No completed tests yet',
                  message: 'Complete your first typing test to start building your profile.',
                ),
              const SizedBox(height: 18),
              const Text('Best Scores on This Device', style: AppTextStyles.h3),
              const SizedBox(height: 4),
              Text(
                'Your own top results, stored only on this device. This is not a shared leaderboard — other people\'s scores are never shown here. A shared leaderboard needs accounts and a backend.',
                style: AppTextStyles.captionOf(context),
              ),
              const SizedBox(height: 10),
              if (controller.bestScores.isEmpty)
                const Text('No scores yet — complete a typing test to appear here.')
              else
                for (int i = 0; i < controller.bestScores.length; i++)
                  _BestScoreRow(
                    rank: i + 1,
                    record: controller.bestScores[i],
                  ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _editName(BuildContext context, String current) async {
    final text = TextEditingController(text: current);
    final formKey = GlobalKey<FormState>();
    await showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(
      title: const Text('Change name'),
      content: Form(key: formKey, child: TextFormField(controller: text, autofocus: true, maxLength: 40, decoration: const InputDecoration(labelText: 'Name'), validator: (v) => v == null || v.trim().isEmpty ? 'Name cannot be empty' : null)),
      actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')), FilledButton(onPressed: () async { if (!formKey.currentState!.validate()) return; await controller.saveName(text.text); if (dialogContext.mounted) Navigator.pop(dialogContext); }, child: const Text('Save'))],
    ));
    text.dispose();
  }

  static String _formatTime(int seconds) {
    final h = seconds ~/ 3600; final m = (seconds % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final int count = c.maxWidth >= 1000
            ? 4
            : c.maxWidth >= 650
                ? 2
                : 1;
        return GridView.count(
          crossAxisCount: count,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.4,
          children: children,
        );
      },
    );
  }
}

/// One profile statistic: accent icon badge, value, label.
class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value, this.icon);

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color accent = isDark ? AppColors.primaryDark : AppColors.primary;
    return SoftSurface(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: isDark ? 0.22 : 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(value, maxLines: 1, style: AppTextStyles.h2),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.captionOf(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.count, this.icon);

  final String label;
  final int count;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color accent = isDark ? AppColors.primaryDark : AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SoftSurface(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: accent),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
            Text('$count tests', style: AppTextStyles.captionOf(context)),
          ],
        ),
      ),
    );
  }
}

class _BestScoreRow extends StatelessWidget {
  const _BestScoreRow({required this.rank, required this.record});

  final int rank;
  final TypingTestRecord record;

  @override
  Widget build(BuildContext context) {
    final DateTime d = record.completedAt;
    final String date =
        '${d.day}/${d.month}/${d.year}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SoftSurface(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '#$rank',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.languageAndTypeLabel,
                    style: AppTextStyles.bodyMedium,
                  ),
                  Text(date, style: AppTextStyles.captionOf(context)),
                ],
              ),
            ),
            Text(
              '${record.netWpm.toStringAsFixed(1)} WPM',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              '${record.accuracy.toStringAsFixed(0)}%',
              style: AppTextStyles.captionOf(context),
            ),
          ],
        ),
      ),
    );
  }
}
