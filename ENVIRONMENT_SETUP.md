# Environment Setup Guide

Complete guide for working with BACKDRP.FM's multi-environment architecture.

## Overview

BACKDRP.FM uses **three separate Firebase projects** for complete isolation:

| Environment | Firebase Project | Purpose |
|-------------|-----------------|---------|
| **Development** | `backdrp-fm-dev` | Local development and testing |
| **Staging** | `backdrp-fm-staging` | QA and pre-production testing |
| **Production** | `backdrp-fm-prod-4215e` | Live application |

## Quick Start

### Running Different Environments

```bash
# Development (default)
flutter run -d chrome

# Staging
flutter run -d chrome --dart-define=ENVIRONMENT=staging

# Production
flutter run -d chrome --dart-define=ENVIRONMENT=production
```

### Building for Release

```bash
# Development build
flutter build web --dart-define=ENVIRONMENT=development

# Staging build
flutter build web --dart-define=ENVIRONMENT=staging

# Production build
flutter build web --dart-define=ENVIRONMENT=production --release
```

## How It Works

### 1. Environment Detection Priority

The app determines the environment in this order:

1. **--dart-define flags** (highest priority)
   ```bash
   flutter run --dart-define=ENVIRONMENT=staging
   ```

2. **.env files** (fallback)
   - `.env.development` (default)
   - `.env.staging`
   - `.env.production`

3. **Default** - Always falls back to `development`

### 2. Firebase Project Selection

Based on the environment, the app automatically uses the correct Firebase project:

```dart
// lib/config/environment.dart
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
```

### 3. Collection Naming

**All environments use the same collection names** for consistent code across dev/staging/prod:

```dart
// All environments return the same collection name
AppEnvironment.getCollectionName('videos') → 'videos'
AppEnvironment.getCollectionName('artists') → 'artists'
AppEnvironment.getCollectionName('users') → 'users'
AppEnvironment.getCollectionName('playlists') → 'playlists'
```

**Collections used:**
- `videos`
- `artists`
- `users`
- `playlists`
- `mailingList`

**Environment isolation** is achieved through separate Firebase projects, not collection prefixes.

**Test data convention:** Document IDs use `dev_` prefix (e.g., `dev_video_001`, `dev_user_john`) to distinguish seeded test data from real user-generated content within the same collections.

### 4. Environment Indicators

In debug builds, you'll see a colored banner in the top-right corner:

- 🟢 **DEVELOPMENT** - Green banner
- 🟠 **STAGING** - Orange banner
- 🔴 **PRODUCTION** - Red banner (only shows in debug mode)

## Environment Files

### File Structure

```
project-root/
├── .env.example          # Template (committed to git)
├── .env.development      # Dev config (gitignored)
├── .env.staging          # Staging config (gitignored)
└── .env.production       # Prod config (gitignored)
```

### .env.development

```bash
ENVIRONMENT=development
FIREBASE_PROJECT_ID=backdrp-fm-dev

# Feature Flags (disabled for dev)
ENABLE_ANALYTICS=false
ENABLE_CRASHLYTICS=false
ENABLE_PERFORMANCE_MONITORING=false
```

### .env.staging

```bash
ENVIRONMENT=staging
FIREBASE_PROJECT_ID=backdrp-fm-staging

# Feature Flags (enabled for testing)
ENABLE_ANALYTICS=true
ENABLE_CRASHLYTICS=true
ENABLE_PERFORMANCE_MONITORING=true
```

### .env.production

```bash
ENVIRONMENT=production
FIREBASE_PROJECT_ID=backdrp-fm-prod-4215e

# Feature Flags (fully enabled)
ENABLE_ANALYTICS=true
ENABLE_CRASHLYTICS=true
ENABLE_PERFORMANCE_MONITORING=true
```

## Using Environment Variables in Code

```dart
import 'package:backdrp_fm/config/environment.dart';

// Check current environment
if (AppEnvironment.isDevelopment) {
  print('Running in development mode');
}

if (AppEnvironment.isStaging) {
  print('Running in staging mode');
}

if (AppEnvironment.isProduction) {
  print('Running in production mode');
}

// Get environment name
String envName = AppEnvironment.name;
// Returns: "DEVELOPMENT", "STAGING", or "PRODUCTION"

// Get collection name with correct prefix
String videosCollection = AppEnvironment.getCollectionName('videos');

// Get environment variable from .env
String apiKey = AppEnvironment.getEnvVar('YOUTUBE_API_KEY', defaultValue: '');
```

