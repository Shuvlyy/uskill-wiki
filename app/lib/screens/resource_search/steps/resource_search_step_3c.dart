import 'package:app/core/utils.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
import 'package:app/providers/resource_search_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:app/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceSearchStep3c extends ConsumerWidget {
  const ResourceSearchStep3c({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resourceSearchFormProvider);
    final notifier = ref.read(resourceSearchFormProvider.notifier);

    final isLanguage = state.selectedFocus == LearningFocus.language;
    final isValid = isLanguage ? true : state.selectedLinguisticObjectives.isNotEmpty;

    return ResourceDepositFormStepLayout(
      title: isLanguage ? context.l10n.languagePointOptional : context.l10n.linguisticObjectivesTitle,
      pageIndex: isLanguage ? 4 : 3,
      stepperAmount: isLanguage ? 6 : 4,
      errorMessage: (state.showErrors && !isValid) ? context.l10n.pleaseSelectAtLeastOneObjective : null,
      onNext: () => notifier.validateAndNext(isValid),
      onBack: notifier.previousStep,
      body: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: Constants.linguisticObjectives.map((objective) {
          return SelectableCard.horizontal(
            label: context.translateObjective(objective),
            icon: Icons.flag,
            isSelected: state.selectedLinguisticObjectives.contains(objective),
            onTap: () => notifier.toggleLinguisticObjective(objective),
          );
        }).toList(),
      ),
    );
  }
}
