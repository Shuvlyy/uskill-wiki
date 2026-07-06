import 'package:app/core/regexes.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/modals/resource_deposit_form_modal.dart';
import 'package:app/widgets/labeled_text_form_field.dart';
import 'package:flutter/material.dart';

class ResourceDepositStep5 extends StatefulWidget {
  final ResourceDepositFormModal formModal;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ResourceDepositStep5({
    required this.formModal,
    required this.onNext,
    required this.onBack,
    super.key,
  });

  @override
  State<ResourceDepositStep5> createState() => _ResourceDepositStep5State();
}

class _ResourceDepositStep5State extends State<ResourceDepositStep5> {
  final _formKey = GlobalKey<FormState>();

  void _next() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
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
              initialValue: widget.formModal.authorName,
              onSaved: (value) => widget.formModal.authorName = value!,
            ),
            LabeledTextFormField(
              label: 'E-mail',
              hintText: 'john.doe@univ-nantes.fr',
              initialValue: widget.formModal.authorEmail,
              validator: (String? val) {
                if (!Regexes.email.hasMatch(val!)) {
                  return "Veuillez entrer une adresse e-mail valide.";
                }
                return null;
              },
              onSaved: (value) => widget.formModal.authorEmail = value!,
            ),
          ],
        ),
      ),
      onNext: _next,
      onBack: widget.onBack,
    );
  }
}
