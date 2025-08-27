// Temporary RTM service implementation without Agora RTM dependencies
// This will allow the build to succeed while we fix the native library conflicts

class RtmService {
  static const String _appId = '984361f3279443f68ad1918d3188f948';

  dynamic _client;

  Future<void> initialize() async {
    // Temporary implementation
    _client = null;
  }

  Future<void> login(String userId) async {
    // Temporary implementation
    print('RTM Login: $userId');
  }

  Future<void> logout() async {
    // Temporary implementation
    print('RTM Logout');
  }

  Future<void> sendMessage(String peerId, String message) async {
    // Temporary implementation
    print('RTM Send message: $message to $peerId');
  }

  void onMessageReceived(void Function(dynamic, String) callback) {
    // Temporary implementation
    print('RTM Message received callback registered');
  }
}
