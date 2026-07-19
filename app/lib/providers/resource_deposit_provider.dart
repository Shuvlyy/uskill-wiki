import 'package:app/api/api_repository.dart';
import 'package:app/models/resource.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SubmitStatus { idle, loading, success, error }

// todo: better management
class ResourceDepositState {
  final int currentStepIndex;

  // step 1
  final String name;
  final String description;
  final String link;

  // step 2
  final List<String> targets;

  // step 3
  final String resourceType;

  // step 4
  final String language;
  final int languageLevel;

  // step 5
  final LearningFocus? focus;

  // step 5b
  final LanguageSkill? languageSkill;

  // step 5c
  final List<String> linguisticObjectives;

  // step 6
  final List<String> tags;

  // step 7
  final String authorName;
  final String authorEmail;

  final bool showErrors;

  final SubmitStatus submitStatus;
  final String? errorMessage;

  const ResourceDepositState({
    this.currentStepIndex = 0,
    this.name = '',
    this.description = '',
    this.link = '',
    this.targets = const [],
    this.resourceType = '',
    this.language = '',
    this.languageLevel = -1,
    this.focus,
    this.languageSkill,
    this.linguisticObjectives = const [],
    this.tags = const [],
    this.authorName = '',
    this.authorEmail = '',
    this.showErrors = false,
    this.submitStatus = SubmitStatus.idle,
    this.errorMessage,
  });

  ResourceDepositState copyWith({
    int? currentStepIndex,
    String? name,
    String? description,
    String? link,
    List<String>? targets,
    String? resourceType,
    String? language,
    int? languageLevel,
    LearningFocus? focus,
    LanguageSkill? languageSkill,
    List<String>? linguisticObjectives,
    List<String>? tags,
    String? authorName,
    String? authorEmail,
    bool? showErrors,
    SubmitStatus? submitStatus,
    String? errorMessage,
  }) {
    return ResourceDepositState(
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      name: name ?? this.name,
      description: description ?? this.description,
      link: link ?? this.link,
      targets: targets ?? this.targets,
      resourceType: resourceType ?? this.resourceType,
      language: language ?? this.language,
      languageLevel: languageLevel ?? this.languageLevel,
      focus: focus ?? this.focus,
      languageSkill: languageSkill ?? this.languageSkill,
      linguisticObjectives: linguisticObjectives ?? this.linguisticObjectives,
      tags: tags ?? this.tags,
      authorName: authorName ?? this.authorName,
      authorEmail: authorEmail ?? this.authorEmail,
      showErrors: showErrors ?? this.showErrors,
      submitStatus: submitStatus ?? this.submitStatus,
      errorMessage: errorMessage,
    );
  }
}

class ResourceDepositNotifier extends Notifier<ResourceDepositState> {
  @override
  ResourceDepositState build() => const ResourceDepositState();

  void updateStep1({String? name, String? description, String? link}) {
    state = state.copyWith(
      name: name,
      description: description,
      link: link,
      showErrors: false,
    );
  }

  void toggleTarget(String target) {
    final targets = List<String>.from(state.targets);
    if (targets.contains(target)) {
      targets.remove(target);
    } else {
      targets.add(target);
    }
    state = state.copyWith(targets: targets, showErrors: false);
  }

  void setResourceType(String type) {
    state = state.copyWith(resourceType: type, showErrors: false);
  }

  void updateStep4({String? language, int? languageLevel}) {
    state = state.copyWith(
      language: language,
      languageLevel: languageLevel,
      showErrors: false,
    );
  }

  void setFocus(LearningFocus focus) {
    state = state.copyWith(focus: focus, tags: [], languageSkill: null, linguisticObjectives: [], showErrors: false);
  }

  void setLanguageSkill(LanguageSkill skill) {
    state = state.copyWith(languageSkill: skill, showErrors: false);
  }

  void toggleLinguisticObjective(String objective) {
    if (state.linguisticObjectives.contains(objective)) {
      state = state.copyWith(linguisticObjectives: [], showErrors: false);
    } else {
      state = state.copyWith(linguisticObjectives: [objective], showErrors: false);
    }
  }

