import 'package:app/core/utils.dart';
import 'package:app/core/regexes.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/providers/resource_deposit_provider.dart';
import 'package:app/widgets/labeled_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceDepositStep1 extends ConsumerStatefulWidget {
  const ResourceDepositStep1({super.key});

  @override
  ConsumerState<ResourceDepositStep1> createState() => _ResourceDepositStep1State();
}

class _ResourceDepositStep1State extends ConsumerState<ResourceDepositStep1> {
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
      title: context.l10n.resourceStep,
      showMandatoryFieldsWarning: true,
      pageIndex: 0,
      body: Form(
        key: _formKey,
        child: Column(
          spacing: 20,
          children: [
            LabeledTextFormField(
              label: context.l10n.resourceName,
              hintText: context.l10n.exerciseExample,
              initialValue: state.name,
              onSaved: (value) => notifier.updateStep1(name: value!),
            ),
            LabeledTextFormField(
              label: context.l10n.description,
              hintText: context.l10n.loremIpsum,
              initialValue: state.description,
              maxLines: 6,
              isRequired: false,
              onSaved: (value) => notifier.updateStep1(description: value!),
            ),
            LabeledTextFormField(
              label: context.l10n.link,
              hintText: context.l10n.linkExample,
              initialValue: state.link,
              validator: (String? val) {
                if (!Regexes.url.hasMatch(val!)) {
                  return context.l10n.pleaseEnterValidUrl;
                }
                return null;
              },
              onSaved: (value) => notifier.updateStep1(link: value!),
            ),
          ],
        ),
      ),
      onNext: _next
    );
  }
}
