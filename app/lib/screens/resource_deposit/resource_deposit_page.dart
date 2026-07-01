import 'package:app/layouts/main_page_layout.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/modals/resource_deposit_form_modal.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_1.dart';
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
      ResourceDepositFormStepLayout(
        key: const ValueKey(1),
        title: 'hi 1',
        body: const Center(child: Text('1')),
        pageIndex: 1,
        onNext: _nextPage,
        onBack: _previousPage,
      ),
      ResourceDepositFormStepLayout(
        key: const ValueKey(2),
        title: 'hi 2',
        body: const Center(child: Text('2')),
        pageIndex: 2,
        onNext: _nextPage,
        onBack: _previousPage,
      ),
      ResourceDepositFormStepLayout(
        key: const ValueKey(3),
        title: 'hi 3',
        body: const Center(child: Text('3')),
        pageIndex: 3,
        onNext: _nextPage,
        onBack: _previousPage,
      ),
      ResourceDepositFormStepLayout(
        key: const ValueKey(4),
        title: 'hi 4',
        body: const Center(child: Text('4')),
        pageIndex: 4,
        onNext: _submitForm,
        onBack: _previousPage,
      )
    ];

    return MainPageLayout(
      body: Center(
        child: steps[_currentIndex]
      ),
    );
  }
}
