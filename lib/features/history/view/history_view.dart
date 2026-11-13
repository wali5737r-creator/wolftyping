import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../controller/history_controller.dart';
import '../model/history_filters.dart';
import '../model/typing_test_record.dart';
import '../service/history_backup_repository.dart';
import 'widgets/delete_test_dialog.dart';
import 'widgets/history_row.dart';

/// History screen: real completed tests from TypingTests, with
/// filters/search/sort applied in memory (spec section 19).
class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.history,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'History',
              subtitle:
                  'Every completed typing test and mock test, exactly as it finished.',
            ),
            const SizedBox(height: 20),
            _FiltersBar(controller: controller),
            const SizedBox(height: 16),
            Expanded(child: _HistoryList(controller: controller)),
          ],
        );
      }),
    );
  }
}

class _FiltersBar extends StatefulWidget {
  const _FiltersBar({required this.controller});

  final HistoryController controller;

  @override
  State<_FiltersBar> createState() => _FiltersBarState();
}

class _FiltersBarState extends State<_FiltersBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SoftSurface(
      raised: false,
      radius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Wrap(
      spacing: 16,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 220,
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, size: 20),
              hintText: 'Search language, type, test name, date...',
              isDense: true,
            ),
            onChanged: (v) => widget.controller.searchQuery.value = v,
          ),
        ),
        Obx(() => FilterShell(
              child: DropdownButton<HistoryLanguageFilter>(
              underline: const SizedBox.shrink(),
              borderRadius: BorderRadius.circular(12),
              value: widget.controller.languageFilter.value,
              items: [
                for (final f in HistoryLanguageFilter.values)
                  DropdownMenuItem(value: f, child: Text('Language: ${f.label}')),
              ],
              onChanged: (v) {
                if (v != null) widget.controller.languageFilter.value = v;
              },
              ),
            )),
        Obx(() => FilterShell(
              child: DropdownButton<HistoryTestTypeFilter>(
              underline: const SizedBox.shrink(),
              borderRadius: BorderRadius.circular(12),
              value: widget.controller.testTypeFilter.value,
              items: [
                for (final f in HistoryTestTypeFilter.values)
                  DropdownMenuItem(value: f, child: Text('Type: ${f.label}')),
              ],
              onChanged: (v) {
                if (v != null) widget.controller.testTypeFilter.value = v;
              },
              ),
            )),
        Obx(() => FilterShell(
              child: DropdownButton<HistoryDurationFilter>(
              underline: const SizedBox.shrink(),
              borderRadius: BorderRadius.circular(12),
              value: widget.controller.durationFilter.value,
              items: [
                for (final f in HistoryDurationFilter.values)
                  DropdownMenuItem(value: f, child: Text('Duration: ${f.label}')),
              ],
              onChanged: (v) {
                if (v != null) widget.controller.durationFilter.value = v;
              },
              ),
            )),
        Obx(() => FilterShell(
              child: DropdownButton<HistoryDateFilter>(
              underline: const SizedBox.shrink(),
              borderRadius: BorderRadius.circular(12),
              value: widget.controller.dateFilter.value,
              items: [
                for (final f in HistoryDateFilter.values)
                  DropdownMenuItem(value: f, child: Text(f.label)),
              ],
              onChanged: (v) {
                if (v != null) widget.controller.dateFilter.value = v;
              },
              ),
            )),
        Obx(() => FilterShell(
              child: DropdownButton<HistorySort>(
              underline: const SizedBox.shrink(),
              borderRadius: BorderRadius.circular(12),
              value: widget.controller.sort.value,
              items: [
                for (final s in HistorySort.values)
                  DropdownMenuItem(value: s, child: Text(s.label)),
              ],
              onChanged: (v) {
                if (v != null) widget.controller.sort.value = v;
              },
              ),
            )),
        // Backup lives only in this browser's database, so export it
        // before clearing browser data. Web only — desktop/mobile
        // have no browser download or file picker.
        if (kIsWeb) ...[
          OutlinedButton.icon(
            onPressed: _exportJson,
            icon: const Icon(Icons.download_outlined, size: 20),
            label: const Text('Export JSON'),
          ),
          OutlinedButton.icon(
            onPressed: _exportCsv,
            icon: const Icon(Icons.table_chart_outlined, size: 20),
            label: const Text('Export CSV'),
          ),
          OutlinedButton.icon(
            onPressed: _importBackup,
            icon: const Icon(Icons.upload_file_outlined, size: 20),
            label: const Text('Import'),
          ),
        ],
      ],
      ),
    );
  }

  Future<void> _exportJson() async {
    final String? message = await widget.controller.exportHistoryJson();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message ?? 'Download is available on the web version.',
        ),
      ),
    );
  }

  Future<void> _exportCsv() async {
    final String? message = await widget.controller.exportHistoryCsv();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message ?? 'Download is available on the web version.',
        ),
      ),
    );
  }

  Future<void> _importBackup() async {
    try {
      final HistoryImportResult? result =
          await widget.controller.importHistoryBackup();
      if (!mounted || result == null) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Imported ${result.importedTests} test'
            '${result.importedTests == 1 ? '' : 's'} '
            '(${result.importedMistakes} mistake rows), '
            '${result.skippedDuplicates} already here, '
            '${result.mergedLessons} lesson record'
            '${result.mergedLessons == 1 ? '' : 's'} updated.',
          ),
        ),
      );
    } on FormatException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.controller});

  final HistoryController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<TypingTestRecord> list = controller.filtered;
      if (controller.allTests.isEmpty) {
        return _EmptyState(
          loadTimedOut: controller.loadTimedOut.value,
          loadFailed: controller.loadFailed.value,
          onRetry: controller.retryLoad,
        );
      }
      if (list.isEmpty) {
        return const EmptyStateView(
          icon: Icons.filter_alt_off_outlined,
          title: 'No matching tests',
          message: 'No tests match your filters. Try changing or clearing them.',
        );
      }
      final Widget listView = ListView.separated(
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final TypingTestRecord t = list[index];
          return HistoryRow(
            record: t,
            onTap: () => Get.toNamed(AppRoutes.historyDetail, arguments: t),
            onDelete: () async {
              final bool confirmed = await confirmDeleteTest(context);
              if (confirmed) controller.deleteTest(t);
            },
          );
        },
      );
      if (!controller.hasPartialData) return listView;
      // Partial load: one source could not be read, the other is shown
      // below. The banner lives INSIDE the flexed list region (not as
      // a fixed sibling in the outer Column, which would overflow a
      // short viewport): it names the missing part and whether
      // recovery is still running or has already failed, and Retry
      // re-reads only the failed part.
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PartialDataBanner(
            note: controller.partialDataNote,
            onRetry: controller.retryLoad,
          ),
          const SizedBox(height: 12),
          Expanded(child: listView),
        ],
      );
    });
  }
}

