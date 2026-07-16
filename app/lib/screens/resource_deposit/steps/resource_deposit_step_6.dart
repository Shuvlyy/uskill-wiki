import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
import 'package:app/providers/resource_deposit_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceDepositStep6 extends ConsumerWidget {
  const ResourceDepositStep6({super.key});

  List<String> _getAvailableTags(LearningFocus focus) {
    if (focus == LearningFocus.language) {
      return ['ponctuation', 'grammaire', 'conjugaison', 'prononciation', 'vocabulaire'];
    } else {
      return ['sante', 'crous', 'logement', 'administratif', 'vie pratique', 'professionnel'];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resourceDepositProvider);
    final notifier = ref.read(resourceDepositProvider.notifier);
    
    if (state.focus == null) return const SizedBox.shrink();

    final tags = _getAvailableTags(state.focus!);

    final isValid = state.tags.isNotEmpty;
    final isLanguage = state.focus == LearningFocus.language;

    return ResourceDepositFormStepLayout(
      title: 'Tags',
      pageIndex: isLanguage ? 6 : 5,
      stepperAmount: isLanguage ? 8 : 7,
      errorMessage: (state.showErrors && !isValid) ? 'Sélectionne au moins un tag.' : null,
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
                  isSelected: state.tags.contains(tag),
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
