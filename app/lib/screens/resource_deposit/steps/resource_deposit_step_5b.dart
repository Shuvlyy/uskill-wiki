import 'package:app/core/constants.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
import 'package:app/providers/resource_deposit_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceDepositStep5b extends ConsumerWidget {
  const ResourceDepositStep5b({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resourceDepositProvider);
    final notifier = ref.read(resourceDepositProvider.notifier);

    final cards = LanguageSkill.values.map((skill) {
      return SelectableCard.horizontal(
        label: skill.label,
        icon: skill.icon,
        isSelected: state.languageSkill == skill,
        onTap: () => notifier.setLanguageSkill(skill),
      );
    }).toList();

    final isValid = state.languageSkill != null;

    return ResourceDepositFormStepLayout(
      title: 'Compétence langagière',
      pageIndex: 5,
      stepperAmount: 8,
      errorMessage: (state.showErrors && !isValid) ? 'Veuillez sélectionner une compétence.' : null,
      onNext: () => notifier.validateAndNext(isValid),
      onBack: notifier.previousStep,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final cardWidth = isMobile ? constraints.maxWidth : (constraints.maxWidth - 12) / 2;

          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: cards.map((card) {
              return SizedBox(
                width: cardWidth,
                child: card,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
