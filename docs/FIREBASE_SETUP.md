# Firebase Multi-Environment Setup

This project supports three Firebase environments: Development, Staging, and Production.

## Required Firebase Config Files

Firebase configuration files contain sensitive API keys and must be downloaded separately for each environment.

### Android

Place `google-services.json` files in:
- **Dev**: `android/app/src/dev/google-services.json`
- **Staging**: `android/app/src/staging/google-services.json`
- **Prod**: `android/app/src/prod/google-services.json`

### iOS

Place `GoogleService-Info.plist` files in:
- **Dev**: `ios/Runner/Firebase/Dev/GoogleService-Info.plist`
- **Staging**: `ios/Runner/Firebase/Staging/GoogleService-Info.plist`
- **Prod**: `ios/Runner/Firebase/Prod/GoogleService-Info.plist`

## Downloading Config Files

Use the Firebase CLI to download configuration files:

```bash
# Development
firebase apps:sdkconfig ANDROID --project=backdrp-fm-dev -o android/app/src/dev/google-services.json
firebase apps:sdkconfig IOS --project=backdrp-fm-dev -o ios/Runner/Firebase/Dev/GoogleService-Info.plist

# Staging
firebase apps:sdkconfig ANDROID --project=backdrp-fm-staging -o android/app/src/staging/google-services.json
firebase apps:sdkconfig IOS --project=backdrp-fm-staging -o ios/Runner/Firebase/Staging/GoogleService-Info.plist

# Production
firebase apps:sdkconfig ANDROID --project=backdrp-fm-prod-4215e -o android/app/src/prod/google-services.json
firebase apps:sdkconfig IOS --project=backdrp-fm-prod-4215e -o ios/Runner/Firebase/Prod/GoogleService-Info.plist
```

## Launch Configurations

The app uses **VS Code launch configurations** and **pre-launch tasks** to select environments:

Available configurations in VS Code (`.vscode/launch.json`):
- **Development (backdrp-fm-dev)** - Default for local development
- **Staging (backdrp-fm-staging)** - Pre-release testing
- **Production (backdrp-fm-prod-4215e)** - Production (use with caution)
- **Local Emulators (offline)** - Uses Firebase Emulators

### How It Works

1. **VS Code tasks** (`.vscode/tasks.json`) copy environment-specific Firebase configs:
   - `ios/Runner/Firebase/{Dev|Staging|Prod}/GoogleService-Info.plist` → `ios/Runner/GoogleService-Info.plist`
   - `android/app/src/{dev|staging|prod}/google-services.json` → `android/app/google-services.json`

2. **Launch configurations** specify:
   - Which pre-launch task to run
   - `--dart-define=ENVIRONMENT={development|staging|production}` flag

3. The app reads the copied config files and connects to the correct Firebase project.

This approach works across all platforms (iOS, Android, macOS, Web) without requiring platform-specific build flavors or schemes.

## App IDs

Each environment uses a different application ID:
- Dev: `com.backdrpfm.app.dev`
- Staging: `com.backdrpfm.app.staging`
- Prod: `com.backdrpfm.app`
