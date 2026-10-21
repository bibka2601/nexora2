import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollReveal extends StatefulWidget {
  const ScrollReveal({super.key, required this.child});

  final Widget child;

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  final GlobalKey _childKey = GlobalKey();
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );
  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  late final Animation<Offset> _position = Tween<Offset>(
    begin: const Offset(0, 0.07),
    end: Offset.zero,
  ).animate(_opacity);

  ScrollPosition? _scrollPosition;
  bool _revealed = false;
  bool _visibilityCheckScheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (MediaQuery.disableAnimationsOf(context)) {
      _revealImmediately();
      return;
    }

    final position = Scrollable.maybeOf(context)?.position;
    if (position != _scrollPosition) {
      _scrollPosition?.removeListener(_checkVisibility);
      _scrollPosition = position;
      _scrollPosition?.addListener(_scheduleVisibilityCheck);
    }

    _scheduleVisibilityCheck();
  }

  void _scheduleVisibilityCheck() {
    if (!mounted || _visibilityCheckScheduled) return;

    _visibilityCheckScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _visibilityCheckScheduled = false;
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (!mounted || _revealed) return;

    final child = _childKey.currentContext?.findRenderObject();
    if (child is! RenderBox || !child.attached) return;

    final viewport = RenderAbstractViewport.of(child);
    if (viewport is! RenderBox) return;
    if (!_hasLayoutPath(child, viewport)) return;

    final top = child.localToGlobal(Offset.zero, ancestor: viewport).dy;
    final bottom = top + child.size.height;
    if (bottom > 0 && top < viewport.paintBounds.height) {
      _revealed = true;
      _controller.forward();
      _scrollPosition?.removeListener(_checkVisibility);
    }
  }

  bool _hasLayoutPath(RenderObject child, RenderObject viewport) {
    RenderObject? current = child;
    while (current != null && current != viewport) {
      if (current is RenderBox && !current.hasSize) return false;
      current = current.parent;
    }

    return current == viewport && viewport is RenderBox && viewport.hasSize;
  }

  void _revealImmediately() {
    if (_revealed) return;
    _revealed = true;
    _controller.value = 1;
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_checkVisibility);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _position,
        child: KeyedSubtree(key: _childKey, child: widget.child),
      ),
    );
  }
}


