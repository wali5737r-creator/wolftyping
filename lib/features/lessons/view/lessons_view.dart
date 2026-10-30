import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../../typing_test/model/typing_language.dart';
import '../controller/lessons_controller.dart';
import '../model/lesson_level.dart';
import '../model/lesson_status_filter.dart';
import '../model/lesson_with_progress.dart';
import 'widgets/lesson_card.dart';

/// Lessons Dashboard: language tabs, search + level/status filters, and a
/// responsive grid of lesson cards. Real content and progress -- no
/// placeholder UI.
class LessonsView extends GetView<LessonsController> {
  const LessonsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.lessons,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Lessons',
            subtitle: 'Learn typing step by step, from home row to full paragraphs.',
          ),
          const SizedBox(height: 20),
          _LanguageTabs(controller: controller),
          const SizedBox(height: 12),
          _FiltersBar(controller: controller),
          const SizedBox(height: 16),
          Expanded(child: _LessonGrid(controller: controller)),
        ],
      ),
    );
  }
}

class _LanguageTabs extends StatelessWidget {
  const _LanguageTabs({required this.controller});

  final LessonsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          children: [
            for (final TypingLanguage lang in TypingLanguage.values)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: OptionChip(
                  label: '${lang.label} Lessons',
                  selected: controller.selectedLanguage.value == lang,
                  onSelected: () => controller.selectLanguage(lang),
                ),
              ),
          ],
        ));
  }
}

class _FiltersBar extends StatefulWidget {
  const _FiltersBar({required this.controller});

  final LessonsController controller;

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
              hintText: 'Search lessons...',
              isDense: true,
            ),
            onChanged: widget.controller.setSearch,
          ),
        ),
        Obx(() => FilterShell(
              child: DropdownButton<LessonLevel?>(
                borderRadius: BorderRadius.circular(12),
                value: widget.controller.levelFilter.value,
                hint: const Text('All levels'),
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text('All levels')),
                  for (final level in LessonLevel.values)
                    DropdownMenuItem(value: level, child: Text(level.label)),
                ],
                onChanged: widget.controller.setLevelFilter,
              ),
            )),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final filter in LessonStatusFilter.values)
                  OptionChip(
                    label: filter.label,
                    selected: widget.controller.statusFilter.value == filter,
                    onSelected: () =>
                        widget.controller.setStatusFilter(filter),
                  ),
              ],
            )),
      ],
    );
  }
}

class _LessonGrid extends StatelessWidget {
  const _LessonGrid({required this.controller});

  final LessonsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final List<LessonWithProgress> lessons = controller.filteredLessons;
      if (lessons.isEmpty) {
        return const EmptyStateView(
          icon: Icons.filter_alt_off_outlined,
          title: 'No matching lessons',
          message: 'No lessons match your filters. Try changing or clearing them.',
        );
      }
      // Group by course stage (falls back to the level for lessons that
      // have no stage), keeping the original lesson order.
      final Map<String, List<LessonWithProgress>> groups = {};
      for (final LessonWithProgress l in lessons) {
        final String key = l.definition.stage.isEmpty
            ? l.definition.level.label
            : l.definition.stage;
        groups.putIfAbsent(key, () => <LessonWithProgress>[]).add(l);
      }
      return CustomScrollView(
        slivers: [
          for (final MapEntry<String, List<LessonWithProgress>> g
              in groups.entries) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(g.key, style: AppTextStyles.h3),
                    ),
                    Text(
                      '${g.value.where((l) => l.completed).length}'
                      ' / ${g.value.length} completed',
                      style: AppTextStyles.captionOf(context),
                    ),
                  ],
                ),
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 320,
                mainAxisExtent: 250,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final LessonWithProgress lesson = g.value[index];
                  return LessonCard(
                    lesson: lesson,
                    onTap: () async {
                      await Get.toNamed(AppRoutes.lessonPractice,
                          arguments: lesson);
                      controller.refresh();
                    },
                  );
                },
                childCount: g.value.length,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ],
      );
    });
  }
}
