import 'package:app/core/theme.dart';
import 'package:flutter/material.dart';

enum _SelectableCardType { vertical, horizontal }

class SelectableCard extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;
  final _SelectableCardType _type;

  const SelectableCard.vertical({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    super.key,
  }) : _type = _SelectableCardType.vertical;

  const SelectableCard.horizontal({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.icon,
    super.key,
  }) : _type = _SelectableCardType.horizontal;

  @override
  State<SelectableCard> createState() => _SelectableCardState();
}

class _SelectableCardState extends State<SelectableCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _isHovered ? 1.02 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? AppTheme.primaryColor.withOpacity(0.05)
                    : const Color(0xFFF5F5F5),
                border: Border.all(
                  color: widget.isSelected
                      ? AppTheme.primaryColor
                      : (_isHovered ? AppTheme.primaryColor.withOpacity(0.3) : Colors.transparent),
                  width: 4,
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: widget._type == _SelectableCardType.vertical
                  ? _buildVerticalLayout()
                  : _buildHorizontalLayout(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalLayout() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                _buildIconCircle(),
                const SizedBox(height: 12),
                _buildLabel(),
              ],
            ),
          ),
        ),
        if (widget.isSelected)
          Positioned(
            top: 0,
            right: 0,
            child: _buildCheckmark(),
          ),
      ],
    );
  }

  Widget _buildHorizontalLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: [
          _buildIconCircle(small: true),
          const SizedBox(width: 20),
          Expanded(child: _buildLabel()),
          if (widget.isSelected) _buildCheckmark(withBackground: false),
        ],
      ),
    );
  }

  Widget _buildIconCircle({bool small = false}) {
    final double size = small ? 50 : 60;
    final double iconSize = small ? 25 : 30;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: widget.isSelected
            ? AppTheme.primaryColor.withOpacity(0.1)
            : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.isSelected
              ? AppTheme.primaryColor.withOpacity(0.2)
              : const Color(0xFFE0E0E0),
          width: 2,
        ),
      ),
      child: Icon(
        widget.icon,
        size: iconSize,
        color: widget.isSelected ? AppTheme.primaryColor : const Color(0xFF9E9E9E),
      ),
    );
  }

  Widget _buildLabel() {
    return Text(
      widget.label,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        fontFamily: 'Source Sans Pro',
        color: widget.isSelected ? AppTheme.primaryColor : AppTheme.blackColor,
      ),
      textAlign: .center,
    );
  }

  Widget _buildCheckmark({bool withBackground = true}) {
    if (!withBackground) {
      return const Icon(
        Icons.check_circle,
        color: AppTheme.primaryColor,
        size: 24,
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      color: AppTheme.primaryColor,
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}
