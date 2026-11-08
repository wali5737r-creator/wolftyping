import 'package:flutter_test/flutter_test.dart';
import 'package:typing_master/core/routes/app_routes.dart';
import 'package:typing_master/core/routes/initial_route.dart';

/// Cold-start deep links: the browser URL hash must become the first
/// route, and anything empty or unknown must fall back to the dashboard.
void main() {
  group('resolveInitialRoute', () {
    test('empty fragment opens the dashboard', () {
      expect(resolveInitialRoute(''), AppRoutes.dashboard);
    });

    test('bare slash opens the dashboard', () {
      expect(resolveInitialRoute('/'), AppRoutes.dashboard);
    });

    test('unknown route opens the dashboard', () {
      expect(resolveInitialRoute('/no-such-page'), AppRoutes.dashboard);
      expect(resolveInitialRoute('/typing-test/extra'), AppRoutes.dashboard);
    });

    test('known routes pass through unchanged', () {
      expect(resolveInitialRoute('/typing-test'), '/typing-test');
      expect(resolveInitialRoute('/dashboard'), '/dashboard');
      expect(resolveInitialRoute('/lessons'), '/lessons');
      expect(resolveInitialRoute('/about'), '/about');
    });

    test('query string is preserved for the year route', () {
      expect(
        resolveInitialRoute('/ppsc-past-papers-year?year=2025'),
        '/ppsc-past-papers-year?year=2025',
      );
    });

    test('trailing slash is normalized', () {
      expect(resolveInitialRoute('/typing-test/'), '/typing-test');
    });
  });
}
