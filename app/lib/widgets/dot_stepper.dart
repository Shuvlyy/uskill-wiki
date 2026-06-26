import 'package:app/core/theme.dart';
import 'package:flutter/material.dart';

class DotStepper extends StatelessWidget {
  static const double size = 6;

  final int amount;
  final int index;

  const DotStepper({required this.amount, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      mainAxisSize: .min, // todo: maybe delete this
      spacing: 6,
      children: List.generate(amount, (int index) {
        Color dotColor = AppTheme.blackColor;

        if (index >= this.index) {
          dotColor = dotColor.withValues(alpha: .2);
        }

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: dotColor,
            borderRadius: BorderRadius.circular(size / 2),
          ),
        );
      }),
    );
  }
}
