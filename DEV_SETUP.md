# Development Environment Setup

## Overview

This project uses environment-based Firestore collections to separate development and production data within the same Firebase project.

## How It Works

### Collection Naming Convention
- **Development**: All collections are prefixed with `dev_`
  - `dev_videos`
  - `dev_artists`
  - `dev_users`
  - `dev_playlists`

- **Production**: Collections use their base names
  - `videos`
  - `artists`
  - `users`
  - `playlists`

### Environment Configuration

The environment is controlled by `lib/config/environment.dart`:

```dart
// Set development mode (default)
AppEnvironment.setEnvironment(Environment.development);

// Set production mode
AppEnvironment.setEnvironment(Environment.production);
```

## Switching Environments

### Option 1: Code Change (Current Method)
Edit `lib/main.dart` and add at the start of `main()`:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set to development or production
  AppEnvironment.setEnvironment(Environment.development);

  // ... rest of initialization
}
```

### Option 2: Command Line Flags (Recommended for Production)
Run with environment flag:
```bash
# Development
flutter run --dart-define=ENVIRONMENT=development

# Production
flutter run --dart-define=ENVIRONMENT=production
```

Then update `main.dart`:
```dart
const environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
AppEnvironment.setEnvironment(
  environment == 'production' ? Environment.production : Environment.development
);
```

## Test Data

### Seeding Development Data

Run the seed script to populate development collections:

```bash
node seed-all-test-data.js
```

This creates:
- **6 Videos** (5 published, 1 draft)
- **5 Artists** (The Weeknd, Daft Punk, Billie Eilish, Robert Glasper, Travis Scott)
- **2 Test Users** (test1@backdrp.fm, test2@backdrp.fm)
- **2 Playlists**

### Clearing Development Data

To clear all dev data:
```bash
# Using Firebase CLI (be careful!)
firebase firestore:delete --all-collections --force --project backdrop-fm
# Then manually delete only dev_* collections in Firebase Console
```

Or use this script:
```javascript
// clear-dev-data.js
const admin = require('firebase-admin');
const serviceAccount = require('./functions/service-account-key.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

async function clearDevData() {
  const collections = ['dev_videos', 'dev_artists', 'dev_users', 'dev_playlists'];

  for (const collectionName of collections) {
    const snapshot = await db.collection(collectionName).get();
    const batch = db.batch();
    snapshot.docs.forEach(doc => batch.delete(doc.ref));
    await batch.commit();
    console.log(`✓ Cleared ${collectionName}`);
  }
}

clearDevData().then(() => process.exit(0));
```

## Firebase Indexes

Indexes are configured for both dev and prod collections in `firestore.indexes.json`.

Deploy indexes:
```bash
firebase deploy --only firestore:indexes --project backdrop-fm
```

Wait 1-2 minutes for indexes to build.

Check index status:
https://console.firebase.google.com/project/backdrop-fm/firestore/indexes

## Best Practices

1. **Always use development mode during development**
   - Prevents accidentally modifying production data
   - Test data is isolated and can be reset anytime

2. **Never commit service account keys**
   - `service-account-key.json` is in `.gitignore`
   - Each developer should download their own key

3. **Before releasing to production**
   - Test thoroughly in development environment
   - Switch to production environment
   - Test again with production data
   - Monitor for errors

4. **Production deployment checklist**
   - [ ] All features tested in development
   - [ ] No references to `dev_` collections in production code
   - [ ] Environment set to `production`
   - [ ] Firebase indexes deployed
   - [ ] Security rules updated

## Firestore Security Rules

Update security rules to handle both environments:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Production collections
    match /videos/{videoId} {
      allow read: if true;
      allow write: if request.auth != null;
    }

    // Development collections (less restrictive for testing)
    match /dev_videos/{videoId} {
      allow read, write: if true;  // Open for dev
    }

    // Repeat for other collections...
  }
}
```

## Troubleshooting

### App shows no data
- Check environment setting in `main.dart`
- Verify dev collections exist in Firestore Console
- Check that indexes are built (status: Enabled)

### Index errors
- Run: `firebase deploy --only firestore:indexes`
- Wait 1-2 minutes for building
- Check console: https://console.firebase.google.com/project/backdrop-fm/firestore/indexes

### Wrong environment data showing
- Verify `AppEnvironment.setEnvironment()` is called correctly
- Check collection names in Firestore Console
- Hot restart the app (not just hot reload)

## Quick Reference

```bash
# Seed dev data
node seed-all-test-data.js

# Deploy indexes
firebase deploy --only firestore:indexes

# View Firestore data
open https://console.firebase.google.com/project/backdrop-fm/firestore

# View indexes
open https://console.firebase.google.com/project/backdrop-fm/firestore/indexes

# Run in development mode
flutter run  # (default is development)

# Run in production mode
flutter run --dart-define=ENVIRONMENT=production
```