## Firebase Configuration

### Configuration Files

Each environment has its own Firebase configuration file:

```
lib/
├── firebase_options_dev.dart       # Development config
├── firebase_options_staging.dart   # Staging config
└── firebase_options_prod.dart      # Production config
```

These files are **auto-generated** by FlutterFire CLI and contain:
- API keys
- App IDs
- Project IDs
- Platform-specific configs (Android, iOS, Web)

### Regenerating Firebase Configs

If you need to regenerate the config files:

```bash
# Development
flutterfire configure \
  --project=backdrp-fm-dev \
  --platforms=web,android,ios \
  --out=lib/firebase_options_dev.dart \
  --ios-bundle-id=com.backdrpfm.app.dev \
  --android-package-name=com.backdrpfm.app.dev

# Staging
flutterfire configure \
  --project=backdrp-fm-staging \
  --platforms=web,android,ios \
  --out=lib/firebase_options_staging.dart \
  --ios-bundle-id=com.backdrpfm.app.staging \
  --android-package-name=com.backdrpfm.app.staging

# Production
flutterfire configure \
  --project=backdrp-fm-prod-4215e \
  --platforms=web,android,ios \
  --out=lib/firebase_options_prod.dart \
  --ios-bundle-id=com.backdrpfm.app \
  --android-package-name=com.backdrpfm.app
```

## Firebase Deployment

### Deploy Firestore Rules and Indexes

You must deploy rules and indexes to **each** Firebase project:

```bash
# Development
firebase deploy --only firestore --project backdrp-fm-dev

# Staging
firebase deploy --only firestore --project backdrp-fm-staging

# Production
firebase deploy --only firestore --project backdrp-fm-prod-4215e
```

### Deploy Everything

```bash
# Deploy all Firebase services (Functions, Hosting, etc.)
firebase deploy --project backdrp-fm-dev
firebase deploy --project backdrp-fm-staging
firebase deploy --project backdrp-fm-prod-4215e
```

### Switch Active Project

```bash
# Check current project
firebase projects:list

# Use specific project
firebase use backdrp-fm-dev
firebase use backdrp-fm-staging
firebase use backdrp-fm-prod-4215e
```

## Test Data Seeding

### Seed Development Data

```bash
node seed-all-test-data.js --project=backdrp-fm-dev
```

This creates in `dev_*` collections:
- 6 test videos (5 published, 1 draft)
- 5 test artists
- 2 test users
- 2 test playlists

### Seed Staging Data

```bash
node seed-all-test-data.js --project=backdrp-fm-staging
```

This creates the same data in `staging_*` collections.

### Production Data

**Never seed production!** Production data should only be added through:
- Admin panel uploads
- Manual Firebase Console entries
- Verified production scripts (with extreme caution)

## Firestore Security Rules

Security rules apply uniformly to all environments since collections are named identically:

```javascript
// Videos - public read for published, admin write
match /videos/{videoId} {
  allow read: if resource.data.status == 'published' || isAdmin();
  allow create, update, delete: if isAdmin();
}

// Artists - public read, admin write
match /artists/{artistId} {
  allow read: if resource.data.active == true;
  allow create, update, delete: if isAdmin();
}

// Users - authenticated read, owner/admin write
match /users/{userId} {
  allow read: if request.auth != null;
  allow write: if request.auth.uid == userId || isAdmin();
}

// Playlists - public read, admin write
match /playlists/{playlistId} {
  allow read: if true;
  allow create, update, delete: if isAdmin();
}
```

Admin role detection works the same across all environments by checking the user's `role` field in their user document.

## Testing Different Environments

### Manual Testing

1. **Start app in desired environment:**
   ```bash
   flutter run -d chrome --dart-define=ENVIRONMENT=staging
   ```

2. **Verify environment banner** - Check top-right corner for:
   - 🟢 GREEN = Development
   - 🟠 ORANGE = Staging
   - 🔴 RED = Production

3. **Check console logs:**
   ```
   🚀 Starting BACKDRP.FM in STAGING mode
   ```

4. **Verify Firebase project** - Check Firebase Console to confirm data is going to correct project

### Automated Testing

```bash
# Run tests with specific environment
flutter test --dart-define=ENVIRONMENT=development
flutter test --dart-define=ENVIRONMENT=staging
```

## Troubleshooting

