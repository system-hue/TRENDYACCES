import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocationService {
  static const String _cacheKey = 'cached_location';
  static const String _cacheTimeKey = 'location_cache_time';
  static const Duration _cacheDuration = Duration(hours: 24);

  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  static Future<Position?> getCurrentLocation({
    LocationAccuracy accuracy = LocationAccuracy.medium,
  }) async {
    try {
      final permission = await checkPermission();

      if (permission == LocationPermission.denied) {
        final newPermission = await requestPermission();
        if (newPermission == LocationPermission.denied ||
            newPermission == LocationPermission.deniedForever) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      if (!await isLocationServiceEnabled()) {
        return null;
      }

      return await Geolocator.getCurrentPosition(desiredAccuracy: accuracy);
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  static Future<String?> getCountryFromLocation(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        return placemarks.first.isoCountryCode;
      }
      return null;
    } catch (e) {
      print('Error getting country from location: $e');
      return null;
    }
  }

  static Future<String?> getCountryFromIP() async {
    // Fallback to IP-based geolocation
    try {
      // This would typically use a service like ipapi.co or similar
      // For now, returning a default based on system locale
      return 'US'; // Default fallback
    } catch (e) {
      return 'US';
    }
  }

  static Future<String> getUserCountry({bool usePreciseLocation = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cacheKey);
    final cachedTime = prefs.getInt(_cacheTimeKey);

    // Check if we have valid cached data
    if (cachedData != null && cachedTime != null) {
      final cacheDate = DateTime.fromMillisecondsSinceEpoch(cachedTime);
      if (DateTime.now().difference(cacheDate) < _cacheDuration) {
        final cached = json.decode(cachedData);
        return cached['country'] ?? 'US';
      }
    }

    String country = 'US';

    if (usePreciseLocation) {
      final position = await getCurrentLocation();
      if (position != null) {
        final countryFromLocation = await getCountryFromLocation(position);
        country = countryFromLocation ?? await getCountryFromIP();
      } else {
        country = await getCountryFromIP();
      }
    } else {
      country = await getCountryFromIP();
    }

    // Cache the result
    await prefs.setString(_cacheKey, json.encode({'country': country}));
    await prefs.setInt(_cacheTimeKey, DateTime.now().millisecondsSinceEpoch);

    return country;
  }

  static Future<void> clearLocationCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_cacheTimeKey);
  }

  static Future<String> getTimezone() async {
    return DateTime.now().timeZoneName;
  }

  static Future<String> getTimezoneOffset() async {
    final offset = DateTime.now().timeZoneOffset;
    final hours = offset.inHours;
    final minutes = offset.inMinutes.remainder(60);
    return '${hours >= 0 ? '+' : ''}$hours:${minutes.toString().padLeft(2, '0')}';
  }
}

enum LocationMode { precise, approximate, off }

class LocationSettings {
  static const String _modeKey = 'location_mode';
  static const String _consentKey = 'location_consent';

  static Future<void> setLocationMode(LocationMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modeKey, mode.toString());
  }

  static Future<LocationMode> getLocationMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeString = prefs.getString(_modeKey);

    if (modeString == null) return LocationMode.approximate;

    try {
      return LocationMode.values.firstWhere((e) => e.toString() == modeString);
    } catch (e) {
      return LocationMode.approximate;
    }
  }

  static Future<void> setLocationConsent(bool consent) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentKey, consent);
  }

  static Future<bool> getLocationConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_consentKey) ?? false;
  }
}
