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
/// The year's paper data is a deferred library: it is downloaded on
/// first opening this page ([loadPapersForYear]) and a loading state
/// is shown until it arrives, then the page renders exactly as
/// before. A year with no built papers shows honestly as coming soon
/// with 0 papers built, and offers no Start action and no test. No
/// paper is ever invented for an unbuilt year.
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
  late final Future<List<PaperTest>> _papersFuture;

  @override
  void initState() {
    super.initState();
    _papersFuture = loadPapersForYear(widget.year);
  }

  @override
  Widget build(BuildContext context) {
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
                FutureBuilder<List<PaperTest>>(
                  future: _papersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Loading ${widget.year} papers…',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      );
                    }
                    final List<PaperTest> papers =
                        snapshot.data ?? const <PaperTest>[];
                    if (papers.isEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                        ],
                      );
                    }
                    return PaperListSection(
                      year: widget.year,
                      papers: papers,
                      onStartPaper: (PaperTest paper) {
                        Get.find<MockTestController>().selectPaper(paper);
                        Get.toNamed(AppRoutes.ppscMockTest);
                      },
                    );
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
