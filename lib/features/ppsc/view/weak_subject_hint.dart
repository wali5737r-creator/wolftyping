import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_controls.dart';
import '../controller/mock_test_controller.dart';
import '../model/mock_attempt.dart';
import '../model/mock_question.dart';
import '../service/mock_progress_repository.dart';

/// Weakest-subject hint, built ONLY from recorded attempts on this
/// device. Shows the basis plainly ('English: 4/10 correct in your
/// recorded tests') and a one-tap action to practise that subject's
/// sample test. With no attempts — or too few answered questions to
/// judge — it shows a neutral prompt and never invents data.
class WeakSubjectHint extends StatelessWidget {
  const WeakSubjectHint({
    super.key,
    required this.controller,
    required this.onPractiseSubject,
  });

  final MockTestController controller;
  final void Function(MockSubject subject) onPractiseSubject;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Reactive read: the hint updates when an attempt is recorded.
      MockProgressRepository.instance.attempts.length;
      final List<SubjectAttemptStats> stats = controller.weakestSubjects;
      if (stats.isEmpty) {
        return const SectionCard(
          title: 'Weakest subject',
          child: Text(
            'Take a paper or mock test first — your weakest subject '
            'will be suggested here from your real results.',
            style: AppTextStyles.body,
          ),
        );
      }
      final SubjectAttemptStats weakest = stats.first;
      return SectionCard(
        title: 'Weakest subject',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${weakest.subject.label}: ${weakest.correct}/${weakest.total} '
              'correct in your recorded tests.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => onPractiseSubject(weakest.subject),
              icon: const Icon(Icons.play_arrow),
              label: Text('Practise ${weakest.subject.label} test'),
            ),
          ],
        ),
      );
    });
  }
}
