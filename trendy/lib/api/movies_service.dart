// lib/services/movies_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class MoviesService {
  final String baseUrl;

  MoviesService({required this.baseUrl});

  /// Get Movies with pagination and optional filters
  Future<dynamic> getMovies({
    int skip = 0,
    int limit = 20,
    String? category,
    String? search,
  }) async {
    final uri = Uri.parse('$baseUrl/api/movies/').replace(
      queryParameters: {
        'skip': '$skip',
        'limit': '$limit',
        if (category != null) 'category': category,
        if (search != null) 'search': search,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to get movies: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// Get trending movies
  Future<dynamic> getTrendingMovies() async {
    final uri = Uri.parse('$baseUrl/api/movies/trending');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to get trending movies: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// Get detailed movie information
  Future<dynamic> getMovieDetail(String movieId) async {
    final uri = Uri.parse('$baseUrl/api/movies/$movieId');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to get movie detail: ${response.statusCode} ${response.body}',
      );
    }
  }
}
