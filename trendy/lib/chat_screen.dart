import 'package:flutter/material.dart';
import 'package:trendy/conversation_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage('https://i.imgur.com/3oEJMlB.png'),
            ),
            title: const Text('Username'),
            subtitle: const Text('Last message...'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConversationScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
