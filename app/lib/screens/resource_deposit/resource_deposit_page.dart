import 'package:app/layouts/main_page_layout.dart';
import 'package:app/providers/resource_deposit_provider.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_1.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_2.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_3.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_4.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_5.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_5b.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_5c.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_6.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_7.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_preview.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_loading.dart';
import 'package:app/screens/resource_deposit/steps/resource_deposit_step_finished.dart';
import 'package:app/widgets/title.dart';
import 'package:flutter/material.dart' hide Title;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/resource.dart';

class ResourceDepositPage extends ConsumerWidget {
  const ResourceDepositPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resourceDepositProvider);

    final List<Widget> steps = [
      const ResourceDepositStep1(),
      const ResourceDepositStep2(),
      const ResourceDepositStep3(),
      const ResourceDepositStep4(),
      const ResourceDepositStep5(),
      if (state.focus == LearningFocus.language) const ResourceDepositStep5b(),
      if (state.focus == LearningFocus.language || state.focus == LearningFocus.linguisticObjective) const ResourceDepositStep5c(),
      const ResourceDepositStep6(),
      const ResourceDepositStep7(),
      const ResourceDepositStepPreview(),
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
