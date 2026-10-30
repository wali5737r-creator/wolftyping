import 'dart:js_interop';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

/// Web implementation: captures the widget behind [boundaryKey] as a
/// PNG and triggers a browser download of it (no server, no file-system
/// APIs — a Blob + object URL + anchor click, all standard browser APIs).
Future<bool> downloadResultCardPng(
  GlobalKey boundaryKey,
  String fileName,
) async {
  final BuildContext? context = boundaryKey.currentContext;
  if (context == null) return false;
  final RenderObject? renderObject = context.findRenderObject();
  if (renderObject is! RenderRepaintBoundary) return false;
  final ui.Image image = await renderObject.toImage(pixelRatio: 2);
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  if (byteData == null) return false;
  final Uint8List bytes = byteData.buffer.asUint8List();
  final web.Blob blob = web.Blob(
    <web.BlobPart>[bytes.toJS].toJS,
    web.BlobPropertyBag(type: 'image/png'),
  );
  final String url = web.URL.createObjectURL(blob);
  final web.HTMLAnchorElement anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = fileName;
  anchor.click();
  web.URL.revokeObjectURL(url);
  return true;
}
