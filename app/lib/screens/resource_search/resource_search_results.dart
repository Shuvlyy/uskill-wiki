import 'package:app/core/theme.dart';
import 'package:app/providers/resource_search_provider.dart';
import 'package:app/widgets/resource_card.dart';
import 'package:app/widgets/text_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ResourceSearchResults extends ConsumerWidget {
  const ResourceSearchResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredResources = ref.watch(filteredResourcesProvider);
    final notifier = ref.read(resourceSearchFormProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextIconButton(
          icon: Icons.arrow_back_ios,
          text: 'Retour aux filtres',
          color: Colors.grey.shade500,
          onTap: notifier.previousStep,
        ),
        const Gap(24),
        Text(
          'Ressources trouvées',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontFamily: AppTheme.titleFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(8),
        Text(
          '${filteredResources.length} résultat(s) correspondant à votre recherche',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.inactiveTextColor,
          ),
        ),
        const Gap(32),
        if (filteredResources.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'Aucune ressource ne correspond à vos critères.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          )
        else
          ...filteredResources.map((res) => ResourceCard(resource: res)),
        const Gap(40),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            onPressed: () => notifier.reset(),
            child: const Text('Recommencer la recherche'),
          ),
        ),
      ],
    );
  }
}
