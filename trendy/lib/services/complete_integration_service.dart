// Minimal stub to replace corrupted CompleteIntegrationService for build stability.

class CompleteIntegrationService {
  static Future<void> initializeAllServices() async {}
  static bool get isInCall => false;
  static bool get isLiveStreaming => false;
}
