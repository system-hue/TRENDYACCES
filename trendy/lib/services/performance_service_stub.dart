// Stub implementation for Firebase Performance
// This is a temporary replacement to fix compilation errors

class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();

  factory PerformanceService() => _instance;
  PerformanceService._internal();

  Future<void> initialize() async {
    // Stub implementation
    print('Performance service initialized');
  }

  Future<dynamic> startTrace(String name) async {
    // Stub implementation
    return null;
  }

  Future<void> stopTrace(dynamic trace) async {
    // Stub implementation
    print('Trace stopped: $trace');
  }

  Future<void> logHttpMetric(
    String url,
    String method,
    int statusCode,
    int responseTime,
  ) async {
    // Stub implementation
    print(
      'HTTP metric logged: $method $url - $statusCode in ${responseTime}ms',
    );
  }
}
