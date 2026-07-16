import 'package:app/core/constants.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
import 'package:app/providers/resource_search_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceSearchStep3 extends ConsumerWidget {
  const ResourceSearchStep3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(resourceSearchFormProvider);
    final notifier = ref.read(resourceSearchFormProvider.notifier);

    final cards = [
      SelectableCard.vertical(
        label: 'Langue',
        icon: Icons.translate,
        isSelected: searchState.selectedFocus == LearningFocus.language,
        onTap: () => notifier.setFocus(LearningFocus.language),
      ),
      SelectableCard.vertical(
        label: 'Vie universitaire',
        icon: Icons.psychology,
        isSelected: searchState.selectedFocus == LearningFocus.univLife,
        onTap: () => notifier.setFocus(LearningFocus.univLife),
      ),
    ];

    final isValid = searchState.selectedFocus != null;

    return ResourceDepositFormStepLayout(
      title: 'Sur quoi veux-tu travailler ?',
      pageIndex: 2,
      errorMessage: (searchState.showErrors && !isValid) ? 'Veuillez sélectionner un axe de travail.' : null,
      onNext: () => notifier.validateAndNext(isValid),
      onBack: notifier.previousStep,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < Constants.mobileWidthThreshold;

          if (isMobile) {
            return Column(
              spacing: 20,
              children: cards,
            );
          }

          return Row(
            spacing: 20,
            children: cards.map((card) => Expanded(child: card)).toList(),
          );
        },
      ),
    );
  }
}
