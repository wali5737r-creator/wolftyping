/// Desktop/mobile implementation: there is no browser download or file
/// picker here, so file export/import is unavailable on these platforms.
/// The copyable code (clipboard) still works everywhere, so sharing is
/// never blocked — the list UI hides the file buttons off the web.
Future<bool> downloadCustomSetFile(String fileName, String content) async {
  return false;
}

/// Returns null: no file picker off the web.
Future<String?> pickCustomSetFileText() async {
  return null;
}
