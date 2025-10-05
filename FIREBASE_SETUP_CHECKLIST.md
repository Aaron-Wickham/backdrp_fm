# Firebase Setup Checklist

## What I Just Did For You ✅

1. ✅ Updated `firestore.rules` to support all three environments (dev, staging, prod)
2. ✅ Updated `firestore.indexes.json` to include staging indexes
3. ✅ Created environment configuration files (.env.development, .env.staging, .env.production)

## What You Need To Do Now 🔧

### Step 1: Deploy Firestore Rules & Indexes (REQUIRED)

```bash
# Deploy both rules and indexes to Firebase
firebase deploy --only firestore

# This will deploy:
# - firestore.rules (security rules for dev_*, staging_*, and production collections)
# - firestore.indexes.json (indexes for all environments)
```

**Wait 2-3 minutes for indexes to build.** You can check status at:
https://console.firebase.google.com/project/backdrop-fm/firestore/indexes

---

### Step 2: Verify Your Current Data

Check which collections currently exist in your Firestore:

```bash
# Open Firebase Console
open https://console.firebase.google.com/project/backdrop-fm/firestore/data
```

You should see `dev_*` collections if you've run `node seed-all-test-data.js`

---

### Step 3: Test the Environment Switching

```bash
# Test development (default - should work with existing dev_* collections)
flutter run -d chrome

# You should see a GREEN banner that says "DEVELOPMENT" in the top-right
```

Once the app loads:
1. ✅ Check for green "DEVELOPMENT" banner
2. ✅ Try logging in (test1@backdrp.fm / Test123!)
3. ✅ Verify videos load from dev_videos collection
4. ✅ Check browser console for: "🚀 Starting BACKDRP.FM in DEVELOPMENT mode"

---

### Step 4: Test Staging Environment (Optional)

First, you need staging data:

```bash
# TODO: Create a seed-staging-data.js script (copy seed-all-test-data.js)
# Modify it to write to staging_* collections instead of dev_*

# For now, you can manually create a test document in Firebase Console:
# 1. Go to Firestore
# 2. Create collection: staging_videos
# 3. Add a test document
```

Then test:
```bash
flutter run -d chrome --dart-define=ENVIRONMENT=staging

# You should see an ORANGE banner that says "STAGING"
```

---

## Current Environment Status

| Environment | Collections | Data Status | Firebase Project |
|-------------|------------|-------------|------------------|
| Development | `dev_*` | ✅ Seeded (via seed-all-test-data.js) | backdrop-fm |
| Staging | `staging_*` | ❌ Empty (needs seeding) | backdrop-fm |
| Production | No prefix | ❌ Empty | backdrop-fm |

---

## Testing Your Setup

### Quick Test Commands

```bash
# 1. Deploy Firebase config
firebase deploy --only firestore

# 2. Check deployment worked
firebase firestore:indexes

# 3. Run development mode
flutter run -d chrome

# 4. In another terminal, check running app
# Look for "DEVELOPMENT" banner in top-right
```

---

## Troubleshooting

### "Missing or insufficient permissions"
- **Cause**: Security rules not deployed
- **Fix**: Run `firebase deploy --only firestore:rules`

### "Index required" error
- **Cause**: Indexes not built yet
- **Fix**: Wait 2-3 minutes after deploying, or check https://console.firebase.google.com/project/backdrop-fm/firestore/indexes

### "No data showing"
- **Cause**: Wrong environment or no data in collections
- **Fix**:
  1. Check banner shows correct environment
  2. Verify collections exist in Firestore Console
  3. Re-run `node seed-all-test-data.js` for dev data

### Environment banner not showing
- **Cause**: Running in production mode or release build
- **Fix**:
  1. Make sure you're running in debug mode
  2. Check `flutter run` not `flutter run --release`
  3. Production environment hides banner by design

---

## Next Steps (Future Improvements)

### Separate Firebase Projects (Recommended)
Currently all environments share `backdrop-fm` project. For better isolation:

1. Create new Firebase projects:
   - `backdrop-fm-dev`
   - `backdrop-fm-staging`
   - `backdrop-fm-prod`

2. Run `flutterfire configure` for each

3. Update `.env.development`, `.env.staging`, `.env.production` with correct project IDs

### Seed Scripts for Each Environment

Create these scripts:
- `seed-dev-data.js` (rename current seed-all-test-data.js)
- `seed-staging-data.js` (copy and modify for staging_* collections)
- Never seed production - only manual admin uploads

---

## Summary

**To get everything working right now:**

```bash
# 1. Deploy Firebase configuration
firebase deploy --only firestore

# 2. Wait 2-3 minutes for indexes

# 3. Run your app
flutter run -d chrome

# 4. Verify:
# - GREEN "DEVELOPMENT" banner appears
# - Console shows: "🚀 Starting BACKDRP.FM in DEVELOPMENT mode"
# - You can see videos from dev_videos collection
```

That's it! Your multi-environment setup is ready. 🎉
