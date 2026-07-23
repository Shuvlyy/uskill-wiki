import 'package:app/core/utils.dart';
import 'package:app/core/constants.dart';
import 'package:app/core/regexes.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
import 'package:app/providers/resource_deposit_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:app/widgets/labeled_text_form_field.dart';
import 'package:app/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceDepositStep6 extends ConsumerStatefulWidget {
  const ResourceDepositStep6({super.key});

  @override
  ConsumerState<ResourceDepositStep6> createState() => _ResourceDepositStep6State();
}

class _ResourceDepositStep6State extends ConsumerState<ResourceDepositStep6> {
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
        _customTagError = context.l10n.invalidCharacters;
      });
      return;
    }

    final notifier = ref.read(resourceDepositProvider.notifier);
    final currentState = ref.read(resourceDepositProvider);
    
    if (!currentState.tags.contains(text)) {
      notifier.toggleTag(text);
    }
    
    setState(() {
      _customTagError = null;
    });
    _customTagController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resourceDepositProvider);
    final notifier = ref.read(resourceDepositProvider.notifier);
    
    if (state.focus == null) {
      return const SizedBox.shrink();
    }

    final predefinedTags = _getAvailableTags(state.focus!);
    final customTags = state.tags.where((t) => !predefinedTags.contains(t)).toList();

    final isLanguage = state.focus == LearningFocus.language;
    final isLinguistic = state.focus == LearningFocus.linguisticObjective;
    final isValid = state.tags.isNotEmpty || state.linguisticObjectives.isNotEmpty;

    int pageIndex = 5;
    int stepperAmount = 7;
    if (isLanguage) {
      pageIndex = 7;
      stepperAmount = 9;
    } else if (isLinguistic) {
      pageIndex = 6;
      stepperAmount = 8;
    }

    return ResourceDepositFormStepLayout(
      title: context.l10n.tagsAndTheme,
      pageIndex: pageIndex,
      stepperAmount: stepperAmount,
      errorMessage: (state.showErrors && !isValid) ? context.l10n.pleaseSelectAtLeastOneTagOrLanguagePoint : null,
      onNext: () {
        _addTag(ref);

        if (_customTagError != null) {
          return;
        }

        final currentTags = ref.read(resourceDepositProvider).tags;
        final hasObj = ref.read(resourceDepositProvider).linguisticObjectives.isNotEmpty;

        notifier.validateAndNext(currentTags.isNotEmpty || hasObj);
      },
      onBack: notifier.previousStep,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < Constants.mobileWidthThreshold;

          return Column(
            crossAxisAlignment: .start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ...predefinedTags.map((tag) {
                    return SelectableCard.horizontal(
                      label: tag,
                      icon: Icons.tag,
                      isSelected: state.tags.contains(tag),
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
                      label: context.l10n.searchTag,
                      hintText: context.l10n.exMaths,
                      isRequired: false,
                      errorText: _customTagError,
                      onFieldSubmitted: (_) => _addTag(ref),
                    ),
                    Button.secondary(
                      text: context.l10n.add,
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
                        label: context.l10n.searchTag,
                        hintText: context.l10n.exMaths,
                        isRequired: false,
                        errorText: _customTagError,
                        onFieldSubmitted: (_) => _addTag(ref),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Button.secondary(
                        text: context.l10n.add,
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
