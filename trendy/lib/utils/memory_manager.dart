import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MemoryManager {
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  final List<VoidCallback> _disposeCallbacks = [];
  Timer? _memoryTimer;

  // Keep track of cached image URLs if you want targeted eviction
  final Set<String> _cachedUrls = {};

  void init() {
    _startMemoryMonitoring();
  }

  void _startMemoryMonitoring() {
    _memoryTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _checkMemoryUsage();
    });
  }

  void _checkMemoryUsage() {
    if (kDebugMode) {
      print('Memory check performed');
    }
  }

  void registerDisposeCallback(VoidCallback callback) {
    _disposeCallbacks.add(callback);
  }

  void trackUrl(String url) {
    _cachedUrls.add(url);
  }

  Future<void> disposeAll() async {
    // Run all registered cleanup callbacks
    for (final callback in _disposeCallbacks) {
      callback();
    }
    _disposeCallbacks.clear();

    // ✅ Clear specific cached images
    for (final url in _cachedUrls) {
      try {
        await CachedNetworkImage.evictFromCache(url);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to evict $url: $e');
        }
      }
    }
    _cachedUrls.clear();

    // ✅ Also clear the global Flutter image cache
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    if (kDebugMode) {
      print('All cached images evicted');
    }
  }

  void dispose() {
    _memoryTimer?.cancel();
    _disposeCallbacks.clear();
    _cachedUrls.clear();
  }
}
