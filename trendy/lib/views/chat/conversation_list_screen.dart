import 'package:flutter/material.dart';
import 'package:trendy/views/chat/chat_screen_temp.dart';

class ConversationListScreen extends StatelessWidget {
  const ConversationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
            ),
            title: Text('User $index'),
            subtitle: const Text('Last message...'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
          );
        },
      ),
    );
  }
}
