import 'package:flutter/material.dart';

class TextIconButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const TextIconButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  State<TextIconButton> createState() => _TextIconButtonState();
}

class _TextIconButtonState extends State<TextIconButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  Color get _currentColor {
    if (_isPressed) {
      return Color.lerp(widget.color, Colors.black, 0.4) ?? widget.color;
    }
    if (_isHovered) {
      return Color.lerp(widget.color, Colors.black, 0.2) ?? widget.color;
    }
    return widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            mainAxisSize: .min,
            spacing: 4,
            children: [
              Icon(
                widget.icon,
                color: _currentColor,
                size: 16,
              ),
              SelectionContainer.disabled(
                child: Text(
                  widget.text,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: _currentColor
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}