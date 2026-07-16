import 'package:app/core/constants.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
import 'package:app/providers/resource_search_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceSearchStep2 extends ConsumerWidget {
  const ResourceSearchStep2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(resourceSearchFormProvider);
    final notifier = ref.read(resourceSearchFormProvider.notifier);

    final cards = ['fr', 'en', 'es'].map((s) {
      return SelectableCard.vertical(
        label: s.languageLabel,
        icon: Icons.language,
        isSelected: searchState.selectedLanguage == s,
        onTap: () => notifier.setLanguage(s),
      );
    }).toList();

    final isValid = searchState.selectedLanguage != null;

    return ResourceDepositFormStepLayout(
      title: 'Quelle langue cherches-tu ?',
      pageIndex: 1,
      errorMessage: (searchState.showErrors && !isValid) ? 'Veuillez sélectionner une langue.' : null,
      onNext: () => notifier.validateAndNext(isValid),
      onBack: notifier.previousStep,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < Constants.mobileWidthThreshold;

          if (isMobile) {
            return Column(
              spacing: 16,
              children: cards,
            );
          }

          return Row(
            spacing: 16,
            children: cards.map((card) => Expanded(child: card)).toList(),
          );
        },
      ),
    );
  }
}
