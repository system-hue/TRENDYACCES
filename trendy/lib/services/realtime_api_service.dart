import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RealtimeApiService {
  static const String _wsBaseUrl = 'ws://localhost:8000/ws';
  static WebSocketChannel? _channel;
  static StreamController<Map<String, dynamic>>? _messageController;

  static Future<void> connect() async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    _channel = WebSocketChannel.connect(
      Uri.parse('$_wsBaseUrl/chat?token=$token'),
    );
    _messageController = StreamController<Map<String, dynamic>>();

    _channel!.stream.listen(
      (message) {
        final data = json.decode(message);
        _messageController?.add(data);
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed');
      },
    );
  }

  static void sendMessage(String message, String recipientId) {
    if (_channel != null) {
      _channel!.sink.add(
        json.encode({
          'type': 'message',
          'content': message,
          'recipient_id': recipientId,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
    }
  }

  static Stream<Map<String, dynamic>> getMessageStream() {
    return _messageController?.stream ?? Stream.empty();
  }

  static void disconnect() {
    _channel?.sink.close();
    _messageController?.close();
  }
}
