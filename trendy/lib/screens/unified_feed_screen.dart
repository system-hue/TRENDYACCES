import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../widgets/post_widget.dart';
import '../widgets/story_widget.dart';
import '../widgets/reel_widget.dart';

class UnifiedFeedScreen extends StatefulWidget {
  @override
  _UnifiedFeedScreenState createState() => _UnifiedFeedScreenState();
}

class _UnifiedFeedScreenState extends State<UnifiedFeedScreen> {
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'all';
  List<String> _filters = [
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
        title: Text('Trendy Feed'),
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
          await Provider.of<ApiService>(context, listen: false).refreshPosts();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Stories Section (Instagram-style)
            SliverToBoxAdapter(
              child: Container(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return StoryWidget(
                      userId: index,
                      username: 'User $index',
                      isViewed: index % 3 == 0,
                    );
                  },
                ),
              ),
            ),

            // Reels Section (TikTok-style)
            SliverToBoxAdapter(
              child: Container(
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

            // Main Feed
            Consumer<ApiService>(
              builder: (context, apiService, child) {
                return FutureBuilder(
                  future: apiService.getPosts(filter: _selectedFilter),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasError) {
                      return SliverFillRemaining(
                        child: Center(child: Text('Error loading posts')),
                      );
                    }

                    final posts = snapshot.data ?? [];

                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final post = posts[index];
                        return PostWidget(
                          post: post,
                          onLike: () => apiService.likePost(post.id),
                          onComment: () => _showCommentDialog(context, post.id),
                          onShare: () => _sharePost(post),
                        );
                      }, childCount: posts.length),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.text_fields),
                title: Text('Text Post'),
                onTap: () => _createPost(context, 'text'),
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Image Post'),
                onTap: () => _createPost(context, 'image'),
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Video Post'),
                onTap: () => _createPost(context, 'video'),
              ),
              ListTile(
                leading: Icon(Icons.music_note),
                title: Text('Reel'),
                onTap: () => _createPost(context, 'reel'),
              ),
              ListTile(
                leading: Icon(Icons.circle),
                title: Text('Story'),
                onTap: () => _createPost(context, 'story'),
              ),
              ListTile(
                leading: Icon(Icons.chat),
                title: Text('Tweet'),
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
          title: Text('Add Comment'),
          content: TextField(
            decoration: InputDecoration(hintText: 'Write your comment...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add comment logic
                Navigator.pop(context);
              },
              child: Text('Post'),
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
    ).showSnackBar(SnackBar(content: Text('Post shared successfully!')));
  }
}
