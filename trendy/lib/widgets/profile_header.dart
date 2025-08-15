import 'package:flutter/material.dart';
import 'package:trendy/models/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile user;
  final VoidCallback onEditProfile;
  final VoidCallback onFollowToggle;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.onEditProfile,
    required this.onFollowToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Avatar and basic info
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.avatarUrl ?? ''),
                child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                    ? const Icon(Icons.person, size: 40)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@${user.username ?? 'user'}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    if (user.location != null && user.location!.isNotEmpty)
                      Text(
                        user.location!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Bio
          if (user.bio != null && user.bio!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(user.bio!, style: const TextStyle(fontSize: 14)),
            ),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (user.isOwnProfile)
                ElevatedButton(
                  onPressed: onEditProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Edit Profile'),
                )
              else
                ElevatedButton(
                  onPressed: onFollowToggle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: user.isFollowing
                        ? Colors.grey
                        : Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(user.isFollowing ? 'Following' : 'Follow'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
