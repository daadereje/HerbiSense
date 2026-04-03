class AppConfig {
  static const String appName = 'HerbSénsse';
  static const String appTagline = 'ETHIOPIAN HERBAL WISDOM';
  static const String appVersion = '1.0.0';

  // Backend
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.250.56.116/5001/api',
  );

  // Features
  static const int totalHerbs = 100;
  static const int certifiedHealers = 500;
  static const int communityMembers = 10000;

  // Cache initialization state to avoid repeated work
  static bool _isInitialized = false;

  static Future<void> init() async {
    if (_isInitialized) {
      return;
    }
    
    // Use compute for any heavy initialization work
    await Future.microtask(() {
      // Initialize any services here
      // Keep this minimal for fast startup
    });
    
    _isInitialized = true;
  }
}
