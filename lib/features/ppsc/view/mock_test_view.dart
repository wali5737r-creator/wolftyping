import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../controller/mock_test_controller.dart';
import '../model/custom_set.dart';
import '../model/mock_question.dart';
import '../model/paper_test.dart';
import '../service/mock_test_engine.dart';

/// PPSC practice MCQ mock test: a timed column view showing every
/// question together on one scrollable page, with a Submit control at
/// the end, instant result and per-question review.
///
/// The questions are PRACTICE SAMPLES (see `mock_questions.dart`) — the
/// screens say so, and never claim to be real PPSC papers. Attempts
/// are recorded on the device only (see MockProgressRepository) so
/// paper rows can show completion and the weakest-subject hint has
/// real data; typing-test history is separate.
class MockTestView extends GetView<MockTestController> {
  const MockTestView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.ppscMockTest,
      body: Obx(() {
        switch (controller.phase.value) {
          case MockTestPhase.setup:
            return _SetupPanel(controller: controller);
          case MockTestPhase.test:
            return _TestPanel(controller: controller);
          case MockTestPhase.result:
            return _ResultPanel(controller: controller);
        }
      }),
    );
  }
}

// ---------------------------------------------------------------------
// Setup
// ---------------------------------------------------------------------

class _SetupPanel extends StatelessWidget {
  const _SetupPanel({required this.controller});

  final MockTestController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Obx(() {
            // Reactive reads captured directly in this builder, so this
            // branch rebuilds when the selected test kind changes.
            final bool isPaper =
                controller.kind.value == MockTestKind.paper;
            final PaperTest? paper = controller.activePaper.value;
            if (isPaper && paper != null) {
              return _PaperSetupPanel(controller: controller, paper: paper);
            }
            final bool isCustom =
                controller.kind.value == MockTestKind.custom;
            final CustomSet? customSet = controller.activeCustomSet.value;
            if (isCustom && customSet != null) {
              return _CustomSetupPanel(
                controller: controller,
                customSet: customSet,
              );
            }
            if (controller.kind.value == MockTestKind.bookmarked) {
              return _BookmarkedSetupPanel(controller: controller);
            }
            return _SampleSetupPanel(controller: controller);
          }),
        ),
      ),
    );
  }
}

/// Setup for the sample (full / subject-wise) mock tests.
class _SampleSetupPanel extends StatelessWidget {
  const _SampleSetupPanel({required this.controller});

