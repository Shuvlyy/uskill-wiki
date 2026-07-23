import 'package:app/core/utils.dart';
import 'package:app/core/constants.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
import 'package:app/providers/resource_search_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:app/widgets/option_slider.dart';
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
        label: s.languageLabel(context),
        icon: Icons.language,
        isSelected: searchState.selectedLanguage == s,
        onTap: () => notifier.setLanguage(s),
      );
    }).toList();

    final isValid = searchState.selectedLanguage != null && searchState.selectedLanguageLevel != null;

    return ResourceDepositFormStepLayout(
      title: context.l10n.whichLanguage,
      pageIndex: 1,
      errorMessage: (searchState.showErrors && !isValid) ? context.l10n.selectLanguageAndLevel : null,
      onNext: () => notifier.validateAndNext(isValid),
      onBack: notifier.previousStep,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < Constants.mobileWidthThreshold;

          Widget cardsWidget = isMobile
            ? Column(spacing: 16, children: cards)
            : Row(spacing: 16, children: cards.map((card) => Expanded(child: card)).toList());

          return Column(
            spacing: 20,
            children: [
              cardsWidget,
              OptionSlider(
                label: context.l10n.languageLevel,
                steps: LanguageLevel.values.map((e) => e.label).cast<String>().toList(),
                selectedIndex: searchState.selectedLanguageLevel != null 
                  ? LanguageLevel.values.indexOf(searchState.selectedLanguageLevel!)
                  : -1,
                onChanged: (int newIndex) {
                  notifier.setLanguageLevel(LanguageLevel.values[newIndex]);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
