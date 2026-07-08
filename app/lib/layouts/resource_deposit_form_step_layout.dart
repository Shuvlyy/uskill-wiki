import 'package:app/core/theme.dart';
import 'package:app/widgets/dot_stepper.dart';
import 'package:app/widgets/icon_button.dart';
import 'package:app/widgets/text_icon_button.dart';
import 'package:app/widgets/title.dart';
import 'package:flutter/material.dart' hide Title;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class ResourceDepositFormStepLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final int pageIndex;
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final bool showMandatoryFieldsWarning;
  final String? errorMessage;

  const ResourceDepositFormStepLayout({
    required this.title,
    required this.body,
    required this.pageIndex,
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
              Gap(errorMessage != null ? 20 : 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 20,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      crossAxisAlignment: .center,
                      children: [
                        DotStepper(amount: 7, index: pageIndex + 1), // fixme: 7 is magic number 😤😤
                        if (showMandatoryFieldsWarning) ... {
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
                                  'Ces champs sont obligatoires.',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              )
                            ],
                          )
                        }
                      ],
                    ),
                  ),
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
