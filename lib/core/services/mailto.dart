/// Opens a `mailto:` link in the user's mail app, following the same
/// conditional-import pattern as the file-download sharing services:
/// a browser anchor click on web, no mail-app mechanism off the web.
/// Returns true when a mail app was asked to open, false otherwise
/// (the caller falls back to copy-email).
library;
export 'mailto_io.dart'
    if (dart.library.js_interop) 'mailto_web.dart';

/// Builds a `mailto:` URL with an encoded subject. Pure function, unit
/// tested — the address and subject are the only inputs.
String buildMailtoUrl({required String email, required String subject}) {
  return 'mailto:$email?subject=${Uri.encodeComponent(subject)}';
}
