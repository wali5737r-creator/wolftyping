import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/mailto.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_surfaces.dart';
import '../../feedback/view/feedback_view.dart'
    show feedbackEmail, feedbackMailSubject;

/// About WolfTyping: what the app is, what it can do, where your data
/// lives, and what the practice questions are — and are not.
///
/// Every claim here is checked against what the app actually does.
/// Nothing is sent or stored by the app itself; feedback goes by email
/// through the user's own mail app, exactly as on the Feedback page.
class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.about,
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeader(
                  title: 'About',
                  subtitle:
                      'What WolfTyping is, what it can do, and where '
                      'your data lives.',
                ),
                const SizedBox(height: 20),
                const Text(
                  'WolfTyping is a free English and Urdu typing trainer '
                  'that runs in your browser. You do not need an account '
                  'to use it, and nothing you type or score is sent to '
                  'a server.',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 20),
                const SectionCard(
                  title: 'What you can do',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      _AboutRow(
                        'English and Urdu typing tests with instant '
                        'WPM and accuracy results.',
                      ),
                      _AboutRow(
                        'Step-by-step typing lessons, with practice '
                        'drills for the keys you get wrong most.',
                      ),
                      _AboutRow(
                        'Your own paragraphs: paste a paragraph and '
                        'take a typing test with it.',
                      ),
                      _AboutRow(
                        'A 600-question practice bank — 100 questions '
                        'for each of English, General Knowledge, '
                        'Pakistan Studies, Islamiat, Mathematics and '
                        'Everyday Science.',
                      ),
                      _AboutRow(
                        '77 timed practice papers — 21 from 2026 and '
                        '56 from 2025 — 4,596 practice questions in '
                        'total, each with an explanation in the end '
                        'review, and latest-update notes on '
                        'current-affairs questions.',
                      ),
                      _AboutRow(
                        'Custom MCQ tests: teachers can make their own '
                        'test, share it as a code, file or link, and '
                        'students can import it and take the same '
                        'timed test.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const SectionCard(
                  title: 'Your data stays on your device',
                  child: Text(
                    'Your history, progress and best scores — shown as '
                    'the leaderboard — are stored only on your own '
                    'device. There is no account and no shared '
                    'leaderboard: nobody else can see your results, '
                    'and clearing your browser or site data removes '
                    'them.',
                    style: AppTextStyles.body,
                  ),
                ),
                const SizedBox(height: 20),
                const SectionCard(
                  title: 'Practice material only',
                  child: Text(
                    'All MCQ questions on WolfTyping are practice '
                    'samples written for practice only. They are not '
                    'real, past or official PPSC papers, and WolfTyping '
                    'is not affiliated with the PPSC or any exam body.',
                    style: AppTextStyles.body,
                  ),
                ),
                const SizedBox(height: 20),
                SectionCard(
                  title: 'Contact',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Questions, corrections or suggestions go by '
                        'email, through your own mail app. Nothing is '
                        'sent or stored by the app.',
                        style: AppTextStyles.body,
                      ),
                      const SizedBox(height: 12),
                      const SelectableText(
                        feedbackEmail,
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              // Fire-and-forget, as on the Feedback
                              // page: the confirmation is shown
                              // immediately so a slow clipboard can
                              // never leave the tap looking dead.
                              unawaited(
                                Clipboard.setData(
                                  const ClipboardData(text: feedbackEmail),
                                ).catchError((_) {}),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Email address copied.'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.copy),
                            label: const Text('Copy email address'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () async {
                              final bool opened = await openMailtoUrl(
                                buildMailtoUrl(
                                  email: feedbackEmail,
                                  subject: feedbackMailSubject,
                                ),
                              );
                              if (context.mounted && !opened) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Could not open a mail app on this '
                                      'device — copy the email address '
                                      'instead.',
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.mail_outlined),
                            label: const Text('Open my mail app'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Icon(Icons.check, size: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: AppTextStyles.body),
        ),
      ],
    );
  }
}
