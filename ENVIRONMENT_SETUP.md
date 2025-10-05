# Environment Setup Guide

## Overview

BACKDRP.FM supports three environments:
- **Development**: For local development and testing
- **Staging**: For QA and pre-production testing
- **Production**: For live app deployment

## Quick Start

### Running Different Environments

```bash
# Development (default)
flutter run

# Using --dart-define
flutter run --dart-define=ENVIRONMENT=development
flutter run --dart-define=ENVIRONMENT=staging
flutter run --dart-define=ENVIRONMENT=production

# Using .env files (automatically loaded)
# Just run flutter run and it will load .env.development by default
```

## How It Works

### Priority Order
1. **--dart-define flags** (highest priority)
2. **.env files** (fallback)
3. **Default** (development)

### Environment Indicators

In debug builds, you'll see a banner in the top-right corner showing:
- 🟢 **DEVELOPMENT** (green)
- 🟠 **STAGING** (orange)
- 🔴 **PRODUCTION** (red - only shows if explicitly set)

### Firestore Collections

Each environment uses separate Firestore collections:

| Environment | Collection Names |
|-------------|-----------------|
| Development | `dev_videos`, `dev_artists`, `dev_users`, `dev_playlists` |
| Staging | `staging_videos`, `staging_artists`, `staging_users`, `staging_playlists` |
| Production | `videos`, `artists`, `users`, `playlists` |

## Environment Files

### .env.development
Used for local development. Features like analytics and crashlytics are disabled.

### .env.staging
Used for staging/QA environment. All features enabled for testing.

### .env.production
Used for production builds. All features fully enabled.

### .env.example
Template file showing all available configuration options. **This is the only .env file committed to git.**

## Configuration Options

Available in .env files:

```bash
# Environment identifier
ENVIRONMENT=development

# Firebase project
FIREBASE_PROJECT_ID=backdrop-fm

# Feature flags
ENABLE_ANALYTICS=false
ENABLE_CRASHLYTICS=false
ENABLE_PERFORMANCE_MONITORING=false

# API keys (when needed)
# YOUTUBE_API_KEY=your_key_here
# SPOTIFY_API_KEY=your_key_here
```

## Accessing Environment Variables

In your code:

```dart
import 'package:backdrp_fm/config/environment.dart';

// Check current environment
if (AppEnvironment.isDevelopment) {
  print('Running in development mode');
}

// Get environment name
String envName = AppEnvironment.name; // "DEVELOPMENT", "STAGING", or "PRODUCTION"

// Get collection name with proper prefix
String collection = AppEnvironment.getCollectionName('videos');
// Returns: "dev_videos", "staging_videos", or "videos"

// Get environment variable from .env
String apiKey = AppEnvironment.getEnvVar('YOUTUBE_API_KEY', defaultValue: '');
```

## Firebase Projects

### Current Setup
All environments currently use the same Firebase project: `backdrop-fm`

### Recommended Setup (TODO)
Create separate Firebase projects for better isolation:

1. **backdrop-fm-dev** - Development environment
2. **backdrop-fm-staging** - Staging environment
3. **backdrop-fm-prod** - Production environment

## Testing

### Seed Test Data

```bash
# Seed development data
node seed-all-test-data.js

# This creates data in dev_* collections
```

### Run Tests

```bash
# Run all tests
flutter test

# Run tests with specific environment
flutter test --dart-define=ENVIRONMENT=development
```

## Building for Release

### Development Build
```bash
flutter build web --dart-define=ENVIRONMENT=development
flutter build apk --dart-define=ENVIRONMENT=development
```

### Staging Build
```bash
flutter build web --dart-define=ENVIRONMENT=staging
flutter build apk --dart-define=ENVIRONMENT=staging
```

### Production Build
```bash
flutter build web --dart-define=ENVIRONMENT=production --release
flutter build apk --dart-define=ENVIRONMENT=production --release
flutter build ios --dart-define=ENVIRONMENT=production --release
```

## Security Best Practices

1. **Never commit actual .env files** - They're in .gitignore
2. **Use .env.example as template** - Copy and rename for each environment
3. **Store sensitive keys in Firebase Remote Config** or secure key management
4. **Rotate API keys regularly**
5. **Use separate Firebase projects** for production isolation

## Troubleshooting

### Wrong environment data showing
- Check which environment is active: Look for banner in debug mode
- Verify .env file is loaded correctly
- Check Firebase console for correct collection names
- Hot restart app (not just hot reload)

### Environment variable not found
- Verify .env file exists
- Check file is listed in pubspec.yaml assets
- Ensure key name matches exactly
- Try flutter clean && flutter pub get

### Banner not showing
- Only shows in debug mode
- Only shows for non-production environments by default
- Check lib/main.dart has EnvironmentBanner widget

## Next Steps

- [ ] Create separate Firebase projects for dev/staging/prod
- [ ] Set up CI/CD pipeline with environment-specific builds
- [ ] Add environment-specific Firebase Remote Config
- [ ] Implement feature flags system
- [ ] Add environment-specific error reporting
