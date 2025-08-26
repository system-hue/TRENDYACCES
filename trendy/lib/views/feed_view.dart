import 'package:flutter/material.dart';
import 'package:trendy/data/dummy_data.dart';
import 'package:trendy/models/movie.dart';
import 'package:trendy/models/song.dart';
import 'package:trendy/models/match.dart';

class FeedView extends StatelessWidget {
  final List<Post> posts;

  const FeedView({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        if (post.type == PostType.song) {
          final song = post.item as Song;
          return ListTile(
            title: Text(song.title),
            subtitle: Text(song.artist),
            leading: song.imageUrl.isNotEmpty
                ? Image.network(song.imageUrl)
                : null,
          );
        } else if (post.type == PostType.movie) {
          final movie = post.item as Movie;
          return ListTile(
            title: Text(movie.title),
            subtitle: Text(movie.releaseDate as String),
            leading: movie.imageUrl != null
                ? Image.network('https://image.tmdb.org/t/p/w200${movie.imageUrl}')
                : null,
          );
        } else if (post.type == PostType.match) {
          final match = post.item as Match;
          return ListTile(
            title: Text('${match.homeTeam.name} vs ${match.awayTeam.name}'),
            subtitle: Text('${match.homeScore} - ${match.awayScore}'),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
