import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostWidget extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: post['userPhoto'] != null
                      ? NetworkImage(post['userPhoto'])
                      : null,
                  child: post['userPhoto'] == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['username'] ?? 'Unknown User',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      post['createdAt'] ?? 'Just now',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Post content
            if (post['content'] != null)
              Text(post['content'], style: const TextStyle(fontSize: 14)),

            // Post image
            if (post['imageUrl'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    post['imageUrl'],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 8),

            // Post stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () => _handleLike(post),
                    ),
                    Text('${post['likes'] ?? 0}'),
                    IconButton(
                      icon: const Icon(Icons.comment),
                      onPressed: () => _handleComment(post),
                    ),
                    Text('${post['comments'] ?? 0}'),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () => _handleShare(post),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleLike(Map<String, dynamic> post) {
    // Implement like functionality
    print('Liked post: ${post['id']}');
  }

  void _handleComment(Map<String, dynamic> post) {
    // Implement comment functionality
    print('Comment on post: ${post['id']}');
  }

  void _handleShare(Map<String, dynamic> post) {
    // Implement share functionality
    print('Share post: ${post['id']}');
  }
}
