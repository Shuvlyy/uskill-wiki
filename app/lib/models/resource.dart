enum UserRole { student, teacher, staff }
enum ResourceType { exercise, game, video, article, link }
enum LanguageLevel { a1, a2, b1, b2, c1, c2 }
enum LearningFocus { language, skill }

class Author {
  final String name;
  final String email;

  const Author({
    required this.name,
    required this.email,
  });
}

class Resource {
  final String id;
  final String title;
  final String description;
  final String contentUrl;

  final ResourceType type;
  final String language;
  final LearningFocus focus;

  final Set<UserRole> targetAudiences;
  final LanguageLevel level;

  final List<String> tags;

  final Author author;
  final DateTime createdAt;

  const Resource({
    required this.id,
    required this.title,
    required this.description,
    required this.contentUrl,
    required this.type,
    required this.language,
    required this.focus,
    required this.targetAudiences,
    required this.level,
    required this.tags,
    required this.author,
    required this.createdAt,
  });
}
