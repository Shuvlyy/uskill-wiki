import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/providers/resource_deposit_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceDepositStep3 extends ConsumerWidget {
  const ResourceDepositStep3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resourceDepositProvider);
    final notifier = ref.read(resourceDepositProvider.notifier);

    final isValid = state.resourceType.isNotEmpty;

    return ResourceDepositFormStepLayout(
      title: 'Type de ressource',
      pageIndex: 2,
      onNext: () => notifier.validateAndNext(isValid),
      onBack: notifier.previousStep,
      errorMessage: (state.showErrors && !isValid) ? 'Veuillez sélectionner un type de ressource.' : null,
      body: Column(
        spacing: 20,
        children: [
          SelectableCard.horizontal(
            label: 'Exercice',
            icon: Icons.edit_note,
            isSelected: state.resourceType == 'exercice',
            onTap: () => notifier.setResourceType('exercice'),
          ),
          SelectableCard.horizontal(
            label: 'Vidéo',
            icon: Icons.play_circle_outline,
            isSelected: state.resourceType == 'video',
            onTap: () => notifier.setResourceType('video'),
          ),
          SelectableCard.horizontal(
            label: 'Jeu',
            icon: Icons.videogame_asset_outlined,
            isSelected: state.resourceType == 'game',
            onTap: () => notifier.setResourceType('game'),
          ),
          SelectableCard.horizontal(
            label: 'Article',
            icon: Icons.description_outlined,
            isSelected: state.resourceType == 'article',
            onTap: () => notifier.setResourceType('article'),
          ),
        ],
      ),
    );
  }
}
