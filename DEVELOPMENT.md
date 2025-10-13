# Development Guide

## Running the App Locally

BACKDRP.FM uses different Firebase projects for different environments. You can easily switch between them using VS Code launch configurations.

### Available Configurations

In VS Code, click the Run & Debug icon (or press `F5`), then select from these configurations:

1. **Development (backdrp-fm-dev)** ⭐ _Default for local development_
   - Connects to: `backdrp-fm-dev` Firebase project
   - Use this for: Daily development and testing
   - Data persists in Firebase

2. **Staging (backdrp-fm-staging)**
   - Connects to: `backdrp-fm-staging` Firebase project
   - Use this for: Pre-release testing
   - Data persists in Firebase

3. **Production (backdrp-fm-prod)** ⚠️ _Use with caution_
   - Connects to: `backdrp-fm-prod` Firebase project
   - Use this for: Testing production issues only
   - **Never commit test data to production**

4. **Local Emulators (offline)**
   - Connects to: Local Firebase Emulators
   - Use this for: Offline development
   - Data does NOT persist (resets on emulator restart)

### Quick Start

1. **Select your device** in the VS Code status bar (iOS Simulator, iPhone, Chrome, etc.)
2. **Press F5** or click the Run button
3. **Select "Development (backdrp-fm-dev)"** from the dropdown
4. App launches and connects to the dev Firebase project

### Firebase Projects

| Environment | Project ID | Purpose |
|------------|------------|---------|
| Development | `backdrp-fm-dev` | Daily development, safe for experiments |
| Staging | `backdrp-fm-staging` | Pre-release testing |
| Production | `backdrp-fm-prod-4215e` | Live production data |

### Database Structure

**All environments use identical collection names** (no prefixes):
- `videos`
- `users`
- `artists`
- `playlists`
- `mailingList`

**Environment isolation is achieved via separate Firebase projects**, not collection naming.

**Test data convention:** Document IDs use `dev_` prefix (e.g., `dev_video_001`, `dev_user_john`) to distinguish seeded test data from real user-generated content within the same collections.

### Seeding Test Data

To populate the development database with test data:

```bash
node seed-all-test-data.js --project=backdrp-fm-dev
```

For local emulators:

```bash
./start-emulators.sh  # Terminal 1
FIRESTORE_EMULATOR_HOST=localhost:8080 node seed-all-test-data.js --project=demo-test  # Terminal 2
```

### Firebase Console Links

- [Development Console](https://console.firebase.google.com/project/backdrp-fm-dev)
- [Staging Console](https://console.firebase.google.com/project/backdrp-fm-staging)
- [Production Console](https://console.firebase.google.com/project/backdrp-fm-prod-4215e)

### Security Rules

Firestore security rules are unified across all environments:
- Published videos are public
- Users can read/update their own profile
- Admin users (role: 'admin') have full access
- Artists and playlists are public read, admin write

### Troubleshooting

**"Permission denied" errors:**
- Make sure you're signed in with a valid account
- Check that your user document exists in Firestore
- Verify security rules are deployed: `firebase deploy --only firestore:rules`

**Can't see test data:**
- Run the seed script for your environment
- Verify you're connected to the correct Firebase project (check console logs)

**Changes not appearing:**
- Try hot restart (`R` in debug console) instead of hot reload
- For Firebase configuration changes, do a full restart
