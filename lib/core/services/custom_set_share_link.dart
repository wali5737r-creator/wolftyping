/// Shareable-link helpers for custom tests (pure functions, unit
/// tested — no browser APIs here so the logic can be verified without
/// a web build).
///
/// A shareable link is only offered when the full URL is at most
/// [maxShareUrlLength] characters. There is no server and no short-code
/// service, so larger tests must be shared as a code or a file instead
/// — never as a link that silently breaks.
///
/// Link shape: `<origin>/#/ppsc-custom-tests?import=<code>`. The
/// custom-tests page reads the `import` parameter out of the
/// hash fragment on load, validates it with the existing
/// [CustomSet.decode]/`validate` path, and offers to save it.
library;

import '../../features/ppsc/model/custom_set.dart';

/// Maximum length of a shareable link URL, in characters.
const int maxShareUrlLength = 4000;

/// Builds the shareable link for [set] from the app's [origin]
/// (e.g. `https://wolftyping.pages.dev`), or null when the full URL
/// would exceed [maxShareUrlLength]. The code is embedded verbatim
/// (base64url has no characters that need escaping in a query value).
String? buildCustomSetShareLink({
  required String origin,
  required CustomSet set,
}) {
  final String url =
      '$origin/#/ppsc-custom-tests?import=${set.encode()}';
  if (url.length > maxShareUrlLength) return null;
  return url;
}

/// Extracts the `import` code from a hash fragment such as
/// `/ppsc-custom-tests?import=<code>`, or null when the fragment
/// carries no import parameter. Returns the raw (still encoded) code;
/// decoding/validation stays with [CustomSet.decode].
String? extractImportCodeFromFragment(String fragment) {
  final String cleaned = fragment.startsWith('#')
      ? fragment.substring(1)
      : fragment;
  final int queryIndex = cleaned.indexOf('?');
  if (queryIndex < 0) return null;
  final String query = cleaned.substring(queryIndex + 1);
  for (final String part in query.split('&')) {
    final int equals = part.indexOf('=');
    if (equals < 0) continue;
    if (part.substring(0, equals) != 'import') continue;
    final String value = part.substring(equals + 1);
    if (value.isEmpty) return null;
    return Uri.decodeComponent(value);
  }
  return null;
}
