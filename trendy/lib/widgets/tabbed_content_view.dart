import 'package:flutter/material.dart';

class TabbedContentView extends StatelessWidget {
  const TabbedContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Posts'),
              Tab(text: 'Favorites'),
              Tab(text: 'Reposts'),
              Tab(text: 'Activity'),
            ],
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                _buildPostsTab(),
                _buildFavoritesTab(),
                _buildRepostsTab(),
                _buildActivityTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Post ${index + 1}'),
          subtitle: const Text('This is a sample post'),
        );
      },
    );
  }

  Widget _buildFavoritesTab() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Favorite ${index + 1}'),
          subtitle: const Text('This is a favorite item'),
        );
      },
    );
  }

  Widget _buildRepostsTab() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Repost ${index + 1}'),
          subtitle: const Text('This is a repost'),
        );
      },
    );
  }

  Widget _buildActivityTab() {
    return ListView.builder(
      itemCount: 7,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Activity ${index + 1}'),
          subtitle: const Text('This is an activity'),
        );
      },
    );
  }
}
