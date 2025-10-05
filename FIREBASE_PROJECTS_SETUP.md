# Create Separate Firebase Projects - Step by Step Guide

## Why Separate Projects?

Currently, all environments (dev/staging/prod) share the **same** Firebase project (`backdrop-fm`). This means:
- ❌ Dev changes can affect staging/prod
- ❌ All environments share the same auth users
- ❌ Risk of accidentally corrupting production data
- ❌ Can't have different security settings per environment

**With separate projects:**
- ✅ Complete isolation between environments
- ✅ Independent auth users per environment
- ✅ Different Firebase configs (Analytics, Crashlytics, etc.)
- ✅ Zero risk of dev affecting production

---

## Step-by-Step Instructions

### Step 1: Create Development Project

1. **Open Firebase Console:**
   ```bash
   open https://console.firebase.google.com/
   ```

2. **Click "Add project"** (or "Create a project")

3. **Enter project details:**
   - **Project name:** `backdrp-fm-dev`
   - Click "Continue"

4. **Google Analytics (optional):**
   - Toggle OFF for development (or keep ON if you want)
   - Click "Continue" or "Create project"

5. **Wait for project creation** (~30 seconds)

6. **Click "Continue"** when done

✅ **First project created!**

---

### Step 2: Create Staging Project

Repeat the same process:

1. Go back to Firebase Console home
2. Click "Add project"
3. **Project name:** `backdrp-fm-staging`
4. Configure Google Analytics (recommended ON for staging)
5. Click "Create project"
6. Wait and click "Continue"

✅ **Second project created!**

---

### Step 3: Create Production Project

One more time:

1. Go back to Firebase Console home
2. Click "Add project"
3. **Project name:** `backdrp-fm-prod`
4. **Enable Google Analytics** (recommended for production)
5. Click "Create project"
6. Wait and click "Continue"

✅ **Third project created!**

---

### Step 4: Enable Services for Each Project

For **EACH** project (dev, staging, prod), you need to enable:

#### 4a. Enable Authentication

1. Open the project in Firebase Console
2. Click **"Authentication"** in left sidebar
3. Click **"Get started"**
4. Click **"Email/Password"** under "Sign-in method"
5. Toggle **"Email/Password"** to ON
6. Click **"Save"**

#### 4b. Enable Firestore

1. Click **"Firestore Database"** in left sidebar
2. Click **"Create database"**
3. Choose **"Start in production mode"** (we'll deploy our rules later)
4. Choose location: **"us-central"** (or your preferred region)
5. Click **"Enable"**

#### 4c. Enable Storage (if needed)

1. Click **"Storage"** in left sidebar
2. Click **"Get started"**
3. Accept default rules
4. Choose same location as Firestore
5. Click **"Done"**

Repeat for all 3 projects! ✅

---

### Step 5: Configure FlutterFire CLI

Now we'll configure your Flutter app to use all 3 projects.

**Important:** We'll use environment-specific Firebase config files.

#### 5a. Install/Update FlutterFire CLI

```bash
# Install if you don't have it
dart pub global activate flutterfire_cli

# Or update if you already have it
dart pub global activate flutterfire_cli
```

#### 5b. Configure Development Project

```bash
# This will create firebase config for development
flutterfire configure \
  --project=backdrop-fm-dev \
  --platforms=web,android,ios \
  --out=lib/firebase_options_dev.dart \
  --ios-bundle-id=com.backdrpfm.app.dev \
  --android-package-name=com.backdrpfm.app.dev
```

When prompted:
- Select: `backdrop-fm-dev` project
- Select platforms: `web`, `android`, `ios`

This creates **`lib/firebase_options_dev.dart`**

#### 5c. Configure Staging Project

```bash
flutterfire configure \
  --project=backdrop-fm-staging \
  --platforms=web,android,ios \
  --out=lib/firebase_options_staging.dart \
  --ios-bundle-id=com.backdrpfm.app.staging \
  --android-package-name=com.backdrpfm.app.staging
```

This creates **`lib/firebase_options_staging.dart`**

#### 5d. Configure Production Project

```bash
flutterfire configure \
  --project=backdrop-fm-prod \
  --platforms=web,android,ios \
  --out=lib/firebase_options_prod.dart \
  --ios-bundle-id=com.backdrpfm.app \
  --android-package-name=com.backdrpfm.app
```

This creates **`lib/firebase_options_prod.dart`**

#### 5e. Keep Original for Backward Compatibility

Your existing `lib/firebase_options.dart` will stay as is (points to `backdrop-fm`).

---

### Step 6: Update Your Code to Use Correct Config

I'll help you with this! You need to:

1. Modify `lib/config/environment.dart` to export the right Firebase options
2. Update `lib/main.dart` to use environment-specific Firebase options

**Tell me when you've created the 3 Firebase projects and run the flutterfire configure commands, and I'll update your code!**

---

### Step 7: Update .env Files

Update your environment files with the new project IDs:

**`.env.development`**
```bash
ENVIRONMENT=development
FIREBASE_PROJECT_ID=backdrop-fm-dev
```

**`.env.staging`**
```bash
ENVIRONMENT=staging
FIREBASE_PROJECT_ID=backdrop-fm-staging
```

**`.env.production`**
```bash
ENVIRONMENT=production
FIREBASE_PROJECT_ID=backdrop-fm-prod
```

---

### Step 8: Deploy Rules & Indexes to Each Project

After creating projects, deploy your Firestore rules and indexes to each:

```bash
# Deploy to development
firebase use backdrop-fm-dev
firebase deploy --only firestore

# Deploy to staging
firebase use backdrop-fm-staging
firebase deploy --only firestore

# Deploy to production
firebase use backdrop-fm-prod
firebase deploy --only firestore
```

---

### Step 9: Seed Development Data

```bash
# Make sure you're using dev project
firebase use backdrop-fm-dev

# Run seed script (you'll need to update it with the new project)
node seed-all-test-data.js
```

---

## Quick Reference

After setup, switch between projects:

```bash
# Switch Firebase CLI to dev
firebase use backdrop-fm-dev

# Switch to staging
firebase use backdrop-fm-staging

# Switch to production
firebase use backdrop-fm-prod

# See all projects
firebase projects:list
```

Run your app with different environments:

```bash
# Development
flutter run --dart-define=ENVIRONMENT=development

# Staging
flutter run --dart-define=ENVIRONMENT=staging

# Production
flutter run --dart-define=ENVIRONMENT=production
```

---

## Checklist

Use this to track your progress:

- [ ] Create `backdrop-fm-dev` project in Firebase Console
- [ ] Create `backdrop-fm-staging` project in Firebase Console
- [ ] Create `backdrop-fm-prod` project in Firebase Console
- [ ] Enable Authentication in all 3 projects
- [ ] Enable Firestore in all 3 projects
- [ ] Enable Storage in all 3 projects
- [ ] Run `flutterfire configure` for dev → creates `firebase_options_dev.dart`
- [ ] Run `flutterfire configure` for staging → creates `firebase_options_staging.dart`
- [ ] Run `flutterfire configure` for prod → creates `firebase_options_prod.dart`
- [ ] Update code to use environment-specific Firebase configs (I'll help!)
- [ ] Update `.env` files with new project IDs
- [ ] Deploy Firestore rules to all 3 projects
- [ ] Seed development data
- [ ] Test each environment

---

## Need Help?

**After you create the 3 Firebase projects and run the `flutterfire configure` commands, message me:**

> "I've created the 3 Firebase projects and have the firebase_options_*.dart files. Ready for code updates!"

And I'll update your code to automatically use the correct Firebase project based on the environment! 🚀
