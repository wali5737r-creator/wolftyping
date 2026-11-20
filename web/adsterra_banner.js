// Adsterra 728x90 banner options for WolfTyping (this site's own unit).
//
// This is the first half of Adsterra's banner snippet. It lives in a
// self-hosted file because the site's CSP (web/_headers) allows
// script-src 'self' but not inline scripts. index.html loads this file
// immediately before the Adsterra invoke script
// (https://bauval.org/22/56470454c425ca6e6e04de8e1d86bda3), which reads
// the global `atOptions` when it executes — the same order and effect
// as the original inline snippet.
atOptions = {
  'key': '56470454c425ca6e6e04de8e1d86bda3',
  'format': 'iframe',
  'height': 90,
  'width': 728,
  'params': {}
};