  final MockTestController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
              const PageHeader(
                title: 'PPSC Practice Mock Test',
                subtitle:
                    'Timed MCQ practice. Questions are practice samples — not real PPSC past papers.',
              ),
              const SizedBox(height: 20),
              _KindChoice(controller: controller),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.kind.value != MockTestKind.subject) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Subject', style: AppTextStyles.h3),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final MockSubject s in MockSubject.values)
                          ChoiceChip(
                            label: Text(s.label),
                            selected: controller.subject.value == s,
                            onSelected: (_) => controller.selectSubject(s),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),
              const Text('Duration', style: AppTextStyles.h3),
              const SizedBox(height: 8),
              Obx(() {
                final List<Duration> options =
                    controller.kind.value == MockTestKind.full
                    ? MockTestController.fullDurations
                    : MockTestController.subjectDurations;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final Duration d in options)
                      ChoiceChip(
                        label: Text('${d.inMinutes} minutes'),
                        selected: controller.selectedDuration.value == d,
                        onSelected: (_) => controller.selectDuration(d),
                      ),
                  ],
                );
              }),
              const SizedBox(height: 16),
              Obx(
                () => SwitchListTile(
                  title: const Text('Negative marking'),
                  subtitle: Text(
                    controller.negativeMarking.value
                        ? 'Each wrong answer deducts ${controller.negativeDeduction.value} marks. Skipped questions never deduct.'
                        : 'Off: wrong answers score 0, nothing is deducted.',
                  ),
                  value: controller.negativeMarking.value,
                  onChanged: controller.setNegativeMarking,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Obx(() {
                if (!controller.negativeMarking.value) {
                  return const SizedBox.shrink();
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    const Text('Deduction per wrong answer:'),
                    for (final double d in MockTestController.deductionOptions)
                      ChoiceChip(
                        label: Text('-$d'),
                        selected: controller.negativeDeduction.value == d,
                        onSelected: (_) => controller.setDeduction(d),
                      ),
                  ],
                );
              }),
              const SizedBox(height: 20),
              Obx(() {
                final int count = controller.availableQuestions.length;
                final bool isFull = controller.kind.value == MockTestKind.full;
                return SectionCard(
                  title: isFull
                      ? 'Full mock test'
                      : '${controller.subject.value?.label ?? ''} test',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$count question${count == 1 ? '' : 's'} · ${controller.selectedDuration.value.inMinutes} minutes · all questions together on one page',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Practice sample questions only — 100 per subject. The full test draws a balanced 100 across all subjects.',
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  if (controller.availableQuestions.isEmpty) return;
                  controller.startTest();
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Mock Test'),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => Get.toNamed(AppRoutes.ppscUrdu),
                icon: const Icon(Icons.keyboard_alt_outlined),
                label: const Text('Go to PPSC Urdu Typing Practice instead'),
              ),
              const SizedBox(height: 20),
              SectionCard(
                title: '2026 practice papers',
                subtitle:
                    'Timed practice tests by paper, year and department.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Practice material only — not official papers. Pick a '
                      'paper to run it with the same timer and review.',
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () =>
                          Get.toNamed(AppRoutes.ppscPastPapers),
                      icon: const Icon(Icons.article_outlined),
                      label: const Text('Browse 2026 papers'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                final int bookmarkedCount =
                    controller.progress.bookmarks.length;
                return SectionCard(
                  title: 'Bookmarked questions',
                  subtitle: 'Questions you bookmarked in answer reviews.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookmarkedCount == 0
                            ? 'No bookmarked questions yet. Bookmark a '
                                'question in any answer review to practise '
                                'it here.'
                            : '$bookmarkedCount bookmarked question${bookmarkedCount == 1 ? '' : 's'} — practise them together in one timed test.',
                        style: AppTextStyles.body,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: bookmarkedCount == 0
                            ? null
                            : () => controller.selectBookmarked(),
                        icon: const Icon(Icons.bookmark_outlined),
                        label: const Text('Practise bookmarked questions'),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              SectionCard(
                title: 'My Custom Tests',
                subtitle:
                    'Tests you create yourself, saved on this device.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create your own MCQ test, or import one a teacher '
                      'shared as a code or file. User-created practice '
                      'tests only — never official papers.',
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () =>
                          Get.toNamed(AppRoutes.ppscCustomTests),
                      icon: const Icon(Icons.edit_note_outlined),
                      label: const Text('My Custom Tests'),
                    ),
                  ],
                ),
              ),
            ],
    );
  }
}

/// Setup for a selected past paper: paper identity, duration, negative
/// marking and start. Reached from the papers list.
class _PaperSetupPanel extends StatelessWidget {
  const _PaperSetupPanel({required this.controller, required this.paper});

  final MockTestController controller;
  final PaperTest paper;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          title: 'Practice Paper ${paper.paperNo}',
          subtitle:
              '${paper.post}, ${paper.department} · ${paper.examDate} · '
              'Practice material only — not an official paper.',
        ),
        const SizedBox(height: 20),
        SectionCard(
          title: paper.post,
          subtitle: '${paper.department} · ${paper.examDate}',
          child: Text(
            '${paper.questionCount} question${paper.questionCount == 1 ? '' : 's'} · '
            'all questions together on one page · auto-submit when time ends',
            style: AppTextStyles.bodyMedium,
          ),
        ),
        const SizedBox(height: 20),
        const Text('Duration', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        Obx(() {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final Duration d in MockTestController.fullDurations)
                ChoiceChip(
                  label: Text('${d.inMinutes} minutes'),
                  selected: controller.selectedDuration.value == d,
                  onSelected: (_) => controller.selectDuration(d),
                ),
            ],
          );
        }),
        const SizedBox(height: 16),
        Obx(
          () => SwitchListTile(
            title: const Text('Negative marking'),
            subtitle: Text(
              controller.negativeMarking.value
                  ? 'Each wrong answer deducts ${controller.negativeDeduction.value} marks. Skipped questions never deduct.'
                  : 'Off: wrong answers score 0, nothing is deducted.',
            ),
            value: controller.negativeMarking.value,
            onChanged: controller.setNegativeMarking,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        Obx(() {
          if (!controller.negativeMarking.value) {
            return const SizedBox.shrink();
          }
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const Text('Deduction per wrong answer:'),
              for (final double d in MockTestController.deductionOptions)
                ChoiceChip(
                  label: Text('-$d'),
                  selected: controller.negativeDeduction.value == d,
                  onSelected: (_) => controller.setDeduction(d),
                ),
            ],
          );
        }),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {
            if (controller.availableQuestions.isEmpty) return;
            controller.startTest();
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start This Paper'),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () => Get.toNamed(AppRoutes.ppscPastPapers),
          icon: const Icon(Icons.list),
          label: const Text('Choose another paper'),
        ),
        TextButton.icon(
          onPressed: () => controller.selectKind(MockTestKind.full),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back to sample mock tests'),
        ),
      ],
    );
  }
}

