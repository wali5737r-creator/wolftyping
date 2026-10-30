import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/custom_set_share.dart';
import '../../../core/services/custom_set_share_link.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../controller/custom_sets_controller.dart';
import '../controller/mock_test_controller.dart';
import '../model/custom_set.dart';

/// Teacher-created custom MCQ tests: the sets saved on this device,
/// with create / edit / delete, run, and sharing for students on other
/// devices (copyable code + downloadable file on web, import from
/// pasted code or — on web — from a file).
///
/// Everything here is clearly labelled user-created and practice-only:
/// custom sets are never official papers and never reference any
/// source. Tests run through the shared mock-test engine, so they get
/// the same timer, palette, auto-submit and review as sample tests.
///
/// NOTE on shareable links: offered only for small sets, when the
/// full URL is at most 4000 characters (see
/// `custom_set_share_link.dart`). There is no server to host short
/// codes (sets are device-only by design), so larger sets are shared
/// as a code or a file instead — never as a link that silently breaks.
class CustomTestsView extends GetView<CustomSetsController> {
  const CustomTestsView({super.key});

  @override
  Widget build(BuildContext context) {
    _SharedLinkImport.maybeHandle(context, controller);
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
                const PageHeader(
                  title: 'My Custom Tests',
                  subtitle:
                      'Tests you create yourself, saved on this device. '
                      'User-created practice tests only — never official papers.',
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () =>
                          Get.toNamed(AppRoutes.ppscCustomTestEditor),
                      icon: const Icon(Icons.add),
                      label: const Text('Create custom test'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _showImportDialog(context),
                      icon: const Icon(Icons.input),
                      label: const Text('Import a shared test'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Obx(() {
                  // Reactive reads captured directly in this builder.
                  final List<CustomSet> sets = controller.sets.toList();
                  final bool loaded = controller.loaded.value;
                  if (!loaded) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (sets.isEmpty) {
                    return const SectionCard(
                      title: 'No custom tests yet',
                      child: Text(
                        'Create your own MCQ test: give it a name, add '
                        'questions with 4 options each, pick the correct '
                        'answer, then run it or share it with students '
                        'as a code, a file, or — for small tests — a '
                        'shareable link.',
                        style: AppTextStyles.body,
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (final CustomSet set in sets)
                        _CustomSetTile(set: set, controller: controller),
                    ],
                  );
                }),
                const SizedBox(height: 20),
                TextButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.ppscMockTest),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to mock test setup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showImportDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _ImportDialog(controller: controller),
    );
  }
}

class _CustomSetTile extends StatelessWidget {
  const _CustomSetTile({required this.set, required this.controller});

  final CustomSet set;
  final CustomSetsController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.gapMedium),
      child: SectionCard(
        title: set.name,
        subtitle:
            '${set.questionCount} question${set.questionCount == 1 ? '' : 's'} · '
            'User-created practice test — not an official paper.',
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Get.find<MockTestController>().selectCustomSet(set);
                Get.toNamed(AppRoutes.ppscMockTest);
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start this test'),
            ),
            OutlinedButton.icon(
              onPressed: () => Get.toNamed(
                AppRoutes.ppscCustomTestEditor,
                arguments: set,
              ),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit'),
            ),
            OutlinedButton.icon(
              onPressed: () => _showExportDialog(context),
              icon: const Icon(Icons.share_outlined),
              label: const Text('Share'),
            ),
            TextButton.icon(
              onPressed: () => _confirmDelete(context),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showExportDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _ExportDialog(set: set),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this custom test?'),
        content: Text(
          '"${set.name}" will be removed from this device. '
          'Students who already imported it keep their own copy.',
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
      await controller.deleteSet(set.id);
    }
  }
}

class _ExportDialog extends StatelessWidget {
  const _ExportDialog({required this.set});

  final CustomSet set;

