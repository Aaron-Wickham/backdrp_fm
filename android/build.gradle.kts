plugins {
    // Versions here are examples; use ones compatible with your setup/Flutter channel.
    id("com.android.application") version "8.9.1" apply false
    id("com.android.library") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "1.9.24" apply false

    // Google Services plugin (needed for Firebase on Android)
    id("com.google.gms.google-services") version "4.4.2" apply false

    // Flutter plugin loader (do not apply here; Flutter applies it in the app module)
    id("dev.flutter.flutter-plugin-loader") version "1.0.0" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ---- Optional: keep your custom build dir strategy ----
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
