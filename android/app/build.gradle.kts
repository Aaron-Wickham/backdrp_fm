plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")

    // START: FlutterFire / Firebase Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire / Firebase Configuration

    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.backdrpfm.app"

    // These come from the Flutter Gradle plugin (keeps in sync with your Flutter SDK)
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Java 11 is fine; you can bump to 17 if your toolchain is on JDK 17.
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.backdrpfm.app"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: configure a real signingConfig for Play/App Store releases.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    // Path to the Flutter project root
    source = "../.."
}

// No explicit Firebase dependencies needed here for Flutter;
// your Dart packages (firebase_core, firebase_messaging, etc.) pull in what’s needed.
