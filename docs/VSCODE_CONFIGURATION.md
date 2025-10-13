# VS Code Configuration Guide

This guide explains how BACKDRP.FM uses VS Code tasks and launch configurations to manage multi-environment Firebase setup.

## Overview

The app uses **VS Code pre-launch tasks** to copy environment-specific Firebase configuration files before running the app. This approach provides:

- ✅ **Cross-platform compatibility** - Works on iOS, Android, macOS, and Web
- ✅ **No platform-specific build complexity** - Avoids iOS schemes and Android flavor limitations
- ✅ **Simple developer experience** - Just select environment from dropdown
- ✅ **Version control friendly** - Config files stay in separate directories

## How It Works

### 1. Directory Structure

Firebase configuration files are organized by environment:

```
android/app/src/
├── dev/google-services.json          # Development config
├── staging/google-services.json      # Staging config
└── prod/google-services.json         # Production config

ios/Runner/Firebase/
├── Dev/GoogleService-Info.plist      # Development config
├── Staging/GoogleService-Info.plist  # Staging config
└── Prod/GoogleService-Info.plist     # Production config
```

### 2. VS Code Tasks (`.vscode/tasks.json`)

Pre-launch tasks copy the correct Firebase config files to the locations where Flutter/Firebase SDK expects them:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Copy Dev Firebase Config",
      "type": "shell",
      "command": "cp ios/Runner/Firebase/Dev/GoogleService-Info.plist ios/Runner/GoogleService-Info.plist && cp android/app/src/dev/google-services.json android/app/google-services.json"
    },
    // Similar tasks for staging and prod...
  ]
}
```

**What this does:**
- Copies `ios/Runner/Firebase/Dev/GoogleService-Info.plist` → `ios/Runner/GoogleService-Info.plist`
- Copies `android/app/src/dev/google-services.json` → `android/app/google-services.json`

### 3. Launch Configurations (`.vscode/launch.json`)

Launch configurations tie everything together:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Development (backdrp-fm-dev)",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": [
        "--dart-define=ENVIRONMENT=development"
      ],
      "flutterMode": "debug",
      "preLaunchTask": "Copy Dev Firebase Config"
    }
  ]
}
```

**Sequence of events when you press F5:**
1. VS Code runs the `preLaunchTask` ("Copy Dev Firebase Config")
2. Task copies environment-specific Firebase configs
3. VS Code launches Flutter with `--dart-define=ENVIRONMENT=development`
4. App reads the copied config files and connects to the correct Firebase project

## Available Configurations

### 1. Development (backdrp-fm-dev)
- **Purpose:** Daily development and testing
- **Firebase Project:** `backdrp-fm-dev`
- **Use when:** Working on features, experimenting
- **Data:** Safe to modify/delete

### 2. Staging (backdrp-fm-staging)
- **Purpose:** Pre-release testing and QA
- **Firebase Project:** `backdrp-fm-staging`
- **Use when:** Testing release candidates
- **Data:** Treat as semi-production

### 3. Production (backdrp-fm-prod-4215e)
- **Purpose:** Production debugging only
- **Firebase Project:** `backdrp-fm-prod-4215e`
- **Use when:** Debugging production issues
- **Data:** ⚠️ **NEVER modify production data**

### 4. Local Emulators (offline)
- **Purpose:** Offline development
- **Firebase Project:** Firebase Emulators (localhost)
- **Use when:** Working without internet
- **Data:** Ephemeral - lost on emulator restart

## Using the Configurations

### Quick Start

1. **Open VS Code** in the project directory
2. **Press F5** or click Run button
3. **Select configuration** from dropdown:
   - "Development (backdrp-fm-dev)" - Default choice
   - "Staging (backdrp-fm-staging)"
   - "Production (backdrp-fm-prod-4215e)"
   - "Local Emulators (offline)"
4. **App launches** connected to the selected environment

### Verifying Environment

When the app starts, check the console output:

```
🚀 Starting BACKDRP.FM in development mode
🔥 Connecting to Firebase project: backdrp-fm-dev
```

In debug mode, you'll also see a colored banner:
- 🟢 Green = Development
- 🟠 Orange = Staging
- 🔴 Red = Production

## Adding a New Environment

To add a new environment (e.g., "QA"):

### 1. Create Firebase Config Files

Download config files from Firebase Console:

```bash
firebase apps:sdkconfig ANDROID --project=backdrp-fm-qa -o android/app/src/qa/google-services.json
firebase apps:sdkconfig IOS --project=backdrp-fm-qa -o ios/Runner/Firebase/QA/GoogleService-Info.plist
```

### 2. Add VS Code Task

Edit `.vscode/tasks.json`:

