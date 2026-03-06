class AppConfig {
  static const String appName = 'HerbSénsse';
  static const String appTagline = 'ETHIOPIAN HERBAL WISDOM';
  static const String appVersion = '1.0.0';

  // Features
  static const int totalHerbs = 100;
  static const int certifiedHealers = 500;
  static const int communityMembers = 10000;

  static Future<void> init() async {
    // Initialize any services here
    return Future.value();
  }
}
