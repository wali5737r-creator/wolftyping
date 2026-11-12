// WolfTyping loading screen: removed when Flutter renders its first frame.
//
// Mechanism (Flutter 3.47.9 SDK, verified in the local SDK at
// ~/workspace/.flutter):
//  - Framework: packages/flutter/lib/src/rendering/binding.dart:64 —
//    RendererBinding registers addPostFrameCallback(_handleWebFirstFrame),
//    which (line 537) invokes 'first-frame' on the
//    'flutter/service_worker' method channel once the first frame is drawn.
//  - Engine: bin/cache/flutter_web_sdk/lib/_engine/engine/
//    platform_dispatcher.dart:559-561 — on that channel message the engine
//    dispatches a 'flutter-first-frame' DOM event on window.
//
// Listening for that event removes the splash exactly when the app is
// actually visible — never earlier, and never before first paint.
// This file is external (not inline) because the site's CSP in web/_headers
// allows script-src 'self' but not 'unsafe-inline'.
(function () {
  var splash = document.getElementById('wt-splash');
  if (!splash) {
    return;
  }
  var removed = false;
  function removeSplash() {
    if (removed) {
      return;
    }
    removed = true;
    splash.classList.add('wt-fade');
    window.setTimeout(function () {
      splash.remove();
    }, 300);
  }
  window.addEventListener('flutter-first-frame', removeSplash, { once: true });
  // Safety net only: if the first-frame event is ever missed (engine error),
  // do not leave the splash stuck forever. 60s is far beyond the normal
  // ~5s boot, so this never fires during a healthy load.
  window.setTimeout(removeSplash, 60000);
})();
