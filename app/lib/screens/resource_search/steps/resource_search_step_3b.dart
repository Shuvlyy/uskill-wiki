import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
import 'package:app/providers/resource_search_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceSearchStep3b extends ConsumerWidget {
  const ResourceSearchStep3b({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resourceSearchFormProvider);
    final notifier = ref.read(resourceSearchFormProvider.notifier);

    final Map<LanguageSkill, String> labels = {
      LanguageSkill.writtenComprehension: 'Compréhension Écrite',
      LanguageSkill.oralComprehension: 'Compréhension Orale',
      LanguageSkill.writtenExpression: 'Expression Écrite',
      LanguageSkill.oralExpression: 'Expression Orale',
      LanguageSkill.phonetics: 'Phonétique',
    };

    final Map<LanguageSkill, IconData> icons = {
      LanguageSkill.writtenComprehension: Icons.menu_book,
      LanguageSkill.oralComprehension: Icons.headphones,
      LanguageSkill.writtenExpression: Icons.edit,
      LanguageSkill.oralExpression: Icons.mic,
      LanguageSkill.phonetics: Icons.record_voice_over,
    };

    final cards = LanguageSkill.values.map((skill) {
      return SelectableCard.horizontal(
        label: labels[skill]!,
        icon: icons[skill]!,
        isSelected: state.selectedLanguageSkill == skill,
        onTap: () => notifier.setLanguageSkill(skill),
      );
    }).toList();

    return ResourceDepositFormStepLayout(
      title: 'Quelle compétence langagière souhaitez-vous travailler ?',
      pageIndex: 3,
      stepperAmount: 5,
      onNext: () => notifier.validateAndNext(true), // Optional, so just continue
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
