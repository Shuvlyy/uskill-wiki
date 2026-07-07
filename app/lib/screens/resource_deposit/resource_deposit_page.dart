import 'package:app/layouts/main_page_layout.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/form/resource_deposit_form.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_1.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_2.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_3.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_4.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_5.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_loading.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_finished.dart';
import 'package:app/widgets/title.dart';
import 'package:flutter/material.dart' hide Title;

class ResourceDepositPage extends StatefulWidget {
  const ResourceDepositPage({super.key});

  @override
  State<ResourceDepositPage> createState() => _ResourceDepositPageState();
}

class _ResourceDepositPageState extends State<ResourceDepositPage> {
  int _currentIndex = 0;
  final _formModal = ResourceDepositForm();

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

  void _submitForm() async {
    _nextPage();
    await Future.delayed(const Duration(seconds: 2)); // net sim
    _nextPage();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> steps = [
      ResourceDepositStep1(
        formModal: _formModal,
        onNext: _nextPage
      ),
      ResourceDepositStep2(
        formModal: _formModal,
        onNext: _nextPage,
        onBack: _previousPage,
      ),
      ResourceDepositStep3(
        formModal: _formModal,
        onNext: _nextPage,
        onBack: _previousPage,
      ),
      ResourceDepositStep4(
        formModal: _formModal,
        onNext: _nextPage,
        onBack: _previousPage,
      ),
      ResourceDepositStep5(
        formModal: _formModal,
        onNext: _nextPage,
        onBack: _previousPage,
      ),
      ResourceDepositFormStepLayout(
        title: 'Prévisualisation de la ressource',
        body: const Center(child: Text('6')),
        pageIndex: 5, // index was 6 but it should be 5 (0-based, step 6/6)
        onNext: _submitForm,
        onBack: _previousPage,
      ),
      const ResourceDepositStepLoading(),
      const ResourceDepositStepFinished(),
    ];

    return MainPageLayout(
      body: Center(
        child: Column(
          spacing: 40,
          children: [
            Title(
              title: 'Dépôt de ressource',
              decorationAlignment: .center,
            ),
            steps[_currentIndex]
          ],
        )
      ),
    );
  }
}
