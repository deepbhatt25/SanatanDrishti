import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static const String geetaDefaultBaseUrl = 'https://vedicscriptures.github.io';
  static const String panchangBaseUrl = 'https://json.freeastrologyapi.com';
  static const String rashiBaseUrl = 'https://api.api-ninjas.com/v1';

  static String get geetaBaseUrl {
    return dotenv.env['GEETA_API_BASE_URL'] ?? geetaDefaultBaseUrl;
  }

  static String get freeAstrologyApiKey {
    return dotenv.env['FREE_ASTROLOGY_API_KEY'] ?? '';
  }

  static bool get hasPanchangApiKey => freeAstrologyApiKey.trim().isNotEmpty;

  static String get apiNinjasKey {
    return dotenv.env['API_NINJAS_KEY'] ?? '';
  }

  static bool get hasRashiApiKey => apiNinjasKey.trim().isNotEmpty;

  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // .env missing or empty, fall back gracefully to environment constants
    }
  }
}