```json
{
  "label": "Copy QA Firebase Config",
  "type": "shell",
  "command": "cp ios/Runner/Firebase/QA/GoogleService-Info.plist ios/Runner/GoogleService-Info.plist && cp android/app/src/qa/google-services.json android/app/google-services.json",
  "problemMatcher": [],
  "presentation": {
    "reveal": "silent",
    "panel": "shared"
  }
}
```

### 3. Add Launch Configuration

Edit `.vscode/launch.json`:

```json
{
  "name": "QA (backdrp-fm-qa)",
  "request": "launch",
  "type": "dart",
  "program": "lib/main.dart",
  "args": [
    "--dart-define=ENVIRONMENT=qa"
  ],
  "flutterMode": "debug",
  "preLaunchTask": "Copy QA Firebase Config"
}
```

### 4. Update App Code

Edit `lib/config/environment.dart` to add the new environment enum and Firebase options.

## Troubleshooting

### Issue: App connects to wrong Firebase project

**Symptom:** Console shows different project ID than expected

**Solution:**
1. Check which launch configuration you selected
2. Verify the task ran successfully (check task output)
3. Confirm correct config files exist in source directories
4. Try "Flutter: Clean Project" then relaunch

### Issue: "No Firebase App '[DEFAULT]' has been created"

**Symptom:** App crashes on startup with Firebase initialization error

**Solution:**
1. Verify config files were copied correctly:
   ```bash
   cat ios/Runner/GoogleService-Info.plist
   cat android/app/google-services.json
   ```
2. Check that `project_id` matches expected environment
3. Run the copy task manually from VS Code's task menu

### Issue: Task fails with "No such file or directory"

**Symptom:** Pre-launch task fails before app starts

**Solution:**
1. Verify source config files exist:
   ```bash
   ls ios/Runner/Firebase/Dev/
   ls android/app/src/dev/
   ```
2. If missing, download from Firebase Console
3. Ensure paths in `tasks.json` match your directory structure

### Issue: Changes to Firebase config not taking effect

**Symptom:** Updated config file but app still uses old project

**Solution:**
1. Stop the running app completely
2. Run "Flutter: Clean Project" from command palette
3. Re-run the launch configuration
4. For iOS: Clean build folder in Xcode if necessary

### Issue: VS Code doesn't show launch configurations

**Symptom:** Launch configuration dropdown is empty

**Solution:**
1. Verify `.vscode/launch.json` exists and is valid JSON
2. Reload VS Code window (Cmd/Ctrl + Shift + P → "Reload Window")
3. Ensure Dart/Flutter extensions are installed and active

## Why This Approach?

### Alternatives Considered

**iOS Schemes:**
- ❌ Requires Xcode project configuration
- ❌ Complex to maintain
- ❌ Doesn't work for Android/Web
- ❌ Harder for non-iOS developers

**Android Build Flavors:**
- ❌ Only works for Android
- ❌ Complex Gradle configuration
- ❌ Increases build time
- ❌ Doesn't help with iOS/Web/macOS

**Dart/Flutter Flavors:**
- ❌ Experimental and poorly documented
- ❌ Significant boilerplate code
- ❌ Platform-specific complications
- ❌ Maintenance overhead

**VS Code Tasks (Current Approach):**
- ✅ Works across all platforms
- ✅ Simple shell commands
- ✅ Easy to understand and modify
- ✅ No platform-specific build complexity
- ✅ Easy onboarding for new developers

## Best Practices

### ✅ DO:
- Use "Development" for daily work
- Verify environment indicator when app starts
- Keep config files in `.gitignore`
- Download fresh config files when Firebase project settings change

### ❌ DON'T:
- Commit Firebase config files to version control
- Modify production data from local dev environment
- Use production configuration for testing
- Share Firebase config files via insecure channels

## Security Notes

Firebase configuration files contain sensitive API keys and should **never** be committed to version control.

**Protected by `.gitignore`:**
```gitignore
# Firebase configuration files
android/app/google-services.json
android/app/src/*/google-services.json
ios/Runner/GoogleService-Info.plist
ios/Runner/Firebase/*/GoogleService-Info.plist
```

**Each developer must:**
1. Download their own config files from Firebase Console
2. Place them in the correct directories
3. Never commit them to Git
4. Never share them via email/Slack

## Related Documentation

- [Firebase Setup Guide](FIREBASE_SETUP.md) - Downloading and organizing config files
- [Development Guide](../DEVELOPMENT.md) - Running different environments
- [Environment Setup](../ENVIRONMENT_SETUP.md) - Complete multi-environment architecture

---

**Need help?** Check the troubleshooting section above or ask in team discussions.