### Wrong environment showing

**Symptoms:** Banner shows wrong color, or data from wrong environment appears

**Solutions:**
1. Verify `--dart-define` flag is correct
2. Check `.env` file has correct `ENVIRONMENT` value
3. Hot **restart** (not just hot reload) - `r` in terminal
4. Check Firebase Console to verify which collections exist

### Environment banner not showing

**Symptoms:** No colored banner in corner

**Solutions:**
1. Ensure running in **debug mode** (not `--release`)
2. Banner only shows in development/staging by default
3. Check `lib/main.dart` has `EnvironmentBanner` widget

### Data not loading

**Symptoms:** Videos/artists not appearing

**Solutions:**
1. Verify correct environment is active (check banner)
2. Check Firebase Console for data in correct collections (`dev_*`, `staging_*`, or production)
3. Verify Firestore indexes are deployed and built
4. Check security rules allow read access
5. Reseed data: `node seed-all-test-data.js --project=backdrp-fm-dev`

### "Index required" error

**Symptoms:** Error message about missing Firestore index

**Solutions:**
1. Deploy indexes: `firebase deploy --only firestore:indexes --project <project-id>`
2. Wait 2-3 minutes for indexes to build
3. Check index status: https://console.firebase.google.com/project/{project-id}/firestore/indexes

### Environment variable not found

**Symptoms:** API key or config not loading

**Solutions:**
1. Verify `.env.{environment}` file exists
2. Check variable name matches exactly (case-sensitive)
3. Run `flutter clean && flutter pub get`
4. Ensure file is properly formatted (no extra spaces)

## Best Practices

### Development Workflow

1. **Always develop in development environment**
   ```bash
   flutter run  # defaults to development
   ```

2. **Test in staging before production**
   ```bash
   flutter run --dart-define=ENVIRONMENT=staging
   ```

3. **Never directly test in production**

### Security

1. **Never commit `.env` files** - They're in `.gitignore`
2. **Never commit Firebase config files** - `google-services.json`, `GoogleService-Info.plist`
3. **Use separate Firebase projects** - Already configured
4. **Rotate API keys regularly** - Especially in production
5. **Use environment-specific service accounts** - For backend scripts

### Data Management

1. **Development**: Can be reset anytime
2. **Staging**: Treat as semi-permanent for QA
3. **Production**: Never delete, always backup

### Deployment Checklist

Before deploying to production:

- [ ] All features tested in development
- [ ] All features tested in staging
- [ ] Firebase indexes deployed to production
- [ ] Security rules deployed to production
- [ ] .env.production has correct values
- [ ] Environment set to `ENVIRONMENT=production`
- [ ] Build created with `--release` flag
- [ ] Tested production build locally
- [ ] Crashlytics/Analytics configured
- [ ] Monitoring tools ready

## Environment-Specific Features

### Development
- Debug banner always visible
- Verbose console logging
- Hot reload enabled
- Analytics disabled
- Crashlytics disabled
- Test data can be reset anytime

### Staging
- Debug banner visible
- Console logging enabled
- Analytics enabled (test mode)
- Crashlytics enabled (test mode)
- Mirrors production config
- QA testing environment

### Production
- Debug banner only in debug builds
- Minimal console logging
- Analytics fully enabled
- Crashlytics fully enabled
- Real user data
- Maximum security rules

## Quick Reference

```bash
# Run environments
flutter run                                          # Development
flutter run --dart-define=ENVIRONMENT=staging        # Staging
flutter run --dart-define=ENVIRONMENT=production     # Production

# Build environments
flutter build web --dart-define=ENVIRONMENT=development
flutter build web --dart-define=ENVIRONMENT=staging
flutter build web --dart-define=ENVIRONMENT=production --release

# Deploy Firebase
firebase deploy --only firestore --project backdrp-fm-dev
firebase deploy --only firestore --project backdrp-fm-staging
firebase deploy --only firestore --project backdrp-fm-prod-4215e

# Seed data
node seed-all-test-data.js --project=backdrp-fm-dev
node seed-all-test-data.js --project=backdrp-fm-staging

# Firebase CLI
firebase use backdrp-fm-dev                          # Switch to dev
firebase use backdrp-fm-staging                      # Switch to staging
firebase use backdrp-fm-prod-4215e                   # Switch to prod
firebase projects:list                               # List all projects
```

---

**Questions?** Check [README.md](README.md) or open an issue on GitHub.
