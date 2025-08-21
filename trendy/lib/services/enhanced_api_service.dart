import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trendy/services/api_service.dart';

class EnhancedApiService {
  static const String baseUrl = 'http://10.0.2.2:8000'; // For Android emulator
  static const Duration timeoutDuration = Duration(seconds: 30);

  static Future<String?> _getAuthToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  static Map<String, String> _getHeaders() {
    return {'Content-Type': 'application/json', 'Accept': 'application/json'};
  }

  static Future<Map<String, String>> _getAuthHeaders() async {
    final headers = _getHeaders();
    final token = await _getAuthToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // Weather API
  static Future<Map<String, dynamic>> getWeather(String city) async {
    try {
      final uri = Uri.parse('$baseUrl/api/weather/current/$city');
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }

  static Future<Map<String, dynamic>> getWeatherForecast(String city) async {
    try {
      final uri = Uri.parse('$baseUrl/api/weather/forecast/$city');
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to load weather forecast: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching weather forecast: $e');
    }
  }

  // News API
  static Future<Map<String, dynamic>> getTrendingNews() async {
    try {
      final uri = Uri.parse('$baseUrl/api/news/trending');
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load trending news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching trending news: $e');
    }
  }

  static Future<Map<String, dynamic>> getNewsByCategory(String category) async {
    try {
      final uri = Uri.parse('$baseUrl/api/news/category/$category');
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to load news for $category: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }

  // Crypto API
  static Future<Map<String, dynamic>> getCryptoPrices() async {
    try {
      final uri = Uri.parse('$baseUrl/api/crypto/prices');
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load crypto prices: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching crypto prices: $e');
    }
  }

  static Future<Map<String, dynamic>> getTrendingCrypto() async {
    try {
      final uri = Uri.parse('$baseUrl/api/crypto/trending');
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to load trending crypto: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching trending crypto: $e');
    }
  }

  static Future<Map<String, dynamic>> getCryptoDetails(String coinId) async {
    try {
      final uri = Uri.parse('$baseUrl/api/crypto/details/$coinId');
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Failed to load crypto details: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching crypto details: $e');
    }
  }

  // Jokes API
  static Future<Map<String, dynamic>> getRandomJoke() async {
    try {
      final uri = Uri.parse(
        'https://official-joke-api.appspot.com/random_joke',
      );
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load joke: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching joke: $e');
    }
  }

  // Facts API
  static Future<Map<String, dynamic>> getRandomFact() async {
    try {
      final uri = Uri.parse(
        'https://uselessfacts.jsph.pl/random.json?language=en',
      );
      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load fact: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching fact: $e');
    }
  }

  // Translation API
  static Future<Map<String, dynamic>> translateText(
    String text,
    String targetLang,
  ) async {
    try {
      final uri = Uri.parse('https://api.mymemory.translated.net/get');
      final response = await http
          .get(
            uri.replace(
              queryParameters: {'q': text, 'langpair': 'en|$targetLang'},
            ),
            headers: _getHeaders(),
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to translate text: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error translating text: $e');
    }
  }

  // Added for InboxScreen compatibility
  static Future<List<dynamic>> getMessages() async {
    // Mock messages for demo; integrate backend when auth is ready
    final now = DateTime.now().toIso8601String();
    return [
      {
        'id': 1,
        'sender': 'Alice',
        'avatar': 'https://i.pravatar.cc/100?img=1',
        'content': 'Hey there! How are you?',
        'timestamp': now,
      },
      {
        'id': 2,
        'sender': 'Bob',
        'avatar': 'https://i.pravatar.cc/100?img=2',
        'content': 'Let\'s catch up later.',
        'timestamp': now,
      },
    ];
  }

  static Future<List<dynamic>> getNotifications() async {
    // Use existing API service that hits backend /api/notifications
    try {
      return await ApiService.getNotifications();
    } catch (_) {
      return [];
    }
  }

  static Future<List<dynamic>> getCalls() async {
    final now = DateTime.now().toIso8601String();
    return [
      {
        'id': 1,
        'caller': 'Charlie',
        'type': 'Video',
        'created_at': now,
      },
      {
        'id': 2,
        'caller': 'Dana',
        'type': 'Voice',
        'created_at': now,
      },
    ];
  }
}
