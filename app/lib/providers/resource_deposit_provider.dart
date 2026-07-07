import 'package:app/models/resource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  // step 6
  final List<String> tags;

  // step 7
  final String authorName;
  final String authorEmail;

  final bool showErrors;

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
    this.tags = const [],
    this.authorName = '',
    this.authorEmail = '',
    this.showErrors = false,
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
    List<String>? tags,
    String? authorName,
    String? authorEmail,
    bool? showErrors,
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
      tags: tags ?? this.tags,
      authorName: authorName ?? this.authorName,
      authorEmail: authorEmail ?? this.authorEmail,
      showErrors: showErrors ?? this.showErrors,
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
    state = state.copyWith(focus: focus, tags: [], showErrors: false);
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
      state = state.copyWith(
        currentStepIndex: state.currentStepIndex + 1,
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
      state = state.copyWith(
        currentStepIndex: state.currentStepIndex - 1,
        showErrors: false,
      );
    }
  }

  Future<void> submit() async {
    nextStep(); // to loading step
    await Future.delayed(const Duration(seconds: 2));
    nextStep(); // to finished step
  }

  void reset() {
    state = const ResourceDepositState();
  }
}

final resourceDepositProvider =
    NotifierProvider.autoDispose<ResourceDepositNotifier, ResourceDepositState>(() {
  return ResourceDepositNotifier();
});
