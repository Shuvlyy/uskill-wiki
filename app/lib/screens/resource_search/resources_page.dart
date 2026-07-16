import 'package:app/layouts/main_page_layout.dart';
import 'package:app/providers/resource_search_provider.dart';
import 'package:app/screens/resource_search/steps/resource_search_step_1.dart';
import 'package:app/screens/resource_search/steps/resource_search_step_2.dart';
import 'package:app/screens/resource_search/steps/resource_search_step_3.dart';
import 'package:app/screens/resource_search/steps/resource_search_step_3b.dart';
import 'package:app/screens/resource_search/steps/resource_search_step_4.dart';
import 'package:app/screens/resource_search/resource_search_results.dart';
import 'package:app/widgets/title.dart';
import 'package:flutter/material.dart' hide Title;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/resource.dart';

class ResourcesPage extends ConsumerWidget {
  const ResourcesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(resourceSearchFormProvider.select((s) => s.currentStepIndex));

    return MainPageLayout(
      body: Center(
        child: Column(
          spacing: 40,
          children: [
            Title(
              title: 'Recherche de ressource',
              decorationAlignment: .center,
            ),
            _buildStep(currentStep, ref.watch(resourceSearchFormProvider))
          ],
        ),
      )
    );
  }

  Widget _buildStep(int stepIndex, ResourceSearchState state) {
    final isLanguage = state.selectedFocus == LearningFocus.language;

    if (stepIndex == 0) return const ResourceSearchStep1();
    if (stepIndex == 1) return const ResourceSearchStep2();
    if (stepIndex == 2) return const ResourceSearchStep3();
    
    if (isLanguage) {
      if (stepIndex == 3) return const ResourceSearchStep3b();
      if (stepIndex == 4) return const ResourceSearchStep4();
      if (stepIndex == 5) return const ResourceSearchResults();
    } else {
      if (stepIndex == 3) return const ResourceSearchStep4();
      if (stepIndex == 4) return const ResourceSearchResults();
    }

    return const ResourceSearchStep1();
  }
}
