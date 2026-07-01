import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/modals/resource_deposit_form_modal.dart';
import 'package:app/widgets/labeled_text_form_field.dart';
import 'package:flutter/material.dart';

class ResourceDepositStep1 extends StatefulWidget {
  final ResourceDepositFormModal formModal;
  final VoidCallback onNext;

  const ResourceDepositStep1({
    required this.formModal,
    required this.onNext,
    super.key,
  });

  @override
  State<ResourceDepositStep1> createState() => _ResourceDepositStep1State();
}

class _ResourceDepositStep1State extends State<ResourceDepositStep1> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResourceDepositFormStepLayout(
      title: 'Ressource',
      showMandatoryFieldsWarning: true,
      pageIndex: 0,
      body: Form(
        key: _formKey,
        child: Column(
          spacing: 20,
          children: [
            LabeledTextFormField(
              label: 'Nom de la ressource',
              hintText: 'Exercice sur les panthères roses',
              initialValue: widget.formModal.name,
              onSaved: (value) => widget.formModal.name = value!,
            ),
            LabeledTextFormField(
              label: 'Description',
              hintText: 'Lorem ipsum dolor sit amet',
              initialValue: widget.formModal.description,
              maxLines: 6,
              onSaved: (value) => widget.formModal.description = value!,
            ),
            LabeledTextFormField(
              label: 'Lien',
              hintText: 'https://...',
              initialValue: widget.formModal.link,
              onSaved: (value) => widget.formModal.link = value!,
            ),
          ],
        ),
      ),
      onNext: widget.onNext
    );
  }
}
