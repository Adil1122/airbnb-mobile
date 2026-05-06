import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_config.dart';

class NotificationsService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Map<String, String> _authHeaders(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<List<dynamic>> getNotifications() async {
    final token = await _getToken();
    if (token == null) return [];
    final res = await http.get(
      Uri.parse(ApiConfig.notificationsUrl),
      headers: _authHeaders(token),
    );
    if (res.statusCode == 200) return jsonDecode(res.body) as List;
    return [];
  }

  Future<int> getUnreadCount() async {
    final token = await _getToken();
    if (token == null) return 0;
    final res = await http.get(
      Uri.parse(ApiConfig.notificationUnreadCountUrl),
      headers: _authHeaders(token),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return data['count'] as int? ?? 0;
    }
    return 0;
  }

  Future<void> markRead(int notificationId) async {
    final token = await _getToken();
    if (token == null) return;
    await http.put(
      Uri.parse(ApiConfig.markNotificationReadUrl(notificationId)),
      headers: _authHeaders(token),
    );
  }

  Future<void> markAllRead() async {
    final token = await _getToken();
    if (token == null) return;
    await http.post(
      Uri.parse(ApiConfig.markAllNotificationsReadUrl),
      headers: _authHeaders(token),
    );
  }

  Future<Map<String, dynamic>> getPreferences() async {
    final token = await _getToken();
    if (token == null) return {};
    final res = await http.get(
      Uri.parse(ApiConfig.notificationPreferencesUrl),
      headers: _authHeaders(token),
    );
    if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    return {};
  }

  Future<bool> updatePreferences(Map<String, bool> prefs) async {
    final token = await _getToken();
    if (token == null) return false;
    final res = await http.put(
      Uri.parse(ApiConfig.notificationPreferencesUrl),
      headers: _authHeaders(token),
      body: jsonEncode(prefs),
    );
    return res.statusCode == 200;
  }
}
