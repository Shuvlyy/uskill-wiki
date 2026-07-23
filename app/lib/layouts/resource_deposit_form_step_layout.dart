import 'package:app/core/utils.dart';
import 'package:app/core/theme.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/dot_stepper.dart';
import 'package:app/widgets/icon_button.dart';
import 'package:app/widgets/text_icon_button.dart';
import 'package:app/widgets/title.dart';
import 'package:flutter/material.dart' hide Title;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ResourceDepositFormStepLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final int pageIndex;
  final int stepperAmount;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final bool showMandatoryFieldsWarning;
  final String? errorMessage;

  const ResourceDepositFormStepLayout({
    required this.title,
    required this.body,
    required this.pageIndex,
    this.stepperAmount = 7,
    required this.onNext,
    this.onBack,
    this.showMandatoryFieldsWarning = false,
    this.errorMessage,
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
            // spacing: 40,
            children: [
              Title(title: title),
              const Gap(40),
              body,
              if (errorMessage != null) ... [
                const Gap(20),
                Text(
                  errorMessage!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.errorRedColor,
                  ),
                ),
              ],
              if (showMandatoryFieldsWarning) ... {
                const Gap(20),
                Row(
                  mainAxisSize: .min,
                  spacing: 5,
                  children: [
                    SvgPicture.asset(
                      'pictos/star-of-life.svg',
                      height: 12,
                      color: AppTheme.secondaryRedColor,
                    ),
                    Flexible(
                      child: Text(
                        context.l10n.thoseFieldsAreMandatory,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    )
                  ],
                )
              },
              Gap(errorMessage != null ? 20 : 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 20,
                children: [
                  if (onBack != null) ... {
                    TextIconButton(
                      icon: Icons.arrow_back_ios,
                      text: context.l10n.back,
                      color: Colors.grey.shade500,
                      onTap: onBack
                    ),
                    Expanded(
                      child: DotStepper(amount: stepperAmount, index: pageIndex + 1),
                    )
                  } else ... {
                    DotStepper(amount: stepperAmount, index: pageIndex + 1)
                  },
                  PrimaryIconButton(
                    icon: Icons.arrow_forward_ios,
                    onPressed: onNext
                  )
                ],
              ),
              const Gap(20),
              Column(
                children: [
                  Button.primary(
                    text: context.l10n.dontKnowWhatToSearch,
                    onPressed: () => context.go('/constellation')
                  )
                ],
              )
            ],
          ),
        ),
        if (onBack != null) ... [
          const Gap(10),
        ]
      ],
    );
  }
}
