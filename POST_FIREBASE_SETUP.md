# Code Changes After Creating Firebase Projects

## What I'll Update For You

After you create the 3 Firebase projects and run the `flutterfire configure` commands, you'll have:

- ✅ `lib/firebase_options_dev.dart`
- ✅ `lib/firebase_options_staging.dart`
- ✅ `lib/firebase_options_prod.dart`

Then I need to update **2 files** in your code:

---

## File 1: `lib/config/environment.dart`

**Add this method:**

```dart
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart' as firebase_options_original;
import '../firebase_options_dev.dart' as firebase_options_dev;
import '../firebase_options_staging.dart' as firebase_options_staging;
import '../firebase_options_prod.dart' as firebase_options_prod;

class AppEnvironment {
  // ... existing code ...

  /// Get Firebase options for current environment
  static FirebaseOptions get firebaseOptions {
    switch (_current) {
      case Environment.development:
        return firebase_options_dev.DefaultFirebaseOptions.currentPlatform;
      case Environment.staging:
        return firebase_options_staging.DefaultFirebaseOptions.currentPlatform;
      case Environment.production:
        return firebase_options_prod.DefaultFirebaseOptions.currentPlatform;
    }
  }
}
```

---

## File 2: `lib/main.dart`

**Change this line:**

```dart
// OLD:
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

// NEW:
await Firebase.initializeApp(options: AppEnvironment.firebaseOptions);
```

---

## That's It!

After these 2 small changes:
- Development mode → Uses `backdrop-fm-dev` project
- Staging mode → Uses `backdrop-fm-staging` project
- Production mode → Uses `backdrop-fm-prod` project

Everything else (collection names, security rules, indexes) stays the same!

---

## What To Do Now

1. **Go create the 3 Firebase projects** following FIREBASE_PROJECTS_SETUP.md
2. **Run the 3 `flutterfire configure` commands**
3. **Tell me when you're done**, and I'll make these code changes for you!

The whole process takes about 10-15 minutes. 🚀
