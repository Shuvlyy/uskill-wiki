import 'package:app/api/api_repository.dart';
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

  // step 3b
  final LanguageSkill? selectedLanguageSkill;

  // step 4
  final List<String> selectedTags;

  // step 5
  final bool showErrors;

  const ResourceSearchState({
    this.currentStepIndex = 0,
    this.selectedRole,
    this.selectedLanguage,
    this.selectedFocus,
    this.selectedLanguageSkill,
    this.selectedTags = const [],
    this.showErrors = false,
  });

  ResourceSearchState copyWith({
    int? currentStepIndex,
    UserRole? selectedRole,
    String? selectedLanguage,
    LearningFocus? selectedFocus,
    LanguageSkill? selectedLanguageSkill,
    List<String>? selectedTags,
    bool? showErrors,
  }) {
    return ResourceSearchState(
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      selectedRole: selectedRole ?? this.selectedRole,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedFocus: selectedFocus ?? this.selectedFocus,
      selectedLanguageSkill: selectedLanguageSkill ?? this.selectedLanguageSkill,
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
    state = state.copyWith(selectedFocus: focus, selectedTags: [], selectedLanguageSkill: null, showErrors: false);
  }

  void setLanguageSkill(LanguageSkill skill) {
    state = state.copyWith(selectedLanguageSkill: skill, showErrors: false);
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

final tagsProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  final repository = ref.watch(apiRepositoryProvider);
  return repository.getTags();
});

final filteredResourcesProvider = FutureProvider.autoDispose<List<Resource>>((ref) async {
  final searchState = ref.watch(resourceSearchFormProvider);
  final repository = ref.watch(apiRepositoryProvider);

  return repository.getResources(
    role: searchState.selectedRole,
    language: searchState.selectedLanguage,
    focus: searchState.selectedFocus,
    languageSkill: searchState.selectedLanguageSkill,
    tags: searchState.selectedTags,
  );
});
