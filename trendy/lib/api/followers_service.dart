import 'dart:convert';
import 'package:http/http.dart' as http;

class FollowersService {
  final String baseUrl = "http://your-backend-url.com"; // Replace with actual backend

  // ---------------- Get Followers ----------------
  Future<Map<String, dynamic>> getFollowers({
    required int userId,
    required String accessToken,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/users/$userId/followers");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $accessToken"},
    );

    return _handleResponse(response);
  }

  // ---------------- Get Following ----------------
  Future<Map<String, dynamic>> getFollowing({
    required int userId,
    required String accessToken,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/users/$userId/following");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $accessToken"},
    );

    return _handleResponse(response);
  }

  // ---------------- Follow User ----------------
  Future<Map<String, dynamic>> followUser({
    required int userId,
    required String accessToken,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/users/$userId/follow");

    final response = await http.post(
      url,
      headers: {"Authorization": "Bearer $accessToken"},
    );

    return _handleResponse(response);
  }

  // ---------------- Unfollow User ----------------
  Future<Map<String, dynamic>> unfollowUser({
    required int userId,
    required String accessToken,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/users/$userId/unfollow");

    final response = await http.delete(
      url,
      headers: {"Authorization": "Bearer $accessToken"},
    );

    return _handleResponse(response);
  }

  // ---------------- Is Following ----------------
  Future<Map<String, dynamic>> isFollowing({
    required int userId,
    required int targetUserId,
    required String accessToken,
  }) async {
    final url =
        Uri.parse("$baseUrl/api/v1/users/$userId/is_following/$targetUserId");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $accessToken"},
    );

    return _handleResponse(response);
  }

  // ---------------- Get User Stats ----------------
  Future<Map<String, dynamic>> getUserStats({
    required int userId,
    required String accessToken,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/users/$userId/stats");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $accessToken"},
    );

    return _handleResponse(response);
  }

  // ---------------- Search Users ----------------
  Future<Map<String, dynamic>> searchUsers({
    required String query,
    required String accessToken,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/users/search?query=$query");

    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $accessToken"},
    );

    return _handleResponse(response);
  }

  // ---------------- Private Response Handler ----------------
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return {"message": response.body};
      }
    } else {
      try {
        return jsonDecode(response.body);
      } catch (_) {
        throw Exception("Request failed: ${response.statusCode}");
      }
    }
  }
}
