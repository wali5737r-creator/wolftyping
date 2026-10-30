import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../controller/mock_test_controller.dart';
import '../model/paper_test.dart';
import '../service/papers_registry.dart';
import 'paper_list_section.dart';

/// One year's page of practice papers, reached by tapping a year on
/// the year-grouped papers list. Lists ALL of that year's papers in
/// todo-list style rows, with search, a department filter, and the
/// year's completion line.
///
/// A year with no built papers shows honestly as coming soon with
/// 0 papers built, and offers no Start action and no test. No paper
/// is ever invented for an unbuilt year.
///
/// Practice material only: every paper is written in fresh wording
/// and is never presented as an official or verbatim paper.
class YearPapersView extends StatefulWidget {
  const YearPapersView({super.key, required this.year});

  final int year;

  @override
  State<YearPapersView> createState() => _YearPapersViewState();
}

class _YearPapersViewState extends State<YearPapersView> {
  @override
  Widget build(BuildContext context) {
    final List<PaperTest> papers = papersForYear(widget.year);
    final bool built = papers.isNotEmpty;
    return AppScaffold(
      currentRoute: AppRoutes.ppscPastPapersYear,
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageHeader(
                  title: '${widget.year} Practice Papers',
                  subtitle:
                      'Timed practice tests by paper and department. '
                      'Practice material only — not official papers.',
                ),
                const SizedBox(height: 20),
                if (!built) ...[
                  EmptyStateView(
                    icon: Icons.hourglass_empty_outlined,
                    title: 'Coming soon',
                    message:
                        'No ${widget.year} papers are built yet. Papers '
                        'for this year will appear here when they are '
                        'built — 0 papers built so far.',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.year} — coming soon · 0 papers built',
                    style: AppTextStyles.bodyMedium,
                  ),
                ] else
                  PaperListSection(
                    year: widget.year,
                    papers: papers,
                    onStartPaper: (PaperTest paper) {
                      Get.find<MockTestController>().selectPaper(paper);
                      Get.toNamed(AppRoutes.ppscMockTest);
                    },
                  ),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.ppscPastPapers),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to practice papers'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
