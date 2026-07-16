import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
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

    final cards = ResourceType.values.map((e) {
      return SelectableCard.horizontal(
        label: e.label,
        isSelected: state.resourceType == e.name,
        onTap: () => notifier.setResourceType(e.name),
        icon: e.icon
      );
    }).toList();

    final isValid = state.resourceType.isNotEmpty;

    return ResourceDepositFormStepLayout(
      title: 'Type de ressource',
      pageIndex: 2,
      onNext: () => notifier.validateAndNext(isValid),
      onBack: notifier.previousStep,
      errorMessage: (state.showErrors && !isValid) ? 'Veuillez sélectionner un type de ressource.' : null,
      body: Column(
        spacing: 20,
        children: cards,
      ),
    );
  }
}
