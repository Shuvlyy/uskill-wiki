import 'package:app/layouts/main_page_layout.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/providers/resource_deposit_provider.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_1.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_2.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_3.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_4.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_5.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_6.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_7.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_loading.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_finished.dart';
import 'package:app/widgets/title.dart';
import 'package:flutter/material.dart' hide Title;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceDepositPage extends ConsumerWidget {
  const ResourceDepositPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resourceDepositProvider);
    final notifier = ref.read(resourceDepositProvider.notifier);

    final List<Widget> steps = [
      const ResourceDepositStep1(),
      const ResourceDepositStep2(),
      const ResourceDepositStep3(),
      const ResourceDepositStep4(),
      const ResourceDepositStep5(),
      const ResourceDepositStep6(),
      const ResourceDepositStep7(),
      ResourceDepositFormStepLayout(
        title: 'Prévisualisation de la ressource',
        body: const Center(child: Text('8')),
        pageIndex: 7,
        onNext: notifier.submit,
        onBack: notifier.previousStep,
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
            steps[state.currentStepIndex]
          ],
        )
      ),
    );
  }
}
