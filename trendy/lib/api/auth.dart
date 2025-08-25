import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://127.0.0.1:8000"; // Replace with your API base

  // ---------------- Register ----------------
  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/auth/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "username": username,
        "display_name": displayName,
      }),
    );

    return _handleResponse(response);
  }

  // ---------------- Login ----------------
  Future<Map<String, dynamic>> loginUser({
    required String identifier, // can be email or username
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/auth/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "identifier": identifier,
        "password": password,
      }),
    );

    return _handleResponse(response);
  }

  // ---------------- Request Password Reset ----------------
  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    final url = Uri.parse("$baseUrl/api/v1/auth/password/reset");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    return _handleResponse(response);
  }

  // ---------------- Confirm Password Reset ----------------
  Future<Map<String, dynamic>> confirmPasswordReset({
    required String token,
    required String newPassword,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/auth/password/reset/confirm");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": token,
        "new_password": newPassword,
      }),
    );

    return _handleResponse(response);
  }

  // ---------------- Get Current User Profile ----------------
  Future<Map<String, dynamic>> getProfile(String accessToken) async {
    final url = Uri.parse("$baseUrl/api/v1/auth/me");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );

    return _handleResponse(response);
  }

  // ---------------- Refresh Token ----------------
  Future<Map<String, dynamic>> refreshAccessToken(String refreshToken) async {
    final url = Uri.parse("$baseUrl/api/v1/auth/refresh?refresh_token=$refreshToken");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
    );

    return _handleResponse(response);
  }

  // ---------------- Private Response Handler ----------------
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      try {
        return jsonDecode(response.body); // return error details if available
      } catch (_) {
        throw Exception("Request failed: ${response.statusCode}");
      }
    }
  }
}
