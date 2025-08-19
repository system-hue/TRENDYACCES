import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  static const Duration _cacheDuration = Duration(minutes: 15);
  final Map<String, dynamic> _memoryCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};

  // Memory cache
  T? getFromMemory<T>(String key) {
    if (_memoryCache.containsKey(key)) {
      final timestamp = _cacheTimestamps[key];
      if (timestamp != null &&
          DateTime.now().difference(timestamp) < _cacheDuration) {
        return _memoryCache[key] as T?;
      }
      _memoryCache.remove(key);
      _cacheTimestamps.remove(key);
    }
    return null;
  }

  void setInMemory<T>(String key, T value) {
    _memoryCache[key] = value;
    _cacheTimestamps[key] = DateTime.now();
  }

  void clearMemory() {
    _memoryCache.clear();
    _cacheTimestamps.clear();
  }

  // Persistent cache
  Future<void> setPersistent(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getPersistent(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> clearPersistent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Image caching
  Future<void> cacheImage(String url, String base64Image) async {
    await setPersistent('img_$url', base64Image);
  }

  Future<String?> getCachedImage(String url) async {
    return await getPersistent('img_$url');
  }
}
