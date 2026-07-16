import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
import 'package:app/providers/resource_deposit_provider.dart';
import 'package:app/widgets/labeled_dropdown_menu.dart';
import 'package:app/widgets/option_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceDepositStep4 extends ConsumerWidget {
  const ResourceDepositStep4({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resourceDepositProvider);
    final notifier = ref.read(resourceDepositProvider.notifier);

    final isValid = state.language.isNotEmpty && state.languageLevel != -1;

    return ResourceDepositFormStepLayout(
      title: 'Langue',
      pageIndex: 3,
      onNext: () => notifier.validateAndNext(isValid),
      onBack: notifier.previousStep,
      showMandatoryFieldsWarning: true,
      errorMessage: (state.showErrors && !isValid) ? 'Veuillez sélectionner une langue et un niveau.' : null,
      body: Column(
        spacing: 20,
        children: [
          LabeledDropdownMenu(
            label: 'Langue',
            hintText: 'Langue',
            initialSelection: state.language,
            dropdownMenuEntries: ['fr', 'en', 'es']
              .map((s) => DropdownMenuEntry(
                value: s,
                label: s.languageLabel)
              ).toList(),
            onSelected: (value) {
              if (value == null) return;
              notifier.updateStep4(language: value);
            },
          ),
          OptionSlider(
            label: 'Niveau de langue',
            steps: LanguageLevel.values.map((e) => e.label).toList(),
            selectedIndex: state.languageLevel,
            onChanged: (int newIndex) {
              notifier.updateStep4(languageLevel: newIndex);
            },
          ),
        ],
      ),
    );
  }
}
