/// Environment Configuration
/// Maps to src/config/env.ts
class AppEnv {
  AppEnv._();

  // For Android Emulator, localhost is reached at 10.0.2.2.
  // For physical device or web, change or pass --dart-define=API_URL=...
  static const String defaultApiUrl = 'http://10.0.2.2:5158';
  
  static String get apiUrl {
    const fromDefine = String.fromEnvironment('API_URL');
    if (fromDefine.isNotEmpty) {
      return fromDefine;
    }
    return defaultApiUrl;
  }
}
