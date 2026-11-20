{{flutter_js}}
{{flutter_build_config}}

// WolfTyping customization of the default generated bootstrap.
// Identical boot path to the default (same build config, same
// service-worker settings, same main.dart.js entrypoint); the only
// difference is the `config.hostElement`: the engine mounts into the
// #wt-app element in index.html instead of taking the full viewport,
// so the page shell can hold a slim Adsterra strip below the app in
// normal flow (the app is never overlaid by the ads).
_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}}
  },
  config: {
    hostElement: document.querySelector('#wt-app')
  }
});