/// Setup for a selected teacher-created custom set: set identity,
/// duration, negative marking and start. Reached from the custom tests
/// list. The run itself reuses the shared test and result panels, so a
/// custom set gets the same timer, 5-minute warning, auto-submit and
/// review as every other test.
class _CustomSetupPanel extends StatelessWidget {
  const _CustomSetupPanel({required this.controller, required this.customSet});

  final MockTestController controller;
  final CustomSet customSet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          title: 'Custom Test: ${customSet.name}',
          subtitle:
              'User-created practice test · ${customSet.questionCount} '
              'question${customSet.questionCount == 1 ? '' : 's'} · '
              'Practice only — not an official paper.',
        ),
        const SizedBox(height: 20),
        SectionCard(
          title: customSet.name,
          subtitle: 'User-created practice test',
          child: Text(
            '${customSet.questionCount} question${customSet.questionCount == 1 ? '' : 's'} · '
            'all questions together on one page · auto-submit when time ends',
            style: AppTextStyles.bodyMedium,
          ),
        ),
        const SizedBox(height: 20),
        const Text('Duration', style: AppTextStyles.h3),
        const SizedBox(height: 8),
        Obx(() {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final Duration d in MockTestController.customDurations)
                ChoiceChip(
                  label: Text('${d.inMinutes} minutes'),
                  selected: controller.selectedDuration.value == d,
                  onSelected: (_) => controller.selectDuration(d),
                ),
            ],
          );
        }),
        const SizedBox(height: 16),
        Obx(
          () => SwitchListTile(
            title: const Text('Negative marking'),
            subtitle: Text(
              controller.negativeMarking.value
                  ? 'Each wrong answer deducts ${controller.negativeDeduction.value} marks. Skipped questions never deduct.'
                  : 'Off: wrong answers score 0, nothing is deducted.',
            ),
            value: controller.negativeMarking.value,
            onChanged: controller.setNegativeMarking,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        Obx(() {
          if (!controller.negativeMarking.value) {
            return const SizedBox.shrink();
          }
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              const Text('Deduction per wrong answer:'),
              for (final double d in MockTestController.deductionOptions)
                ChoiceChip(
                  label: Text('-$d'),
                  selected: controller.negativeDeduction.value == d,
                  onSelected: (_) => controller.setDeduction(d),
                ),
            ],
          );
        }),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () {
            if (controller.availableQuestions.isEmpty) return;
            _askStudentNameAndStart(context, controller);
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start This Custom Test'),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () => Get.toNamed(AppRoutes.ppscCustomTests),
          icon: const Icon(Icons.list),
          label: const Text('Choose another custom test'),
        ),
        TextButton.icon(
          onPressed: () => controller.selectKind(MockTestKind.full),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back to sample mock tests'),
        ),
      ],
    );
  }
}


/// Asks for the student's name before a CUSTOM test starts. The name
/// is carried into the result ('Name — Score X/Y'). Empty falls back
/// to 'Student' and never blocks starting. Sample/paper tests never
/// ask for a name. The last-used name is saved on the device only.
Future<void> _askStudentNameAndStart(
  BuildContext context,
  MockTestController controller,
) async {
  final String? name = await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) => _StudentNameDialog(
      initialName: controller.progress.lastStudentName.value,
    ),
  );
  if (name == null) return;
  controller.studentName.value = name;
  if (name.trim().isNotEmpty) {
    unawaited(controller.progress.setLastStudentName(name.trim()));
  }
  controller.startTest();
}

