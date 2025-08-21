import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class AdsService {
  static const String _consentKey = 'ads_consent';
  static const String _frequencyKey = 'ad_frequency';

  static bool _isInitialized = false;
  static bool _hasConsent = false;
  static bool _isGDPRRegion = false;
  static bool _isCCPARegion = false;

  // Ad unit IDs (use production IDs for release)
  static const String _bannerId = 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx';
  static const String _interstitialId = 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx';
  static const String _rewardedId = 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx';
  static const String _nativeId = 'ca-app-pub-xxxxxxxxxxxxxxxx/xxxxxxxxxx';

  // Google Mobile Ads test IDs (Android). Replace with iOS IDs on iOS builds.
  static const String _testBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewardedId = 'ca-app-pub-3940256099942544/5224354917';
  static const String _testNativeId = 'ca-app-pub-3940256099942544/2247696110';

  static Future<void> initialize() async {
    if (_isInitialized) return;

    await MobileAds.instance.initialize();

    final prefs = await SharedPreferences.getInstance();
    _hasConsent = prefs.getBool(_consentKey) ?? false;

    // Check region for privacy compliance
    await _checkPrivacyRegions();

    _isInitialized = true;
  }

  static Future<void> _checkPrivacyRegions() async {
    // This would typically use IP geolocation
    // For now, we'll use a simple check
    _isGDPRRegion = true; // Default to GDPR compliance
    _isCCPARegion = false;
  }

  static Future<void> setConsent(bool consent) async {
    _hasConsent = consent;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentKey, consent);

    // Update ad request configuration
    final request = RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
      maxAdContentRating: MaxAdContentRating.ma,
    );

    MobileAds.instance.updateRequestConfiguration(request);
  }

  static bool canShowPersonalizedAds() {
    return _hasConsent && !_isGDPRRegion && !_isCCPARegion;
  }

  static bool shouldShowConsentDialog() {
    return _isGDPRRegion || _isCCPARegion;
  }

  // Banner Ad
  static BannerAd createBannerAd({
    required String adUnitId,
    required AdSize size,
    required Function(Ad) onAdLoaded,
    required Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: AdRequest(nonPersonalizedAds: !canShowPersonalizedAds()),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdOpened: (Ad ad) => print('Ad opened.'),
        onAdClosed: (Ad ad) => print('Ad closed.'),
      ),
    );
  }

  // Interstitial Ad
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialAdReady = false;

  static void loadInterstitialAd({
    required String adUnitId,
    required Function() onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) {
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: AdRequest(nonPersonalizedAds: !canShowPersonalizedAds()),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          onAdLoaded();
        },
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }

  static void showInterstitialAd({required Function() onAdDismissed}) {
    if (!_isInterstitialAdReady || _interstitialAd == null) {
      onAdDismissed();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (Ad ad) {
        ad.dispose();
        _isInterstitialAdReady = false;
        _interstitialAd = null;
        onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (Ad ad, AdError error) {
        ad.dispose();
        _isInterstitialAdReady = false;
        _interstitialAd = null;
        onAdDismissed();
      },
    );

    _interstitialAd!.show();
  }

  // Rewarded Ad
  static RewardedAd? _rewardedAd;
  static bool _isRewardedAdReady = false;

  static void loadRewardedAd({
    required String adUnitId,
    required Function() onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) {
    RewardedAd.load(
      adUnitId: adUnitId,
      request: AdRequest(nonPersonalizedAds: !canShowPersonalizedAds()),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          onAdLoaded();
        },
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }

  static void showRewardedAd({
    required Function(RewardItem) onUserEarnedReward,
    required Function() onAdDismissed,
  }) {
    if (!_isRewardedAdReady || _rewardedAd == null) {
      onAdDismissed();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (Ad ad) {
        ad.dispose();
        _isRewardedAdReady = false;
        _rewardedAd = null;
        onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (Ad ad, AdError error) {
        ad.dispose();
        _isRewardedAdReady = false;
        _rewardedAd = null;
        onAdDismissed();
      },
    );

    _rewardedAd!.show(onUserEarnedReward: onUserEarnedReward);
  }

  // Native Ad
  static NativeAd createNativeAd({
    required String adUnitId,
    required Function(Ad) onAdLoaded,
    required Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    return NativeAd(
      adUnitId: adUnitId,
      request: AdRequest(nonPersonalizedAds: !canShowPersonalizedAds()),
      listener: NativeAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: Colors.white,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: Colors.blue,
          style: NativeTemplateFontStyle.normal,
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 16.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.grey,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.italic,
          size: 12.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.grey,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 12.0,
        ),
      ),
    );
  }

  // Frequency capping
  static Future<bool> canShowAd(String adType) async {
    final prefs = await SharedPreferences.getInstance();
    final lastShown = prefs.getInt('${adType}_last_shown') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final minInterval = _getMinIntervalForAdType(adType);

    return (now - lastShown) >= minInterval;
  }

  static Future<void> recordAdShown(String adType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      '${adType}_last_shown',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static int _getMinIntervalForAdType(String adType) {
    switch (adType) {
      case 'interstitial':
        return 30 * 60 * 1000; // 30 minutes
      case 'rewarded':
        return 5 * 60 * 1000; // 5 minutes
      case 'banner':
        return 0; // No limit for banners
      default:
        return 60 * 60 * 1000; // 1 hour
    }
  }

  // Ad mediation
  static Future<void> initializeMediation() async {
    // Initialize AdMob
    await initialize();

    // Initialize Facebook Audience Network
    // FacebookAudienceNetwork.init(
    //   testingId: "YOUR_TESTING_ID",
    // );
  }

  // Brand safety
  static AdRequest createSafeAdRequest() {
    return AdRequest(
      nonPersonalizedAds: !canShowPersonalizedAds(),
      keywords: ['safe', 'family-friendly', 'general'],
      contentUrl: 'https://trendy.app',
    );
  }
}

class AdView extends StatelessWidget {
  final Ad ad;
  final double height;

  const AdView({Key? key, required this.ad, this.height = 50})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: AdWidget(ad: ad),
    );
  }
}

// Ad placement configurations
class AdPlacements {
  static const String musicFeedNative = 'music_feed_native';
  static const String moviesPreRoll = 'movies_preroll';
  static const String footballRewarded = 'football_rewarded';
  static const String profileInterstitial = 'profile_interstitial';

  static String getAdUnitId(String placement) {
    // Return appropriate ad unit ID based on placement and region
    // This would typically come from a remote config
    switch (placement) {
      case musicFeedNative:
        return AdsService._testNativeId;
      case moviesPreRoll:
        return AdsService._testRewardedId;
      case footballRewarded:
        return AdsService._testRewardedId;
      case profileInterstitial:
        return AdsService._testInterstitialId;
      default:
        return AdsService._testBannerId;
    }
  }
}
