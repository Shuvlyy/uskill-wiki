import 'package:app/core/theme.dart';
import 'package:app/widgets/dot_stepper.dart';
import 'package:app/widgets/icon_button.dart';
import 'package:app/widgets/text_icon_button.dart';
import 'package:app/widgets/title.dart';
import 'package:flutter/material.dart' hide Title;
import 'package:gap/gap.dart';

class ResourceDepositFormStepLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final int pageIndex;
  final VoidCallback onNext;
  final VoidCallback? onBack;

  const ResourceDepositFormStepLayout({
    required this.title,
    required this.body,
    required this.pageIndex,
    required this.onNext,
    this.onBack,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.primaryColor,
              width: 4
            )
          ),
          padding: const EdgeInsets.all(40),
          constraints: BoxConstraints(
            maxWidth: 650 // todo: change?
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 40,
            children: [
              Title(title: title),
              body,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 20,
                children: [
                  DotStepper(amount: 6, index: pageIndex + 1), // fixme: 6 is magic number 😤😤
                  PrimaryIconButton(
                    icon: Icons.arrow_forward_ios,
                    onPressed: onNext
                  )
                ],
              )
            ],
          ),
        ),
        if (onBack != null) ... [
          const Gap(10),
          TextIconButton(
            icon: Icons.arrow_back_ios,
            text: 'Back',
            color: Colors.grey.shade500,
            onTap: onBack
          ),
        ]
      ],
    );
  }
}
