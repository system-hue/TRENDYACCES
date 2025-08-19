// Stub implementation for Agora RTM service
// This is a temporary replacement to fix compilation errors
// Replace with actual Agora RTM implementation when needed

class RtmService {
  static const String _appId = 'your-app-id-here';

  dynamic _client;

  Future<void> initialize() async {
    // Stub implementation
    _client = null;
  }

  Future<void> login(String userId) async {
    // Stub implementation
    print('RTM Login stub: $userId');
  }

  Future<void> logout() async {
    // Stub implementation
    print('RTM Logout stub');
  }

  Future<void> sendMessage(String peerId, String message) async {
    // Stub implementation
    print('RTM Send message stub: $message to $peerId');
  }

  void onMessageReceived(void Function(dynamic, String) callback) {
    // Stub implementation
    print('RTM Message received callback stub');
  }
}
