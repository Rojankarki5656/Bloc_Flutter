// lib/core/services/shared_preferences_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service for managing shared preferences
class SharedPreferencesService {
  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  // ============================================================================
  // String Methods
  // ============================================================================

  Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  // ============================================================================
  // Boolean Methods
  // ============================================================================

  Future<bool> saveBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // ============================================================================
  // Integer Methods
  // ============================================================================

  Future<bool> saveInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // ============================================================================
  // Double Methods
  // ============================================================================

  Future<bool> saveDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // ============================================================================
  // List Methods
  // ============================================================================

  Future<bool> saveStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // ============================================================================
  // JSON Methods
  // ============================================================================

  Future<bool> saveJson(String key, Map<String, dynamic> value) async {
    return await _prefs.setString(key, jsonEncode(value));
  }

  Map<String, dynamic>? getJson(String key) {
    final String? jsonString = _prefs.getString(key);
    if (jsonString != null) {
      try {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<bool> saveJsonList(String key, List<Map<String, dynamic>> value) async {
    return await _prefs.setString(key, jsonEncode(value));
  }

  List<Map<String, dynamic>>? getJsonList(String key) {
    final String? jsonString = _prefs.getString(key);
    if (jsonString != null) {
      try {
        final List<dynamic> list = jsonDecode(jsonString);
        return list.map((e) => e as Map<String, dynamic>).toList();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // ============================================================================
  // Auth Methods
  // ============================================================================

  Future<bool> saveToken(String token) async {
    return await saveString('auth_token', token);
  }

  String? getToken() {
    return getString('auth_token');
  }

  Future<bool> saveUser(Map<String, dynamic> user) async {
    return await saveJson('user_data', user);
  }

  Map<String, dynamic>? getUser() {
    return getJson('user_data');
  }

  Future<bool> saveRememberMe(bool value) async {
    return await saveBool('remember_me', value);
  }

  bool? getRememberMe() {
    return getBool('remember_me');
  }

  // ============================================================================
  // App Preferences
  // ============================================================================

  Future<bool> saveThemeMode(String themeMode) async {
    return await saveString('theme_mode', themeMode);
  }

  String? getThemeMode() {
    return getString('theme_mode');
  }

  Future<bool> saveLanguage(String language) async {
    return await saveString('language', language);
  }

  String? getLanguage() {
    return getString('language');
  }

  Future<bool> savePreferredLanguage(String lang) async {
    return await saveString('preferred_language', lang);
  }

  String? getPreferredLanguage() {
    return getString('preferred_language');
  }

  // ============================================================================
  // Continue Watching
  // ============================================================================

  Future<bool> saveContinueWatching(List<Map<String, dynamic>> data) async {
    return await saveJsonList('continue_watching', data);
  }

  List<Map<String, dynamic>>? getContinueWatching() {
    return getJsonList('continue_watching');
  }

  // ============================================================================
  // Utility Methods
  // ============================================================================

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs.clear();
  }

  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }
}