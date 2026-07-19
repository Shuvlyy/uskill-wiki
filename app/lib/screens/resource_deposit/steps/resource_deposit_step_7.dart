import 'package:app/core/regexes.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/providers/resource_deposit_provider.dart';
import 'package:app/widgets/labeled_text_form_field.dart';
import 'package:app/models/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceDepositStep7 extends ConsumerStatefulWidget {
  const ResourceDepositStep7({super.key});

  @override
  ConsumerState<ResourceDepositStep7> createState() => _ResourceDepositStep7State();
}

class _ResourceDepositStep7State extends ConsumerState<ResourceDepositStep7> {
  final _formKey = GlobalKey<FormState>();

  void _next() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    ref.read(resourceDepositProvider.notifier).nextStep();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resourceDepositProvider);
    final notifier = ref.read(resourceDepositProvider.notifier);
    final isLanguage = state.focus == LearningFocus.language;
    final isLinguistic = state.focus == LearningFocus.linguisticObjective;
    final isValid = state.authorName.isNotEmpty && state.authorEmail.isNotEmpty && Regexes.email.hasMatch(state.authorEmail);

    int pageIndex = 6;
    int stepperAmount = 7;
    if (isLanguage) {
      pageIndex = 8;
      stepperAmount = 9;
    } else if (isLinguistic) {
      pageIndex = 7;
      stepperAmount = 8;
    }

    return ResourceDepositFormStepLayout(
      title: 'Auteur',
      showMandatoryFieldsWarning: true,
      pageIndex: pageIndex,
      stepperAmount: stepperAmount,
      errorMessage: (state.showErrors && !isValid) ? 'Veuillez remplir tous les champs avec une adresse e-mail valide.' : null,
      body: Form(
        key: _formKey,
        child: Column(
          spacing: 20,
          children: [
            LabeledTextFormField(
              label: 'Nom prénom',
              hintText: 'John Doe',
              initialValue: state.authorName,
              onSaved: (value) => notifier.updateStepAuthor(authorName: value!),
            ),
            LabeledTextFormField(
              label: 'E-mail',
              hintText: 'john.doe@univ-nantes.fr',
              initialValue: state.authorEmail,
              validator: (String? val) {
                if (!Regexes.email.hasMatch(val!)) {
                  return "Veuillez entrer une adresse e-mail valide.";
                }
                return null;
              },
              onSaved: (value) => notifier.updateStepAuthor(authorEmail: value!),
            ),
          ],
        ),
      ),
      onNext: _next,
      onBack: notifier.previousStep,
    );
  }
}
