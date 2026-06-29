import 'package:app/core/theme.dart';
import 'package:app/widgets/dot_stepper.dart';
import 'package:app/widgets/icon_button.dart';
import 'package:app/widgets/title.dart';
import 'package:flutter/material.dart' hide Title;

class ResourceDepositFormStepLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final int pageIndex;

  const ResourceDepositFormStepLayout({
    required this.title,
    required this.body,
    required this.pageIndex,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.primaryColor,
          width: 4
        )
      ),
      // color: Color(0XFFCECECE),
      padding: const EdgeInsets.all(40),
      constraints: BoxConstraints(
        maxWidth: 650
      ),
      child: Column(
        crossAxisAlignment: .stretch,
        spacing: 40,
        children: [
          Title(title: title),
          body,
          Row(
            mainAxisAlignment: .spaceBetween,
            spacing: 20,
            children: [
              DotStepper(amount: 6, index: pageIndex),
              PrimaryIconButton(icon: Icons.arrow_forward_ios, onPressed: () {})
            ],
          )
        ],
      ),
    );
  }
}
