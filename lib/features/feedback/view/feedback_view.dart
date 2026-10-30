import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/mailto.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_controls.dart';
import '../../../core/widgets/app_surfaces.dart';

/// Contact email for WolfTyping feedback, as given by the owner.
const String feedbackEmail = 'wali5737r@gmail.com';

/// Subject pre-filled by the mail-app button.
const String feedbackMailSubject = 'WolfTyping Feedback';

/// Feedback / contact view: shows the email address, a copy-email
/// button, and a button that opens the user's mail app with a
/// `mailto:` link.
///
/// There is deliberately NO in-app form: feedback goes by email, and
/// nothing is sent or stored by the app. The view says so plainly.
class FeedbackView extends StatelessWidget {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: AppRoutes.feedback,
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeader(
                  title: 'Feedback',
                  subtitle:
                      'Tell us what is wrong, what is missing, or what '
                      'you would like added to WolfTyping.',
                ),
                const SizedBox(height: 20),
                const Text(
                  'Feedback goes by email. Nothing is sent or stored '
                  'by the app — your message goes only to the email '
                  'address below, through your own mail app.',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 20),
                SectionCard(
                  title: 'Email',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              // Fire-and-forget: the confirmation is
                              // shown immediately so a slow clipboard
                              // can never leave the tap looking dead.
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
