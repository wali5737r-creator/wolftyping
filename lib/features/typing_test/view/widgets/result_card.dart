import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/result_share.dart';
import '../../model/typing_snapshot.dart';

/// A clean, self-contained result card for sharing: net WPM, accuracy,
/// duration and date. It is rendered with explicit light colours so the
/// downloaded PNG looks the same in light and dark mode.
///
/// Wrap it in a [RepaintBoundary] with a stable [GlobalKey] and pass that
/// key to [ResultShareButtons] to enable the PNG download on web.
class ShareableResultCard extends StatelessWidget {
  const ShareableResultCard({
    super.key,
    required this.snapshot,
    required this.title,
    required this.subtitle,
    required this.completedAt,
  });

  final TypingSnapshot snapshot;
  final String title;
  final String subtitle;
  final DateTime completedAt;

  @override
  Widget build(BuildContext context) {
    final TypingSnapshot s = snapshot;
    return Container(
      width: 420,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(Icons.keyboard, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'TYPING MASTER',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1D23),
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF5A6372),
              ),
            ),
          ],
          const SizedBox(height: 18),
          Row(
            children: [
              _BigStat(
                label: 'Net WPM',
                value: s.netWpm.toStringAsFixed(0),
              ),
              const SizedBox(width: 24),
              _BigStat(
                label: 'Accuracy',
                value: '${s.accuracy.toStringAsFixed(0)}%',
              ),
            ],
          ),
          const SizedBox(height: 14),
          _DetailRow('Gross WPM', s.grossWpm.toStringAsFixed(1)),
          _DetailRow('Duration', _formatElapsed(s.elapsed)),
          _DetailRow('Correct / Wrong', '${s.correctCharacters} / ${s.wrongCharacters}'),
          _DetailRow('Total errors', '${s.totalErrors}'),
          const SizedBox(height: 14),
          Text(
            'Completed ${_formatDate(completedAt)} · Practice result — Typing Master',
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF5A6372),
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
            fontSize: 34,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1D23),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5A6372),
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
          Text(label, style: const TextStyle(color: Color(0xFF5A6372))),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1D23),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatElapsed(Duration d) {
  final int minutes = d.inMinutes;
  final int seconds = d.inSeconds % 60;
  if (minutes == 0) return '${seconds}s';
  return '${minutes}m ${seconds}s';
}

String _formatDate(DateTime d) {
  final String day = d.day.toString().padLeft(2, '0');
  final String month = d.month.toString().padLeft(2, '0');
  final String hour = d.hour.toString().padLeft(2, '0');
  final String minute = d.minute.toString().padLeft(2, '0');
  return '$day/$month/${d.year} $hour:$minute';
}

/// Buttons under a [ShareableResultCard]: copy the result as text
/// (everywhere) and download the card as a PNG (web only — on desktop
/// the download button is hidden and only Copy is offered).
class ResultShareButtons extends StatelessWidget {
  const ResultShareButtons({
    super.key,
    required this.boundaryKey,
    required this.shareText,
    required this.fileName,
  });

  final GlobalKey boundaryKey;
  final String shareText;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        OutlinedButton.icon(
          onPressed: () async {
            await copyResultText(shareText);
            Get.snackbar('Copied', 'Result copied to the clipboard.');
          },
          icon: const Icon(Icons.copy_outlined),
          label: const Text('Copy Result'),
        ),
        if (kIsWeb)
          ElevatedButton.icon(
            onPressed: () async {
              final bool ok =
                  await downloadResultCardPng(boundaryKey, fileName);
              Get.snackbar(
                ok ? 'Downloaded' : 'Could not download',
                ok
                    ? 'Your result card was downloaded as a PNG image.'
                    : 'The result card could not be captured. Try again.',
              );
            },
            icon: const Icon(Icons.download_outlined),
            label: const Text('Download Result Card'),
          ),
      ],
    );
  }
}

/// Plain-text summary of a typing result, for clipboard sharing.
String formatResultShareText({
  required TypingSnapshot snapshot,
  required String title,
  required DateTime completedAt,
}) {
  final TypingSnapshot s = snapshot;
  return 'Typing Master — $title\n'
      'Net WPM: ${s.netWpm.toStringAsFixed(0)} · '
      'Accuracy: ${s.accuracy.toStringAsFixed(0)}%\n'
      'Gross WPM: ${s.grossWpm.toStringAsFixed(1)} · '
      'Duration: ${_formatElapsed(s.elapsed)}\n'
      'Correct characters: ${s.correctCharacters} · '
      'Wrong characters: ${s.wrongCharacters} · '
      'Total errors: ${s.totalErrors}\n'
      'Completed: ${_formatDate(completedAt)}';
}
