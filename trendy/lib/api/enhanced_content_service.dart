import 'dart:convert';
import 'package:http/http.dart' as http;

class EnhancedContentService {
  final String baseUrl = "http://your-backend-url.com"; // Replace with actual backend URL

  // ---------------- MUSIC ----------------

  Future<List<dynamic>> getTrendingMusic({
    int limit = 20,
    String? genre,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/content/music/trending")
        .replace(queryParameters: {
      "limit": limit.toString(),
      if (genre != null) "genre": genre,
    });

    final response = await http.get(url);
    return _handleListResponse(response);
  }

  Future<List<dynamic>> searchMusic({
    required String query,
    int limit = 20,
    String? genre,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/content/music/search").replace(
      queryParameters: {
        "query": query,
        "limit": limit.toString(),
        if (genre != null) "genre": genre,
      },
    );

    final response = await http.get(url);
    return _handleListResponse(response);
  }

  Future<Map<String, dynamic>> getMusicById(int musicId) async {
    final url = Uri.parse("$baseUrl/api/v1/content/music/$musicId");
    final response = await http.get(url);
    return _handleResponse(response);
  }

  // ---------------- MOVIES ----------------

  Future<List<dynamic>> getTrendingMovies({
    int limit = 20,
    String? genre,
    int? year,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/content/movies/trending").replace(
      queryParameters: {
        "limit": limit.toString(),
        if (genre != null) "genre": genre,
        if (year != null) "year": year.toString(),
      },
    );

    final response = await http.get(url);
    return _handleListResponse(response);
  }

  Future<List<dynamic>> searchMovies({
    required String query,
    int limit = 20,
    String? genre,
    int? year,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/content/movies/search").replace(
      queryParameters: {
        "query": query,
        "limit": limit.toString(),
        if (genre != null) "genre": genre,
        if (year != null) "year": year.toString(),
      },
    );

    final response = await http.get(url);
    return _handleListResponse(response);
  }

  Future<Map<String, dynamic>> getMovieById(int movieId) async {
    final url = Uri.parse("$baseUrl/api/v1/content/movies/$movieId");
    final response = await http.get(url);
    return _handleResponse(response);
  }

  // ---------------- FOOTBALL ----------------

  Future<List<dynamic>> getFootballMatches({
    int limit = 20,
    String? team,
    String? competition,
    String? status,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/content/football/matches").replace(
      queryParameters: {
        "limit": limit.toString(),
        if (team != null) "team": team,
        if (competition != null) "competition": competition,
        if (status != null) "status": status,
      },
    );

    final response = await http.get(url);
    return _handleListResponse(response);
  }

  Future<List<dynamic>> searchFootballMatches({
    required String query,
    int limit = 20,
  }) async {
    final url =
        Uri.parse("$baseUrl/api/v1/content/football/matches/search").replace(
      queryParameters: {
        "query": query,
        "limit": limit.toString(),
      },
    );

    final response = await http.get(url);
    return _handleListResponse(response);
  }

  Future<Map<String, dynamic>> getFootballMatchById(int matchId) async {
    final url = Uri.parse("$baseUrl/api/v1/content/football/matches/$matchId");
    final response = await http.get(url);
    return _handleResponse(response);
  }

  // ---------------- PRIVATE HELPERS ----------------

  List<dynamic> _handleListResponse(http.Response response) {
    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body) as List<dynamic>;
      } catch (_) {
        throw Exception("Invalid response format");
      }
    } else {
      throw Exception("Request failed: ${response.statusCode} - ${response.body}");
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        throw Exception("Invalid response format");
      }
    } else {
      throw Exception("Request failed: ${response.statusCode} - ${response.body}");
    }
  }
}
