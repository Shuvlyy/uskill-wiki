import 'package:app/core/utils.dart';
import 'package:app/core/theme.dart';
import 'package:app/widgets/title.dart';
import 'package:flutter/material.dart' hide Title;
import 'package:gap/gap.dart';

class ResourceDepositStepLoading extends StatelessWidget {
  const ResourceDepositStepLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              strokeWidth: 8,
              color: AppTheme.primaryColor,
              strokeCap: StrokeCap.square,
            ),
          ),
          const Gap(40),

          Title(
            title: context.l10n.sending,
            decorationAlignment: TitleDecorationAlignment.center,
          ),
          Gap(20),

          Text(
            context.l10n.pleaseWaitSending,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.inactiveTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
