import 'package:flutter/material.dart';
import 'package:trendy/services/enhanced_api_service.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> messages = [];
  List<dynamic> notifications = [];
  List<dynamic> calls = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadInboxData();
  }

  Future<void> _loadInboxData() async {
    try {
      final messages = await EnhancedApiService.getMessages();
      final notifications = await EnhancedApiService.getNotifications();
      final calls = await EnhancedApiService.getCalls();

      setState(() {
        this.messages = messages;
        this.notifications = notifications;
        this.calls = calls;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Messages'),
            Tab(text: 'Notifications'),
            Tab(text: 'Calls'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildMessagesTab(),
                _buildNotificationsTab(),
                _buildCallsTab(),
              ],
            ),
    );
  }

  Widget _buildMessagesTab() {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(message['avatar'] ?? ''),
          ),
          title: Text(message['sender'] ?? 'Unknown'),
          subtitle: Text(message['content'] ?? ''),
          trailing: Text(message['timestamp'] ?? ''),
        );
      },
    );
  }

  Widget _buildNotificationsTab() {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return ListTile(
          leading: const Icon(Icons.notifications),
          title: Text(notification['title'] ?? ''),
          subtitle: Text(notification['body'] ?? ''),
          trailing: Text(notification['created_at'] ?? ''),
        );
      },
    );
  }

  Widget _buildCallsTab() {
    return ListView.builder(
      itemCount: calls.length,
      itemBuilder: (context, index) {
        final call = calls[index];
        return ListTile(
          leading: const Icon(Icons.phone),
          title: Text(call['caller'] ?? ''),
          subtitle: Text(call['type'] ?? ''),
          trailing: Text(call['created_at'] ?? ''),
        );
      },
    );
  }
}
