import 'package:flutter/widgets.dart';

import '../../features/settings/controller/settings_controller.dart';

/// Keeps a typing screen's [focusNode] focused while Settings > Auto Focus
/// is on: when the screen first appears, and again when the Windows app
/// window regains focus after the user alt-tabbed away (Flutter reports
/// that as [AppLifecycleState.resumed]). With Auto Focus off it does
/// nothing — the user clicks the text area to focus it.
class TypingFocusKeeper extends StatefulWidget {
  const TypingFocusKeeper({
    super.key,
    required this.focusNode,
    required this.child,
  });

  final FocusNode focusNode;
  final Widget child;

  @override
  State<TypingFocusKeeper> createState() => _TypingFocusKeeperState();
}

class _TypingFocusKeeperState extends State<TypingFocusKeeper>
    with WidgetsBindingObserver {
  bool get _autoFocus => SettingsController.currentOrNull?.autoFocus ?? true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestSoon();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _requestSoon();
  }

  void _requestSoon() {
    if (!_autoFocus) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!widget.focusNode.hasFocus && widget.focusNode.canRequestFocus) {
        widget.focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
