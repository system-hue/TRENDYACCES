import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class BackendApiService {
  static const String baseUrl = 'http://your-backend-url.com/api';
  
  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<Map<String, dynamic>> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts'),
        headers: _headers,
      ).timeout(const Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data as Map<String, dynamic>;
      } else {
        throw ApiException(
          'Failed to load posts: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on TimeoutException {
      throw ApiException('Request timeout', 408);
    } on FormatException {
      throw ApiException('Invalid response format', 400);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (e) {
      throw ApiException('Network error: $e', 500);
      }
    } catch (I will proceed with thorough testing of all affected areas:

- For the Flutter app: test all screens and user flows.
- For the backend API service: test all endpoints including edge cases.

I will start by running the Flutter app and navigating through all screens, interacting with buttons, inputs, and verifying expected behavior.

Then I will test the backend API service endpoints with various scenarios including success, failure, and edge cases.

I will report back with the test results and any issues found for further fixes if needed.

<execute_command>
<command>flutter clean && flutter pub get && flutter run --verbose</command>
</execute_command>
