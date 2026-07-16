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
enum LearningFocus { language, univLife }

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
    @JsonKey(name: 'target_audiences') required Set<UserRole> targetAudiences,
    required LanguageLevel level,
    required List<String> tags,
    required Author author,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    String? status,
  }) = _Resource;

  factory Resource.fromJson(Map<String, dynamic> json) => _$ResourceFromJson(json);
}