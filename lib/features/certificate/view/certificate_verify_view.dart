import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/certificate_code.dart';
import '../../../../core/widgets/app_controls.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_surfaces.dart';

/// Verify a practice-certificate code, entirely on the device: paste
/// the code, and the app decodes it, recomputes its checksum and shows
/// the result it carries — or rejects it with a plain reason. No
/// server, no account, no network.
///
/// The screen also says plainly what verification does not prove: the
/// code shows the result was not altered after it was created, not
/// that the test was supervised or really taken.
class CertificateVerifyView extends StatefulWidget {
  const CertificateVerifyView({super.key});

  @override
  State<CertificateVerifyView> createState() => _CertificateVerifyViewState();
}

class _CertificateVerifyViewState extends State<CertificateVerifyView> {
  final TextEditingController _codeController = TextEditingController();
  CertificateData? _verified;
  String? _error;

  @override
  void initState() {
    super.initState();
    final Object? raw = Get.arguments;
    if (raw is String && raw.isNotEmpty) {
      _codeController.text = raw;
      _verify();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verify() {
    final String code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _verified = null;
        _error = 'Paste a certificate code first.';
      });
      return;
    }
    try {
      final CertificateData data = decodeCertificateCode(code);
      setState(() {
        _verified = data;
        _error = null;
      });
    } on FormatException catch (e) {
      setState(() {
        _verified = null;
        _error = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.certificateVerify,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeader(
                title: 'Verify Certificate',
                subtitle:
                    'Paste a WolfTyping practice-certificate code to check '
                    'the result it carries. Checked on this device — '
                    'nothing is sent anywhere.',
              ),
              const SizedBox(height: 20),
              SectionCard(
                title: 'Certificate code',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _codeController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Verification code',
                        hintText: 'WT1.…',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _verify,
                      icon: const Icon(Icons.verified_outlined),
                      label: const Text('Verify Code'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_error != null)
                SectionCard(
                  title: 'Code not valid',
                  child: Text(_error!, style: AppTextStyles.body),
                ),
              if (_verified != null) ...[
                SectionCard(
                  title: 'Certificate verified',
                  subtitle:
                      'The code checks out — it was not changed after it '
                      'was created.',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Row('Awarded to', _verified!.holderName),
                      _Row('Test', _verified!.testLabel),
                      _Row(
                        _verified!.kind == CertificateKind.mock
                            ? 'Score'
                            : 'Net WPM',
                        _verified!.headline,
                      ),
                      if (_verified!.kind == CertificateKind.mock)
                        _Row(
                          'Correct / Wrong / Skipped',
                          '${_verified!.correct} / ${_verified!.wrong} / '
                          '${_verified!.skipped}',
                        )
                      else ...[
                        _Row(
                          'Accuracy',
                          '${_verified!.accuracy.toStringAsFixed(1)}%',
                        ),
                        _Row(
                          'Correct / Wrong characters',
                          '${_verified!.correct} / ${_verified!.wrong}',
                        ),
                      ],
                      _Row(
                        'Completed',
                        '${_verified!.date.day}/${_verified!.date.month}/'
                        '${_verified!.date.year}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'This only proves the code was not altered after it was '
                  'created. It does not prove the test was supervised or '
                  'really taken — a WolfTyping practice certificate is not '
                  'an official PPSC or government certificate.',
                  style: AppTextStyles.body,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
