import 'dart:convert';
import 'package:http/http.dart' as http;

class EnhancedApiService {
  static const String baseUrl = 'http://localhost:8000/api/v1';

  static Future<List<dynamic>> getTrendingPosts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/feed/trending'));
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> getTrendingTopics() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trending/topics'));
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> getTrendingUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/trending/users'));
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> getMessages() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/dm/messages'));
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> getNotifications() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/notifications'));
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> getCalls() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/calls'));
      if (response.statusCode == 200) {
        return json.decode(response.body)['data'];
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