  @override
  Widget build(BuildContext context) {
    final String code = set.encode();
    final TextEditingController codeController =
        TextEditingController(text: code);
    return AlertDialog(
      title: Text('Share "${set.name}"'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Students paste this code into Import on their own device, '
              'open the downloaded file the same way, or open the '
              'shareable link (small tests only). This is a '
              'user-created practice test, not an official paper.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: codeController,
              readOnly: true,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Share code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Share code copied.'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy code'),
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(text: _shareText(set, code)),
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Share text copied.'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.text_snippet_outlined),
                  label: const Text('Copy share text'),
                ),
                if (kIsWeb) _ShareLinkButton(set: set),
                if (kIsWeb)
                  OutlinedButton.icon(
                    onPressed: () async {
                      final bool ok = await downloadCustomSetFile(
                        CustomSetsController.fileNameFor(set),
                        jsonEncode(set.toJson()),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              ok
                                  ? 'File downloaded.'
                                  : 'Could not download the file.',
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('Download file'),
                  )
                else
                  const Text(
                    'File download is available on the web version; '
                    'on this device, use Copy code.',
                    style: AppTextStyles.body,
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done'),
        ),
      ],
    );
  }
}


String _shareText(CustomSet set, String code) {
  final String base =
      'Try my practice test "${set.name}" '
      '(${set.questionCount} question${set.questionCount == 1 ? '' : 's'}) '
      'on WolfTyping. Open My Custom Tests and choose Import a shared test';
  // The code travels in the share text only when it fits comfortably;
  // for large sets the student uses the code or file from the share
  // sheet instead.
  if (code.length <= 1000) {
    return '$base, then paste this code: $code';
  }
  return '$base, then paste the code or open the file from the share sheet.';
}

/// Copy-share-link button, shown only on web and only when the full
/// URL fits in 4000 characters. Larger tests show a plain note
/// instead — never a link that does not work.
class _ShareLinkButton extends StatelessWidget {
  const _ShareLinkButton({required this.set});

  final CustomSet set;

  @override
  Widget build(BuildContext context) {
    final String? link = buildCustomSetShareLink(
      origin: Uri.base.origin,
      set: set,
    );
    if (link == null) {
      return const Text(
        'This test is too large for a shareable link — share the code '
        'or file instead.',
        style: AppTextStyles.body,
      );
    }
    return OutlinedButton.icon(
      onPressed: () async {
        await Clipboard.setData(ClipboardData(text: link));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Share link copied.')),
          );
        }
      },
      icon: const Icon(Icons.link_outlined),
      label: const Text('Copy share link'),
    );
  }
}

/// Reads a shareable-link import parameter out of the URL hash
/// fragment once (web only), validates it, and offers to save it.
/// Runs at most once per app run; a fragment without an import
/// parameter is ignored silently.
class _SharedLinkImport {
  static bool _handled = false;

  static void maybeHandle(
    BuildContext context,
    CustomSetsController controller,
  ) {
    if (!kIsWeb || _handled) return;
    _handled = true;
    final String? code =
        extractImportCodeFromFragment(Uri.base.fragment);
    if (code == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      CustomSet decoded;
      try {
        decoded = CustomSet.decode(code);
      } on FormatException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
        return;
      }
      showDialog<void>(
        context: context,
        builder: (dialogContext) => _LinkImportDialog(
          controller: controller,
          code: code,
          decoded: decoded,
        ),
      );
    });
  }
}

class _LinkImportDialog extends StatefulWidget {
  const _LinkImportDialog({
    required this.controller,
    required this.code,
    required this.decoded,
  });

  final CustomSetsController controller;
  final String code;
  final CustomSet decoded;

  @override
  State<_LinkImportDialog> createState() => _LinkImportDialogState();
}

class _LinkImportDialogState extends State<_LinkImportDialog> {
  String? _error;
  bool _busy = false;

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final CustomSet imported =
          await widget.controller.importCode(widget.code);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Imported "${imported.name}" '
            '(${imported.questionCount} questions).',
          ),
        ),
      );
    } on FormatException catch (e) {
      setState(() {
        _error = e.message;
        _busy = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Could not import this test: $e';
        _busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save this shared test?'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '"${widget.decoded.name}" — '
              '${widget.decoded.questionCount} question${widget.decoded.questionCount == 1 ? '' : 's'}. '
              'User-created practice test — not an official paper.',
              style: AppTextStyles.body,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _busy ? null : _save,
          child: const Text('Save test'),
        ),
      ],
    );
  }
}

class _ImportDialog extends StatefulWidget {
  const _ImportDialog({required this.controller});

  final CustomSetsController controller;

  @override
  State<_ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<_ImportDialog> {
  final TextEditingController _codeController = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _import(String code) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final CustomSet imported = await widget.controller.importCode(code);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Imported "${imported.name}" '
            '(${imported.questionCount} questions).',
          ),
        ),
      );
    } on FormatException catch (e) {
      setState(() {
        _error = e.message;
        _busy = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Could not import this test: $e';
        _busy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Import a shared test'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Paste the share code a teacher sent you. Bad codes are '
              'rejected with an explanation — nothing is saved until '
              'the whole test checks out.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _codeController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Share code',
                border: OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            if (kIsWeb) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _busy
                    ? null
                    : () async {
                        final String? text =
                            await pickCustomSetFileText();
                        if (text == null) return;
                        _codeController.text = text;
                        await _import(text);
                      },
                icon: const Icon(Icons.upload_file_outlined),
                label: const Text('Choose file instead'),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _busy ? null : () => _import(_codeController.text),
          child: const Text('Import'),
        ),
      ],
    );
  }
}
