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

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // 🔐 Change for producti// 🔐 Replace with release signing for production
            isMinifyEnabled = false
            isShrinkResources = false
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
