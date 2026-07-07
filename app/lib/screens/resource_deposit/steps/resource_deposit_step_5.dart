import 'package:app/core/regexes.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/providers/resource_deposit_provider.dart';
import 'package:app/widgets/labeled_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceDepositStep5 extends ConsumerStatefulWidget {
  const ResourceDepositStep5({super.key});

  @override
  ConsumerState<ResourceDepositStep5> createState() => _ResourceDepositStep5State();
}

class _ResourceDepositStep5State extends ConsumerState<ResourceDepositStep5> {
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

    return ResourceDepositFormStepLayout(
      title: 'Auteur',
      showMandatoryFieldsWarning: true,
      pageIndex: 4,
      body: Form(
        key: _formKey,
        child: Column(
          spacing: 20,
          children: [
            LabeledTextFormField(
              label: 'Nom prénom',
              hintText: 'John Doe',
              initialValue: state.authorName,
              onSaved: (value) => notifier.updateStep5(authorName: value!),
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
              onSaved: (value) => notifier.updateStep5(authorEmail: value!),
            ),
          ],
        ),
      ),
      onNext: _next,
      onBack: notifier.previousStep,
    );
  }
}
