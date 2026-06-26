import 'package:app/core/theme.dart';
import 'package:flutter/material.dart';

class OptionSlider extends StatelessWidget {
  final List<String> steps;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const OptionSlider({
    super.key,
    required this.steps,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const double circleSize = 24.0;
    const double lineHeight = 6.0;

    return Stack(
      children: [
        Positioned(
          left: circleSize / 2,
          right: circleSize / 2,
          top: (circleSize / 2) - (lineHeight / 2),
          child: Container(
            height: lineHeight,
            color: AppTheme.fieldOutlineColor,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length, (index) {
            return _SliderNode(
              label: steps[index],
              isSelected: index == selectedIndex,
              onTap: () => onChanged(index),
            );
          }),
        ),
      ],
    );
  }
}

class _SliderNode extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SliderNode({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SliderNode> createState() => _SliderNodeState();
}

class _SliderNodeState extends State<_SliderNode> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const double circleSize = 24.0;
    final double scale = _isPressed ? 0.9 : (_isHovered ? 1.15 : 1.0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: scale,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected
                      ? AppTheme.whiteColor
                      : AppTheme.fieldOutlineColor,
                  border: widget.isSelected
                      ? Border.all(color: AppTheme.primaryColor, width: 4)
                      : null,
                  boxShadow: _isHovered && !widget.isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.blackColor.withValues(alpha: .1),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : [],
                ),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 16,
                fontFamily: AppTheme.bodyFont,
                fontWeight: widget.isSelected
                    ? FontWeight.bold
                    : FontWeight.w500,
                color: widget.isSelected
                    ? AppTheme.blackColor
                    : (_isHovered
                          ? AppTheme.blackColor.withValues(alpha: .6)
                          : AppTheme.inactiveTextColor),
              ),
              child: Text(widget.label),
            ),
          ],
        ),
      ),
    );
  }
}
