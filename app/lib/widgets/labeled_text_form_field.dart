import 'package:app/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LabeledTextFormField extends StatelessWidget {
  final String label;
  final String hintText;
  final String? initialValue;
  final void Function(String?)? onSaved;
  final bool isRequired;
  final String? Function(String?)? validator;
  final int? maxLines;
  final TextEditingController? controller;
  final bool obscureText;
  final String? errorText;
  final void Function(String)? onFieldSubmitted;

  const LabeledTextFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.initialValue,
    this.onSaved,
    this.isRequired = true,
    this.validator,
    this.maxLines = 1,
    this.controller,
    this.obscureText = false,
    this.errorText,
    this.onFieldSubmitted,
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
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
          ),
          onFieldSubmitted: onFieldSubmitted,
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
