import 'dart:convert';
import 'package:http/http.dart' as http;

class ContentApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  // Music API endpoints
  static Future<List<dynamic>> getTrendingMusic() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/music/trending'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load trending music');
    } catch (e) {
      throw Exception('Error loading music: $e');
    }
  }

  static Future<List<dynamic>> searchMusic(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/music/search?q=$query'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to search music');
    } catch (e) {
      throw Exception('Error searching music: $e');
    }
  }

  // Movies API endpoints
  static Future<List<dynamic>> getTrendingMovies() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/movies/trending'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load trending movies');
    } catch (e) {
      throw Exception('Error loading movies: $e');
    }
  }

  static Future<List<dynamic>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/movies/search?q=$query'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to search movies');
    } catch (e) {
      throw Exception('Error searching movies: $e');
    }
  }

  // Photography API endpoints
  static Future<List<dynamic>> getTrendingPhotos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/photos/trending'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load trending photos');
    } catch (e) {
      throw Exception('Error loading photos: $e');
    }
  }

  static Future<List<dynamic>> searchPhotos(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/photos/search?q=$query'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to search photos');
    } catch (e) {
      throw Exception('Error searching photos: $e');
    }
  }
}
