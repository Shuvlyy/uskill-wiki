import 'package:app/core/utils.dart';
import 'package:app/core/constants.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
import 'package:app/providers/resource_search_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceSearchStep1 extends ConsumerWidget {
  const ResourceSearchStep1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(resourceSearchFormProvider);
    final notifier = ref.read(resourceSearchFormProvider.notifier);

    final cards = UserRole.values.map((e) {
      return SelectableCard.vertical(
        label: e.label(context),
        isSelected: searchState.selectedRole == e,
        onTap: () => notifier.setRole(e),
        icon: e.icon
      );
    }).toList();

    final isValid = searchState.selectedRole != null;

    return ResourceDepositFormStepLayout(
      title: context.l10n.whoAreYou,
      pageIndex: 0,
      errorMessage: (searchState.showErrors && !isValid) ? context.l10n.pleaseSelectRole : null,
      onNext: () => notifier.validateAndNext(isValid),
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
