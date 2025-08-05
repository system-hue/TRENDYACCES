import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://your-backend-url.com/api';
  
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<Map<String, dynamic>> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts'),
        headers: _headers,
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data as Map<String, dynamic>;
      } else {
        throw ApiException(
          'Failed to load posts: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on TimeoutException {
      throw ApiException('Request timeout', 408);
    } on FormatException {
      throw ApiException('Invalid response format', 400);
    } catch (e) {
      throw ApiException('Network error: $e', 500);
    }
  }

  static Future<Map<String, dynamic>> createPost(Map<String, dynamic> postData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: _headers,
        body: json.encode(postData),
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 201) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw ApiException(
          'Failed to create post: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException('Error creating post: $e', 500);
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
