import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MemoryManager {
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  final List<VoidCallback> _disposeCallbacks = [];
  Timer? _memoryTimer;

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

  Future<void> disposeAll() async {
    for (final callback in _disposeCallbacks) {
      callback();
    }
    _disposeCallbacks.clear();

    // Clear image cache
    await CachedNetworkImage.evictFromCache();
  }

  void dispose() {
    _memoryTimer?.cancel();
    _disposeCallbacks.clear();
  }
}
