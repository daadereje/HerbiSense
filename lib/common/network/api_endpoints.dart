class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String resetPassword = '/auth/reset-password';
  static const String currentUser = '/auth/me';

  // Herbs
  static const String herbs = '/herbs';
  static const String herbsPublished = '/herbs/published';
  static const String herbSearch = '/herbs/search';
  static String herbById(String id) => '$herbs/$id';

  // Conditions / recommendations
  static const String skinConcerns = '/conditions';
  static const String conditionSearch = '/conditions/search';
  static const String recommendations = '/recommendations';
  static const String userProfile = '/users/profile';
  static String conditionTranslation(String conditionId) =>
      '/condition-translations/$conditionId';

  // Lists
  static const String favorites = '/favorites';
  static const String savedHerbs = '/saved-herbs';

  // Feedback
  static const String feedback = '/feedback';

  // Translations
  static String translationByHerb(String herbId) => '/translations/$herbId';

  // Uploads (some backends serve at /uploads/{id}, others at /uploads/herbs/{id})
  static String uploadHerbById(String id, {bool withHerbsSegment = true}) =>
      withHerbsSegment ? '/uploads/herbs/$id' : '/uploads/$id';
  static String uploadById(String id) => '/uploads/$id';
  static const String upload = '/uploads/herbs';

  // About
  static const String aboutStats = '/about/stats';
  static const String companyInfo = '/about/company';
}
