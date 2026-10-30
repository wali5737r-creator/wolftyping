import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../controller/mock_test_controller.dart';
import '../model/paper_test.dart';
import '../service/papers2026_registry.dart';

/// List of the 2026 practice papers, reachable from the PPSC mock test
/// setup panel. Tapping a paper selects it in the shared mock-test
/// controller and opens the mock test setup for that paper, which then
/// runs on the existing mock-test engine.
///
/// Practice material only: every paper is written in fresh wording and
/// is never presented as an official or verbatim paper.
class PapersListView extends GetView<MockTestController> {
  const PapersListView({super.key});

  @override
  Widget build(BuildContext context) {
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
                  title: '2026 Practice Papers',
                  subtitle:
                      'Timed practice tests by paper, year and department. '
                      'Practice material only — not official papers.',
                ),
                const SizedBox(height: 20),
                Text(
                  '${papers2026.length} papers · $papers2026TotalQuestions questions in total',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 16),
                for (final PaperTest paper in papers2026)
                  _PaperTile(paper: paper, controller: controller),
                const SizedBox(height: 20),
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

class _PaperTile extends StatelessWidget {
  const _PaperTile({required this.paper, required this.controller});

  final PaperTest paper;
  final MockTestController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.gapMedium),
      child: SectionCard(
        title: paper.post,
        subtitle: '${paper.department} · ${paper.examDate}',
        trailing: Text(
          '${paper.questionCount} Qs',
          style: AppTextStyles.bodyMedium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paper ${paper.paperNo} · ${paper.year} · one question at a time, '
              'with palette, timer and review — just like the sample mock test.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                controller.selectPaper(paper);
                Get.toNamed(AppRoutes.ppscMockTest);
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start this paper'),
            ),
          ],
        ),
      ),
    );
  }
}
