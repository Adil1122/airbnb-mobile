import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/user_settings_model.dart';
import 'auth_service.dart';

class UserSettingsService {
  static String get baseUrl {
    // Stripping /auth from AuthService.baseUrl and adding /user-settings
    final base = AuthService.baseUrl.replaceAll('/auth', '');
    return '$base/user-settings';
  }

  final AuthService _authService = AuthService();

  Future<UserSettingsModel?> getSettings() async {
    try {
      final token = await _authService.getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return UserSettingsModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Error fetching user settings: $e');
    }
    return null;
  }

  Future<UserSettingsModel?> updateSettings(Map<String, dynamic> settingsData) async {
    try {
      final token = await _authService.getToken();
      if (token == null) return null;

      final response = await http.put(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(settingsData),
      );

      if (response.statusCode == 200) {
        return UserSettingsModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Error updating user settings: $e');
    }
    return null;
  }
}
