import 'package:flutter/material.dart';
import 'package:trendy/models/notification.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: dummyNotifications.length,
        itemBuilder: (context, index) {
          final notification = dummyNotifications[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
            ),
            title: Text('${notification.user} ${notification.content}'),
            subtitle: Text(
              '${DateTime.now().difference(notification.timestamp).inMinutes} minutes ago',
            ),
          );
        },
      ),
    );
  }
}
