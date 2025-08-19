import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';

class MemoryManager {
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  final LinkedHashMap<String, dynamic> _cache = LinkedHashMap();
  static const int _maxCacheSize = 100;
  Timer? _cleanupTimer;

  void initialize() {
    _cleanupTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _cleanup();
    });
  }

  void dispose() {
    _cleanupTimer?.cancel();
    _cache.clear();
  }

  void cacheData(String key, dynamic data) {
    if (_cache.length >= _maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = data;
  }

  dynamic getCachedData(String key) {
    return _cache[key];
  }

  void evictFromCache(String key) {
    _cache.remove(key);
  }

  void _cleanup() {
    if (_cache.length > _maxCacheSize * 0.8) {
      final keysToRemove = _cache.keys.take((_cache.length * 0.2).ceil());
      for (final key in keysToRemove) {
        _cache.remove(key);
      }
    }
  }

  void clearCache() {
    _cache.clear();
  }
}
