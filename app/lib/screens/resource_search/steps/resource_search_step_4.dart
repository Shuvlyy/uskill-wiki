import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
import 'package:app/providers/resource_search_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceSearchStep4 extends ConsumerWidget {
  const ResourceSearchStep4({super.key});

  List<String> _getAvailableTags(LearningFocus focus) {
    if (focus == LearningFocus.language) {
      return ['ponctuation', 'grammaire', 'conjugaison', 'prononciation', 'vocabulaire'];
    } else {
      return ['sante', 'crous', 'logement', 'administratif', 'vie pratique', 'professionnel'];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(resourceSearchFormProvider);
    final notifier = ref.read(resourceSearchFormProvider.notifier);
    
    if (searchState.selectedFocus == null) return const SizedBox.shrink();

    final tags = _getAvailableTags(searchState.selectedFocus!);

    final isValid = searchState.selectedTags.isNotEmpty;

    return ResourceDepositFormStepLayout(
      title: 'Précise ta recherche',
      pageIndex: 3,
      errorMessage: (searchState.showErrors && !isValid) ? 'Sélectionne au moins un tag.' : null,
      onNext: () => notifier.validateAndNext(isValid),
      onBack: notifier.previousStep,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final cardWidth = isMobile ? constraints.maxWidth : (constraints.maxWidth - 12) / 2;
          
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: tags.map((tag) {
              return SizedBox(
                width: cardWidth,
                child: SelectableCard.horizontal(
                  label: tag,
                  icon: Icons.tag,
                  isSelected: searchState.selectedTags.contains(tag),
                  onTap: () => notifier.toggleTag(tag),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
