import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Web implementation of the cross-tab database-change signal, over
/// the browser's `BroadcastChannel` API (same origin only — other
/// sites can neither post nor listen).
///
/// A tab never receives its own post (per the BroadcastChannel spec),
/// so the tab that saved does not re-open its own database. The
/// listener channel is opened once and kept for the life of the tab;
/// a throwaway channel is opened per post and closed at once, so a
/// post can never leak a channel.

web.BroadcastChannel? _channel;

void postDbChanged(String channelName) {
  final web.BroadcastChannel channel = web.BroadcastChannel(channelName);
  channel.postMessage('changed'.toJS);
  channel.close();
}

void listenDbChanged(String channelName, void Function() onDbChanged) {
  _channel ??= web.BroadcastChannel(channelName);
  // The event parameter must be typed (web.Event): dart2js refuses to
  // convert a closure with a dynamic parameter via .toJS.
  _channel!.onmessage = ((web.Event event) {
    onDbChanged();
  }).toJS;
}
