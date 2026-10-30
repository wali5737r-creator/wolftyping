/// Desktop/mobile implementation: there is no mail-app mechanism
/// without a launcher dependency, so opening a mail app is
/// unavailable here. The copy-email fallback still works everywhere,
/// so feedback is never blocked — the view hides nothing and says
/// plainly when no mail app could be opened.
Future<bool> openMailtoUrl(String url) async {
  return false;
}
