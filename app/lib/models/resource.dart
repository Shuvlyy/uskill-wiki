import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
  String get label {
    switch (this) {
      case .staff: return 'Staff';
      case .student: return 'Étudiant';
      case .teacher: return 'Enseignant';
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
  String get label {
    switch (this) {
      case .language: return 'Langue';
      case .univLife: return 'Vie universitaire';
      case .linguisticObjective: return 'Objectifs linguistiques';
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
  String get label {
    switch (this) {
      case .writtenComprehension: return 'Compréhension Écrite';
      case .oralComprehension: return 'Compréhension Orale';
      case .writtenExpression: return 'Expression Écrite';
      case .oralExpression: return 'Expression Orale';
      case .phonetics: return 'Phonétique';
    }
  }

  IconData get icon {
    switch (this) {
      case .writtenComprehension: return Icons.menu_book;
      case .oralComprehension: return Icons.headphones;
      case .writtenExpression: return Icons.edit;
      case .oralExpression: return Icons.mic;
      case .phonetics: return Icons.record_voice_over;
    }
  }
}

extension ResourceTypeX on ResourceType {
  String get label {
    switch (this) {
      case .exercise: return 'Exercice';
      case .activity: return 'Activité';
      case .game: return 'Jeu';
      case .video: return 'Vidéo';
      case .audio: return 'Audio';
      case .article: return 'Article';
      case .pdf: return 'PDF';
      case .text: return 'Texte';
      case .image: return 'Image';
    }
  }

  IconData get icon {
    switch (this) {
      case .exercise: return Icons.edit_note;
      case .activity: return Icons.local_activity_outlined;
      case .game: return Icons.videogame_asset_outlined;
      case .video: return Icons.play_circle_outline;
      case .audio: return Icons.audiotrack_outlined;
      case .article: return Icons.description_outlined;
      case .pdf: return Icons.picture_as_pdf_outlined;
      case .text: return Icons.text_snippet_outlined;
      case .image: return Icons.image_outlined;
    }
  }
}

extension LanguageStringX on String {
  String get languageLabel {
    switch (toLowerCase()) {
      case 'fr': return 'Français';
      case 'en': return 'Anglais';
      case 'es': return 'Espagnol';
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
