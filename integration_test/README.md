# Integration Tests

This directory contains integration tests for the BACKDRP.FM app. These tests verify complete user flows across multiple screens and features.

## Test Suites

### 1. Authentication Flow (`flows/authentication_flow_test.dart`)
Tests user authentication including:
- Complete signup flow with form validation
- Login flow with credentials
- Password visibility toggle
- Navigation between login and signup screens
- Form validation on empty submissions

### 2. Video Browsing Flow (`flows/video_browsing_flow_test.dart`)
Tests video discovery and navigation including:
- Browsing videos on home screen
- Navigating to video detail screens
- Searching for videos
- Filtering by categories
- Archive and artist browsing
- Pull-to-refresh functionality
- Scroll interactions

### 3. Profile Management Flow (`flows/profile_management_flow_test.dart`)
Tests user profile and settings including:
- Viewing profile details
- Editing profile information
- Accessing and updating notification settings
- Accessing privacy settings
- Viewing liked videos
- Logout functionality

## Running Integration Tests

### Prerequisites

**Important:** Integration tests require a connected device or emulator because they test the full application with all dependencies including Firebase.

1. **Firebase Setup (Recommended)**
   - Install Firebase Emulator Suite: `firebase init emulators`
   - Start emulators: `firebase emulators:start`
   - Update your app to use Firebase Emulators in test mode

2. **Device Requirements**
   - iOS: Physical device or iOS Simulator
   - Android: Physical device or Android Emulator
   - macOS: macOS desktop app (requires macOS platform setup)

### Running Tests

**On iOS Simulator:**
```bash
open -a Simulator
flutter test integration_test/app_test.dart -d <device-id>
```

**On Android Emulator:**
```bash
# Start emulator first
flutter emulators --launch <emulator-name>
flutter test integration_test/app_test.dart -d <device-id>
```

**On macOS Desktop:**
```bash
flutter test integration_test/app_test.dart -d macos
```

**Run Individual Test Files:**
```bash
flutter test integration_test/flows/authentication_flow_test.dart -d <device-id>
flutter test integration_test/flows/video_browsing_flow_test.dart -d <device-id>
flutter test integration_test/flows/profile_management_flow_test.dart -d <device-id>
```

**List Available Devices:**
```bash
flutter devices
```

### Test Configuration Notes

1. **Firebase Dependencies:**
   - Tests use the real Firebase SDK, so you'll need:
     - Valid Firebase configuration
     - Or Firebase Emulators running locally
     - Or test Firebase project

2. **Network Requests:**
   - Tests may make real network requests
   - Consider using Firebase Emulators to avoid rate limits
   - Ensure stable internet connection

3. **Test Data:**
   - Tests assume certain UI elements exist
   - May need adjustment based on actual app state
   - Consider using a test Firebase project with known data

4. **Timeouts:**
   - Tests include generous timeouts for network operations
   - Adjust `pumpAndSettle` durations if needed
   - Some tests may take longer on slower devices

## Test Organization

```
integration_test/
├── app_test.dart                          # Main test suite
├── flows/
│   ├── authentication_flow_test.dart      # 6 tests
│   ├── video_browsing_flow_test.dart      # 10 tests
│   └── profile_management_flow_test.dart  # 12 tests
└── README.md                              # This file
```

## Troubleshooting

**Tests timeout:**
- Increase timeout in test files: `await tester.pumpAndSettle(const Duration(seconds: 5));`
- Check Firebase connection
- Verify device has sufficient resources

**Firebase errors:**
- Ensure Firebase is initialized in `main.dart`
- Check `.env` files are present
- Verify Firebase configuration files exist

**Widget not found:**
- Tests may need adjustment based on your auth state
- Consider mocking authentication for consistent test runs
- Verify app starts in expected state

**Web platform not supported:**
- Integration tests don't work on web (`flutter test -d chrome`)
- Use mobile platforms (iOS/Android) or macOS desktop instead

## Best Practices

1. **Use Firebase Emulators:** Run tests against local Firebase emulators to avoid affecting production data
2. **Consistent State:** Ensure app starts in a known state (logged out, test data loaded, etc.)
3. **Independent Tests:** Each test should be self-contained and not rely on previous test state
4. **Selective Running:** Run individual test files during development, full suite in CI/CD
5. **Real Devices:** Test on real devices occasionally to catch platform-specific issues

## CI/CD Integration

For continuous integration, you'll need to:
1. Set up emulators in CI environment
2. Configure Firebase Emulators or use test project
3. Add appropriate timeouts for CI environment
4. Consider using `flutter drive` instead of `flutter test` for more control

Example GitHub Actions:
```yaml
- name: Run Integration Tests
  run: |
    firebase emulators:start --only auth,firestore &
    flutter test integration_test/ -d emulator-5554
```

## Additional Resources

- [Flutter Integration Testing](https://docs.flutter.dev/testing/integration-tests)
- [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite)
- [Flutter Testing Best Practices](https://docs.flutter.dev/testing/best-practices)
