import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/certificate_code.dart';
import '../../../../core/widgets/app_controls.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_surfaces.dart';
import '../service/last_certificate_store.dart';
import 'certificate_card.dart';

/// The name last used on a certificate, stored only on this device so
/// the user does not have to retype it every time. Never leaves the
/// device; never sent anywhere.
const String certificateNameStorageKey = 'certificate_name';

/// Key for the certificate's RepaintBoundary, owned by this screen's
/// state: stable across rebuilds (the State outlives them) so the
/// PNG capture always finds the same boundary, but distinct per
/// screen — a file-level key collided when two certificate screens
/// coexisted (e.g. navigating to #/certificate while one was already
/// shown) and crashed the tree with a duplicate GlobalKey.

/// Certificate screen: the user enters the name that goes on the
/// certificate, then sees the certificate document with its
/// verification code and can copy the code or download the certificate
/// as a PNG. Reached from a mock-test or typing-test result via
/// [GetCertificateButton]. The last GENERATED certificate is kept on
/// the device (see [LastCertificateStore]), so a direct visit to
/// `#/certificate` — or a reload — after generating still shows the
/// certificate; opening it directly with no generated certificate
/// shows the honest empty state instead of inventing one.
class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey _certificateCardKey = GlobalKey();
  String? _code;
  CertificateData? _issued;

  /// The result being certified, restored from the device store when
  /// the screen was opened directly (no navigation arguments).
  CertificateData? _resultData;

  CertificateScreenArgs? get _args {
    final Object? raw = Get.arguments;
    return raw is CertificateScreenArgs ? raw : null;
  }

  @override
  void initState() {
    super.initState();
    _loadStoredName();
    _restoreCertificate();
  }

  /// Restores the last generated certificate when the screen was
  /// opened directly (deep link, reload, Back after the result is
  /// gone). Navigation arguments always win: a fresh result from a
  /// result screen is certified, never the stored one.
  Future<void> _restoreCertificate() async {
    if (_args != null) return;
    final StoredCertificate? stored =
        await LastCertificateStore.instance.load();
    if (stored == null || !mounted) return;
    setState(() {
      _resultData = stored.data;
      _issued = stored.data;
      _code = stored.code;
    });
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
    final CertificateData? resultData = _args?.data ?? _resultData;
    if (resultData == null) return;
    final String name = _nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Name needed', 'Enter the name for the certificate.');
      return;
    }
    final CertificateData data = CertificateData(
      kind: resultData.kind,
      testLabel: resultData.testLabel,
      holderName: name,
      date: resultData.date,
      score: resultData.score,
      totalQuestions: resultData.totalQuestions,
      correct: resultData.correct,
      wrong: resultData.wrong,
      skipped: resultData.skipped,
      accuracy: resultData.accuracy,
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(certificateNameStorageKey, name);
    final String code = encodeCertificateCode(data);
    // Keep the generated certificate on this device so a direct
    // visit or a reload still shows it (see _restoreCertificate).
    await LastCertificateStore.instance.save(data, code);
    setState(() {
      _issued = data;
      _code = code;
    });
  }

  /// Back to the name form. The stored certificate is forgotten too,
  /// so a reload after "Change Name" shows the name form, not the
  /// certificate the user went back to edit.
  Future<void> _changeName() async {
    await LastCertificateStore.instance.clear();
    if (!mounted) return;
    setState(() {
      _issued = null;
      _code = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // A fresh result from navigation wins; otherwise the last
    // generated certificate restored from this device.
    final CertificateData? data = _args?.data ?? _resultData;
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
              if (data == null) ...[
                const Text(
                  'No result to certify yet. Complete a mock test or a '
                  'typing test first, then tap "Get Practice Certificate" '
                  'on its result screen.',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.certificateVerify),
                  icon: const Icon(Icons.verified_outlined),
                  label: const Text('Verify a Certificate Code'),
                ),
              ] else if (_issued == null || _code == null) ...[
                SectionCard(
                  title: data.testLabel,
                  subtitle: data.kind == CertificateKind.mock
                      ? 'Score ${data.headline} · '
                          '${data.correct} correct, '
                          '${data.wrong} wrong, '
                          '${data.skipped} skipped'
                      : 'Net WPM ${data.score.toStringAsFixed(1)} · '
                          'Accuracy ${data.accuracy.toStringAsFixed(1)}%',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _nameController,
                        // Focused as soon as the screen opens: entering
                        // the name is the whole job here, and on
                        // Flutter web the DOM input element only
                        // exists while the field is focused — without
                        // this, a first fill (e.g. from a browser
                        // automation) failed with "not_editable" until
                        // the field was tapped first.
                        autofocus: true,
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
                      onPressed: _changeName,
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
