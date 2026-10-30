import 'package:flutter/services.dart';

export 'result_share_io.dart'
    if (dart.library.js_interop) 'result_share_web.dart';

/// Copies a plain-text result summary to the clipboard. Works on web
/// and desktop (Flutter's Clipboard is platform-neutral).
Future<void> copyResultText(String text) async {
  await Clipboard.setData(ClipboardData(text: text));
}
