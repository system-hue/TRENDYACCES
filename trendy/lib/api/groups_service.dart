// lib/services/groups_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class GroupsService {
  final String baseUrl;

  GroupsService({required this.baseUrl});

  /// Create a new group
  Future<dynamic> createGroup(Map<String, dynamic> payload) async {
    final uri = Uri.parse('$baseUrl/groups/');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to create group: ${response.body}");
    }
  }

  /// Get groups (user's groups or public groups)
  Future<List<dynamic>> getGroups({int skip = 0, int limit = 20}) async {
    final uri = Uri.parse('$baseUrl/groups/?skip=$skip&limit=$limit');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch groups: ${response.body}");
    }
  }

  /// Get a specific group
  Future<dynamic> getGroup(int groupId) async {
    final uri = Uri.parse('$baseUrl/groups/$groupId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch group: ${response.body}");
    }
  }

  /// Update a group (owners only)
  Future<dynamic> updateGroup(int groupId, Map<String, dynamic> payload) async {
    final uri = Uri.parse('$baseUrl/groups/$groupId');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to update group: ${response.body}");
    }
  }

  /// Delete a group (owners only)
  Future<String> deleteGroup(int groupId) async {
    final uri = Uri.parse('$baseUrl/groups/$groupId');
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to delete group: ${response.body}");
    }
  }

  /// Join a group
  Future<dynamic> joinGroup(int groupId) async {
    final uri = Uri.parse('$baseUrl/groups/$groupId/members');
    final response = await http.post(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to join group: ${response.body}");
    }
  }

  /// Leave a group
  Future<String> leaveGroup(int groupId) async {
    final uri = Uri.parse('$baseUrl/groups/$groupId/members');
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to leave group: ${response.body}");
    }
  }

  /// Get members of a group
  Future<List<dynamic>> getGroupMembers(int groupId, {int skip = 0, int limit = 50}) async {
    final uri = Uri.parse('$baseUrl/groups/$groupId/members?skip=$skip&limit=$limit');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch group members: ${response.body}");
    }
  }
}
