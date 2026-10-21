import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardScrollable extends StatefulWidget {
  const KeyboardScrollable({
    super.key,
    required this.builder,
    this.scrollController,
  });

  final Widget Function(BuildContext context, ScrollController controller)
      builder;
  final ScrollController? scrollController;

  @override
  State<KeyboardScrollable> createState() => _KeyboardScrollableState();
}

class _KeyboardScrollableState extends State<KeyboardScrollable> {
  late final ScrollController _controller =
      widget.scrollController ?? ScrollController();
  final FocusNode _focusNode = FocusNode();

  bool get _ownsController => widget.scrollController == null;

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return;

    final isRepeat = event is KeyRepeatEvent;

    // При зажатии — маленький шаг и быстрая анимация (плавный скролл)
    // При одиночном нажатии — большой шаг (прокрутка на экран)
    final step = isRepeat
        ? MediaQuery.sizeOf(context).height * 0.05
        : MediaQuery.sizeOf(context).height * 0.8;
    final duration = isRepeat
        ? const Duration(milliseconds: 80)
        : const Duration(milliseconds: 400);
    final curve = isRepeat ? Curves.linear : Curves.easeInOut;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown ||
        event.logicalKey == LogicalKeyboardKey.pageDown) {
      _controller.animateTo(
        _controller.offset + step,
        duration: duration,
        curve: curve,
      );
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.pageUp) {
      _controller.animateTo(
        _controller.offset - step,
        duration: duration,
        curve: curve,
      );
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: widget.builder(context, _controller),
    );
  }
}


