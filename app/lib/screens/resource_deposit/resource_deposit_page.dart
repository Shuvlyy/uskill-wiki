import 'package:app/layouts/main_page_layout.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/modals/resource_deposit_form_modal.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_1.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_2.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_3.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_4.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_5.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_finished.dart';
import 'package:flutter/material.dart';

class ResourceDepositPage extends StatefulWidget {
  const ResourceDepositPage({super.key});

  @override
  State<ResourceDepositPage> createState() => _ResourceDepositPageState();
}

class _ResourceDepositPageState extends State<ResourceDepositPage> {
  int _currentIndex = 0;
  final _formModal = ResourceDepositFormModal();

  void _nextPage() {
    setState(() {
      _currentIndex++;
    });
  }

  void _previousPage() {
    setState(() {
      _currentIndex--;
    });
  }

  void _submitForm() {
    print("Formulaire soumis par: ${_formModal.authorName}");
    _nextPage();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> steps = [
      ResourceDepositStep1(
        key: const ValueKey(1),
        formModal: _formModal,
        onNext: _nextPage
      ),
      ResourceDepositStep2(
        key: const ValueKey(2),
        formModal: _formModal,
        onNext: _nextPage,
        onBack: _previousPage,
      ),
      ResourceDepositStep3(
        key: const ValueKey(3),
        formModal: _formModal,
        onNext: _nextPage,
        onBack: _previousPage,
      ),
      ResourceDepositStep4(
        key: const ValueKey(4),
        formModal: _formModal,
        onNext: _nextPage,
        onBack: _previousPage,
      ),
      ResourceDepositStep5(
        key: const ValueKey(5),
        formModal: _formModal,
        onNext: _nextPage,
        onBack: _previousPage,
      ),
      ResourceDepositFormStepLayout(
        key: const ValueKey(6),
        title: 'Prévisualisation de la ressource',
        body: const Center(child: Text('6')),
        pageIndex: 6,
        onNext: _submitForm,
        onBack: _previousPage,
      ),
      const ResourceDepositStepFinished(
        key: ValueKey('finished'),
      ),
    ];

    return MainPageLayout(
      body: Center(
        child: steps[_currentIndex]
      ),
    );
  }
}
