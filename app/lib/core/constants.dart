class Constants {
  static const appName = 'U-Skill Wiki';

  static const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://127.0.0.1:8000');

  static const List<String> linguisticObjectives = [
    'La ponctuation',
    'Le nom',
    'Le complément du nom',
    'Le présent de l’indicatif',
    'L’impératif',
    'Le passé',
    'Le futur',
    'Le conditionnel',
    'Le subjonctif',
    'Le passif',
    'Le discours rapporté',
    'L’hypothèse',
    'La modalisation',
    'La mise en relief',
    'L’énonciation',
    'Les pronoms',
    'Les déterminants',
    'Le comparatif et le superlatif',
    'L’adjectif',
    'L\'interrogation',
    'La négation',
    'Les présentatifs',
    'La localisation spatiale',
    'La localisation temporelle',
    'Articulateurs chronologiques (du discours)',
    'Les articulateurs logiques'
  ];

  static const double mobileWidthThreshold = 450;
}
