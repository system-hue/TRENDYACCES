import 'dart:async';
import 'package:flutter/foundation.dart';

class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  final Map<String, DateTime> _operationStartTimes = {};
  final Map<String, int> _operationCounts = {};

  Future<T> trackOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    final startTime = DateTime.now();
    _operationStartTimes[operationName] = startTime;

    if (kDebugMode) {
      print('🚀 Starting operation: $operationName');
    }

    try {
      final result = await operation();
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      _operationCounts[operationName] =
          (_operationCounts[operationName] ?? 0) + 1;

      if (kDebugMode) {
        print(
          '✅ Completed operation: $operationName in ${duration.inMilliseconds}ms',
        );
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed operation: $operationName - $e');
      }
      rethrow;
    }
  }

  static Future<T> runInIsolate<T>(FutureOr<T> Function() computation) async {
    return await compute((_) => computation(), null);
  }

  static Future<T> runHeavyComputation<T>(T Function() computation) async {
    return await compute((_) => computation(), null);
  }

  Map<String, dynamic> getPerformanceStats() {
    return {
      'operations': _operationCounts,
      'activeOperations': _operationStartTimes.keys.toList(),
    };
  }

  static Future<void> dispose() async {
    // Cleanup resources
  }
}
