import 'package:app/data/mock_resources.dart';
import 'package:app/models/resource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResourceSearchState {
  final int currentStepIndex;

  // step 1
  final UserRole? selectedRole;

  // step 2
  final String? selectedLanguage;

  // step 3
  final LearningFocus? selectedFocus;

  // step 4
  final List<String> selectedTags;

  // step 5
  final bool showErrors;

  const ResourceSearchState({
    this.currentStepIndex = 0,
    this.selectedRole,
    this.selectedLanguage,
    this.selectedFocus,
    this.selectedTags = const [],
    this.showErrors = false,
  });

  ResourceSearchState copyWith({
    int? currentStepIndex,
    UserRole? selectedRole,
    String? selectedLanguage,
    LearningFocus? selectedFocus,
    List<String>? selectedTags,
    bool? showErrors,
  }) {
    return ResourceSearchState(
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      selectedRole: selectedRole ?? this.selectedRole,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedFocus: selectedFocus ?? this.selectedFocus,
      selectedTags: selectedTags ?? this.selectedTags,
      showErrors: showErrors ?? this.showErrors,
    );
  }
}

class ResourceSearchFormNotifier extends Notifier<ResourceSearchState> {
  @override
  ResourceSearchState build() => const ResourceSearchState();

  void setRole(UserRole role) {
    state = state.copyWith(selectedRole: role, showErrors: false);
  }

  void setLanguage(String language) {
    state = state.copyWith(selectedLanguage: language, showErrors: false);
  }

  void setFocus(LearningFocus focus) {
    state = state.copyWith(selectedFocus: focus, selectedTags: [], showErrors: false);
  }

  void toggleTag(String tag) {
    final tags = List<String>.from(state.selectedTags);
    if (tags.contains(tag)) {
      tags.remove(tag);
    } else {
      tags.add(tag);
    }
    state = state.copyWith(selectedTags: tags, showErrors: false);
  }

  void validateAndNext(bool isValid) {
    if (isValid) {
      state = state.copyWith(
        currentStepIndex: state.currentStepIndex + 1,
        showErrors: false,
      );
    } else {
      state = state.copyWith(showErrors: true);
    }
  }

  void previousStep() {
    if (state.currentStepIndex > 0) {
      state = state.copyWith(
        currentStepIndex: state.currentStepIndex - 1,
        showErrors: false,
      );
    }
  }

  void reset() {
    state = const ResourceSearchState();
  }
}

final resourceSearchFormProvider =
    NotifierProvider.autoDispose<ResourceSearchFormNotifier, ResourceSearchState>(() {
  return ResourceSearchFormNotifier();
});

final filteredResourcesProvider = Provider<List<Resource>>((ref) {
  final searchState = ref.watch(resourceSearchFormProvider);
  final allResources = ref.watch(mockResourcesProvider);

  return allResources.where((resource) {
    if (searchState.selectedRole != null &&
        !resource.targetAudiences.contains(searchState.selectedRole)) {
      return false;
    }
    if (searchState.selectedLanguage != null &&
        resource.language != searchState.selectedLanguage) {
      return false;
    }
    if (searchState.selectedFocus != null &&
        resource.focus != searchState.selectedFocus) {
      return false;
    }
    if (searchState.selectedTags.isNotEmpty) {
      return searchState.selectedTags.any((tag) => resource.tags.contains(tag));
    }
    return true;
  }).toList();
});
