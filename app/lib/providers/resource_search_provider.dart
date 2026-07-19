import 'package:app/api/api_repository.dart';
import 'package:app/models/resource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// todo: better management
class ResourceSearchState {
  final int currentStepIndex;

  // step 1
  final UserRole? selectedRole;

  // step 2
  final String? selectedLanguage;
  final LanguageLevel? selectedLanguageLevel;

  // step 3
  final LearningFocus? selectedFocus;

  // step 3b
  final LanguageSkill? selectedLanguageSkill;

  // step 3c
  final List<String> selectedLinguisticObjectives;

  // step 4
  final List<String> selectedTags;

  // step 5
  final bool showErrors;

  const ResourceSearchState({
    this.currentStepIndex = 0,
    this.selectedRole,
    this.selectedLanguage,
    this.selectedLanguageLevel,
    this.selectedFocus,
    this.selectedLanguageSkill,
    this.selectedLinguisticObjectives = const [],
    this.selectedTags = const [],
    this.showErrors = false,
  });

  ResourceSearchState copyWith({
    int? currentStepIndex,
    UserRole? selectedRole,
    String? selectedLanguage,
    LanguageLevel? selectedLanguageLevel,
    LearningFocus? selectedFocus,
    LanguageSkill? selectedLanguageSkill,
    List<String>? selectedLinguisticObjectives,
    List<String>? selectedTags,
    bool? showErrors,
  }) {
    return ResourceSearchState(
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      selectedRole: selectedRole ?? this.selectedRole,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedLanguageLevel: selectedLanguageLevel ?? this.selectedLanguageLevel,
      selectedFocus: selectedFocus ?? this.selectedFocus,
      selectedLanguageSkill: selectedLanguageSkill ?? this.selectedLanguageSkill,
      selectedLinguisticObjectives: selectedLinguisticObjectives ?? this.selectedLinguisticObjectives,
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

  void setLanguageLevel(LanguageLevel level) {
    state = state.copyWith(selectedLanguageLevel: level, showErrors: false);
  }

  void setFocus(LearningFocus focus) {
    state = state.copyWith(selectedFocus: focus, selectedTags: [], selectedLanguageSkill: null, selectedLinguisticObjectives: [], showErrors: false);
  }

  void setLanguageSkill(LanguageSkill skill) {
    state = state.copyWith(selectedLanguageSkill: skill, showErrors: false);
  }

  void toggleLinguisticObjective(String objective) {
    if (state.selectedLinguisticObjectives.contains(objective)) {
      state = state.copyWith(selectedLinguisticObjectives: [], showErrors: false);
    } else {
      state = state.copyWith(selectedLinguisticObjectives: [objective], showErrors: false);
    }
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
      int nextStep = state.currentStepIndex + 1;

      // in step 3B (currentStepIndex == 3, focus == language), if phonetics, skip point de langue (4) and tags (5) and go to results (6)
      if (state.currentStepIndex == 3 && state.selectedFocus == LearningFocus.language && state.selectedLanguageSkill == LanguageSkill.phonetics) {
        nextStep = 6;
      }
      
      state = state.copyWith(
        currentStepIndex: nextStep,
        showErrors: false,
      );
    } else {
      state = state.copyWith(showErrors: true);
    }
  }

  void previousStep() {
    if (state.currentStepIndex > 0) {
      int prevStep = state.currentStepIndex - 1;

      // if we are at results (index 6) and phonetics is selected, go back to step 3b (index 3)
      if (state.currentStepIndex == 6 && state.selectedFocus == LearningFocus.language && state.selectedLanguageSkill == LanguageSkill.phonetics) {
        prevStep = 3;
      }

      state = state.copyWith(
        currentStepIndex: prevStep,
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
    level: searchState.selectedLanguageLevel,
    focus: searchState.selectedFocus,
    languageSkill: searchState.selectedLanguageSkill,
    tags: searchState.selectedTags,
    linguisticObjectives: searchState.selectedLinguisticObjectives,
  );
});
