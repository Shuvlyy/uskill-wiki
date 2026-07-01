import 'package:app/core/theme.dart';
import 'package:flutter/material.dart';

class LabeledTextFormField extends StatelessWidget {
  final String label;
  final String hintText;
  final String initialValue;
  final void Function(String?) onSaved;
  // is required, regex check...

  const LabeledTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    required this.initialValue,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 5,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTheme.blackColor,
            fontWeight: FontWeight.w600
          ),
        ),
        TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            hintText: hintText
          ),
          onSaved: onSaved,
        )
      ],
    );
  }
}
