import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Web implementation: triggers a browser download of the set's JSON
/// (Blob + object URL + anchor click, the same approach as the result
/// card PNG download) and reads a picked file back as text. No server,
/// no new dependencies.
Future<bool> downloadCustomSetFile(String fileName, String content) async {
  final web.Blob blob = web.Blob(
    <web.BlobPart>[content.toJS].toJS,
    web.BlobPropertyBag(type: 'application/json'),
  );
  final String url = web.URL.createObjectURL(blob);
  final web.HTMLAnchorElement anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = fileName;
  anchor.click();
  web.URL.revokeObjectURL(url);
  return true;
}

/// Opens the browser file picker and returns the picked file's text,
/// or null when the user cancels or the file cannot be read.
Future<String?> pickCustomSetFileText() async {
  final Completer<String?> completer = Completer<String?>();
  final web.HTMLInputElement input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = '.json,.txt';
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
