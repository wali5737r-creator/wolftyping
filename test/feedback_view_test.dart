import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:typing_master/core/routes/app_pages.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/services/mailto.dart';
import 'package:typing_master/core/theme/app_theme.dart';
import 'package:typing_master/core/widgets/sidebar_item.dart';
import 'package:typing_master/features/feedback/view/feedback_view.dart';

/// Feedback view: email shown, copy-email works, mailto URL is exact,
/// sidebar entry sits between Profile and Settings, and the view
/// states plainly that nothing is sent or stored by the app.
void main() {
  tearDown(() {
    Get.reset();
  });

  test('mailto URL uses the feedback email and exact subject', () {
    expect(
      buildMailtoUrl(email: feedbackEmail, subject: feedbackMailSubject),
      'mailto:wali5737r@gmail.com?subject=WolfTyping%20Feedback',
    );
    expect(feedbackEmail, 'wali5737r@gmail.com');
    expect(feedbackMailSubject, 'WolfTyping Feedback');
  });

  test('sidebar has a Feedback entry between Profile and Settings', () {
    final labels = kSidebarItems.map((i) => i.label).toList();
    expect(labels, contains('Feedback'));
    expect(labels.indexOf('Feedback'), labels.indexOf('Profile') + 1);
    expect(labels.indexOf('Feedback'), labels.indexOf('Settings') - 1);
    final item = kSidebarItems.firstWhere((i) => i.label == 'Feedback');
    expect(item.route, AppRoutes.feedback);
  });

  testWidgets('feedback view shows the email and the honesty note',
      (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.feedback,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Feedback'), findsWidgets);
    expect(find.text('wali5737r@gmail.com'), findsOneWidget);
    expect(find.text('Copy email address'), findsOneWidget);
    expect(find.text('Open my mail app'), findsOneWidget);
    expect(
      find.textContaining('Nothing is sent or stored by the app'),
      findsOneWidget,
    );
    expect(find.textContaining('Feedback goes by email'), findsOneWidget);
  });

  testWidgets('copy-email button confirms with a snackbar', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        initialRoute: AppRoutes.feedback,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Copy email address'));
    await tester.pumpAndSettle();
    expect(find.text('Email address copied.'), findsOneWidget);
  });
}
