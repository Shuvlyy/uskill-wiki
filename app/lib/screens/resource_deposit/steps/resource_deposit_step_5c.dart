import 'package:app/core/utils.dart';
import 'package:app/core/constants.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
import 'package:app/providers/resource_deposit_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceDepositStep5c extends ConsumerWidget {
  const ResourceDepositStep5c({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resourceDepositProvider);
    final notifier = ref.read(resourceDepositProvider.notifier);

    final isLanguage = state.focus == LearningFocus.language;
    final isValid = isLanguage ? true : state.linguisticObjectives.isNotEmpty;

    return ResourceDepositFormStepLayout(
      title: isLanguage ? context.l10n.languagePointOptional : context.l10n.linguisticObjectivesTitle,
      pageIndex: isLanguage ? 6 : 5,
      stepperAmount: isLanguage ? 9 : 8,
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
            isSelected: state.linguisticObjectives.contains(objective),
            onTap: () => notifier.toggleLinguisticObjective(objective),
          );
        }).toList(),
      ),
    );
  }
}
