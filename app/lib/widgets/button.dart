import 'package:app/core/theme.dart';
import 'package:flutter/material.dart';

enum _ButtonVariant { primary, secondary, inverted, outlined }

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final _ButtonVariant _variant;

  const Button.primary({super.key, required this.text, required this.onPressed})
    : _variant = _ButtonVariant.primary;

  const Button.secondary({
    super.key,
    required this.text,
    required this.onPressed,
  }) : _variant = _ButtonVariant.secondary;

  const Button.inverted({
    super.key,
    required this.text,
    required this.onPressed,
  }) : _variant = _ButtonVariant.inverted;

  const Button.outlined({
    super.key,
    required this.text,
    required this.onPressed,
  }) : _variant = _ButtonVariant.outlined;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
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
          switch (_variant) {
            case _ButtonVariant.primary:
              return isActive ? AppTheme.whiteColor : AppTheme.primaryColor;
            case _ButtonVariant.secondary:
              return isActive ? AppTheme.primaryColor : AppTheme.whiteColor;
            case _ButtonVariant.inverted:
              return isActive ? AppTheme.whiteColor : AppTheme.blackColor;
            case _ButtonVariant.outlined:
              return isActive ? AppTheme.blackColor : AppTheme.whiteColor;
          }
        }),

        foregroundColor: WidgetStateProperty.resolveWith((states) {
          final isActive =
              states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered);
          switch (_variant) {
            case _ButtonVariant.primary:
              return isActive ? AppTheme.primaryColor : AppTheme.whiteColor;
            case _ButtonVariant.secondary:
              return isActive ? AppTheme.whiteColor : AppTheme.primaryColor;
            case _ButtonVariant.inverted:
              return isActive ? AppTheme.blackColor : AppTheme.whiteColor;
            case _ButtonVariant.outlined:
              return isActive ? AppTheme.whiteColor : AppTheme.blackColor;
          }
        }),

        side: WidgetStateProperty.resolveWith((states) {
          final isActive =
              states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered);
          switch (_variant) {
            case _ButtonVariant.primary:
              return BorderSide(
                color: isActive ? AppTheme.primaryColor : Colors.transparent,
                width: 1,
              );
            case _ButtonVariant.secondary:
              return const BorderSide(color: AppTheme.primaryColor, width: 1);
            case _ButtonVariant.inverted:
              return BorderSide(
                color: isActive ? AppTheme.blackColor : Colors.transparent,
                width: 1,
              );
            case _ButtonVariant.outlined:
              return const BorderSide(color: AppTheme.blackColor, width: 1);
          }
        }),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: AppTheme.bodyFont,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
