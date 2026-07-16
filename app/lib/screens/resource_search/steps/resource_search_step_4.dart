import 'package:app/core/constants.dart';
import 'package:app/core/regexes.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
import 'package:app/providers/resource_search_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:app/widgets/labeled_text_form_field.dart';
import 'package:app/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceSearchStep4 extends ConsumerStatefulWidget {
  const ResourceSearchStep4({super.key});

  @override
  ConsumerState<ResourceSearchStep4> createState() => _ResourceSearchStep4State();
}

class _ResourceSearchStep4State extends ConsumerState<ResourceSearchStep4> {
  final _customTagController = TextEditingController();
  String? _customTagError;

  @override
  void dispose() {
    _customTagController.dispose();
    super.dispose();
  }

  List<String> _getAvailableTags(LearningFocus focus) {
    if (focus == LearningFocus.language) {
      return ['ponctuation', 'grammaire', 'conjugaison', 'prononciation', 'vocabulaire'];
    } else {
      return ['sante', 'crous', 'logement', 'administratif', 'vie pratique', 'professionnel'];
    }
  }

  void _addTag(WidgetRef ref) {
    final text = _customTagController.text.trim();
    if (text.isEmpty) {
      return;
    }

    if (!Regexes.tag.hasMatch(text)) {
      setState(() {
        _customTagError = 'Caractères invalides.';
      });
      return;
    }

    final notifier = ref.read(resourceSearchFormProvider.notifier);
    final currentState = ref.read(resourceSearchFormProvider);
    
    if (!currentState.selectedTags.contains(text)) {
      notifier.toggleTag(text);
    }
    
    setState(() {
      _customTagError = null;
    });
    _customTagController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(resourceSearchFormProvider);
    final notifier = ref.read(resourceSearchFormProvider.notifier);
    final isLanguage = searchState.selectedFocus == LearningFocus.language;
    
    if (searchState.selectedFocus == null) {
      return const SizedBox.shrink();
    }

    final predefinedTags = _getAvailableTags(searchState.selectedFocus!);
    final customTags = searchState.selectedTags.where((t) => !predefinedTags.contains(t)).toList();

    return ResourceDepositFormStepLayout(
      title: 'Précise ta recherche',
      pageIndex: isLanguage ? 4 : 3,
      stepperAmount: isLanguage ? 5 : 4,
      errorMessage: searchState.showErrors && searchState.selectedTags.isEmpty ? 'Sélectionne au moins un tag.' : null,
      onNext: () {
        _addTag(ref);

        if (_customTagError != null) {
          return;
        }

        final currentTags = ref.read(resourceSearchFormProvider).selectedTags;

        notifier.validateAndNext(currentTags.isNotEmpty);
      },
      onBack: notifier.previousStep,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < Constants.mobileWidthThreshold;

          return Column(
            crossAxisAlignment: .start,
            spacing: 20,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ...predefinedTags.map((tag) {
                    return SelectableCard.horizontal(
                      label: tag,
                      icon: Icons.tag,
                      isSelected: searchState.selectedTags.contains(tag),
                      onTap: () => notifier.toggleTag(tag),
                    );
                  }),
                  ...customTags.map((tag) {
                    return SelectableCard.horizontal(
                      label: tag,
                      icon: Icons.tag,
                      isSelected: true,
                      onTap: () => notifier.toggleTag(tag),
                    );
                  }),
                ],
              ),
              if (isMobile) ... {
                Column(
                  spacing: 10,
                  crossAxisAlignment: .stretch,
                  children: [
                    LabeledTextFormField(
                      controller: _customTagController,
                      label: 'Chercher un tag',
                      hintText: 'Ex: mathématiques',
                      isRequired: false,
                      errorText: _customTagError,
                      onFieldSubmitted: (_) => _addTag(ref),
                    ),
                    Button.secondary(
                      text: 'Ajouter',
                      onPressed: () => _addTag(ref),
                    )
                  ],
                )
              } else ... {
                Row(
                  spacing: 12,
                  crossAxisAlignment: .center,
                  children: [
                    Expanded(
                      child: LabeledTextFormField(
                        controller: _customTagController,
                        label: 'Chercher un tag',
                        hintText: 'Ex: mathématiques',
                        isRequired: false,
                        errorText: _customTagError,
                        onFieldSubmitted: (_) => _addTag(ref),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Button.secondary(
                        text: 'Ajouter',
                        onPressed: () => _addTag(ref),
                      ),
                    )
                  ],
                )
              }
            ],
          );
        },
      ),
    );
  }
}
