import 'package:app/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LabeledTextFormField extends StatelessWidget {
  final String label;
  final String hintText;
  final String initialValue;
  final void Function(String?) onSaved;
  final bool isRequired;
  final String? Function(String?)? validator;
  final int? maxLines;

  const LabeledTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    required this.initialValue,
    required this.onSaved,
    this.isRequired = true,
    this.validator,
    this.maxLines = 1
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      spacing: 5,
      children: [
        Row(
          spacing: 2,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.blackColor,
                  fontWeight: FontWeight.w600
              ),
            ),
            if (isRequired) ... {
              SvgPicture.asset(
                'pictos/star-of-life.svg',
                height: 12,
                color: AppTheme.secondaryRedColor,
              )
            }
          ],
        ),
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
          ),
          validator: (val) {
            if (isRequired && (val == null || val.isEmpty)) {
              return "Veuillez remplir ce champ.";
            }
            return validator?.call(val);
          },
          onSaved: onSaved,
        )
      ],
    );
  }
}
