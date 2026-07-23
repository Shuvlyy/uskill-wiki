import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:app/core/utils.dart';

part 'resource.freezed.dart';
part 'resource.g.dart';

@JsonEnum()
enum UserRole { student, teacher, staff }

@JsonEnum()
enum ResourceType {
  exercise,
  activity,
  game,
  video,
  audio,
  article,
  pdf,
  text,
  image
}

@JsonEnum()
enum LanguageLevel { a1, a2, b1, b2, c1, c2 }

@JsonEnum()
enum LearningFocus { language, univLife, linguisticObjective }

@JsonEnum()
enum LanguageSkill {
  writtenComprehension,
  oralComprehension,
  writtenExpression,
  oralExpression,
  phonetics,
}

@freezed
abstract class Author with _$Author {
  const factory Author({
    required String name,
    required String email,
  }) = _Author;

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
}

@freezed
abstract class Resource with _$Resource {
  const factory Resource({
    String? id,
    required String title,
    required String description,
    @JsonKey(name: 'content_url') required String contentUrl,
    required ResourceType type,
    required String language,
    required LearningFocus focus,
    @JsonKey(name: 'language_skill') LanguageSkill? languageSkill,
    @JsonKey(name: 'target_audiences') required Set<UserRole> targetAudiences,
    required LanguageLevel level,
    required List<String> tags,
    @JsonKey(name: 'linguistic_objectives') List<String>? linguisticObjectives,
    required Author author,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    String? status,
  }) = _Resource;

  factory Resource.fromJson(Map<String, dynamic> json) => _$ResourceFromJson(json);
}

extension UserRoleX on UserRole {
  String label(BuildContext context) {
    switch (this) {
      case UserRole.staff: return context.l10n.roleStaff;
      case UserRole.student: return context.l10n.roleStudent;
      case UserRole.teacher: return context.l10n.roleTeacher;
    }
  }

  IconData get icon {
    switch (this) {
      case .staff: return Icons.badge;
      case .student: return Icons.school_outlined;
      case .teacher: return Icons.person_outline;
    }
  }
}

extension LearningFocusX on LearningFocus {
  String label(BuildContext context) {
    switch (this) {
      case LearningFocus.language: return context.l10n.focusLanguage;
      case LearningFocus.univLife: return context.l10n.focusUnivLife;
      case LearningFocus.linguisticObjective: return context.l10n.focusLinguisticObjective;
    }
  }

  IconData get icon {
    switch (this) {
      case .language: return Icons.translate;
      case .univLife: return Icons.psychology;
      case .linguisticObjective: return Icons.fact_check;
    }
  }
}

extension LanguageSkillX on LanguageSkill {
  String label(BuildContext context) {
    switch (this) {
      case LanguageSkill.writtenComprehension: return context.l10n.skillWrittenComp;
      case LanguageSkill.oralComprehension: return context.l10n.skillOralComp;
      case LanguageSkill.writtenExpression: return context.l10n.skillWrittenExp;
      case LanguageSkill.oralExpression: return context.l10n.skillOralExp;
      case LanguageSkill.phonetics: return context.l10n.skillPhonetics;
    }
  }

  IconData get icon {
    switch (this) {
      case LanguageSkill.writtenComprehension: return Icons.menu_book;
      case LanguageSkill.oralComprehension: return Icons.headphones;
      case LanguageSkill.writtenExpression: return Icons.edit;
      case LanguageSkill.oralExpression: return Icons.mic;
      case LanguageSkill.phonetics: return Icons.record_voice_over;
    }
  }
}

extension ResourceTypeX on ResourceType {
  String label(BuildContext context) {
    switch (this) {
      case ResourceType.exercise: return context.l10n.typeExercise;
      case ResourceType.activity: return context.l10n.typeActivity;
      case ResourceType.game: return context.l10n.typeGame;
      case ResourceType.video: return context.l10n.typeVideo;
      case ResourceType.audio: return context.l10n.typeAudio;
      case ResourceType.article: return context.l10n.typeArticle;
      case ResourceType.pdf: return context.l10n.typePdf;
      case ResourceType.text: return context.l10n.typeText;
      case ResourceType.image: return context.l10n.typeImage;
    }
  }

  IconData get icon {
    switch (this) {
      case ResourceType.exercise: return Icons.edit_note;
      case ResourceType.activity: return Icons.local_activity_outlined;
      case ResourceType.game: return Icons.videogame_asset_outlined;
      case ResourceType.video: return Icons.play_circle_outline;
      case ResourceType.audio: return Icons.audiotrack_outlined;
      case ResourceType.article: return Icons.description_outlined;
      case ResourceType.pdf: return Icons.picture_as_pdf_outlined;
      case ResourceType.text: return Icons.text_snippet_outlined;
      case ResourceType.image: return Icons.image_outlined;
    }
  }
}

extension LanguageStringX on String {
  String languageLabel(BuildContext context) {
    switch (toLowerCase()) {
      case 'fr': return context.l10n.langFr;
      case 'en': return context.l10n.langEn;
      case 'es': return context.l10n.langEs;
      default: return toUpperCase();
    }
  }
}

extension LanguageLevelX on LanguageLevel {
  String get label {
    switch (this) {
      case .a1: return 'A1';
      case .a2: return 'A2';
      case .b1: return 'B1';
      case .b2: return 'B2';
      case .c1: return 'C1';
      case .c2: return 'C2';
    }
  }
}
