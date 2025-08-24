// Stub ads service for development/testing
class AdsService {
  static Future<void> initialize() async {
    print('AdsService initialized (stub mode)');
  }

  static bool canShowPersonalizedAds() {
    return true;
  }

  static dynamic createBannerAd({
    required dynamic size,
    required Function(dynamic) onAdLoaded,
    required Function(dynamic) onAdFailedToLoad,
  }) {
    print('Banner ad created (stub)');
    return null;
  }

  static void loadInterstitialAd({
    required Function() onAdLoaded,
    required Function(dynamic) onAdFailedToLoad,
  }) {
    print('Interstitial ad loaded (stub)');
    onAdLoaded();
  }

  static void showInterstitialAd() {
    print('Interstitial ad shown (stub)');
  }

  static void loadRewardedAd({
    required Function() onAdLoaded,
    required Function(dynamic) onAdFailedToLoad,
    required Function(dynamic) onUserEarnedReward,
  }) {
    print('Rewarded ad loaded (stub)');
    onAdLoaded();
  }

  static void showRewardedAd({required Function(dynamic) onUserEarnedReward}) {
    print('Rewarded ad shown (stub)');
    onUserEarnedReward({'amount': 1, 'type': 'reward'});
  }

  static dynamic createNativeAd({
    required Function(dynamic) onAdLoaded,
    required Function(dynamic) onAdFailedToLoad,
  }) {
    print('Native ad created (stub)');
    return null;
  }

  static dynamic createSafeAdRequest() {
    return null;
  }
}