class _StudentNameDialog extends StatefulWidget {
  const _StudentNameDialog({required this.initialName});

  final String initialName;

  @override
  State<_StudentNameDialog> createState() => _StudentNameDialogState();
}

class _StudentNameDialogState extends State<_StudentNameDialog> {
  late final TextEditingController _nameController =
      TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Your name'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your name will be shown with your score at the end of '
            'this custom test. You can leave it empty — the result '
            'will show "Student".',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('student-name-field'),
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Student name (optional)',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context)
              .pop(_nameController.text.trim()),
          child: const Text('Start test'),
        ),
      ],
    );
  }
}

/// Setup for a bookmarked-questions run: only the questions the
/// student bookmarked in an end review, run in the same column view
/// and engine, labelled practice.
class _BookmarkedSetupPanel extends StatelessWidget {
  const _BookmarkedSetupPanel({required this.controller});

  final MockTestController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int count = controller.availableQuestions.length;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Bookmarked Questions',
            subtitle:
                'Practice only — the questions you bookmarked in answer '
                'reviews, run as one timed test.',
          ),
          const SizedBox(height: 20),
          SectionCard(
            title: 'Bookmarked questions practice',
            child: Text(
              count == 0
                  ? 'No bookmarked questions yet. Bookmark a question '
                      'in any answer review and it will appear here.'
                  : '$count bookmarked question${count == 1 ? '' : 's'} · '
                      'all questions together on one page · auto-submit when time ends',
              style: AppTextStyles.bodyMedium,
            ),
          ),
          const SizedBox(height: 20),
          const Text('Duration', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          Obx(() {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final Duration d in MockTestController.customDurations)
                  ChoiceChip(
                    label: Text('${d.inMinutes} minutes'),
                    selected: controller.selectedDuration.value == d,
                    onSelected: (_) => controller.selectDuration(d),
                  ),
              ],
            );
          }),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: count == 0
                ? null
                : () {
                    if (controller.availableQuestions.isEmpty) return;
                    controller.startTest();
                  },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Bookmarked Practice'),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => controller.selectKind(MockTestKind.full),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to sample mock tests'),
          ),
        ],
      );
    });
  }
}

class _KindChoice extends StatelessWidget {
  const _KindChoice({required this.controller});

  final MockTestController controller;

