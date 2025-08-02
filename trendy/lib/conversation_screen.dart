import 'package:flutter/material.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Username'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return const ListTile(
                  title: Text('Message content'),
                );
              },
            ),
          ),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Send a message...',
            ),
          ),
        ],
      ),
    );
  }
}
