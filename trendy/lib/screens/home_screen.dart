import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:trendy/services/ads_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;
  bool _adLoaded = false;

  @override
  void initState() {
    super.initState();
    _initAds();
  }

  Future<void> _initAds() async {
    await AdsService.initialize();
    final adUnitId = AdPlacements.getAdUnitId('banner');
    final banner = AdsService.createBannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      onAdLoaded: (ad) {
        setState(() {
          _bannerAd = ad as BannerAd;
          _adLoaded = true;
        });
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        debugPrint('Banner ad failed to load: $error');
      },
    );
    banner.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.trending_up, size: 48, color: Colors.deepPurple),
            const SizedBox(height: 16),
            const Text(
              'Trending Content',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Music, Movies, and Photography highlights'),
            const SizedBox(height: 24),
            if (_adLoaded && _bannerAd != null)
              SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
          ],
        ),
      ),
    );
  }
}
