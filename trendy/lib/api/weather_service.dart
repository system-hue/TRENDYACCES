// lib/services/weather_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String baseUrl;

  WeatherService({required this.baseUrl});

  /// Get current weather for a city
  Future<dynamic> getCurrentWeather(String city) async {
    final uri = Uri.parse('$baseUrl/api/weather/current/$city');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to get current weather: ${response.statusCode} ${response.body}',
      );
    }
  }

  /// Get 5-day weather forecast for a city
  Future<dynamic> getForecast(String city) async {
    final uri = Uri.parse('$baseUrl/api/weather/forecast/$city');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to get forecast: ${response.statusCode} ${response.body}',
      );
    }
  }
}
