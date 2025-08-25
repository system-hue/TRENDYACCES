import 'dart:convert';
import 'package:http/http.dart' as http;

class DefaultService {
  final String baseUrl = "http://your-backend-url.com"; // Replace with your API base URL

  // ---------------- AGORA ----------------

  Future<String> generateAgoraToken({
    required String channelName,
    required int uid,
    String? bearerToken,
  }) async {
    final url = Uri.parse("$baseUrl/api/v1/agora/token");

    final headers = {
      "Content-Type": "application/json",
      if (bearerToken != null) "Authorization": "Bearer $bearerToken",
    };

    final body = jsonEncode({
      "channel_name": channelName,
      "uid": uid,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      return response.body; // Token is just a string
    } else {
      throw Exception("Agora token request failed: ${response.statusCode} - ${response.body}");
    }
  }

  // ---------------- PHOTOS ----------------

  Future<String> getPhotos({
    int skip = 0,
    int limit = 20,
    String? category,
    String? search,
  }) async {
    final url = Uri.parse("$baseUrl/").replace(queryParameters: {
      "skip": skip.toString(),
      "limit": limit.toString(),
      if (category != null) "category": category,
      if (search != null) "search": search,
    });

    final response = await http.get(url);
    return _handleTextResponse(response);
  }

  Future<List<dynamic>> getTrendingPhotos({int limit = 20, String? category}) async {
    final url = Uri.parse("$baseUrl/trending").replace(queryParameters: {
      "limit": limit.toString(),
      if (category != null) "category": category,
    });

    final response = await http.get(url);
    return _handleListResponse(response);
  }

  Future<List<dynamic>> searchPhotos({
    required String query,
    String? category,
    String? photographer,
    int limit = 20,
  }) async {
    final url = Uri.parse("$baseUrl/search").replace(queryParameters: {
      "q": query,
      "limit": limit.toString(),
      if (category != null) "category": category,
      if (photographer != null) "photographer": photographer,
    });

    final response = await http.get(url);
    return _handleListResponse(response);
  }

  Future<List<String>> getCategories() async {
    final url = Uri.parse("$baseUrl/categories");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    } else {
      throw Exception("Get categories failed: ${response.statusCode} - ${response.body}");
    }
  }

  Future<String> likePhoto(Map<String, dynamic> data) async {
    final url = Uri.parse("$baseUrl/like");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return _handleTextResponse(response);
  }

  Future<List<dynamic>> getFavorites({int limit = 50}) async {
    final url = Uri.parse("$baseUrl/favorites").replace(queryParameters: {
      "limit": limit.toString(),
    });

    final response = await http.get(url);
    return _handleListResponse(response);
  }

  Future<List<dynamic>> getHistory({int limit = 50}) async {
    final url = Uri.parse("$baseUrl/history").replace(queryParameters: {
      "limit": limit.toString(),
    });

    final response = await http.get(url);
    return _handleListResponse(response);
  }

  // ---------------- FOOTBALL ----------------

  Future<String> getTodayMatches({String? league}) async {
    final url = Uri.parse("$baseUrl/matches/today").replace(queryParameters: {
      if (league != null) "league": league,
    });

    final response = await http.get(url);
    return _handleTextResponse(response);
  }

  Future<String> getLiveMatches() async {
    final url = Uri.parse("$baseUrl/live");
    final response = await http.get(url);
    return _handleTextResponse(response);
  }

  Future<List<dynamic>> getTeams({String? league}) async {
    final url = Uri.parse("$baseUrl/teams").replace(queryParameters: {
      if (league != null) "league": league,
    });

    final response = await http.get(url);
    return _handleListResponse(response);
  }

  Future<List<dynamic>> getLeagues() async {
    final url = Uri.parse("$baseUrl/leagues");
    final response = await http.get(url);
    return _handleListResponse(response);
  }

  Future<String> getStandings(String leagueId) async {
    final url = Uri.parse("$baseUrl/standings/$leagueId");
    final response = await http.get(url);
    return _handleTextResponse(response);
  }

  // ---------------- MISC ----------------

  Future<String> getGenres() async {
    final url = Uri.parse("$baseUrl/genres");
    final response = await http.get(url);
    return _handleTextResponse(response);
  }

  Future<String> healthCheck() async {
    final url = Uri.parse("$baseUrl/health");
    final response = await http.get(url);
    return _handleTextResponse(response);
  }

  // ---------------- PRIVATE HELPERS ----------------

  String _handleTextResponse(http.Response response) {
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Request failed: ${response.statusCode} - ${response.body}");
    }
  }

  List<dynamic> _handleListResponse(http.Response response) {
    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body) as List<dynamic>;
      } catch (_) {
        throw Exception("Invalid response format");
      }
    } else {
      throw Exception("Request failed: ${response.statusCode} - ${response.body}");
    }
  }
}
