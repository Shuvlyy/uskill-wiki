import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/providers/resource_search_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceSearchStep3c extends ConsumerWidget {
  const ResourceSearchStep3c({super.key});

  static const List<String> dummyObjectives = [
    'La ponctuation',
    'Le nom',
    'Le complément du nom',
    'Le présent de l’indicatif',
    'L’impératif',
    'Le passé',
    'Le futur',
    'Le conditionnel',
    'Le subjonctif',
    'Le passif',
    'Le discours rapporté',
    'L’hypothèse',
    'La modalisation',
    'La mise en relief',
    'L’énonciation',
    'Les pronoms',
    'Les déterminants',
    'Le comparatif et le superlatif',
    'L’adjectif',
    'L\'interrogation',
    'La négation',
    'Les présentatifs',
    'La localisation spatiale',
    'La localisation temporelle',
    'Articulateurs chronologiques (du discours)',
    'Les articulateurs logiques'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resourceSearchFormProvider);
    final notifier = ref.read(resourceSearchFormProvider.notifier);

    final isValid = state.selectedLinguisticObjectives.isNotEmpty;

    return ResourceDepositFormStepLayout(
      title: 'Quels sont vos objectifs linguistiques ?',
      pageIndex: 3,
      stepperAmount: 5,
      errorMessage: (state.showErrors && !isValid) ? 'Veuillez sélectionner au moins un objectif.' : null,
      onNext: () => notifier.validateAndNext(isValid),
      onBack: notifier.previousStep,
      body: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: dummyObjectives.map((objective) {
          return SelectableCard.horizontal(
            label: objective,
            icon: Icons.flag,
            isSelected: state.selectedLinguisticObjectives.contains(objective),
            onTap: () => notifier.toggleLinguisticObjective(objective),
          );
        }).toList(),
      ),
    );
  }
}
