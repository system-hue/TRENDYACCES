class Movie {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String backdropPath;
  final DateTime releaseDate;
  final double voteAverage;
  final List<String> genres;
  final int runtime;
  final String director;
  final List<String> cast;
  final DateTime createdAt;
  final int likes;
  final int views;
  final int comments; // ✅ Added
  final MovieUser user; // ✅ Added

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.genres,
    required this.runtime,
    required this.director,
    required this.cast,
    required this.createdAt,
    required this.likes,
    required this.views,
    required this.comments,
    required this.user,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      releaseDate: DateTime.tryParse(json['release_date'] ?? '') ?? DateTime.now(),
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      genres: List<String>.from(json['genres'] ?? []),
      runtime: json['runtime'] ?? 0,
      director: json['director'] ?? '',
      cast: List<String>.from(json['cast'] ?? []),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      likes: json['likes'] ?? 0,
      views: json['views'] ?? 0,
      comments: json['comments'] ?? 0, // ✅ Safe parse
      user: MovieUser.fromJson(json['user'] ?? {}), // ✅ Nested parsing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'backdrop_path': backdropPath,
      'release_date': releaseDate.toIso8601String(),
      'vote_average': voteAverage,
      'genres': genres,
      'runtime': runtime,
      'director': director,
      'cast': cast,
      'created_at': createdAt.toIso8601String(),
      'likes': likes,
      'views': views,
      'comments': comments,
      'user': user.toJson(),
    };
  }
}

class MovieUser {
  final String id;
  final String username;
  final String displayName;
  final String avatarUrl;

  MovieUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatarUrl,
  });

  factory MovieUser.fromJson(Map<String, dynamic> json) {
    return MovieUser(
      id: json['id'] ?? '',
      username: json['username'] ?? 'Unknown',
      displayName: json['display_name'] ?? 'Anonymous',
      avatarUrl: json['avatar_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'display_name': displayName,
      'avatar_url': avatarUrl,
    };
  }
}
