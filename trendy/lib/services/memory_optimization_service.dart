import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MemoryOptimizationService {
  static final MemoryOptimizationService _instance =
      MemoryOptimizationService._internal();
  factory MemoryOptimizationService() => _instance;
  MemoryOptimizationService._internal();

  final Map<String, int> _imageCacheStats = {};
  final List<String> _activeImageUrls = [];
  Timer? _cleanupTimer;

  void initialize() {
    _startPeriodicCleanup();
  }

  void _startPeriodicCleanup() {
    _cleanupTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _performMemoryCleanup();
    });
  }

  void _performMemoryCleanup() {
    if (kDebugMode) {
      debugPrint('🧹 Performing memory cleanup...');
    }

    // Clear image cache for unused images
    _cleanupImageCache();

    // Trigger garbage collection hint
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PaintingBinding.instance.imageCache?.clear();
      PaintingBinding.instance.imageCache?.clearLiveImages();
    });
  }

  void _cleanupImageCache() {
    final currentTime = DateTime.now();
    final expiredKeys = _imageCacheStats.entries
        .where(
          (entry) =>
              currentTime
                  .difference(DateTime.fromMillisecondsSinceEpoch(entry.value))
                  .inMinutes >
              30,
        )
        .map((entry) => entry.key)
        .toList();

    for (final key in expiredKeys) {
      _imageCacheStats.remove(key);
      CachedNetworkImage.evictFromCache(key);
    }
  }

  void trackImageUrl(String url) {
    _activeImageUrls.add(url);
    _imageCacheStats[url] = DateTime.now().millisecondsSinceEpoch;
  }

  void untrackImageUrl(String url) {
    _activeImageUrls.remove(url);
    _imageCacheStats.remove(url);
  }

  Map<String, dynamic> getMemoryStats() {
    return {
      'cachedImages': _imageCacheStats.length,
      'activeImageUrls': _activeImageUrls.length,
      'totalMemoryUsage': _getEstimatedMemoryUsage(),
    };
  }

  int _getEstimatedMemoryUsage() {
    // Rough estimation based on image count and average size
    return _activeImageUrls.length * 2 * 1024 * 1024; // 2MB per image estimate
  }

  void dispose() {
    _cleanupTimer?.cancel();
    _imageCacheStats.clear();
    _activeImageUrls.clear();
  }
}

class OptimizedImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const OptimizedImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      placeholder: (context, url) =>
          placeholder ?? const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          errorWidget ?? const Icon(Icons.error),
      memCacheWidth: width?.toInt() ?? 300,
      memCacheHeight: height?.toInt() ?? 300,
      cacheKey: imageUrl,
    );
  }
}
