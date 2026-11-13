/// Desktop/mobile implementation: there is no browser download or file
/// picker here, so history export/import is unavailable on these
/// platforms. The History screen hides the buttons off the web.
Future<bool> downloadHistoryFile(
  String fileName,
  String content,
  String mimeType,
) async {
  return false;
}

/// Returns null: no file picker off the web.
Future<String?> pickHistoryBackupText() async {
  return null;
}
