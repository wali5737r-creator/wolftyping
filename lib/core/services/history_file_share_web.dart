import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Web implementation: triggers a browser download (Blob + object URL
/// + anchor click, the same approach as the custom-set file download)
/// and reads a picked backup file back as text. No server, no new
/// dependencies.
Future<bool> downloadHistoryFile(
  String fileName,
  String content,
  String mimeType,
) async {
  final web.Blob blob = web.Blob(
    <web.BlobPart>[content.toJS].toJS,
    web.BlobPropertyBag(type: mimeType),
  );
  final String url = web.URL.createObjectURL(blob);
  final web.HTMLAnchorElement anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = fileName;
  anchor.click();
  web.URL.revokeObjectURL(url);
  return true;
}

/// Opens the browser file picker for a JSON backup and returns the
/// picked file's text, or null when the user cancels or the file
/// cannot be read.
Future<String?> pickHistoryBackupText() async {
  final Completer<String?> completer = Completer<String?>();
  final web.HTMLInputElement input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = '.json';
  input.onChange.listen((_) async {
    final web.File? file = input.files?.item(0);
    if (file == null) {
      if (!completer.isCompleted) completer.complete(null);
      return;
    }
    try {
      final String text = (await file.text().toDart).toDart;
      if (!completer.isCompleted) completer.complete(text);
    } catch (_) {
      if (!completer.isCompleted) completer.complete(null);
    }
  });
  input.click();
  return completer.future;
}