  @override
  Widget build(BuildContext context) {
    // NOTE: the Obx must live here, not around _KindChoice in the parent:
    // GetX only tracks observables read directly inside the Obx builder, and
    // the kind read happens when RadioGroup is constructed below. Wrapping
    // _KindChoice in an Obx in the parent threw a GetX improper-use error
    // and rendered this section blank.
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Test type', style: AppTextStyles.h3),
          const SizedBox(height: 8),
          RadioGroup<MockTestKind>(
            groupValue: controller.kind.value,
            onChanged: (v) {
              if (v != null) controller.selectKind(v);
            },
            child: const Column(
              children: [
                RadioListTile<MockTestKind>(
                  title: Text('Full mock test (all subjects)'),
                  subtitle: Text('Every question in the question file.'),
                  value: MockTestKind.full,
                ),
                RadioListTile<MockTestKind>(
                  title: Text('Subject-wise test'),
                  subtitle:
                      Text('One subject only, 100 questions.'),
                  value: MockTestKind.subject,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------
// Test
// ---------------------------------------------------------------------

class _TestPanel extends StatefulWidget {
  const _TestPanel({required this.controller});

  final MockTestController controller;

  @override
  State<_TestPanel> createState() => _TestPanelState();
}

class _TestPanelState extends State<_TestPanel> {
  late final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MockTestController controller = widget.controller;
    return Obx(() {
      // Reactive reads (timer, answers) rebuild this panel.
      controller.remaining.value;
      controller.answersTick.value;
      final MockTestEngine engine = controller.engine;
      final bool warning = controller.timeWarning;
      final Color timerColor = warning
          ? AppColors.wrongChar
          : Theme.of(context).colorScheme.primary;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'All questions',
                  style: AppTextStyles.h2,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.timer_outlined, color: timerColor),
                  const SizedBox(width: 6),
                  Text(
                    controller.remainingLabel,
                    style: AppTextStyles.h2.copyWith(color: timerColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Answered ${engine.answeredCount} of ${engine.totalQuestions} · '
            'Unanswered ${engine.unansweredCount} · '
            'All questions are on this page — scroll to answer, then submit at the end.',
            style: AppTextStyles.captionOf(context),
          ),
          if (warning) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.wrongCharBg,
                borderRadius: BorderRadius.circular(
                  AppDimensions.cardRadius,
                ),
              ),
              child: const Text(
                'Only 5 minutes left! The test will submit automatically when time ends.',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              key: const Key('mock-test-question-list'),
              controller: _scrollController,
              itemCount: engine.totalQuestions,
              itemBuilder: (context, index) {
                final MockQuestion question = engine.questions[index];
                final int? selected = controller.selectedFor(question);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SectionCard(
                    key: ValueKey(question.id),
                    title: 'Q${index + 1} · ${question.subject.label}',
                    subtitle: question.topic,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question.question, style: AppTextStyles.h3),
                        const SizedBox(height: 14),
                        for (int i = 0; i < question.options.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                  backgroundColor: selected == i
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.primary.withValues(alpha: 0.12)
                                      : null,
                                  side: BorderSide(
                                    color: selected == i
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).dividerColor,
                                  ),
                                ),
                                onPressed: () =>
                                    controller.selectOptionFor(question, i),
                                child: Text(
                                  '${String.fromCharCode(65 + i)}. ${question.options[i]}',
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ),
                            ),
                          ),
                        if (selected != null)
                          TextButton(
                            onPressed: () =>
                                controller.clearAnswerFor(question),
                            child: const Text('Clear answer'),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => _confirmSubmit(context),
              icon: const Icon(Icons.check),
              label: const Text('Submit Test'),
            ),
          ),
        ],
      );
    });
  }

  Future<void> _confirmSubmit(BuildContext context) async {
    final MockTestController controller = widget.controller;
    final List<MockQuestion> unanswered = controller.unansweredQuestions;
    final bool? submit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Submit test?'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (unanswered.isEmpty)
                const Text('You have answered every question.')
              else ...[
                Text(
                  '${unanswered.length} question${unanswered.length == 1 ? ' is' : 's are'} still unanswered:',
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final MockQuestion q in unanswered)
                      Chip(
                        label: Text(
                          '${controller.engine.questions.indexOf(q) + 1}',
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'You can go back and answer them, or submit now — unanswered questions score 0.',
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Go Back'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Submit Anyway'),
          ),
        ],
      ),
    );
    if (submit == true) controller.submit();
  }
}

