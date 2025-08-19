import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  // Get paginated posts
  static Future<Map<String, dynamic>> getPosts({
    String? category,
    int page = 1,
    int size = 10,
  }) async {
    try {
      final params = {
        'page': page.toString(),
        'size': size.toString(),
        if (category != null) 'category': category,
      };

      final uri = Uri.parse(
        '$baseUrl/api/posts',
      ).replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print('Error fetching posts: $e');
      return {'items': [], 'total': 0, 'page': 1, 'size': 10, 'pages': 0};
    }
  }

  // Get post details
  static Future<Map<String, dynamic>> getPostDetail(int postId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/posts/$postId'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load post details');
      }
    } catch (e) {
      print('Error fetching post details: $e');
      return {};
    }
  }

  // Get user posts
  static Future<Map<String, dynamic>> getUserPosts(
    int userId, {
    int page = 1,
    int size = 10,
  }) async {
    try {
      final params = {'page': page.toString(), 'size': size.toString()};

      final uri = Uri.parse(
        '$baseUrl/api/users/$userId/posts',
      ).replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user posts');
      }
    } catch (e) {
      print('Error fetching user posts: $e');
      return {'posts': [], 'total': 0, 'page': 1, 'size': 10};
    }
  }

  // Get trending posts
  static Future<List<dynamic>> getTrendingPosts({int limit = 10}) async {
    try {
      final uri = Uri.parse('$baseUrl/api/trending?limit=$limit');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['posts'] ?? [];
      } else {
        throw Exception('Failed to load trending posts');
      }
    } catch (e) {
      print('Error fetching trending posts: $e');
      return [];
    }
  }

  // Create a new post
  static Future<bool> createPost(Map<String, dynamic> postData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/posts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(postData),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error creating post: $e');
      return false;
    }
  }

  // Add a comment
  static Future<bool> addComment(int postId, String text, int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/posts/$postId/comments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'text': text, 'owner_id': userId}),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error adding comment: $e');
      return false;
    }
  }

  // Follow a user
  static Future<bool> followUser(int followerId, int followedId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/$followedId/follow'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'follower_id': followerId}),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error following user: $e');
      return false;
    }
  }
}
