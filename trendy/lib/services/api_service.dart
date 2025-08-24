import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000'; // For Android emulator
  static const Duration timeoutDuration = Duration(seconds: 30);

  static Future<String?> _getAuthToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  static Map<String, String> _getHeaders() {
    return {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  static Future<Map<String, String>> _getAuthHeaders() async {
    final headers = _getHeaders();
    final token = await _getAuthToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Movies API
  static Future<Map<String, dynamic>> getMovies({
    int skip = 0,
    int limit = 20,
    String? category,
    String? search,
  }) async {
    try {
      final params = {
        'skip': skip.toString(),
        'limit': limit.toString(),
        if (category != null) 'category': category,
        if (search != null) 'search': search,
      };

      final uri = Uri.parse(
        '$baseUrl/api/movies',
      ).replace(queryParameters: params);
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }

  static Future<Map<String, dynamic>> getTrendingMovies() async {
    try {
      final uri = Uri.parse('$baseUrl/api/movies/trending');
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to load trending movies: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching trending movies: $e');
    }
  }

  // Music API
  static Future<Map<String, dynamic>> getMusic({
    int skip = 0,
    int limit = 20,
    String? genre,
    String? search,
  }) async {
    try {
      final params = {
        'skip': skip.toString(),
        'limit': limit.toString(),
        if (genre != null) 'genre': genre,
        if (search != null) 'search': search,
      };

      final uri = Uri.parse(
        '$baseUrl/api/music',
      ).replace(queryParameters: params);
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load music: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching music: $e');
    }
  }

  static Future<Map<String, dynamic>> getTrendingMusic() async {
    try {
      final uri = Uri.parse('$baseUrl/api/music/trending');
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to load trending music: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching trending music: $e');
    }
  }

  static Future<List<String>> getMusicGenres() async {
    try {
      final uri = Uri.parse('$baseUrl/api/music/genres');
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['genres'] ?? []);
      } else {
        throw Exception('Failed to load music genres: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching music genres: $e');
    }
  }

  // Football API
  static Future<Map<String, dynamic>> getFootballMatches({
    int skip = 0,
    int limit = 20,
    String? league,
    String? status,
  }) async {
    try {
      final params = {
        'skip': skip.toString(),
        'limit': limit.toString(),
        if (league != null) 'league': league,
        if (status != null) 'status': status,
      };

      final uri = Uri.parse(
        '$baseUrl/api/football',
      ).replace(queryParameters: params);
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to load football matches: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching football matches: $e');
    }
  }

  static Future<Map<String, dynamic>> getLiveMatches() async {
    try {
      final uri = Uri.parse('$baseUrl/api/football/live');
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load live matches: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching live matches: $e');
    }
  }

  // Photos API
  static Future<Map<String, dynamic>> getPhotos({
    int skip = 0,
    int limit = 20,
    String? category,
    String? userId,
    String? search,
  }) async {
    try {
      final params = {
        'skip': skip.toString(),
        'limit': limit.toString(),
        if (category != null) 'category': category,
        if (userId != null) 'user_id': userId,
        if (search != null) 'search': search,
      };

      final uri = Uri.parse(
        '$baseUrl/api/photos',
      ).replace(queryParameters: params);
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load photos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching photos: $e');
    }
  }

  static Future<Map<String, dynamic>> getTrendingPhotos() async {
    try {
      final uri = Uri.parse('$baseUrl/api/photos/trending');
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to load trending photos: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching trending photos: $e');
    }
  }

  static Future<List<String>> getPhotoCategories() async {
    try {
      final uri = Uri.parse('$baseUrl/api/photos/categories');
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['categories'] ?? []);
      } else {
        throw Exception(
          'Failed to load photo categories: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching photo categories: $e');
    }
  }

  // Feed API
  static Future<Map<String, dynamic>> getFeed({
    int skip = 0,
    int limit = 20,
    String? type,
  }) async {
    try {
      final params = {
        'skip': skip.toString(),
        'limit': limit.toString(),
        if (type != null) 'type': type,
      };

      final uri = Uri.parse(
        '$baseUrl/api/feed',
      ).replace(queryParameters: params);
      final response = await http
          .get(uri, headers: await _getAuthHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load feed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching feed: $e');
    }
  }

  // User API
  static Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final uri = Uri.parse('$baseUrl/api/users/$userId');
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }

  static Future<Map<String, dynamic>> getUserPosts(
    String userId, {
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final params = {'skip': skip.toString(), 'limit': limit.toString()};

      final uri = Uri.parse(
        '$baseUrl/api/users/$userId/posts',
      ).replace(queryParameters: params);
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user posts: $e');
    }
  }

  // Notifications API
  static Future<List<dynamic>> getNotifications() async {
    try {
      final uri = Uri.parse('$baseUrl/api/notifications');
      final response = await http
          .get(uri, headers: await _getAuthHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['notifications'] ?? [];
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }

  // Like/Unlike API
  static Future<bool> likePost(String postId) async {
    try {
      final uri = Uri.parse('$baseUrl/api/posts/$postId/like');
      final response = await http
          .post(uri, headers: await _getAuthHeaders())
          .timeout(timeoutDuration);

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error liking post: $e');
    }
  }

  static Future<bool> unlikePost(String postId) async {
    try {
      final uri = Uri.parse('$baseUrl/api/posts/$postId/unlike');
      final response = await http
          .delete(uri, headers: await _getAuthHeaders())
          .timeout(timeoutDuration);

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error unliking post: $e');
    }
  }

  // Comments API
  static Future<bool> addComment(String postId, String content) async {
    try {
      final uri = Uri.parse('$baseUrl/api/posts/$postId/comments');
      final response = await http
          .post(
            uri,
            headers: await _getAuthHeaders(),
            body: json.encode({'content': content}),
          )
          .timeout(timeoutDuration);

      return response.statusCode == 201;
    } catch (e) {
      throw Exception('Error adding comment: $e');
    }
  }

  // Search API
  static Future<Map<String, dynamic>> searchContent({
    required String query,
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final params = {
        'q': query,
        'skip': skip.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse(
        '$baseUrl/api/search',
      ).replace(queryParameters: params);
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to search: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching: $e');
    }
  }

  // AI Features API
  static Future<Map<String, dynamic>> translateText({
    required String text,
    required String targetLanguage,
    String sourceLanguage = "auto",
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/ai/translate');
      final response = await http
          .post(
            uri,
            headers: await _getAuthHeaders(),
            body: json.encode({
              'text': text,
              'target_language': targetLanguage,
              'source_language': sourceLanguage,
            }),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to translate text: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error translating text: $e');
    }
  }

  static Future<Map<String, dynamic>> translatePost({
    required String postId,
    required String targetLanguage,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/ai/posts/$postId/translate');
      final response = await http
          .post(
            uri,
            headers: await _getAuthHeaders(),
            body: json.encode({'target_language': targetLanguage}),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to translate post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error translating post: $e');
    }
  }

  static Future<Map<String, dynamic>> analyzeMood(String text) async {
    try {
      final uri = Uri.parse('$baseUrl/api/ai/analyze-mood');
      final response = await http
          .post(
            uri,
            headers: await _getAuthHeaders(),
            body: json.encode({'text': text}),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to analyze mood: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error analyzing mood: $e');
    }
  }

  static Future<Map<String, dynamic>> getMoodBasedFeed({
    String preferredMood = "happy",
    int limit = 20,
  }) async {
    try {
      final params = {
        'preferred_mood': preferredMood,
        'limit': limit.toString(),
      };

      final uri = Uri.parse(
        '$baseUrl/api/ai/feed/mood-based',
      ).replace(queryParameters: params);
      final response = await http
          .get(uri, headers: await _getAuthHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to load mood-based feed: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching mood-based feed: $e');
    }
  }

  static Future<Map<String, dynamic>> suggestEdits(String text) async {
    try {
      final uri = Uri.parse('$baseUrl/api/ai/smart-edit/suggest');
      final response = await http
          .post(
            uri,
            headers: await _getAuthHeaders(),
            body: json.encode({'text': text}),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to suggest edits: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error suggesting edits: $e');
    }
  }

  static Future<Map<String, dynamic>> autoEditText(String text) async {
    try {
      final uri = Uri.parse('$baseUrl/api/ai/smart-edit/auto');
      final response = await http
          .post(
            uri,
            headers: await _getAuthHeaders(),
            body: json.encode({'text': text}),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to auto-edit text: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error auto-editing text: $e');
    }
  }

  static Future<Map<String, dynamic>> autoEditPost(String postId) async {
    try {
      final uri = Uri.parse('$baseUrl/api/ai/posts/$postId/auto-edit');
      final response = await http
          .post(uri, headers: await _getAuthHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to auto-edit post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error auto-editing post: $e');
    }
  }

  static Future<List<String>> getSupportedLanguages() async {
    try {
      final uri = Uri.parse('$baseUrl/api/ai/languages');
      final response = await http
          .get(uri, headers: await _getAuthHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(
          data['languages'].map((lang) => '${lang['code']}:${lang['name']}'),
        );
      } else {
        throw Exception('Failed to load languages: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching languages: $e');
    }
  }

  static Future<List<String>> getSupportedMoods() async {
    try {
      final uri = Uri.parse('$baseUrl/api/ai/moods');
      final response = await http
          .get(uri, headers: await _getAuthHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['moods']);
      } else {
        throw Exception('Failed to load moods: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching moods: $e');
    }
  }

  // Social Auth API
  static Future<bool> registerSocialUser(
    String uid,
    String displayName,
    String email,
    String provider,
    String accessToken,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl/api/auth/social/register');
      final response = await http
          .post(
            uri,
            headers: _getHeaders(),
            body: json.encode({
              'uid': uid,
              'display_name': displayName,
              'email': email,
              'provider': provider,
              'access_token': accessToken,
            }),
          )
          .timeout(timeoutDuration);

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error registering social user: $e');
      return false;
    }
  }
}
