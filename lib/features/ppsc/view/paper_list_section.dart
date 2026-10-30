import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_text_styles.dart';
import '../model/paper_test.dart';
import '../service/mock_progress_repository.dart';
import '../service/papers_registry.dart';
import 'paper_row.dart';

/// The todo-list section for one year's papers: a search field, a
/// department filter, the year's completion line, and one row per
/// paper. Shared by the year-grouped list (entry screen) and the
/// year's own page, so both filter the same way.
///
/// Search matches paper number, post, department, exam date and
/// title. The filter applies live as the user types or picks a
/// department. With no match, an honest empty message is shown —
///
/// Progress: 'X/Y papers complete' counts distinct papers with at
/// least one recorded attempt. Rows show the best score and a Retake
/// action once attempted, and Start before that.
class PaperListSection extends StatefulWidget {
  const PaperListSection({
    super.key,
    required this.year,
    required this.papers,
    required this.onStartPaper,
  });

  final int year;
  final List<PaperTest> papers;
  final void Function(PaperTest paper) onStartPaper;

  @override
  State<PaperListSection> createState() => _PaperListSectionState();
}

class _PaperListSectionState extends State<PaperListSection> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String? _department;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _departments {
    final List<String> departments = widget.papers
        .map((p) => p.department)
        .toSet()
        .toList()
      ..sort();
    return departments;
  }

  @override
  Widget build(BuildContext context) {
    final List<PaperTest> filtered = filterPapers(
      widget.papers,
      query: _query,
      department: _department,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const Key('paper-search-field'),
          controller: _searchController,
          onChanged: (value) => setState(() => _query = value),
          decoration: const InputDecoration(
            labelText: 'Search papers by number, post or department',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text('Department: '),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButton<String>(
                key: const Key('paper-department-filter'),
                value: _department,
                isExpanded: true,
                hint: const Text('All departments'),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All departments'),
                  ),
                  for (final String department in _departments)
                    DropdownMenuItem<String>(
                      value: department,
                      child: Text(
                        department,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (value) => setState(() => _department = value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          final int done = MockProgressRepository.instance
              .completedCount(widget.papers.map((p) => p.id));
          return Text(
            '$done/${widget.papers.length} papers complete',
            style: AppTextStyles.bodyMedium,
          );
        }),
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          const Text(
            'No papers match this search or filter.',
            style: AppTextStyles.body,
          )
        else
          Obx(() {
            // Reactive read: rows update when an attempt is recorded.
            MockProgressRepository.instance.attempts.length;
            return Column(
              children: [
                for (final PaperTest paper in filtered)
                  PaperRow(
                    paper: paper,
                    bestAttempt: MockProgressRepository.instance
                        .bestAttemptFor(paper.id),
                    onStart: () => widget.onStartPaper(paper),
                  ),
              ],
            );
          }),
      ],
    );
  }
}
