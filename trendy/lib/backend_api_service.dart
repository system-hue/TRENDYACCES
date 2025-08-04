import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class BackendApiService {
  static const String _baseUrl =
      'http://localhost:8000'; // Change this to your backend URL
  static const String _apiPrefix = '/api';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the current user's ID token for authentication with backend
  Future<String?> _getToken() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        final idToken = await user.getIdToken();
        return idToken;
      } catch (e) {
        print('Error getting ID token: $e');
        return null;
      }
    }
    return null;
  }

  // Create authorization header with Firebase ID token
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _getToken();
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Posts endpoints
  Future<List<dynamic>> getPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_apiPrefix/posts'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching posts: $e');
      rethrow;
    }
  }

  Future<dynamic> createPost(Map<String, dynamic> postData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_apiPrefix/posts'),
        headers: await _getAuthHeaders(),
        body: json.encode(postData),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating post: $e');
      rethrow;
    }
  }

  Future<dynamic> getPost(int postId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_apiPrefix/posts/$postId'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load post: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching post: $e');
      rethrow;
    }
  }

  // Followers endpoints
  Future<List<dynamic>> getFollowers() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_apiPrefix/followers'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load followers: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching followers: $e');
      rethrow;
    }
  }

  Future<dynamic> followUser(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_apiPrefix/followers/$userId'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to follow user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error following user: $e');
      rethrow;
    }
  }

  Future<dynamic> unfollowUser(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$_apiPrefix/followers/$userId'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to unfollow user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error unfollowing user: $e');
      rethrow;
    }
  }

  // Notifications endpoints
  Future<List<dynamic>> getNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_apiPrefix/notifications'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      rethrow;
    }
  }

  // User endpoints
  Future<dynamic> getCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_apiPrefix/users/me'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;
    }
  }

  // AI Moderation endpoints
  Future<dynamic> moderateContent(Map<String, dynamic> contentData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_apiPrefix/ai-moderation/moderate'),
        headers: await _getAuthHeaders(),
        body: json.encode(contentData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to moderate content: ${response.statusCode}');
      }
    } catch (e) {
      print('Error moderating content: $e');
      rethrow;
    }
  }
}
