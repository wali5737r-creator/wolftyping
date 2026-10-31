import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/services/mailto.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/core/widgets/sidebar_item.dart';
import 'package:typing_master/features/feedback/view/feedback_view.dart';

/// About view: renders with its heading and key sections, states the
/// practice-only disclaimer and the on-device data rule, reuses the
/// feedback contact, and sits in the sidebar next to Feedback, before
/// Settings.
void main() {
  tearDown(() {
    Get.reset();
  });

  test('about route is registered and the sidebar entry sits correctly',
      () {
    expect(
      AppPages.pages.any((p) => p.name == AppRoutes.about),
      isTrue,
    );
    expect(AppRoutes.about, '/about');
    final labels = kSidebarItems.map((i) => i.label).toList();
    expect(labels, contains('About'));
    expect(labels.indexOf('About'), labels.indexOf('Feedback') + 1);
    expect(labels.indexOf('About'), labels.indexOf('Settings') - 1);
    final item = kSidebarItems.firstWhere((i) => i.label == 'About');
    expect(item.route, AppRoutes.about);
  });

  testWidgets('about view shows heading, features, disclaimer and contact',
      (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.about,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('About'), findsWidgets);
    expect(find.text('What you can do'), findsOneWidget);
    expect(find.text('Your data stays on your device'), findsOneWidget);
    expect(find.text('Practice material only'), findsOneWidget);
    expect(find.text('Contact'), findsOneWidget);
    expect(
      find.textContaining('600-question practice bank'),
      findsOneWidget,
    );
    expect(find.textContaining('77 timed practice papers'), findsOneWidget);
    expect(find.textContaining('4,596 practice questions'), findsOneWidget);
    expect(
      find.textContaining('not real, past or official PPSC papers'),
      findsOneWidget,
    );
    expect(
      find.textContaining('stored only on your own device'),
      findsOneWidget,
    );
    expect(find.text('wali5737r@gmail.com'), findsOneWidget);
    expect(find.text('Copy email address'), findsOneWidget);
    expect(find.text('Open my mail app'), findsOneWidget);
    expect(
      buildMailtoUrl(email: feedbackEmail, subject: feedbackMailSubject),
      'mailto:wali5737r@gmail.com?subject=WolfTyping%20Feedback',
    );
  });

  testWidgets('about copy-email button confirms with a snackbar',
      (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.about,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Copy email address'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Copy email address'));
    await tester.pumpAndSettle();
    expect(find.text('Email address copied.'), findsOneWidget);
  });
}
