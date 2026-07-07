import 'package:app/core/constants.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/providers/resource_search_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceSearchStep2 extends ConsumerWidget {
  const ResourceSearchStep2({super.key});

  String _getLanguageLabel(String code) {
    switch (code) {
      case 'fr': return 'Français';
      case 'en': return 'Anglais';
      case 'es': return 'Espagnol';
      default: return code;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(resourceSearchFormProvider);
    final notifier = ref.read(resourceSearchFormProvider.notifier);

    final cards = [
      SelectableCard.vertical(
        label: 'Français',
        icon: Icons.language,
        isSelected: searchState.selectedLanguage == 'fr',
        onTap: () => notifier.setLanguage('fr'),
      ),
      SelectableCard.vertical(
        label: 'Anglais',
        icon: Icons.language,
        isSelected: searchState.selectedLanguage == 'en',
        onTap: () => notifier.setLanguage('en'),
      ),
      SelectableCard.vertical(
        label: 'Espagnol',
        icon: Icons.language,
        isSelected: searchState.selectedLanguage == 'es',
        onTap: () => notifier.setLanguage('es'),
      ),
    ];

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
