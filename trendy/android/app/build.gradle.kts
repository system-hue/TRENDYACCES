plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}
// Apply the Google Services Gradle plugin to enable Firebase services

android {
    namespace = "com.vibe.trendy" // ✅ Must match your Firebase project
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // Optional: Explicit NDK version for stability

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.vibe.trendy" // ✅ Must match Firebase `google-services.json`
        minSdk = 21 // ✅ Firebase requires at least 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true // ✅ Add this if you get Dex errors with Firebase
    }

    signingConfigs {
        create("release") {
            storeFile = file("keystore/trendy-release.keystore")
            storePassword = System.getenv("KEYSTORE_PASSWORD") ?: "your_keystore_password"
            keyAlias = System.getenv("KEY_ALIAS") ?: "trendy-key"
            keyPassword = System.getenv("KEY_PASSWORD") ?: "your_key_password"
        }
    }

    buildTypes {
        getByName("debug") {
            isDebuggable = true
            isMinifyEnabled = false
            isShrinkResources = false
            applicationIdSuffix = ".debug"
            versionNameSuffix = "-debug"
        }
        
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            isDebuggable = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
