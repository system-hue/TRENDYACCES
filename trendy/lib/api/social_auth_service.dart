import 'dart:convert';
import 'package:http/http.dart' as http;

class SocialAuthService {
  final String baseUrl = "http://your-backend-url.com"; // Replace with your API base

  // ---------------- Google Auth ----------------
  Future<Map<String, dynamic>> authenticateWithGoogle(String token) async {
    final url = Uri.parse("$baseUrl/api/v1/auth/social/google");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": token}),
    );

    return _handleResponse(response);
  }

  // ---------------- Facebook Auth ----------------
  Future<Map<String, dynamic>> authenticateWithFacebook({
    required String code,
    required String redirectUri,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/auth/social/facebook");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "code": code,
        "redirect_uri": redirectUri,
      }),
    );

    return _handleResponse(response);
  }

  // ---------------- Apple Auth ----------------
  Future<Map<String, dynamic>> authenticateWithApple(String token) async {
    final url = Uri.parse("$baseUrl/api/v1/auth/social/apple");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": token}),
    );

    return _handleResponse(response);
  }

  // ---------------- Get Available Providers ----------------
  Future<Map<String, dynamic>> getProviders() async {
    final url = Uri.parse("$baseUrl/api/v1/auth/social/providers");

    final response = await http.get(url);

    return _handleResponse(response);
  }

  // ---------------- Get User's Linked Providers ----------------
  Future<Map<String, dynamic>> getUserProviders(int userId) async {
    final url = Uri.parse("$baseUrl/api/v1/auth/social/user/$userId/providers");

    final response = await http.get(url);

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
        return jsonDecode(response.body); // return error details if available
      } catch (_) {
        throw Exception("Request failed: ${response.statusCode}");
      }
    }
  }
}
