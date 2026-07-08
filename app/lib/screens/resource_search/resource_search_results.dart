import 'package:app/core/theme.dart';
import 'package:app/providers/resource_search_provider.dart';
import 'package:app/widgets/button.dart';
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

    return filteredResources.when(
      data: (res) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 650
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextIconButton(
                icon: Icons.arrow_back_ios,
                text: 'Retour aux filtres',
                color: Colors.grey.shade500,
                onTap: notifier.previousStep,
              ),
              const Gap(20),
              Text(
                'Ressources trouvées',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(5),
              Text(
                '${res.length} résultat(s) correspondant à votre recherche',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.inactiveTextColor,
                ),
              ),
              const Gap(40),
              if (res.isEmpty)
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
                Column(
                  spacing: 20,
                  children: res.map((r) => ResourceCard(resource: r)).toList(),
                ),
              const Gap(40),
              Center(
                  child: Button.primary(
                      text: 'Recommencer la recherche',
                      onPressed: () => notifier.reset()
                  )
              ),
            ],
          ),
        );
      },
      error: (err, stack) {
        return Center(child: Text('Error: $err'));
      },
      loading: () {
        return CircularProgressIndicator();
      }
    );
  }
}
