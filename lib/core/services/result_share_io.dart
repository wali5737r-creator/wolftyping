import 'package:flutter/widgets.dart';

/// Desktop/mobile implementation: there is no browser download, so PNG
/// export is unsupported here. The result can still be shared with
/// [copyResultText] (see `result_share.dart`).
Future<bool> downloadResultCardPng(
  GlobalKey boundaryKey,
  String fileName,
) async {
  return false;
}