/// Banner for a partial load: some rows are shown, but one source
/// could not be read. The note names the missing part and whether
/// recovery is still running or has failed; Retry re-reads only the
/// failed part.
class _PartialDataBanner extends StatelessWidget {
  const _PartialDataBanner({required this.note, required this.onRetry});

  final String note;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    // Column, not a Row: on a narrow screen a side-by-side Retry
    // button would squeeze the note to ~240px wide (11 lines tall)
    // and overflow the list region. Full-width text first, button
    // below, keeps the banner short at any width.
    return SoftSurface(
      raised: false,
      radius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.warning_amber_outlined, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(note),
              ),
            ],
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry loading history'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    this.loadTimedOut = false,
    this.loadFailed = false,
    this.onRetry,
  });

  /// When the history read timed out, the same empty state is shown plus
  /// a Retry button and an honest one-line notice: the data was not
  /// deleted, it just could not be read yet.
  final bool loadTimedOut;

  /// When the background recovery has already reported the database
  /// still unreachable (as opposed to merely still recovering), the
  /// notice says so — the user can tell "still recovering" from
  /// "recovery failed".
  final bool loadFailed;

  /// Called by the "Retry loading history" button. Null when no retry
  /// is offered (kept optional so the plain empty state stays usable).
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final Widget empty = EmptyStateView(
      icon: Icons.history,
      title: 'No completed tests yet',
      message: 'Finish a typing test or a mock test and it will show up here.',
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
          OutlinedButton(
            onPressed: () => Get.toNamed(AppRoutes.ppscMockTest),
            child: const Text('Start Mock Test'),
          ),
        ],
      ),
    );
    if (!loadTimedOut) return empty;
    // Scrollable, not Expanded: the History header + filters already
    // take much of the viewport, so the empty state + Retry + notice
    // (taller than the remaining space on short screens) must scroll
    // rather than overflow. An Expanded around `empty` would give it a
    // tight height smaller than its content and overflow instead. A
    // SingleChildScrollView (not a ListView) builds the Retry button
    // eagerly, so it is always in the tree.
    return SingleChildScrollView(
      child: Column(
        children: [
          empty,
          if (onRetry != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 12),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry loading history'),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              loadFailed
                  ? 'History could not be loaded. Your data is safe — '
                      'tap Retry to try again.'
                  : 'History is still loading in the background — '
                      'recovery has not finished yet. Your data is '
                      'safe; tap Retry to try again, or wait and this '
                      'page will reload on its own.',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
