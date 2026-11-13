import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/certificate_code.dart';
import '../../../../core/services/result_share.dart';

/// A practice certificate as a printable document — deliberately a
/// separate widget from [ShareableResultCard]: the result card stays a
/// result card, and this is the certificate. It always renders the
/// fixed L1 light tokens (like the result card) so the downloaded PNG
/// looks the same in light and dark mode.
///
/// The certificate states plainly that it is a WolfTyping *practice*
/// certificate, never an official PPSC or government certificate, and
/// it prints the verification code so anyone can check the result
/// again in the app (Profile → Verify certificate).
class PracticeCertificateCard extends StatelessWidget {
  const PracticeCertificateCard({
    super.key,
    required this.data,
    required this.code,
  });

  final CertificateData data;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 560,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.workspace_premium_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'WOLFTYPING',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              const Text(
                'PRACTICE CERTIFICATE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightTextSecondary,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Certificate of Practice',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.testLabel,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Awarded to',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.holderName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 28,
            runSpacing: 12,
            children: [
              _BigStat(
                label: data.kind == CertificateKind.mock
                    ? 'Score'
                    : 'Net WPM',
                value: data.headline,
              ),
              if (data.kind == CertificateKind.mock)
                _BigStat(
                  label: 'Correct / Wrong / Skipped',
                  value: '${data.correct} / ${data.wrong} / ${data.skipped}',
                )
              else
                _BigStat(
                  label: 'Accuracy',
                  value: '${data.accuracy.toStringAsFixed(1)}%',
                ),
            ],
          ),
          const SizedBox(height: 16),
          _DetailRow('Test', data.testLabel),
          _DetailRow('Completed', _formatDate(data.date)),
          if (data.kind == CertificateKind.typing) ...[
            _DetailRow('Correct characters', '${data.correct}'),
            _DetailRow('Wrong characters', '${data.wrong}'),
          ],
          const SizedBox(height: 16),
          const Text(
            'Verification code',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          SelectableText(
            code,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'WolfTyping practice certificate — not an official PPSC or '
            'government certificate. Verify this code in the WolfTyping '
            'app: Profile → Verify certificate.',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BigStat extends StatelessWidget {
  const _BigStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.lightTextPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.lightTextSecondary),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.lightTextPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime d) {
  final String day = d.day.toString().padLeft(2, '0');
  final String month = d.month.toString().padLeft(2, '0');
  return '$day/$month/${d.year}';
}

/// Buttons under a [PracticeCertificateCard]: copy the verification
/// code (everywhere) and download the certificate as a PNG (web only).
class CertificateShareButtons extends StatelessWidget {
  const CertificateShareButtons({
    super.key,
    required this.boundaryKey,
    required this.code,
    required this.fileName,
  });

  final GlobalKey boundaryKey;
  final String code;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        OutlinedButton.icon(
          onPressed: () async {
            await copyResultText(code);
            Get.snackbar('Copied', 'Verification code copied to the clipboard.');
          },
          icon: const Icon(Icons.copy_outlined),
          label: const Text('Copy Verification Code'),
        ),
        if (kIsWeb)
          ElevatedButton.icon(
            onPressed: () async {
              final bool ok =
                  await downloadResultCardPng(boundaryKey, fileName);
              Get.snackbar(
                ok ? 'Downloaded' : 'Could not download',
                ok
                    ? 'Your practice certificate was downloaded as a PNG image.'
                    : 'The certificate could not be captured. Try again.',
              );
            },
            icon: const Icon(Icons.download_outlined),
            label: const Text('Download Certificate'),
          ),
      ],
    );
  }
}

/// Arguments for the certificate screen: the result to certify, plus
/// an optional name to prefill (a custom test already asked for one).
/// The name is entered/confirmed on the screen, never assumed.
class CertificateScreenArgs {
  const CertificateScreenArgs({required this.data, this.prefilledName});

  final CertificateData data;
  final String? prefilledName;
}
class GetCertificateButton extends StatelessWidget {
  const GetCertificateButton({
    super.key,
    required this.data,
    this.prefilledName,
  });

  final CertificateData data;
  final String? prefilledName;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => Get.toNamed(
        AppRoutes.certificate,
        arguments: CertificateScreenArgs(
          data: data,
          prefilledName: prefilledName,
        ),
      ),
      icon: const Icon(Icons.workspace_premium_outlined),
      label: const Text('Get Practice Certificate'),
    );
  }
}
