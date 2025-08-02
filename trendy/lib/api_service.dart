import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trendy/models/movie.dart';
import 'package:trendy/models/song.dart';

class ApiService {
  static const String _tmdbApiKey = '69add442c1c44d6f0241bad06c470adc';
  static const String _tmdbBaseUrl = 'https://api.themoviedb.org/3';

  static const String _spotifyClientId = 'ed5d3de21324406ebfa16dcea958d35a';
  static const String _spotifyClientSecret = '31bec2e94ce940cbb8e61ba2c8960fb5';
  static const String _spotifyBaseUrl = 'https://api.spotify.com/v1';

  Future<String> _getSpotifyAccessToken() async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$_spotifyClientId:$_spotifyClientSecret'))}',
      },
      body: {
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      return decoded['access_token'];
    } else {
      throw Exception('Failed to get access token');
    }
  }

  Future<List<Song>> getNewReleases() async {
    final accessToken = await _getSpotifyAccessToken();
    final response = await http.get(
      Uri.parse('$_spotifyBaseUrl/browse/new-releases'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> items = decoded['albums']['items'];
      return items.map((item) => Song.fromSpotify(item)).toList();
    } else {
      throw Exception('Failed to load new releases');
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(Uri.parse('$_tmdbBaseUrl/movie/popular?api_key=$_tmdbApiKey'));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final List<dynamic> results = decoded['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
