import 'package:flutter/foundation.dart';

class AppConfig {
  static const String _devBaseUrl = 'http://10.0.2.2:8000';
  static const String _stagingBaseUrl = 'https://staging-api.trendyapp.com';
  static const String _prodBaseUrl = 'https://api.trendyapp.com';

  static String get apiBaseUrl {
    switch (appFlavor) {
      case Flavor.development:
        return _devBaseUrl;
      case Flavor.staging:
        return _stagingBaseUrl;
      case Flavor.production:
        return _prodBaseUrl;
    }
  }

  static String get apiVersion => 'v1';
  static String get fullApiUrl => '$apiBaseUrl/$apiVersion';

  static bool get isDevelopment => appFlavor == Flavor.development;
  static bool get isStaging => appFlavor == Flavor.staging;
  static bool get isProduction => appFlavor == Flavor.production;

  // Firebase Configuration
  static String get firebaseApiKey {
    return isProduction
        ? 'YOUR_PROD_FIREBASE_API_KEY'
        : isStaging
        ? 'YOUR_STAGING_FIREBASE_API_KEY'
        : 'YOUR_DEV_FIREBASE_API_KEY';
  }

  // Agora Configuration
  static String get agoraAppId {
    return isProduction
        ? 'ead057d4a72448a7afa18dd99f55c5b3'
        : isStaging
        ? 'ead057d4a72448a7afa18dd99f55c5b3'
        : 'ead057d4a72448a7afa18dd99f55c5b3';
  }

  // AdMob Configuration
  static String get admobAppId {
    if (kIsWeb) return '';
    return isProduction
        ? 'ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy'
        : 'ca-app-pub-3940256099942544~3347511713'; // Test ID
  }

  // Feature Flags
  static bool get enableAnalytics => !isDevelopment;
  static bool get enableCrashlytics => !isDevelopment;
  static bool get enablePerformanceMonitoring => !isDevelopment;
  static bool get enableAds => isProduction;
  static bool get enablePushNotifications => true;
  static bool get enableLogging => isDevelopment;

  // Social Configuration
  static String get dynamicLinkDomain => 'trendyapp.page.link';
  static String get supportEmail => 'support@trendyapp.com';
  static String get privacyPolicyUrl => 'https://trendyapp.com/privacy';
  static String get termsOfServiceUrl => 'https://trendyapp.com/terms';

  // App Configuration
  static String get appName {
    switch (appFlavor) {
      case Flavor.development:
        return 'Trendy Dev';
      case Flavor.staging:
        return 'Trendy Staging';
      case Flavor.production:
        return 'Trendy';
    }
  }

  static String get bundleId {
    switch (appFlavor) {
      case Flavor.development:
        return 'com.vibe.trendy.dev';
      case Flavor.staging:
        return 'com.vibe.trendy.staging';
      case Flavor.production:
        return 'com.vibe.trendy';
    }
  }
}

enum Flavor { development, staging, production }

late final Flavor appFlavor;

void initializeAppFlavor(Flavor flavor) {
  appFlavor = flavor;
}
