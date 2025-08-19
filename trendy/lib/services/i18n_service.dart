import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class I18nService extends ChangeNotifier {
  static const String _storageKey = 'selected_language';
  static const String _regionKey = 'user_region';

  Locale _locale = const Locale('en');
  Map<String, String> _localizedStrings = {};
  String _currentRegion = 'US';
  String _currentCurrency = 'USD';

  Locale get locale => _locale;
  String get currentRegion => _currentRegion;
  String get currentCurrency => _currentCurrency;

  // Supported languages with RTL support
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'sw': 'Swahili',
    'fr': 'Français',
    'es': 'Español',
    'pt': 'Português',
    'ar': 'العربية',
    'hi': 'हिंदी',
    'id': 'Bahasa Indonesia',
    'zh': '中文',
  };

  static const List<String> rtlLanguages = ['ar'];

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_storageKey) ?? 'en';
    final savedRegion = prefs.getString(_regionKey) ?? 'US';

    await setLocale(Locale(savedLanguage));
    _currentRegion = savedRegion;
    _updateCurrencyAndFormats();
  }

  Future<void> setLocale(Locale newLocale) async {
    _locale = newLocale;
    await _loadLocalizedStrings();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, newLocale.languageCode);

    notifyListeners();
  }

  Future<void> setRegion(String region) async {
    _currentRegion = region;
    _updateCurrencyAndFormats();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_regionKey, region);

    notifyListeners();
  }

  void _updateCurrencyAndFormats() {
    // Map regions to currencies
    final currencyMap = {
      'US': 'USD',
      'KE': 'KES',
      'TZ': 'TZS',
      'UG': 'UGX',
      'NG': 'NGN',
      'ZA': 'ZAR',
      'GB': 'GBP',
      'EU': 'EUR',
      'IN': 'INR',
      'ID': 'IDR',
      'CN': 'CNY',
      'BR': 'BRL',
      'MX': 'MXN',
    };

    _currentCurrency = currencyMap[_currentRegion] ?? 'USD';
  }

  Future<void> _loadLocalizedStrings() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/i18n/${_locale.languageCode}.json',
      );
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      _localizedStrings = jsonMap.map(
        (key, value) => MapEntry(key, value.toString()),
      );
    } catch (e) {
      // Fallback to English if file not found
      final jsonString = await rootBundle.loadString('assets/i18n/en.json');
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      _localizedStrings = jsonMap.map(
        (key, value) => MapEntry(key, value.toString()),
      );
    }
  }

  String translate(String key, [Map<String, String>? args]) {
    String text = _localizedStrings[key] ?? key;

    if (args != null) {
      args.forEach((key, value) {
        text = text.replaceAll('{$key}', value);
      });
    }

    return text;
  }

  String formatCurrency(double amount) {
    final format = NumberFormat.currency(
      symbol: _getCurrencySymbol(),
      decimalDigits: 2,
    );
    return format.format(amount);
  }

  String formatDate(DateTime date) {
    return DateFormat.yMMMMd(_locale.languageCode).format(date);
  }

  String formatTime(DateTime time) {
    return DateFormat.jm(_locale.languageCode).format(time);
  }

  String _getCurrencySymbol() {
    final symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'KES': 'KSh',
      'TZS': 'TSh',
      'UGX': 'USh',
      'NGN': '₦',
      'ZAR': 'R',
      'INR': '₹',
      'IDR': 'Rp',
      'CNY': '¥',
      'BRL': 'R\$',
      'MXN': '\$',
    };
    return symbols[_currentCurrency] ?? '\$';
  }

  bool isRtl() {
    return rtlLanguages.contains(_locale.languageCode);
  }

  TextDirection get textDirection {
    return isRtl() ? TextDirection.rtl : TextDirection.ltr;
  }
}
