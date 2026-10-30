import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../controller/paragraphs_controller.dart';
import '../model/custom_paragraph.dart';
import '../model/paragraph_category.dart';
import '../model/paragraph_sort.dart';
import 'widgets/delete_paragraph_dialog.dart';
import 'widgets/paragraph_card.dart';

/// My Paragraphs dashboard: counts, search, language/category filters,
/// sort, and a responsive grid of paragraph cards (built-in + custom
/// merged, per spec section 12).
class ParagraphsView extends GetView<ParagraphsController> {
  const ParagraphsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.myParagraphs,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title: 'My Paragraphs',
              subtitle: 'Create, manage and use your own typing paragraphs.',
              trailing: ElevatedButton.icon(
                onPressed: controller.openAdd,
                icon: const Icon(Icons.add),
                label: const Text('Add Paragraph'),
              ),
            ),
            const SizedBox(height: 20),
            _CountsRow(controller: controller),
            const SizedBox(height: 16),
            _FiltersBar(controller: controller),
            const SizedBox(height: 16),
            Expanded(child: _ParagraphGrid(controller: controller)),
          ],
        );
      }),
    );
  }
}

class _CountsRow extends StatelessWidget {
  const _CountsRow({required this.controller});

  final ParagraphsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
          spacing: AppDimensions.gapMedium,
          runSpacing: AppDimensions.gapMedium,
          children: [
            StatCard(
                label: 'Total paragraphs',
                value: '${controller.totalCount}',
                width: 160),
            StatCard(
                label: 'English',
                value: '${controller.englishCount}',
                width: 160),
            StatCard(
                label: 'Urdu',
                value: '${controller.urduCount}',
                width: 160),
          ],
        ));
  }
}

class _FiltersBar extends StatefulWidget {
  const _FiltersBar({required this.controller});

  final ParagraphsController controller;

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
    return Wrap(
      spacing: 12,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 240,
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, size: 20),
              hintText: 'Search title, text or category...',
              isDense: true,
            ),
            onChanged: widget.controller.setSearch,
          ),
        ),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final f in ParagraphLanguageFilter.values)
                  OptionChip(
                    label: f.label,
                    selected: widget.controller.languageFilter.value == f,
                    onSelected: () => widget.controller.setLanguageFilter(f),
                  ),
              ],
            )),
        Obx(() => FilterShell(
              child: DropdownButton<ParagraphCategory?>(
              value: widget.controller.categoryFilter.value,
              hint: const Text('All categories'),
              items: [
                const DropdownMenuItem(
                    value: null, child: Text('All categories')),
                for (final c in ParagraphCategory.values)
                  DropdownMenuItem(value: c, child: Text(c.label)),
              ],
              onChanged: widget.controller.setCategoryFilter,
              ),
            )),
        Obx(() => FilterShell(
              child: DropdownButton<ParagraphSort>(
              value: widget.controller.sort.value,
              items: [
                for (final s in ParagraphSort.values)
                  DropdownMenuItem(value: s, child: Text(s.label)),
              ],
              onChanged: (s) {
                if (s != null) widget.controller.setSort(s);
              },
              ),
            )),
      ],
    );
  }
}

class _ParagraphGrid extends StatelessWidget {
  const _ParagraphGrid({required this.controller});

  final ParagraphsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<CustomParagraph> list = controller.filtered;
      if (list.isEmpty) {
        return controller.allParagraphs.isEmpty
            ? _EmptyState(controller: controller)
            : const EmptyStateView(
                icon: Icons.filter_alt_off_outlined,
                title: 'No matching paragraphs',
                message: 'No paragraphs match your filters.',
              );
      }
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 340,
          mainAxisExtent: 300,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final CustomParagraph p = list[index];
          return ParagraphCard(
            paragraph: p,
            onView: () => controller.openPreview(p),
            onUseForTest: () => controller.useForTest(p),
            onEdit: () => controller.openEdit(p),
            onDelete: () async {
              final bool confirmed =
                  await confirmDeleteParagraph(context, p.title);
              if (confirmed) controller.deleteParagraph(p);
            },
          );
        },
      );
    });
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.controller});

  final ParagraphsController controller;

  @override
  Widget build(BuildContext context) {
    return EmptyStateView(
      icon: Icons.article_outlined,
      title: 'No custom paragraphs yet',
      message: 'Create your own paragraph to practice it anytime.',
      actions: ElevatedButton.icon(
        onPressed: controller.openAdd,
        icon: const Icon(Icons.add),
        label: const Text('Add Paragraph'),
      ),
    );
  }
}
