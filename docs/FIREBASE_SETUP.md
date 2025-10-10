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

Use VS Code launch configurations to run different environments:
- **Development**: Connects to `backdrp-fm-dev`
- **Staging**: Connects to `backdrp-fm-staging`
- **Production**: Connects to `backdrp-fm-prod-4215e`

## Build Flavors

### Android
The project uses Gradle product flavors:
- `dev` - Development environment (app ID: `com.backdrpfm.app.dev`)
- `staging` - Staging environment (app ID: `com.backdrpfm.app.staging`)
- `prod` - Production environment (app ID: `com.backdrpfm.app`)

### iOS
iOS schemes will automatically select the correct configuration based on the launch configuration.
