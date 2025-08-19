import 'package:flutter/material.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadInboxData();
  }

  Future<void> _loadInboxData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isLoading = false;
    });
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
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: const Text('User Name'),
          subtitle: const Text('Last message preview...'),
          trailing: const Text('2 min ago'),
        );
      },
    );
  }

  Widget _buildNotificationsTab() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notification Title'),
          subtitle: const Text('Notification body...'),
          trailing: const Text('5 min ago'),
        );
      },
    );
  }

  Widget _buildCallsTab() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.phone),
          title: const Text('Caller Name'),
          subtitle: const Text('Video call'),
          trailing: const Text('1 hour ago'),
        );
      },
    );
  }
}
