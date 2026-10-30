import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A scroll view for the live typing text that keeps the current word in
/// view.
///
/// Needed because timed tests keep appending paragraphs until the clock
/// ends, so the text quickly becomes taller than the typing area. The
/// [builder] receives the key to hand to `TypingParagraphText.currentWordKey`
/// and a [follow] callback to call whenever the typing state changes
/// (inside the same `Obx` that rebuilds the text). After the frame, the
/// view scrolls only when the current line has moved away from the
/// reading position near the top third of the area, so it stays still
/// while typing along one line and moves one line at a time.
class AutoScrollTypingArea extends StatefulWidget {
  const AutoScrollTypingArea({super.key, required this.builder});

  final Widget Function(GlobalKey currentWordKey, VoidCallback follow) builder;

  @override
  State<AutoScrollTypingArea> createState() => _AutoScrollTypingAreaState();
}

class _AutoScrollTypingAreaState extends State<AutoScrollTypingArea> {
  final ScrollController _controller = ScrollController();
  final GlobalKey _currentWordKey = GlobalKey();

  void _follow() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_controller.hasClients) return;
      final RenderObject? target =
          _currentWordKey.currentContext?.findRenderObject();
      if (target == null || !target.attached) return;
      final RenderAbstractViewport? viewport =
          RenderAbstractViewport.maybeOf(target);
      if (viewport == null) return;

      final ScrollPosition position = _controller.position;
      final double wanted = viewport
          .getOffsetToReveal(target, 0.3)
          .offset
          .clamp(position.minScrollExtent, position.maxScrollExtent)
          .toDouble();
      if ((wanted - position.pixels).abs() < 8) return;
      _controller.animateTo(
        wanted,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      child: widget.builder(_currentWordKey, _follow),
    );
  }
}
