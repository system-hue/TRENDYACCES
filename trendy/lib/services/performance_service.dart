import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_performance/firebase_performance.dart';

class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  final FirebasePerformance _performance = FirebasePerformance.instance;

  Future<T> trackOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    final trace = _performance.newTrace(operationName);
    await trace.start();

    try {
      final result = await operation();
      await trace.stop();
      return result;
    } catch (e) {
      await trace.stop();
      rethrow;
    }
  }

  Future<T> trackNetworkRequest<T>(
    String url,
    String method,
    Future<T> Function() request,
  ) async {
    final metric = _performance.newHttpMetric(url, HttpMethod.Get);
    await metric.start();

    try {
      final result = await request();
      await metric.stop();
      return result;
    } catch (e) {
      await metric.stop();
      rethrow;
    }
  }

  static Future<T> runInIsolate<T>(FutureOr<T> Function() computation) async {
    return await compute((_) => computation(), null);
  }

  static Future<void> dispose() async {
    // Cleanup resources
  }
}
