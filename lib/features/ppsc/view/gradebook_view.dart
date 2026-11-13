import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../controller/gradebook_controller.dart';
import '../model/gradebook_entry.dart';

/// Gradebook: every recorded custom-test result, grouped by the
/// custom test name, with attempts, average and best score per test.
///
/// Results get here two ways: a custom test finished on this device
/// is recorded automatically (same result, same code, never twice),
/// or the teacher pastes a student's WT1 result code, which is
/// verified (checksum + impossible-result checks) before it is
/// added. A code proves the result was not changed after it was
/// created; it does NOT prove the test was supervised — the screen
/// says so plainly, as the certificate screens do.
///
/// Everything is labelled practice-only: custom tests are never
/// official papers. Export is JSON (full entries incl. codes) and
/// CSV (one row per entry), web only. There is no import.
class GradebookView extends GetView<GradebookController> {
  const GradebookView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.gradebook,
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeader(
                  title: 'Gradebook',
                  subtitle:
                      'Recorded results for your custom tests, grouped '
                      'by test. Practice results only — never official '
                      'papers or results.',
                ),
                const SizedBox(height: 12),
                const Text(
                  'A result code proves the result was not changed after '
                  'it was created; it does not prove the test was '
                  'supervised.',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 20),
                _AddCodeCard(controller: controller),
                const SizedBox(height: 20),
                Obx(() {
                  final bool loaded = controller.loaded.value;
                  if (!loaded) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final List<GradebookEntry> entries =
                      controller.entries.toList();
                  if (entries.isEmpty) {
                    return const SectionCard(
                      title: 'No results recorded yet',
                      child: Text(
                        'Finish a custom test on this device and its '
                        'result is recorded here automatically, or paste '
                        'a student\'s WT1 result code above to add it.',
                        style: AppTextStyles.body,
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          if (kIsWeb) ...[
                            OutlinedButton.icon(
                              onPressed: () async {
                                final String? message =
                                    await controller.exportJson();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        message ??
                                            'Downloads are not available '
                                                'on this device.',
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.download_outlined),
                              label: const Text('Export JSON'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () async {
                                final String? message =
                                    await controller.exportCsv();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        message ??
                                            'Downloads are not available '
                                                'on this device.',
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.table_chart_outlined),
                              label: const Text('Export CSV'),
                            ),
                          ] else
                            const Text(
                              'Export (JSON / CSV) is available on the '
                              'web version.',
                              style: AppTextStyles.body,
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      for (final GradebookGroup group in controller.groups)
                        _GradebookGroupCard(
                          group: group,
                          controller: controller,
                        ),
                    ],
                  );
                }),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.ppscCustomTests),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to My Custom Tests'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Paste-a-code card: a taker's WT1 code is verified before anything
/// is saved. Bad, tampered and typing-test codes are rejected with a
/// plain message; a code already recorded is reported, not duplicated.
class _AddCodeCard extends StatefulWidget {
  const _AddCodeCard({required this.controller});

  final GradebookController controller;

  @override
  State<_AddCodeCard> createState() => _AddCodeCardState();
}

class _AddCodeCardState extends State<_AddCodeCard> {
  final TextEditingController _codeController = TextEditingController();
  String? _message;
  bool _isError = false;
  bool _busy = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final String code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _message = 'Paste a WT1 result code first.';
        _isError = true;
      });
      return;
    }
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final GradebookEntry? entry =
          await widget.controller.recordCode(code);
      if (!mounted) return;
      setState(() {
        _busy = false;
        if (entry == null) {
          _message = 'That result is already in the gradebook.';
          _isError = false;
        } else {
          _message =
              'Added ${entry.holderName} — ${entry.scoreLabel} '
              'in "${entry.testLabel}".';
          _isError = false;
          _codeController.clear();
        }
      });
    } on FormatException catch (e) {
      if (!mounted) return;
      setState(() {
        _message = e.message;
        _isError = true;
        _busy = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _message = 'Could not add this result: $e';
        _isError = true;
        _busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Add a result code',
      subtitle:
          'Paste a student\'s WT1 result code. It is checked before it '
          'is added — a changed or typing-test code is rejected.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _codeController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'WT1 result code',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _busy ? null : _add,
            icon: const Icon(Icons.add),
            label: const Text('Add result'),
          ),
          if (_message != null) ...[
            const SizedBox(height: 12),
            Text(
              _message!,
              style: _isError
                  ? TextStyle(color: Theme.of(context).colorScheme.error)
                  : AppTextStyles.body,
            ),
          ],
        ],
      ),
    );
  }
}

class _GradebookGroupCard extends StatelessWidget {
  const _GradebookGroupCard({
    required this.group,
    required this.controller,
  });

  final GradebookGroup group;
  final GradebookController controller;

  @override
  Widget build(BuildContext context) {
    final bool hasSet = controller.hasMatchingSet(group.testLabel);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.gapMedium),
      child: SectionCard(
        title: group.testLabel,
        subtitle:
            '${group.attempts} attempt${group.attempts == 1 ? '' : 's'} · '
            'Average ${group.averageScore.toStringAsFixed(1)} '
            '(${group.averagePercentage.toStringAsFixed(1)}%) · '
            'Best ${group.bestScore.toStringAsFixed(1)}',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!hasSet)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'No matching custom test on this device — the test '
                  'may have been deleted. Results are kept as recorded.',
                  style: AppTextStyles.body,
                ),
              ),
            for (final GradebookEntry entry in group.entries)
              _GradebookEntryRow(entry: entry, controller: controller),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _confirmClearGroup(context),
              icon: const Icon(Icons.delete_outline),
              label: Text('Clear "${group.testLabel}" results'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmClearGroup(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Clear "${group.testLabel}" results?'),
        content: Text(
          'All ${group.attempts} recorded result'
          '${group.attempts == 1 ? '' : 's'} for "${group.testLabel}" '
          'will be removed from this device. This cannot be undone — '
          'export first if you need a copy.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep them'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Clear results'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.clearGroup(group.testLabel);
    }
  }
}

class _GradebookEntryRow extends StatelessWidget {
  const _GradebookEntryRow({
    required this.entry,
    required this.controller,
  });

  final GradebookEntry entry;
  final GradebookController controller;

  @override
  Widget build(BuildContext context) {
    final String date =
        '${entry.date.year}-${entry.date.month.toString().padLeft(2, '0')}-'
        '${entry.date.day.toString().padLeft(2, '0')}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.holderName} — ${entry.scoreLabel} '
                  '(${entry.percentage.toStringAsFixed(1)}%)',
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  'Correct ${entry.correct} · Wrong ${entry.wrong} · '
                  'Skipped ${entry.skipped} · $date · ${entry.source}',
                  style: AppTextStyles.body,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete this result',
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this result?'),
        content: Text(
          '"${entry.holderName} — ${entry.scoreLabel}" in '
          '"${entry.testLabel}" will be removed from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep it'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.deleteEntry(entry.code);
    }
  }
}
