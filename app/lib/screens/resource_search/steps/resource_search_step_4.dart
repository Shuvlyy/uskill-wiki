import 'package:app/core/utils.dart';
import 'package:app/layouts/resource_deposit_form_step_layout.dart';
import 'package:app/models/resource.dart';
import 'package:app/providers/resource_search_provider.dart';
import 'package:app/widgets/selectable_card.dart';
import 'package:app/widgets/labeled_dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceSearchStep4 extends ConsumerStatefulWidget {
  const ResourceSearchStep4({super.key});

  @override
  ConsumerState<ResourceSearchStep4> createState() => _ResourceSearchStep4State();
}

class _ResourceSearchStep4State extends ConsumerState<ResourceSearchStep4> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(resourceSearchFormProvider);
    final notifier = ref.read(resourceSearchFormProvider.notifier);
    final isLanguage = searchState.selectedFocus == LearningFocus.language;
    final tagsAsyncValue = ref.watch(tagsProvider);
    
    if (searchState.selectedFocus == null) {
      return const SizedBox.shrink();
    }

    return ResourceDepositFormStepLayout(
      title: context.l10n.refineSearchByTheme,
      pageIndex: isLanguage ? 5 : 3,
      stepperAmount: isLanguage ? 6 : 4,
      errorMessage: searchState.showErrors && searchState.selectedTags.isEmpty && searchState.selectedLinguisticObjectives.isEmpty ? context.l10n.selectAtLeastOneTheme : null,
      onNext: () {
        final hasTags = ref.read(resourceSearchFormProvider).selectedTags.isNotEmpty;
        final hasObj = ref.read(resourceSearchFormProvider).selectedLinguisticObjectives.isNotEmpty;
        notifier.validateAndNext(hasTags || hasObj);
      },
      onBack: notifier.previousStep,
      body: tagsAsyncValue.when(
        data: (tags) {
          final availableTags = tags.where((t) => !searchState.selectedTags.contains(t)).toList();
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              LabeledDropdownMenu<String>(
                label: context.l10n.searchTag,
                hintText: context.l10n.exMaths,
                isRequired: false,
                enableSearch: true,
                enableFilter: true,
                controller: _searchController,
                dropdownMenuEntries: availableTags.map((tag) {
                  return DropdownMenuEntry(value: tag, label: tag);
                }).toList(),
                onSelected: (val) {
                  if (val != null) {
                    notifier.toggleTag(val);
                    // Defer clearing so it doesn't conflict with DropdownMenu internals
                    Future.microtask(() => _searchController.clear());
                  }
                },
              ),
              if (searchState.selectedTags.isNotEmpty)
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: searchState.selectedTags.map((tag) {
                    return SelectableCard.horizontal(
                      label: tag,
                      icon: Icons.tag,
                      isSelected: true,
                      onTap: () => notifier.toggleTag(tag),
                    );
                  }).toList(),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('${context.l10n.errorLoadingTags}: $err')),
      ),
    );
  }
}
