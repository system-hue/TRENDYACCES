import 'package:flutter/material.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:trendy/rtm_service.dart';
import 'package:trendy/views/chat/video_call_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _rtmService = RtmService();
  final _messages = <String>[];
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rtmService.initialize();
    _rtmService.login('user1');
    _rtmService.onMessageReceived((AgoraRtmMessage message, String peerId) {
      setState(() {
        _messages.add(message.text);
      });
    });
  }

  @override
  void dispose() {
    _rtmService.logout();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _rtmService.sendMessage('user2', _controller.text);
      setState(() {
        _messages.add(_controller.text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with user2'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VideoCallScreen(),
                ),
              );
            },
            icon: const Icon(Icons.video_call),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(_messages[index]));
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a message...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
