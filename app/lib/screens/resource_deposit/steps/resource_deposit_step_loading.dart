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

          const Title(
            title: 'Envoi en cours...',
            decorationAlignment: TitleDecorationAlignment.center,
          ),
          const Gap(20),

          Text(
            'Veuillez patienter pendant que nous soumettons votre ressource.',
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
