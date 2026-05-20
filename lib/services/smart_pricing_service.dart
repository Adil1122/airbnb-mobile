import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_config.dart';

class SmartPricingService {
  static Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
  }

  static Future<Map<String, dynamic>?> getPriceSuggestion(
    int propertyId, String checkIn, String checkOut,
  ) async {
    final url = Uri.parse(
      '${ApiConfig.smartPricingUrl}/$propertyId/suggestion?checkIn=$checkIn&checkOut=$checkOut',
    );
    final res = await http.get(url, headers: await _headers());
    if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    return null;
  }

  static Future<Map<String, dynamic>> getCalendarPricing(
    int propertyId, int year, int month,
  ) async {
    final url = Uri.parse(
      '${ApiConfig.smartPricingUrl}/$propertyId/calendar?year=$year&month=$month',
    );
    final res = await http.get(url, headers: await _headers());
    if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    return {};
  }
}
