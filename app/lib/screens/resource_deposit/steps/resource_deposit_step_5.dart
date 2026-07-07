import 'package:app/core/constants.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
import 'package:app/providers/resource_deposit_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceDepositStep5 extends ConsumerWidget {
  const ResourceDepositStep5({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resourceDepositProvider);
    final notifier = ref.read(resourceDepositProvider.notifier);

    final cards = [
      SelectableCard.vertical(
        label: 'Langue',
        icon: Icons.translate,
        isSelected: state.focus == LearningFocus.language,
        onTap: () => notifier.setFocus(LearningFocus.language),
      ),
      SelectableCard.vertical(
        label: 'Compétence',
        icon: Icons.psychology,
        isSelected: state.focus == LearningFocus.skill,
        onTap: () => notifier.setFocus(LearningFocus.skill),
      ),
    ];

    final isValid = state.focus != null;

    return ResourceDepositFormStepLayout(
      title: 'Axe de travail',
      pageIndex: 4,
      errorMessage: (state.showErrors && !isValid) ? 'Veuillez sélectionner un axe de travail.' : null,
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
