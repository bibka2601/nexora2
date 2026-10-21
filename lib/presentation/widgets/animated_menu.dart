import 'package:flutter/material.dart';

class AnimatedMenu extends StatefulWidget {
  final String title;
  final List<String> items;
  final List<VoidCallback> onPressed;

  const AnimatedMenu({
    super.key,
    required this.title,
    required this.items,
    required this.onPressed,
  });

  @override
  State<AnimatedMenu> createState() => _AnimatedMenuState();
}

class _AnimatedMenuState extends State<AnimatedMenu> {
  bool isOpen = false;

  Future<void> _openMenu() async {
    setState(() {
      isOpen = true;
    });

    final RenderBox button =
        context.findRenderObject() as RenderBox;

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject()
            as RenderBox;

    final Offset position = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    final selected = await showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + button.size.height,
        overlay.size.width - position.dx - button.size.width,
        0,
      ),
      color: Colors.white,
      elevation: 10,
      items: List.generate(
        widget.items.length,
        (index) {
          return PopupMenuItem<int>(
            value: index,
            child: SizedBox(
              width: 230,
              child: Text(
                widget.items[index],
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );

    setState(() {
      isOpen = false;
    });

    if (selected != null) {
      widget.onPressed[selected]();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openMenu,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 10,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),

            const SizedBox(width: 3),

            Icon(
              isOpen
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}


