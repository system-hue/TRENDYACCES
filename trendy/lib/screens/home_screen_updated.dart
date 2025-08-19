import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/backend_service.dart';
import '../services/enhanced_api_service.dart';
import '../widgets/post_widget.dart';
import 'create_post_screen_fixed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> posts = [];
  bool isLoading = true;
  String errorMessage = '';
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });
    }

    try {
      final response = await BackendService.getPosts(page: 1, size: 20);
      final loadedPosts = response['items'] ?? [];

      if (mounted) {
        setState(() {
          posts = loadedPosts;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Failed to load posts: ${e.toString()}';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshPosts() async {
    setState(() => isRefreshing = true);
    await _loadPosts();
    setState(() => isRefreshing = false);
  }

  Future<void> _loadTrendingPosts() async {
    try {
      final trendingPosts = await BackendService.getTrendingPosts(limit: 10);
      if (mounted) {
        setState(() {
          posts = trendingPosts;
          isLoading = false;
        });
      }
    } catch (e) {
      await _loadPosts(); // Fallback to regular posts
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trendy'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshPosts),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'trending') {
                _loadTrendingPosts();
              } else {
                _loadPosts();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'latest', child: Text('Latest Posts')),
              const PopupMenuItem(value: 'trending', child: Text('Trending')),
            ],
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreatePost(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading && !isRefreshing) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _loadPosts, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No posts yet'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _refreshPosts,
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshPosts,
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostWidget(post: posts[index]);
        },
      ),
    );
  }

  void _navigateToCreatePost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreatePostScreen()),
    );
  }
}
