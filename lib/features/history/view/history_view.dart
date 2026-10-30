import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../controller/history_controller.dart';
import '../model/history_filters.dart';
import '../model/typing_test_record.dart';
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
              subtitle: 'Every completed typing test, exactly as it finished.',
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
              hintText: 'Search language, type, date...',
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
      ],
      ),
    );
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
        return _EmptyState();
      }
      if (list.isEmpty) {
        return const EmptyStateView(
          icon: Icons.filter_alt_off_outlined,
          title: 'No matching tests',
          message: 'No tests match your filters. Try changing or clearing them.',
        );
      }
      return ListView.separated(
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
    });
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyStateView(
      icon: Icons.history,
      title: 'No completed tests yet',
      message: 'Finish a typing test and it will show up here.',
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
