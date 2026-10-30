import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../controller/custom_sets_controller.dart';
import '../model/custom_set.dart';
import '../model/mock_question.dart';
import '../service/custom_sets_repository.dart';

/// Create / edit screen for one teacher-created custom MCQ set:
/// set name plus add / edit / delete questions, each with question
/// text, exactly 4 options, a correct-answer picker, and an optional
/// subject and topic.
///
/// The set is only saved when it fully validates (non-empty name,
/// at least one question, every question with 4 non-empty options);
/// otherwise the first problem is shown and nothing is saved.
/// Labelled user-created and practice-only throughout — never an
/// official paper.
class CustomSetEditorView extends StatefulWidget {
  const CustomSetEditorView({super.key});

  @override
  State<CustomSetEditorView> createState() => _CustomSetEditorViewState();
}

class _QuestionDraft {
  _QuestionDraft({required this.id});

  final String id;
  final TextEditingController question = TextEditingController();
  final List<TextEditingController> options =
      List<TextEditingController>.generate(
        4,
        (_) => TextEditingController(),
      );
  final TextEditingController topic = TextEditingController();
  MockSubject subject = MockSubject.generalKnowledge;
  int correctIndex = 0;

  void dispose() {
    question.dispose();
    for (final TextEditingController c in options) {
      c.dispose();
    }
    topic.dispose();
  }
}

class _CustomSetEditorViewState extends State<CustomSetEditorView> {
  final TextEditingController _nameController = TextEditingController();
  final List<_QuestionDraft> _drafts = <_QuestionDraft>[];
  CustomSet? _editing;

  @override
  void initState() {
    super.initState();
    final Object? argument = Get.arguments;
    if (argument is CustomSet) {
      _editing = argument;
      _nameController.text = argument.name;
      for (final MockQuestion q in argument.questions) {
        final _QuestionDraft draft = _QuestionDraft(id: q.id)
          ..question.text = q.question
          ..subject = q.subject
          ..correctIndex = q.correctIndex
          ..topic.text = q.topic ?? '';
        for (int i = 0; i < 4; i++) {
          draft.options[i].text = q.options[i];
        }
        _drafts.add(draft);
      }
    } else {
      _drafts.add(_QuestionDraft(id: CustomSetsRepository.newId()));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (final _QuestionDraft draft in _drafts) {
      draft.dispose();
    }
    super.dispose();
  }

  String? _validate() {
    if (_nameController.text.trim().isEmpty) {
      return 'Give the test a name first.';
    }
    if (_drafts.isEmpty) {
      return 'Add at least one question.';
    }
    for (int qi = 0; qi < _drafts.length; qi++) {
      final _QuestionDraft draft = _drafts[qi];
      if (draft.question.text.trim().isEmpty) {
        return 'Question ${qi + 1} has no question text.';
      }
      for (int i = 0; i < 4; i++) {
        if (draft.options[i].text.trim().isEmpty) {
          return 'Question ${qi + 1} is missing option '
              '${String.fromCharCode(65 + i)}.';
        }
      }
    }
    return null;
  }

  Future<void> _save() async {
    final String? error = _validate();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }
    final CustomSet set = CustomSet(
      id: _editing?.id ?? CustomSetsRepository.newId(),
      name: _nameController.text.trim(),
      questions: _drafts
          .map(
            (d) => MockQuestion(
              id: d.id,
              subject: d.subject,
              question: d.question.text.trim(),
              options: d.options.map((c) => c.text.trim()).toList(),
              correctIndex: d.correctIndex,
              topic: d.topic.text.trim().isEmpty
                  ? null
                  : d.topic.text.trim(),
            ),
          )
          .toList(),
    );
    try {
      await Get.find<CustomSetsController>().saveSet(set);
    } on FormatException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
      return;
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved "${set.name}".')),
      );
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.ppscCustomTests,
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageHeader(
                  title: _editing == null
                      ? 'Create Custom Test'
                      : 'Edit Custom Test',
                  subtitle:
                      'User-created practice test only — never an official paper.',
                ),
                const SizedBox(height: 20),
                const Text('Set name', style: AppTextStyles.h3),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Class 9 Science Quiz 1',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                for (int qi = 0; qi < _drafts.length; qi++)
                  _QuestionCard(
                    index: qi,
                    draft: _drafts[qi],
                    canDelete: _drafts.length > 1,
                    onChanged: () => setState(() {}),
                    onDelete: () {
                      setState(() {
                        final _QuestionDraft removed =
                            _drafts.removeAt(qi);
                        removed.dispose();
                      });
                    },
                  ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _drafts.add(
                        _QuestionDraft(
                          id: CustomSetsRepository.newId(),
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add question'),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Save set'),
                    ),
                    TextButton.icon(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                      label: const Text('Cancel'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.index,
    required this.draft,
    required this.canDelete,
    required this.onChanged,
    required this.onDelete,
  });

  final int index;
  final _QuestionDraft draft;
  final bool canDelete;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SectionCard(
        title: 'Question ${index + 1}',
        trailing: canDelete
            ? IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete question',
                onPressed: onDelete,
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Question', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            TextField(
              controller: draft.question,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Write the question here',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Options — pick the correct answer on the left.',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 8),
            RadioGroup<int>(
              groupValue: draft.correctIndex,
              onChanged: (v) {
                if (v != null) {
                  draft.correctIndex = v;
                  onChanged();
                }
              },
              child: Column(
                children: [
                  for (int i = 0; i < 4; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Radio<int>(value: i),
                          Expanded(
                            child: TextField(
                              controller: draft.options[i],
                              decoration: InputDecoration(
                                labelText:
                                    'Option ${String.fromCharCode(65 + i)}',
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Subject: '),
                DropdownButton<MockSubject>(
                  value: draft.subject,
                  items: [
                    for (final MockSubject s in MockSubject.values)
                      DropdownMenuItem<MockSubject>(
                        value: s,
                        child: Text(s.label),
                      ),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      draft.subject = v;
                      onChanged();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: draft.topic,
              decoration: const InputDecoration(
                labelText: 'Topic (optional)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
