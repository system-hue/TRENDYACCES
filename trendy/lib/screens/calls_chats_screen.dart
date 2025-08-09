import 'package:flutter/material.dart';

class CallsChatsScreen extends StatefulWidget {
  const CallsChatsScreen({super.key});

  @override
  State<CallsChatsScreen> createState() => _CallsChatsScreenState();
}

class _CallsChatsScreenState extends State<CallsChatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats & Calls'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Chats'),
            Tab(text: 'Calls'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_ChatsTab(), _CallsTab()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Start new chat/call
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ChatsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        _buildChatItem('John Doe', 'Hey, how are you?', '2:30 PM', true),
        _buildChatItem('Jane Smith', 'See you tomorrow!', '1:45 PM', false),
        _buildChatItem(
          'Mike Johnson',
          'Great game last night!',
          '11:20 AM',
          true,
        ),
      ],
    );
  }

  Widget _buildChatItem(
    String name,
    String lastMessage,
    String time,
    bool hasUnread,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(name[0])),
        title: Text(name),
        subtitle: Text(lastMessage),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(time, style: const TextStyle(fontSize: 12)),
            if (hasUnread)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        onTap: () {
          // Open chat
        },
      ),
    );
  }
}

class _CallsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        _buildCallItem(
          'Sarah Wilson',
          'Missed call',
          '3:15 PM',
          Icons.call_missed,
          Colors.red,
        ),
        _buildCallItem(
          'David Brown',
          'Outgoing call',
          '2:00 PM',
          Icons.call_made,
          Colors.green,
        ),
        _buildCallItem(
          'Emma Davis',
          'Incoming call',
          '12:30 PM',
          Icons.call_received,
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildCallItem(
    String name,
    String type,
    String time,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(name[0])),
        title: Text(name),
        subtitle: Text(type),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(time, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 8),
            Icon(icon, color: color),
          ],
        ),
        onTap: () {
          // Start call
        },
      ),
    );
  }
}
