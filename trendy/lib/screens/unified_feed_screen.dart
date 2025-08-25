import 'package:flutter/material.dart';
import '../widgets/post_widget.dart';
import '../widgets/story_widget.dart';
import '../widgets/reel_widget.dart';

class UnifiedFeedScreen extends StatefulWidget {
  const UnifiedFeedScreen({super.key});

  @override
  _UnifiedFeedScreenState createState() => _UnifiedFeedScreenState();
}

class _UnifiedFeedScreenState extends State<UnifiedFeedScreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'all';
  final List<String> _filters = [
    'all',
    'text',
    'image',
    'video',
    'reel',
    'story',
    'tweet',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trendy Feed'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => _filters.map((filter) {
              return PopupMenuItem(
                value: filter,
                child: Text(filter.toUpperCase()),
              );
            }).toList(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh logic will be implemented later
          setState(() {});
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Stories Section (Instagram-style)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return StoryWidget(title: 'User $index');
                  },
                ),
              ),
            ),

            // Reels Section (TikTok-style)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ReelWidget(
                      reelId: index,
                      thumbnailUrl:
                          'https://picsum.photos/200/300?random=$index',
                      views: (index + 1) * 1000,
                    );
                  },
                ),
              ),
            ),

            // Main Feed - Using dummy data for now
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final dummyPost = {
                  'id': index,
                  'title': 'Post $index',
                  'content': 'This is a sample post content for post $index',
                  'type': _selectedFilter,
                  'likes': index * 10,
                  'comments': index * 2,
                  'shares': index,
                };
                return PostWidget(post: dummyPost);
              }, childCount: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.text_fields),
                title: const Text('Text Post'),
                onTap: () => _createPost(context, 'text'),
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Image Post'),
                onTap: () => _createPost(context, 'image'),
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Video Post'),
                onTap: () => _createPost(context, 'video'),
              ),
              ListTile(
                leading: const Icon(Icons.music_note),
                title: const Text('Reel'),
                onTap: () => _createPost(context, 'reel'),
              ),
              ListTile(
                leading: const Icon(Icons.circle),
                title: const Text('Story'),
                onTap: () => _createPost(context, 'story'),
              ),
              ListTile(
                leading: const Icon(Icons.chat),
                title: const Text('Tweet'),
                onTap: () => _createPost(context, 'tweet'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _createPost(BuildContext context, String type) {
    Navigator.pop(context);
    // Navigate to post creation screen based on type
    Navigator.pushNamed(context, '/create_post', arguments: {'type': type});
  }

  void _showCommentDialog(BuildContext context, int postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Comment'),
          content: const TextField(
            decoration: InputDecoration(hintText: 'Write your comment...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add comment logic
                Navigator.pop(context);
              },
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  void _sharePost(dynamic post) {
    // Share post logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Post shared successfully!')));
  }
}
