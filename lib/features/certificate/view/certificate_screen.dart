import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/certificate_code.dart';
import '../../../../core/widgets/app_controls.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_surfaces.dart';
import 'certificate_card.dart';

/// The name last used on a certificate, stored only on this device so
/// the user does not have to retype it every time. Never leaves the
/// device; never sent anywhere.
const String certificateNameStorageKey = 'certificate_name';

/// File-level key: stable across rebuilds so the PNG capture always
/// finds the same RepaintBoundary.
final GlobalKey _certificateCardKey = GlobalKey();

/// Certificate screen: the user enters the name that goes on the
/// certificate, then sees the certificate document with its
/// verification code and can copy the code or download the certificate
/// as a PNG. Reached from a mock-test or typing-test result via
/// [GetCertificateButton]; opening it directly without a result shows
/// the honest empty state instead of inventing one.
class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _code;
  CertificateData? _issued;

  CertificateScreenArgs? get _args {
    final Object? raw = Get.arguments;
    return raw is CertificateScreenArgs ? raw : null;
  }

  @override
  void initState() {
    super.initState();
    _loadStoredName();
  }

  Future<void> _loadStoredName() async {
    final String prefilled = _args?.prefilledName?.trim() ?? '';
    if (prefilled.isNotEmpty && prefilled != 'Student') {
      _nameController.text = prefilled;
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String stored = prefs.getString(certificateNameStorageKey) ?? '';
    if (stored.isNotEmpty && mounted) {
      _nameController.text = stored;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final CertificateScreenArgs? args = _args;
    if (args == null) return;
    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Name needed', 'Enter the name for the certificate.');
      return;
    }
    final CertificateData data = CertificateData(
      kind: args.data.kind,
      testLabel: args.data.testLabel,
      holderName: name,
      date: args.data.date,
      score: args.data.score,
      totalQuestions: args.data.totalQuestions,
      correct: args.data.correct,
      wrong: args.data.wrong,
      skipped: args.data.skipped,
      accuracy: args.data.accuracy,
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(certificateNameStorageKey, name);
    setState(() {
      _issued = data;
      _code = encodeCertificateCode(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    final CertificateScreenArgs? args = _args;
    return AppScaffold(
      currentRoute: AppRoutes.certificate,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeader(
                title: 'Practice Certificate',
                subtitle:
                    'A free WolfTyping practice certificate for your result — '
                    'with a verification code anyone can check in the app. '
                    'This is not an official PPSC or government certificate.',
              ),
              const SizedBox(height: 20),
              if (args == null) ...[
                const Text(
                  'No result to certify yet. Complete a mock test or a '
                  'typing test first, then tap "Get Practice Certificate" '
                  'on its result screen.',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () =>
                      Get.toNamed(AppRoutes.certificateVerify),
                  icon: const Icon(Icons.verified_outlined),
                  label: const Text('Verify a Certificate Code'),
                ),
              ] else if (_issued == null || _code == null) ...[
                SectionCard(
                  title: args.data.testLabel,
                  subtitle: args.data.kind == CertificateKind.mock
                      ? 'Score ${args.data.headline} · '
                          '${args.data.correct} correct, '
                          '${args.data.wrong} wrong, '
                          '${args.data.skipped} skipped'
                      : 'Net WPM ${args.data.score.toStringAsFixed(1)} · '
                          'Accuracy ${args.data.accuracy.toStringAsFixed(1)}%',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _nameController,
                        maxLength: CertificateData.maxNameLength,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Name on the certificate',
                          hintText: 'Enter your name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Stored only on this device, and only used on the '
                        'certificate.',
                        style: AppTextStyles.body,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _generate,
                        icon: const Icon(
                          Icons.workspace_premium_outlined,
                        ),
                        label: const Text('Generate Certificate'),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                RepaintBoundary(
                  key: _certificateCardKey,
                  child: PracticeCertificateCard(
                    data: _issued!,
                    code: _code!,
                  ),
                ),
                const SizedBox(height: 12),
                CertificateShareButtons(
                  boundaryKey: _certificateCardKey,
                  code: _code!,
                  fileName: 'wolftyping-certificate.png',
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => Get.toNamed(
                        AppRoutes.certificateVerify,
                        arguments: _code,
                      ),
                      icon: const Icon(Icons.verified_outlined),
                      label: const Text('Verify This Code'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => setState(() {
                        _issued = null;
                        _code = null;
                      }),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Change Name'),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                'How verification works: the code contains the result '
                'itself, plus a checksum the app recomputes. If any part '
                'of the code is changed afterwards, verification fails. '
                'The code proves the result was not altered — it does not '
                'prove the test was supervised or really taken.',
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
