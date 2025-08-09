class UserProfile {
  final String id;
  final String displayName;
  final String username;
  final String? avatarUrl;
  final String? bio;
  final String? location;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final int favoritesCount;
  final bool isFollowing;
  final bool isOwnProfile;

  UserProfile({
    required this.id,
    required this.displayName,
    required this.username,
    this.avatarUrl,
    this.bio,
    this.location,
    required this.followersCount,
    required this.followingCount,
    required this.postsCount,
    required this.favoritesCount,
    this.isFollowing = false,
    this.isOwnProfile = false,
  });
}
