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
import '../model/mock_question.dart';
import '../service/mock_test_engine.dart';

/// PPSC practice MCQ mock test: timed questions answered one at a time,
/// with a question palette, instant result and per-question review.
///
/// The questions are PRACTICE SAMPLES (see `mock_questions.dart`) — the
/// screens say so, and never claim to be real PPSC papers. Results are
/// not saved to history: this is a practice quiz, not a typing test.
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeader(
                title: 'PPSC Practice Mock Test',
                subtitle:
                    'Timed MCQ practice. Questions are practice samples — not real PPSC past papers.',
              ),
              const SizedBox(height: 20),
              Obx(() => _KindChoice(controller: controller)),
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
                      : '${controller.subject.value?.label ?? ''} short test',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$count question${count == 1 ? '' : 's'} · ${controller.selectedDuration.value.inMinutes} minutes · one question at a time',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Practice sample questions only. To run a full 100-question test, add your questions to lib/features/ppsc/service/mock_questions.dart — the engine adapts to however many questions are in the file.',
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
            ],
          ),
        ),
      ),
    );
  }
}

class _KindChoice extends StatelessWidget {
  const _KindChoice({required this.controller});

  final MockTestController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                title: Text('Subject-wise short test'),
                subtitle:
                    Text('One subject only, e.g. 20 questions per subject.'),
                value: MockTestKind.subject,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------
// Test
// ---------------------------------------------------------------------

class _TestPanel extends StatelessWidget {
  const _TestPanel({required this.controller});

  final MockTestController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Reactive reads (timer, answers, navigation) rebuild this panel.
      controller.remaining.value;
      controller.answersTick.value;
      final int index = controller.currentIndex.value;
      final MockTestEngine engine = controller.engine;
      final MockQuestion question = engine.questions[index];
      final int? selected = controller.selectedFor(question);
      final bool warning = controller.timeWarning;
      final Color timerColor = warning
          ? AppColors.wrongChar
          : Theme.of(context).colorScheme.primary;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Question ${index + 1} of ${engine.totalQuestions}',
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
              'Answered ${engine.answeredCount} · Unanswered ${engine.unansweredCount}',
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
            const SizedBox(height: 16),
            SectionCard(
              title: question.subject.label,
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
                          onPressed: () => controller.selectOption(i),
                          child: Text(
                            '${String.fromCharCode(65 + i)}. ${question.options[i]}',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                OutlinedButton.icon(
                  onPressed: index > 0 ? controller.previousQuestion : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                ),
                ElevatedButton.icon(
                  onPressed: index < engine.totalQuestions - 1
                      ? controller.nextQuestion
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                ),
                TextButton(
                  onPressed: selected == null
                      ? null
                      : controller.clearCurrentAnswer,
                  child: const Text('Clear answer'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () => _confirmSubmit(context),
                  icon: const Icon(Icons.check),
                  label: const Text('Submit Test'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SectionCard(
              title: 'Question Palette',
              subtitle: 'Tap a number to jump to that question.',
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 52,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                itemCount: engine.totalQuestions,
                itemBuilder: (context, i) {
                  final MockQuestion q = engine.questions[i];
                  final bool answered =
                      engine.isAnsweredQuestion(q.id);
                  final bool current = i == index;
                  return SizedBox(
                    height: 40,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: answered
                            ? Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.85)
                            : null,
                        foregroundColor: answered ? Colors.white : null,
                        side: current
                            ? BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              )
                            : null,
                      ),
                      onPressed: () => controller.goToQuestion(i),
                      child: Text('${i + 1}'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Palette: filled = answered, outlined = current question.',
              style: AppTextStyles.captionOf(context),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _confirmSubmit(BuildContext context) async {
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
              if (controller.autoSubmitted.value) ...[
                const SizedBox(height: 6),
                const Text(
                  'Time ended, so the test was submitted automatically.',
                  style: AppTextStyles.body,
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
              for (int i = 0; i < result.questions.length; i++)
                _ReviewTile(
                  index: i,
                  question: result.questions[i],
                  selected: result.answers[result.questions[i].id],
                ),
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
  });

  final int index;
  final MockQuestion question;
  final int? selected;

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
        ],
      ),
    );
  }
}
