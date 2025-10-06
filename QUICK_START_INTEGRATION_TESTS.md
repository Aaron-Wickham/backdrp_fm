# Quick Start: Integration Tests

Run integration tests in 3 easy steps:

## Step 1: Start Firebase Emulators

```bash
firebase emulators:start
```

**Keep this terminal window open!**

You'll see:
```
✔  All emulators ready! View status at http://localhost:4000
```

## Step 2: Open Simulator (in a new terminal)

```bash
open -a Simulator
```

Wait for the simulator to fully boot.

## Step 3: Run Tests (in a new terminal)

### Option A: Use the helper script (easiest)

```bash
./run_integration_tests.sh
```

The script will:
- ✅ Check if emulators are running
- ✅ Show available devices
- ✅ Run tests with proper configuration

### Option B: Manual command

```bash
# Get device list
flutter devices

# Run tests on specific device
flutter test integration_test/ \
  -d <device-id> \
  --dart-define=USE_FIREBASE_EMULATORS=true
```

## Quick Examples

### Run all integration tests
```bash
./run_integration_tests.sh
```

### Run specific test file
```bash
flutter test integration_test/flows/authentication_flow_test.dart \
  -d "iPhone 15 Pro" \
  --dart-define=USE_FIREBASE_EMULATORS=true
```

### Run on macOS desktop
```bash
flutter test integration_test/ \
  -d macos \
  --dart-define=USE_FIREBASE_EMULATORS=true
```

## Monitor Tests

While tests run:
- **Emulator UI**: http://localhost:4000
- **Terminal**: Shows test progress
- **Simulator/Device**: Shows app running automatically

## Troubleshooting

### "Firebase Emulators are not running"
```bash
# In separate terminal
firebase emulators:start
```

### "No devices are connected"
```bash
# Open simulator
open -a Simulator

# Or check connected devices
flutter devices
```

### Tests timeout or fail
- Make sure emulators are running
- Try clearing emulator data (stop emulators, restart)
- Check terminal for specific error messages

## That's it!

You're now running integration tests that:
- ✅ Test complete user flows
- ✅ Use Firebase Emulators (no production data affected)
- ✅ Run on real app with all dependencies
- ✅ Validate authentication, video browsing, and profile management

## Next Steps

See **INTEGRATION_TEST_SETUP.md** for:
- Detailed configuration options
- CI/CD setup
- Test data management
- Advanced usage

## Test Coverage

Your integration tests include:

**Authentication Flow** (6 tests)
- Complete signup flow
- Login flow
- Form validation
- Password visibility toggle
- Navigation between screens

**Video Browsing Flow** (10 tests)
- Home screen browsing
- Video detail navigation
- Search functionality
- Category filtering
- Archive and artists screens
- Pull-to-refresh
- Scroll interactions

**Profile Management Flow** (12 tests)
- Profile viewing and editing
- Settings management
- Notification settings
- Privacy settings
- Liked videos
- Logout flow

**Total: 28 integration tests**
