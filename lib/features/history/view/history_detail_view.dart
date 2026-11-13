import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/certificate_code.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../../certificate/view/certificate_card.dart';
import '../../ppsc/service/mock_progress_repository.dart';
import '../model/typing_test_record.dart';
import '../service/history_repository.dart';
import 'widgets/delete_test_dialog.dart';

/// Full detail for one completed test (spec section 5), including its
/// related mistakes read straight from the existing `Mistakes` table —
/// never duplicated or recomputed.
class HistoryDetailView extends StatelessWidget {
  const HistoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Object? args = Get.arguments;
    final TypingTestRecord? record = args is TypingTestRecord ? args : null;

    return AppScaffold(
      currentRoute: AppRoutes.history,
      body: record == null
          ? const EmptyStateView(
              icon: Icons.search_off_outlined,
              title: 'Test result not found',
              message: 'This result may have been deleted.',
            )
          : _DetailContent(record: record),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.record});

  final TypingTestRecord record;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Back to History'),
              ),
              const SizedBox(height: 8),
              PageHeader(
                title: record.isMock
                    ? (record.mockLabel ?? 'Mock test')
                    : record.languageAndTypeLabel,
                subtitle: record.isMock
                    ? '${_formatDateTime(record.completedAt)} · Mock test'
                    : _formatDateTime(record.completedAt),
              ),
              const SizedBox(height: 24),
              if (record.isMock) ...[
                Wrap(
                  spacing: AppDimensions.gapMedium,
                  runSpacing: AppDimensions.gapMedium,
                  children: [
                    StatCard(label: 'Score', value: record.mockScoreLabel),
                    StatCard(
                        label: 'Percentage',
                        value:
                            '${record.accuracy.toStringAsFixed(1)}%'),
                    StatCard(
                        label: 'Correct',
                        value: '${record.mockCorrect ?? 0}'),
                    StatCard(
                        label: 'Wrong', value: '${record.mockWrong ?? 0}'),
                    StatCard(
                        label: 'Skipped',
                        value: '${record.mockSkipped ?? 0}'),
                    StatCard(
                      label: 'Duration',
                      value: record.mockDurationText.isEmpty
                          ? 'Not recorded'
                          : record.mockDurationText +
                              (record.durationSeconds != null &&
                                      record.actualDurationSeconds > 0
                                  ? ' / ${record.durationSeconds}s planned'
                                  : ''),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                // A past mock result can reach its practice certificate
                // from here — the same flow as the result screen. The
                // certificate is built from this result's own numbers
                // (never from the stored last certificate, which may
                // belong to a different result), so a result with no
                // stored certificate still opens its certificate flow
                // instead of dead-ending.
                GetCertificateButton(
                  data: _certificateDataForMockRecord(record),
                ),
                const SizedBox(height: 28),
                const Text('Review', style: AppTextStyles.h3),
                const SizedBox(height: 10),
                const Text(
                  'Per-question review lives on the mock test result '
                  'screen — History stores the score, not the answers.',
                  style: AppTextStyles.body,
                ),
              ] else ...[
                Wrap(
                  spacing: AppDimensions.gapMedium,
                  runSpacing: AppDimensions.gapMedium,
                  children: [
                    StatCard(label: 'Gross WPM', value: record.grossWpm.toStringAsFixed(1)),
                    StatCard(label: 'Net WPM', value: record.netWpm.toStringAsFixed(1)),
                    StatCard(label: 'Accuracy', value: '${record.accuracy.toStringAsFixed(1)}%'),
                    StatCard(label: 'Duration', value: '${record.actualDurationSeconds}s'
                        '${record.durationSeconds != null ? ' / ${record.durationSeconds}s planned' : ''}'),
                    StatCard(label: 'Correct characters', value: '${record.correctCharacters}'),
                    StatCard(label: 'Wrong characters', value: '${record.wrongCharacters}'),
                    StatCard(label: 'Correct words', value: '${record.correctWords}'),
                    StatCard(label: 'Wrong words', value: '${record.wrongWords}'),
                    StatCard(label: 'Skipped words', value: '${record.skippedWords}'),
                    StatCard(label: 'Backspaces', value: '${record.backspaces}'),
                    StatCard(label: 'Total errors', value: '${record.totalErrors}'),
                  ],
                ),
                const SizedBox(height: 28),
                const Text('Mistakes', style: AppTextStyles.h3),
                const SizedBox(height: 10),
                FutureBuilder<List<String>>(
                  future:
                      HistoryRepository.instance.fetchMistakeLines(record.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: LinearProgressIndicator(),
                      );
                    }
                    final List<String> lines = snapshot.data ?? const [];
                    if (lines.isEmpty) {
                      return const Text('No mistakes recorded for this test.');
                    }
                    return SoftSurface(
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final line in lines)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Text(line, style: AppTextStyles.body),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () async {
                  final bool confirmed = await confirmDeleteTest(context);
                  if (confirmed) {
                    if (record.isMock) {
                      await MockProgressRepository.instance
                          .removeAttempt(record.mockAttemptId!);
                    } else {
                      await HistoryRepository.instance.deleteTest(record.id);
                    }
                    Get.back();
                  }
                },
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete This Result'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatDateTime(DateTime d) {
  final String date =
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  final String time =
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  return '$date $time';
}

/// The certificate data for a past mock result, built from the
/// result's own stored numbers — scoring is never recomputed here,
/// and the certificate scheme (WT1 code format) is unchanged. The
/// holder name is empty: the certificate screen asks for it, exactly
/// as the result screen does. Accuracy is 0 for a mock test, as in
/// the result screen's certificate data.
CertificateData _certificateDataForMockRecord(TypingTestRecord record) {
  return CertificateData(
    kind: CertificateKind.mock,
    testLabel: record.mockLabel ?? 'Mock test',
    holderName: '',
    date: record.completedAt,
    score: record.mockScore ?? 0,
    totalQuestions: record.mockTotalQuestions ?? 0,
    correct: record.mockCorrect ?? 0,
    wrong: record.mockWrong ?? 0,
    skipped: record.mockSkipped ?? 0,
    accuracy: 0,
  );
}
