import 'package:app/core/theme.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/title.dart';
import 'package:flutter/material.dart' hide Title;
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ResourceDepositStepFinished extends StatelessWidget {
  const ResourceDepositStepFinished({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      constraints: const BoxConstraints(maxWidth: 600),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            color: AppTheme.primaryColor,
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 40,
            ),
          ),
          const Gap(40),
          
          const Title(
            title: 'Ressource déposée !',
            decorationAlignment: TitleDecorationAlignment.center,
          ),
          const Gap(20),

          Text(
            'Merci pour votre contribution. Votre ressource a été soumise et sera disponible après validation.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.inactiveTextColor,
            ),
          ),
          const Gap(40),

          Button.primary(
            text: "Retour à l'accueil",
            onPressed: () => context.go('/'),
            icon: Icons.arrow_forward,
            verticalPadding: 20,
          ),
        ],
      ),
    );
  }
}
