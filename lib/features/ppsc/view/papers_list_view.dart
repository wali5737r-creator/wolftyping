import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../controller/mock_test_controller.dart';
import '../model/mock_question.dart';
import '../service/papers_registry.dart';
import 'weak_subject_hint.dart';

/// Practice papers organised by year.
///
/// The heading is followed by one row per built year (2026, then
/// 2025, then the next years in year order), each labelled
/// "Past Papers" with its paper and question counts. Tapping a year
/// opens a page listing all of that year's papers in todo-list style
/// (with search, a department filter, and a completion line); years
/// with no built papers show honestly as "coming soon" with 0 papers
/// built and are not tappable into a test.
///
/// Practice material only: every paper is written in fresh wording and
/// is never presented as an official or verbatim paper.
class PapersListView extends GetView<MockTestController> {
  const PapersListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<PaperYearGroup> groups = paperYearGroups;
    return AppScaffold(
      currentRoute: AppRoutes.ppscPastPapers,
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeader(
                  title: 'Practice Papers',
                  subtitle:
                      'Timed practice tests organised by year, paper and '
                      'department. Practice material only — not official '
                      'papers.',
                ),
                const SizedBox(height: 20),
                WeakSubjectHint(
                  controller: controller,
                  onPractiseSubject: (MockSubject subject) {
                    Get.toNamed(AppRoutes.ppscMockTest);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Get.find<MockTestController>().selectSubject(subject);
                    });
                  },
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Get.toNamed(AppRoutes.ppscMockTest);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Get.find<MockTestController>().selectBookmarked();
                    });
                  },
                  icon: const Icon(Icons.bookmark_outlined),
                  label: const Text('Bookmarked questions'),
                ),
                const SizedBox(height: 20),
                for (final PaperYearGroup group in groups) ...[
                  if (group.isBuilt)
                    _YearHeader(group: group)
                  else
                    _ComingSoonYearRow(year: group.year),
                  const SizedBox(height: 20),
                ],
                TextButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.ppscMockTest),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to mock test setup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Tappable header for a built year: opens the year's own page.
class _YearHeader extends StatelessWidget {
  const _YearHeader({required this.group});

  final PaperYearGroup group;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key('paper-year-${group.year}-header'),
      onTap: () => Get.toNamed(
        AppRoutes.ppscPastPapersYear,
        arguments: group.year,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${group.year}', style: AppTextStyles.h2),
                const SizedBox(height: 2),
                Text(
                  'Past Papers · ${group.papers.length} papers · '
                  '${group.totalQuestions} questions in total',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
          const SizedBox(width: 4),
          const Text('View all'),
        ],
      ),
    );
  }
}

/// Honest placeholder for a year with no built papers yet: no Start
/// action, no navigation into a test.
class _ComingSoonYearRow extends StatelessWidget {
  const _ComingSoonYearRow({required this.year});

  final int year;

  @override
  Widget build(BuildContext context) {
    return SoftSurface(
      key: Key('paper-year-$year-row'),
      raised: false,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$year', style: AppTextStyles.h2),
                const SizedBox(height: 2),
                const Text(
                  'Coming soon · 0 papers built',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
          const Text('Coming soon'),
        ],
      ),
    );
  }
}
