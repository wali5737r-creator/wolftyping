import 'package:web/web.dart' as web;

/// Web implementation: triggers the browser's mail-app handling by
/// clicking an anchor with a `mailto:` href — the same anchor-click
/// approach as the file-download sharing service. No server, no new
/// dependency.
Future<bool> openMailtoUrl(String url) async {
  try {
    final web.HTMLAnchorElement anchor = web.HTMLAnchorElement()
      ..href = url;
    anchor.click();
    return true;
  } catch (_) {
    return false;
  }
}
