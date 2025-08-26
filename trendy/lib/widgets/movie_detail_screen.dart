import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trendy/models/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  String _formatDate(DateTime date) {
    return DateFormat.yMMMMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'movie-${movie.id}',
              child: Image.network(
                movie.imageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: const Icon(Icons.movie, size: 128, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Genres
                  Row(
                    children: [
                      const Icon(Icons.category, size: 16, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        movie.genres.join(', '),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// Release Date
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(movie.releaseDate),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// Runtime + Rating
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${movie.runtime} min',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Description
                  Text(
                    movie.description,
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 16),

                  /// Director
                  Text(
                    'Director: ${movie.director}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),

                  const SizedBox(height: 8),

                  /// Cast
                  Text(
                    'Cast: ${movie.cast.join(', ')}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  const SizedBox(height: 16),

                  /// Likes & Comments
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.favorite, size: 20, color: Colors.red),
                          const SizedBox(width: 4),
                          Text(
                            '${movie.likes}',
                            style: const TextStyle(fontSize: 16, color: Colors.red),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.comment, size: 20, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(
                            '${movie.comments}',
                            style: const TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.visibility, size: 20, color: Colors.green),
                          const SizedBox(width: 4),
                          Text(
                            '${movie.views}',
                            style: const TextStyle(fontSize: 16, color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  /// User Info
                  const Text(
                    'Posted by',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(movie.user.avatarUrl),
                        radius: 20,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.user.displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '@${movie.user.username}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