// ---------------------------------------------------------------------
// Result + review
// ---------------------------------------------------------------------

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({required this.controller});

  final MockTestController controller;

  @override
  Widget build(BuildContext context) {
    final MockTestResult? result = controller.result.value;
    if (result == null) {
      return const Center(child: Text('No result yet.'));
    }
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Mock Test Result', style: AppTextStyles.h1),
              if (controller.kind.value == MockTestKind.custom) ...[
                const SizedBox(height: 6),
                Text(
                  '${controller.displayStudentName} — Score ${result.scoreLabel} · ${result.percentage.toStringAsFixed(1)}%',
                  style: AppTextStyles.h2,
                ),
              ],
              if (controller.autoSubmitted.value) ...[
                const SizedBox(height: 6),
                const Text(
                  'Time ended, so the test was submitted automatically.',
                  style: AppTextStyles.body,
                ),
              ],
              if (controller.activePaper.value != null) ...[
                const SizedBox(height: 6),
                Text(
                  'Practice Paper ${controller.activePaper.value!.paperNo} · '
                  '${controller.activePaper.value!.post}, '
                  '${controller.activePaper.value!.department} · '
                  '${controller.activePaper.value!.examDate}',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
              if (controller.activeCustomSet.value != null) ...[
                const SizedBox(height: 6),
                Text(
                  'Custom test "${controller.activeCustomSet.value!.name}" · '
                  'User-created practice test — not an official paper.',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
              const SizedBox(height: 6),
              const Text(
                'Practice result only — not a real PPSC result.',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: AppDimensions.gapMedium,
                runSpacing: AppDimensions.gapMedium,
                children: [
                  StatCard(
                    label: 'Score',
                    value: result.scoreLabel,
                    width: 160,
                  ),
                  StatCard(
                    label: 'Correct',
                    value: '${result.correct}',
                    width: 130,
                  ),
                  StatCard(
                    label: 'Wrong',
                    value: '${result.wrong}',
                    width: 130,
                  ),
                  StatCard(
                    label: 'Skipped',
                    value: '${result.skipped}',
                    width: 130,
                  ),
                  StatCard(
                    label: 'Percentage',
                    value: '${result.percentage.toStringAsFixed(1)}%',
                    width: 130,
                  ),
                  if (result.negativeMarking)
                    StatCard(
                      label: 'Negative marks',
                      value: '-${result.negativeMarksDeducted.toStringAsFixed(2)}',
                      width: 160,
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    onPressed: controller.backToSetup,
                    icon: const Icon(Icons.replay),
                    label: const Text('Take Another Test'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.ppscUrdu),
                    icon: const Icon(Icons.keyboard_alt_outlined),
                    label: const Text('PPSC Urdu Typing Practice'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Answer Review', style: AppTextStyles.h2),
              const SizedBox(height: 10),
              Obx(() {
                // Reactive read: bookmark toggles rebuild the tiles.
                controller.progress.bookmarks.length;
                return Column(
                  children: [
                    for (int i = 0; i < result.questions.length; i++)
                      _ReviewTile(
                        index: i,
                        question: result.questions[i],
                        selected: result.answers[result.questions[i].id],
                        controller: controller,
                      ),
                  ],
                );
              }),
              if (controller.activeLatestUpdates.isNotEmpty) ...[
                const SizedBox(height: 24),
                SectionCard(
                  title: 'Latest updates',
                  subtitle:
                      'Current-affairs answers in this paper, with the latest position.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final String note
                          in controller.activeLatestUpdates)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '• $note',
                            style: AppTextStyles.body,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({
    required this.index,
    required this.question,
    required this.selected,
    required this.controller,
  });

  final int index;
  final MockQuestion question;
  final int? selected;
  final MockTestController controller;

  @override
  Widget build(BuildContext context) {
    final bool correct = question.isCorrect(selected);
    final bool skipped = selected == null;
    final IconData icon = skipped
        ? Icons.remove_circle_outline
        : correct
        ? Icons.check_circle
        : Icons.cancel;
    final Color color = skipped
        ? AppColors.skippedWord
        : correct
        ? AppColors.correctChar
        : AppColors.wrongChar;
    return Card(
      child: ExpansionTile(
        leading: Icon(icon, color: color),
        title: Text('Q${index + 1}. ${question.question}'),
        subtitle: Text(
          skipped
              ? 'Skipped · Correct answer: ${String.fromCharCode(65 + question.correctIndex)}'
              : correct
              ? 'Correct'
              : 'Your answer: ${String.fromCharCode(65 + selected!)} · Correct answer: ${String.fromCharCode(65 + question.correctIndex)}',
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => controller.toggleBookmark(question),
              icon: Icon(
                controller.isBookmarked(question)
                    ? Icons.bookmark
                    : Icons.bookmark_border,
              ),
              label: Text(
                controller.isBookmarked(question)
                    ? 'Bookmarked'
                    : 'Bookmark this question',
              ),
            ),
          ),
          for (int i = 0; i < question.options.length; i++)
            ListTile(
              dense: true,
              leading: Text(String.fromCharCode(65 + i)),
              title: Text(question.options[i]),
              trailing: i == question.correctIndex
                  ? const Icon(Icons.check, color: AppColors.correctChar)
                  : (i == selected
                        ? const Icon(Icons.close, color: AppColors.wrongChar)
                        : null),
            ),
          if (question.explanation != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Text(
                'Explanation: ${question.explanation!}',
                style: AppTextStyles.body,
              ),
            ),
        ],
      ),
    );
  }
}
