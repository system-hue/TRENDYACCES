import 'package:agora_rtm/agora_rtm.dart';

class RtmService {
  static const String _appId = '984361f3279443f68ad1918d3188f948';

  AgoraRtmClient? _client;

  Future<void> initialize() async {
    _client = await AgoraRtmClient.createInstance(_appId);
  }

  Future<void> login(String userId) async {
    await _client?.login(null, userId);
  }

  Future<void> logout() async {
    await _client?.logout();
  }

  Future<void> sendMessage(String peerId, String message) async {
    final AgoraRtmMessage rtmMessage = AgoraRtmMessage.fromText(message);
    await _client?.sendMessageToPeer(peerId, rtmMessage);
  }

  void onMessageReceived(void Function(AgoraRtmMessage, String) callback) {
    _client?.onMessageReceived = callback;
  }
}
