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

    final cards = LearningFocus.values.map((e) {
      return SelectableCard.vertical(
        label: e.label,
        isSelected: state.focus == e,
        onTap: () => notifier.setFocus(e),
        icon: e.icon
      );
    }).toList();

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
