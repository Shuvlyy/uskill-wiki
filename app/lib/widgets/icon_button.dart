import 'package:app/core/theme.dart';
import 'package:flutter/material.dart';

class PrimaryIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const PrimaryIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      iconSize: 24,
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all(const Size(64, 64)),
        elevation: WidgetStateProperty.all(0),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          final isActive =
              states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered);

          return isActive ? AppTheme.whiteColor : AppTheme.primaryColor;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          final isActive =
              states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered);

          return isActive ? AppTheme.primaryColor : AppTheme.whiteColor;
        }),
        side: WidgetStateProperty.resolveWith((states) {
          final isActive =
              states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered);

          return BorderSide(
            color: isActive ? AppTheme.primaryColor : Colors.transparent,
            width: 1,
          );
        }),
      ),
      icon: Icon(icon),
    );
  }
}
