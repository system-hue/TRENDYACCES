import 'package:flutter/material.dart';
import 'package:trendy/widgets/floating_radial_menu_fixed.dart';
import 'package:trendy/services/api_service.dart';
import 'package:trendy/models/user_profile.dart';
import 'package:trendy/widgets/profile_header.dart';
import 'package:trendy/widgets/stats_row.dart';
import 'package:trendy/widgets/tabbed_content_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? userProfile;
  List<dynamic> userPosts = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadUserPosts();
  }

  Future<void> _loadUserProfile() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      // Fetch profile of demo user (ID 1)
      final response = await ApiService.getUserProfile('1');
      if (!mounted) return;
      setState(() {
        userProfile = UserProfile(
          id: response['id'] ?? 'demo-user',
          displayName: response['displayName'] ?? 'Demo User',
          username: response['username'] ?? 'demo_user',
          avatarUrl: response['avatar_url'] ?? '',
          bio: response['bio'] ?? 'Flutter developer',
          location: response['location'] ?? 'San Francisco, CA',
          followersCount: response['followers_count'] ?? 1234,
          followingCount: response['following_count'] ?? 567,
          postsCount: response['posts_count'] ?? 89,
          favoritesCount: response['favorites_count'] ?? 234,
          isFollowing: false,
          isOwnProfile: true,
        );
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        hasError = true;
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _loadUserPosts() async {
    try {
      final resp = await ApiService.getUserPosts('1');
      if (!mounted) return;
      setState(() {
        userPosts = (resp['posts'] as List?) ?? [];
      });
    } catch (e) {
      print('Error loading user posts: $e');
    }
  }

  void _editProfile() {
    // Navigate to edit profile screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $errorMessage'),
            ElevatedButton(
              onPressed: _loadUserProfile,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: _editProfile),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(
              user: userProfile!,
              onEditProfile: _editProfile,
              onFollowToggle: () {
                setState(() {
                  userProfile = UserProfile(
                    id: userProfile!.id,
                    displayName: userProfile!.displayName,
                    username: userProfile!.username,
                    avatarUrl: userProfile!.avatarUrl,
                    bio: userProfile!.bio,
                    location: userProfile!.location,
                    followersCount: userProfile!.followersCount + (userProfile!.isFollowing ? -1 : 1),
                    followingCount: userProfile!.followingCount,
                    postsCount: userProfile!.postsCount,
                    favoritesCount: userProfile!.favoritesCount,
                    isFollowing: !userProfile!.isFollowing,
                    isOwnProfile: userProfile!.isOwnProfile,
                  );
                });
              },
            ),
            StatsRow(
              followersCount: userProfile!.followersCount,
              followingCount: userProfile!.followingCount,
              postsCount: userProfile!.postsCount,
              favoritesCount: userProfile!.favoritesCount,
              onFollowersTap: () {},
              onFollowingTap: () {},
              onPostsTap: () {},
              onFavoritesTap: () {},
            ),
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
