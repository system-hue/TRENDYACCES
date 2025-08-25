import 'dart:convert';
import 'package:http/http.dart' as http;

class UserRelationshipsService {
  final String baseUrl = "http://your-backend-url.com"; // Replace with your backend API

  // ---------------- Follow User ----------------
  Future<Map<String, dynamic>> followUser({
    required int followingId,
    required String relationshipType, // e.g., "following"
    required bool notificationEnabled,
    required String accessToken, // requires auth
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/users/follow");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        "following_id": followingId,
        "relationship_type": relationshipType,
        "notification_enabled": notificationEnabled,
      }),
    );

    return _handleResponse(response);
  }

  // ---------------- Unfollow User ----------------
  Future<Map<String, dynamic>> unfollowUser({
    required int userId,
    required String accessToken,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/users/unfollow/$userId");

    final response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );

    return _handleResponse(response);
  }

  // ---------------- Block User ----------------
  Future<Map<String, dynamic>> blockUser({
    required int blockedId,
    required String reason,
    required bool isPermanent,
    required String accessToken,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/users/block");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        "blocked_id": blockedId,
        "reason": reason,
        "is_permanent": isPermanent,
      }),
    );

    return _handleResponse(response);
  }

  // ---------------- Mute User ----------------
  Future<Map<String, dynamic>> muteUser({
    required int mutedId,
    required bool muteStories,
    required bool mutePosts,
    required bool muteComments,
    required bool muteMessages,
    required String accessToken,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/users/mute");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        "muted_id": mutedId,
        "mute_stories": muteStories,
        "mute_posts": mutePosts,
        "mute_comments": muteComments,
        "mute_messages": muteMessages,
      }),
    );

    return _handleResponse(response);
  }

  // ---------------- Private Response Handler ----------------
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return {"message": response.body}; // plain string response
      }
    } else {
      try {
        return jsonDecode(response.body); // error details if JSON
      } catch (_) {
        throw Exception("Request failed: ${response.statusCode}");
      }
    }
  }
}
