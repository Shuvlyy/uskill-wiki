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

    final cards = [
      SelectableCard.vertical(
        label: 'Étudiant',
        icon: Icons.school_outlined,
        isSelected: searchState.selectedRole == UserRole.student,
        onTap: () => notifier.setRole(UserRole.student),
      ),
      SelectableCard.vertical(
        label: 'Enseignant',
        icon: Icons.person_outline,
        isSelected: searchState.selectedRole == UserRole.teacher,
        onTap: () => notifier.setRole(UserRole.teacher),
      ),
      SelectableCard.vertical(
        label: 'Staff',
        icon: Icons.badge,
        isSelected: searchState.selectedRole == UserRole.staff,
        onTap: () => notifier.setRole(UserRole.staff),
      ),
    ];

    final isValid = searchState.selectedRole != null;

    return ResourceDepositFormStepLayout(
      title: 'Qui es-tu ?',
      pageIndex: 0,
      errorMessage: (searchState.showErrors && !isValid) ? 'Veuillez sélectionner votre rôle.' : null,
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
