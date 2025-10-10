import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options_dev.dart' as firebase_options_dev;
import '../firebase_options_staging.dart' as firebase_options_staging;
import '../firebase_options_prod.dart' as firebase_options_prod;

enum Environment {
  development,
  staging,
  production,
}

class AppEnvironment {
  static Environment _current = Environment.development;

  static Environment get current => _current;

  static bool get isDevelopment => _current == Environment.development;
  static bool get isStaging => _current == Environment.staging;
  static bool get isProduction => _current == Environment.production;

  static String get name {
    switch (_current) {
      case Environment.development:
        return 'DEVELOPMENT';
      case Environment.staging:
        return 'STAGING';
      case Environment.production:
        return 'PRODUCTION';
    }
  }

  static void setEnvironment(Environment env) {
    _current = env;
  }

  /// Initialize environment from String.fromEnvironment or .env file
  /// Called from main.dart during app startup
  static Future<void> init() async {
    // First check --dart-define
    const dartDefineEnv =
        String.fromEnvironment('ENVIRONMENT', defaultValue: '');

    if (dartDefineEnv.isNotEmpty) {
      _setEnvironmentFromString(dartDefineEnv);
      return;
    }

    // If no --dart-define, try loading from .env file
    try {
      // Try to load environment-specific .env file
      String envFile = '.env.development';
      try {
        await dotenv.load(fileName: envFile);
      } catch (_) {
        // If specific env file not found, that's ok
      }

      final envString = dotenv.get('ENVIRONMENT', fallback: 'development');
      _setEnvironmentFromString(envString);
    } catch (e) {
      // Default to development if .env file doesn't exist
      _current = Environment.development;
    }
  }

  static void _setEnvironmentFromString(String environmentString) {
    switch (environmentString.toLowerCase()) {
      case 'production':
      case 'prod':
        _current = Environment.production;
        break;
      case 'staging':
      case 'stage':
        _current = Environment.staging;
        break;
      case 'development':
      case 'dev':
      default:
        _current = Environment.development;
        break;
    }
  }

  // Get environment variable from .env or provide default
  static String getEnvVar(String key, {String defaultValue = ''}) {
    try {
      return dotenv.get(key, fallback: defaultValue);
    } catch (_) {
      return defaultValue;
    }
  }

  // All environments use the same collection names (no prefixes)
  // This ensures code works identically across dev/staging/prod
  static String getCollectionName(String baseName) {
    return baseName;
  }

  /// Get Firebase options for current environment
  static FirebaseOptions get firebaseOptions {
    switch (_current) {
      case Environment.development:
        return firebase_options_dev.DefaultFirebaseOptions.currentPlatform;
      case Environment.staging:
        return firebase_options_staging.DefaultFirebaseOptions.currentPlatform;
      case Environment.production:
        return firebase_options_prod.DefaultFirebaseOptions.currentPlatform;
    }
  }
}
