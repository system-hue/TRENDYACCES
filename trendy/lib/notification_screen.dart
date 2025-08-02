import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return const ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://i.imgur.com/3oEJMlB.png'),
            ),
            title: Text('Username liked your post.'),
            subtitle: Text('2 hours ago'),
          );
        },
      ),
    );
  }
}
