class AppConfig {
  // Backend Configuration
  static const String baseUrl = 'http://localhost:8000';
  static const String apiVersion = '/api/v1';

  // WebSocket Configuration
  static const String websocketUrl = 'ws://localhost:8000/ws';

  // Firebase Configuration
  static const String firebaseProjectId = 'trendy-social-app';

  // Feature Flags
  static const bool enableRealTimeMessaging = true;
  static const bool enableAIFeatures = true;
  static const bool enableMonetization = true;
  static const bool enableLocationServices = true;

  // Media Configuration
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxVideoSize = 100 * 1024 * 1024; // 100MB
  static const String mediaUploadUrl = '$baseUrl/api/v1/media/upload';
}