  void toggleTag(String tag) {
    final tags = List<String>.from(state.tags);
    if (tags.contains(tag)) {
      tags.remove(tag);
    } else {
      tags.add(tag);
    }
    state = state.copyWith(tags: tags, showErrors: false);
  }

  void updateStepAuthor({String? authorName, String? authorEmail}) {
    state = state.copyWith(
      authorName: authorName,
      authorEmail: authorEmail,
      showErrors: false,
    );
  }

  void validateAndNext(bool isValid) {
    if (isValid) {
      int nextStep = state.currentStepIndex + 1;

      // in deposit, for language focus:
      // index 5 = step 5b (skill), index 6 = step 5c (point de langue), index 7 = step 6 (tags), index 8 = step 7 (author)
      if (state.currentStepIndex == 5 && state.focus == LearningFocus.language && state.languageSkill == LanguageSkill.phonetics) {
        // skip point de langue (6) and tags (7), go direectly to author (8)
        nextStep = 8;
      }

      // for linguisticObjective focus:
      // index 5 = step 5c (point de langue), index 6 = step 6 (Tags), index 7 = step 7 (author)
      if (state.currentStepIndex == 5 && state.focus == LearningFocus.linguisticObjective) {
        // skip tags (6), go directly to author (7)
        nextStep = 7;
      }

      state = state.copyWith(
        currentStepIndex: nextStep,
        showErrors: false,
      );
    } else {
      state = state.copyWith(showErrors: true);
    }
  }

  void nextStep() {
    state = state.copyWith(currentStepIndex: state.currentStepIndex + 1);
  }

  void previousStep() {
    if (state.currentStepIndex > 0) {
      int prevStep = state.currentStepIndex - 1;

      if (state.currentStepIndex == 8 && state.focus == LearningFocus.language && state.languageSkill == LanguageSkill.phonetics) {
        // came from step 5b
        prevStep = 5;
      }

      if (state.currentStepIndex == 7 && state.focus == LearningFocus.linguisticObjective) {
        // Came from step 5c
        prevStep = 5;
      }

      state = state.copyWith(
        currentStepIndex: prevStep,
        showErrors: false,
      );
    }
  }

  Future<void> submit() async {
    state = state.copyWith(submitStatus: SubmitStatus.loading, errorMessage: null);
    nextStep(); // to loading step

    try {
      final repository = ref.read(apiRepositoryProvider);

      print("parsing resource");
      print(state.targets);
      print(state.targets.map((t) => UserRole.values.firstWhere((e) => e.name == t)).toSet());
      print(ResourceType.values.firstWhere((e) => e.name == state.resourceType));
      final newResource = Resource(
        title: state.name,
        description: state.description,
        contentUrl: state.link,
        type: ResourceType.values.firstWhere((e) => e.name == state.resourceType),
        language: state.language,
        level: LanguageLevel.values[state.languageLevel],
        focus: state.focus!,
        languageSkill: state.languageSkill,
        linguisticObjectives: state.linguisticObjectives.isEmpty ? null : state.linguisticObjectives,
        targetAudiences: state.targets.map((t) => UserRole.values.firstWhere((e) => e.name == t)).toSet(),
        tags: state.tags,
        author: Author(name: state.authorName, email: state.authorEmail),
      );

      print("just before submitting");
      await repository.submitResource(newResource);

      state = state.copyWith(submitStatus: SubmitStatus.success);
      nextStep(); // to finished step
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      String errMsg = 'An unexpected error occurred.';
      if (e is DioException) {
        errMsg = 'Server error: ${e.response?.statusCode} - ${e.message}';
      }

      state = state.copyWith(
        submitStatus: SubmitStatus.error,
        errorMessage: errMsg,
      );
      nextStep(); // to finished step (which will be error lol)
    }
  }

  void reset() {
    state = const ResourceDepositState();
  }
}

final resourceDepositProvider =
    NotifierProvider.autoDispose<ResourceDepositNotifier, ResourceDepositState>(() {
  return ResourceDepositNotifier();
});
