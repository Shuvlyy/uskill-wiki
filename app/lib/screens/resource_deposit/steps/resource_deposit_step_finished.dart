import 'package:app/core/theme.dart';
import 'package:app/providers/resource_deposit_provider.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/title.dart';
import 'package:flutter/material.dart' hide Title;
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceDepositStepFinished extends ConsumerWidget {
  const ResourceDepositStepFinished({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final depositState = ref.watch(resourceDepositProvider);
    final isError = depositState.submitStatus == SubmitStatus.error;

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
            color: isError ? Colors.red : AppTheme.primaryColor,
            child: Icon(
              isError ? Icons.close : Icons.check,
              color: Colors.white,
              size: 40,
            ),
          ),
          const Gap(40),

          Title(
            title: isError ? 'Erreur' : 'Ressource déposée !',
            decorationAlignment: TitleDecorationAlignment.center,
          ),
          const Gap(20),

          Text(
            isError
                ? (depositState.errorMessage ?? 'Une erreur inattendue est survenue lors de la communication avec le serveur.')
                : 'Merci pour votre contribution. Votre ressource a été soumise et sera disponible après validation.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.inactiveTextColor,
            ),
          ),
          const Gap(40),

          if (isError) ...[
            Button.secondary(
              text: 'Réessayer',
              onPressed: () {
                final prov = ref.read(resourceDepositProvider.notifier);
                prov.previousStep();
                prov.previousStep();
                prov.submit();
              },
              icon: Icons.refresh,
              verticalPadding: 20,
            ),
          ] else ...[
            Button.primary(
              text: "Retour à l'accueil",
              onPressed: () => context.go('/'),
              icon: Icons.arrow_forward,
              verticalPadding: 20,
            ),
          ]
        ],
      ),
    );
  }
}
