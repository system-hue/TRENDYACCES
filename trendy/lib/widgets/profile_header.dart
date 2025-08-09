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
    return Column(
      children: [
        // Profile Picture
        GestureDetector(
          onTap: () {
            // Handle profile picture change
          },
          child: CircleAvatar(
            radius: 50,
            backgroundImage: user.avatarUrl != null
                ? NetworkImage(user.avatarUrl!)
                : null,
            child: user.avatarUrl == null
                ? const Icon(Icons.person, size: 50)
                : null,
          ),
        ),
        const SizedBox(height: 16),

        // Name and Username
        Text(
          user.displayName,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '@${user.username}',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),

        // Bio with clickable hashtags
        if (user.bio != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildBioWithHashtags(user.bio!),
          ),

        // Location
        if (user.location != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(user.location!, style: const TextStyle(color: Colors.grey)),
            ],
          ),

        // Edit/Follow Button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: user.isOwnProfile ? onEditProfile : onFollowToggle,
            style: ElevatedButton.styleFrom(
              backgroundColor: user.isOwnProfile
                  ? Colors.deepPurple
                  : (user.isFollowing ? Colors.grey : Colors.deepPurple),
            ),
            child: Text(
              user.isOwnProfile
                  ? 'Edit Profile'
                  : (user.isFollowing ? 'Following' : 'Follow'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBioWithHashtags(String bio) {
    final parts = bio.split(' ');
    return Wrap(
      alignment: WrapAlignment.center,
      children: parts.map((part) {
        if (part.startsWith('#') || part.startsWith('@')) {
          return GestureDetector(
            onTap: () {
              // Handle hashtag/mention click
            },
            child: Text(
              '$part ',
              style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        return Text('$part ');
      }).toList(),
    );
  }
}
