import 'package:app/core/utils.dart';
import 'package:app/core/constants.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
import 'package:app/providers/resource_deposit_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceDepositStep2 extends ConsumerWidget {
  const ResourceDepositStep2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resourceDepositProvider);
    final notifier = ref.read(resourceDepositProvider.notifier);

    final isValid = state.targets.isNotEmpty;

    final cards = UserRole.values.map((e) {
      return SelectableCard.vertical(
        label: e.label(context),
        isSelected: state.targets.contains(e.name),
        onTap: () => notifier.toggleTarget(e.name),
        icon: e.icon
      );
    }).toList();

    return ResourceDepositFormStepLayout(
      title: context.l10n.target,
      pageIndex: 1,
      onNext: () => notifier.validateAndNext(isValid),
      onBack: notifier.previousStep,
      errorMessage: (state.showErrors && !isValid) ? context.l10n.pleaseSelectTarget : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isMobile = constraints.maxWidth < Constants.mobileWidthThreshold;

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
