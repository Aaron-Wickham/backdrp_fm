# Integration Test Setup Guide

This guide will help you set up and run integration tests for BACKDRP.FM.

## Prerequisites

✅ Firebase CLI installed (already have v14.17.0)
✅ Xcode installed (for iOS/macOS testing)
✅ Android Studio installed (for Android testing, optional)

## Step 1: Start Firebase Emulators

The integration tests need Firebase Emulators running to avoid using your production/staging Firebase projects during testing.

### Start the Emulators

```bash
firebase emulators:start
```

This will start:
- **Auth Emulator** on port 9099
- **Firestore Emulator** on port 8080
- **Storage Emulator** on port 9199
- **Emulator UI** on port 4000 (http://localhost:4000)

**Keep this terminal window open** - the emulators need to stay running while you run tests.

### Optional: Start Only Specific Emulators

If you only need certain emulators:

```bash
# Only Auth and Firestore
firebase emulators:start --only auth,firestore

# With import/export for persistent data
firebase emulators:start --import=./emulator-data --export-on-exit
```

## Step 2: Connect App to Emulators (One-time Setup)

You need to configure your app to use the emulators when running integration tests.

### Option A: Add Environment Variable Check (Recommended)

Add this to your `lib/main.dart` after Firebase initialization:

```dart
// After: await Firebase.initializeApp(options: AppEnvironment.firebaseOptions);

// Connect to emulators in test mode
if (const bool.fromEnvironment('USE_FIREBASE_EMULATORS')) {
  await _connectToEmulators();
}
```

Then add this function to your `main.dart`:

```dart
Future<void> _connectToEmulators() async {
  const host = 'localhost';

  // Auth Emulator
  await FirebaseAuth.instance.useAuthEmulator(host, 9099);

  // Firestore Emulator
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);

  // Storage Emulator
  await FirebaseStorage.instance.useStorageEmulator(host, 9199);

  if (kDebugMode) {
    print('🔧 Connected to Firebase Emulators');
  }
}
```

### Option B: Use Test Configuration File

Alternatively, you can import the emulator config helper:

```dart
// In lib/main.dart, add this import
import 'test_helpers/emulator_config.dart' if (dart.library.io) 'test_helpers/emulator_config.dart';

// After Firebase initialization
if (const bool.fromEnvironment('USE_FIREBASE_EMULATORS')) {
  useFirebaseEmulators();
}
```

## Step 3: Run Integration Tests

### On iOS Simulator (Recommended for Mac)

1. **Open iOS Simulator:**
   ```bash
   open -a Simulator
   ```

2. **Wait for simulator to boot**, then run tests:
   ```bash
   flutter test integration_test/ \
     -d <device-id> \
     --dart-define=USE_FIREBASE_EMULATORS=true
   ```

3. **Find your device ID:**
   ```bash
   flutter devices
   ```
   Look for something like: `iPhone 15 Pro (mobile) • <device-id> • ios`

### On macOS Desktop

```bash
flutter test integration_test/ \
  -d macos \
  --dart-define=USE_FIREBASE_EMULATORS=true
```

### On Android Emulator

1. **Start Android Emulator** from Android Studio or:
   ```bash
   flutter emulators --launch <emulator-name>
   ```

2. **Run tests:**
   ```bash
   flutter test integration_test/ \
     -d <device-id> \
     --dart-define=USE_FIREBASE_EMULATORS=true
   ```

### Run Individual Test Files

```bash
# Authentication flow tests only
flutter test integration_test/flows/authentication_flow_test.dart \
  -d <device-id> \
  --dart-define=USE_FIREBASE_EMULATORS=true

# Video browsing tests only
flutter test integration_test/flows/video_browsing_flow_test.dart \
  -d <device-id> \
  --dart-define=USE_FIREBASE_EMULATORS=true

# Profile management tests only
flutter test integration_test/flows/profile_management_flow_test.dart \
  -d <device-id> \
  --dart-define=USE_FIREBASE_EMULATORS=true
```

## Step 4: Monitor Tests

While tests are running:

1. **Watch the Emulator UI**: http://localhost:4000
   - See auth users being created
   - Watch Firestore documents
   - Monitor Storage uploads

2. **Watch the device/simulator**: You'll see the app running through the flows automatically

3. **Check terminal output**: Shows test progress and results

## Common Issues & Solutions

### Issue: "No devices are connected"
**Solution:** Start a simulator or connect a device, then check with `flutter devices`

### Issue: "Web devices are not supported for integration tests"
**Solution:** Use iOS Simulator, Android Emulator, or macOS instead of `-d chrome`

### Issue: Tests timeout after 2 minutes
**Solution:**
- Make sure Firebase Emulators are running
- Check your internet connection
- Increase timeout in test files if needed

### Issue: "Connection refused" or Firebase errors
**Solution:**
- Verify emulators are running: `firebase emulators:start`
- Check ports aren't being used by other apps
- Ensure you're passing `--dart-define=USE_FIREBASE_EMULATORS=true`

### Issue: Tests fail with "Widget not found"
**Solution:**
- Tests assume you're starting logged out
- Clear emulator data: Stop emulators, delete `firebase-debug.log`, restart
- Some tests may need adjustment based on your specific UI

## Quick Start Commands

### Terminal 1: Start Emulators
```bash
cd /Users/aaronwickham/development/projects/backdrp_fm
firebase emulators:start
```

### Terminal 2: Run Tests
```bash
# Start simulator
open -a Simulator

# Wait for it to boot, then run tests
flutter test integration_test/ \
  -d "iPhone 15 Pro" \
  --dart-define=USE_FIREBASE_EMULATORS=true
```

## Test Data Management

### Clear Emulator Data Between Runs

```bash
# Stop emulators (Ctrl+C in terminal)
# Delete data
rm -rf .firebase/
# Restart emulators
firebase emulators:start
```

### Seed Test Data (Optional)

Create test data in `emulator-data/` directory:

```bash
# Export current emulator data
firebase emulators:export ./emulator-data

# Import data when starting
firebase emulators:start --import=./emulator-data
```

## Next Steps

Once you have integration tests running:

1. **Add to CI/CD Pipeline**: Set up GitHub Actions to run tests automatically
2. **Create Test Data Seeds**: Prepare consistent test data for reliable tests
3. **Add More Test Scenarios**: Expand coverage for edge cases
4. **Performance Testing**: Monitor app performance during test runs

## Resources

- [Firebase Emulator Suite Docs](https://firebase.google.com/docs/emulator-suite)
- [Flutter Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- Integration Test Files: `integration_test/` directory
- Test Results: Check terminal output and Emulator UI

## Need Help?

If you encounter issues:

1. Check Firebase Emulator logs in the terminal
2. Verify emulators are accessible: http://localhost:4000
3. Ensure app is configured to use emulators (see Step 2)
4. Check that test environment variables are being passed correctly
