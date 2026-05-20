import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_config.dart';

class RecentlyViewedService {
  static Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
  }

  static Future<List<dynamic>> getRecentlyViewed() async {
    final response = await http.get(
      Uri.parse(ApiConfig.recentlyViewedUrl),
      headers: await _headers(),
    );
    if (response.statusCode == 200) return jsonDecode(response.body) as List;
    return [];
  }

  static Future<void> track(int propertyId) async {
    await http.post(
      Uri.parse(ApiConfig.recentlyViewedUrl),
      headers: await _headers(),
      body: jsonEncode({'propertyId': propertyId}),
    );
  }

  static Future<void> clear() async {
    await http.delete(
      Uri.parse(ApiConfig.recentlyViewedUrl),
      headers: await _headers(),
    );
  }
}
