import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
import 'package:app/providers/resource_deposit_provider.dart';
import 'package:app/widgets/resource_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceDepositStepPreview extends ConsumerWidget {
  const ResourceDepositStepPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resourceDepositProvider);
    final notifier = ref.read(resourceDepositProvider.notifier);

    final isLanguage = state.focus == LearningFocus.language;
    final isLinguistic = state.focus == LearningFocus.linguisticObjective;

    int pageIndex = 7;
    if (isLanguage) {
      pageIndex = 9;
    } else if (isLinguistic) {
      pageIndex = 8;
    }

    final previewResource = Resource(
      id: 'preview',
      title: state.name,
      description: state.description.isEmpty ? 'Aucune description fournie.' : state.description,
      contentUrl: state.link,
      type: _getResourceType(state.resourceType),
      language: state.language,
      focus: state.focus ?? LearningFocus.language,
      languageSkill: state.languageSkill,
      linguisticObjectives: state.linguisticObjectives.isEmpty ? null : state.linguisticObjectives,
      targetAudiences: state.targets.map(_getRoleFromString).toSet(),
      level: _getLevelFromIndex(state.languageLevel),
      tags: state.tags,
      author: Author(
        name: state.authorName,
        email: state.authorEmail,
      ),
      createdAt: DateTime.now(),
    );

    return ResourceDepositFormStepLayout(
      title: 'Prévisualisation',
      pageIndex: pageIndex,
      stepperAmount: pageIndex,
      onNext: notifier.submit,
      onBack: notifier.previousStep,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Voici un aperçu de la ressource telle qu\'elle sera affichée dans le wiki. Vérifiez bien les informations avant de valider.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ResourceCard(resource: previewResource),
        ],
      ),
    );
  }

  ResourceType _getResourceType(String type) {
    try {
      return ResourceType.values.firstWhere((e) => e.name == type);
    } catch (_) {
      return ResourceType.exercise;
    }
  }

  UserRole _getRoleFromString(String role) {
    switch (role) {
      case 'Enseignants': return UserRole.teacher;
      case 'Staff': return UserRole.staff;
      case 'Étudiants':
      default: return UserRole.student;
    }
  }

  LanguageLevel _getLevelFromIndex(int index) {
    if (index < 0 || index >= LanguageLevel.values.length) return LanguageLevel.a1;
    return LanguageLevel.values[index];
  }
}
