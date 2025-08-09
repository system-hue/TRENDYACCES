import 'package:flutter/material.dart';
import 'package:trendy/models/user_profile.dart';
import 'package:trendy/widgets/profile_header.dart';
import 'package:trendy/widgets/stats_row.dart';
import 'package:trendy/widgets/floating_radial_menu.dart';
import 'package:trendy/widgets/tabbed_content_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile _userProfile;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize with mock data - replace with actual user data
    _userProfile = UserProfile(
      id: 'user123',
      displayName: 'John Doe',
      username: 'johndoe',
      avatarUrl: 'https://example.com/avatar.jpg',
      bio: 'Flutter developer | #TechEnthusiast | @FlutterDev',
      location: 'San Francisco, CA',
      followersCount: 1234,
      followingCount: 567,
      postsCount: 89,
      favoritesCount: 234,
      isFollowing: false,
      isOwnProfile: true,
    );
  }

  void _editProfile() {
    // Navigate to edit profile screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );
  }

  void _toggleFollow() {
    setState(() {
      _userProfile = UserProfile(
        id: _userProfile.id,
        displayName: _userProfile.displayName,
        username: _userProfile.username,
        avatarUrl: _userProfile.avatarUrl,
        bio: _userProfile.bio,
        location: _userProfile.location,
        followersCount: _userProfile.followersCount,
        followingCount: _userProfile.followingCount,
        postsCount: _userProfile.postsCount,
        favoritesCount: _userProfile.favoritesCount,
        isFollowing: !_userProfile.isFollowing,
        isOwnProfile: _userProfile.isOwnProfile,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            ProfileHeader(
              user: _userProfile,
              onEditProfile: _editProfile,
              onFollowToggle: _toggleFollow,
            ),

            // Stats Row
            StatsRow(
              followersCount: _userProfile.followersCount,
              followingCount: _userProfile.followingCount,
              postsCount: _userProfile.postsCount,
              favoritesCount: _userProfile.favoritesCount,
              onFollowersTap: () {
                // Navigate to followers list
              },
              onFollowingTap: () {
                // Navigate to following list
              },
              onPostsTap: () {
                // Navigate to posts
              },
              onFavoritesTap: () {
                // Navigate to favorites
              },
            ),

            // Floating Action Buttons
            const FloatingRadialMenu(),

            // Tabbed Content
            const TabbedContentView(),
          ],
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(child: Text('Edit Profile Screen')),
    );
  }
}

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
