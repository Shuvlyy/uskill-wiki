import 'package:app/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LabeledDropdownMenu<T> extends StatelessWidget {
  final String label;
  final String hintText;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final bool isRequired;
  final T? initialSelection;
  final void Function(T?) onSelected;
  final bool enableSearch;
  final bool enableFilter;
  final TextEditingController? controller;

  const LabeledDropdownMenu({
    super.key,
    required this.label,
    required this.hintText,
    required this.dropdownMenuEntries,
    this.isRequired = true,
    this.initialSelection,
    required this.onSelected,
    this.enableSearch = false,
    this.enableFilter = false,
    this.controller,
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
        DropdownMenu<T>(
          hintText: hintText,
          expandedInsets: EdgeInsets.zero,
          requestFocusOnTap: enableSearch || enableFilter,
          enableSearch: enableSearch,
          enableFilter: enableFilter,
          controller: controller,
          dropdownMenuEntries: dropdownMenuEntries,
          initialSelection: initialSelection,
          onSelected: onSelected,
        )
      ]
    );
  }
}
