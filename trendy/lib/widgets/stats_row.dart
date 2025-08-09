import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final int favoritesCount;
  final VoidCallback onFollowersTap;
  final VoidCallback onFollowingTap;
  final VoidCallback onPostsTap;
  final VoidCallback onFavoritesTap;

  const StatsRow({
    super.key,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    required this.favoritesCount,
    required this.onFollowersTap,
    required this.onFollowingTap,
    required this.onPostsTap,
    required this.onFavoritesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            context,
            count: postsCount,
            label: 'Posts',
            onTap: onPostsTap,
          ),
          _buildDivider(),
          _buildStatItem(
            context,
            count: followersCount,
            label: 'Followers',
            onTap: onFollowersTap,
          ),
          _buildDivider(),
          _buildStatItem(
            context,
            count: followingCount,
            label: 'Following',
            onTap: onFollowingTap,
          ),
          _buildDivider(),
          _buildStatItem(
            context,
            count: favoritesCount,
            label: 'Favorites',
            onTap: onFavoritesTap,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required int count,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            count.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: Colors.grey[300]);
  }
}
