import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_config.dart';

class ConnectionsService {
  static Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
  }

  static Future<List<dynamic>> getConnections() async {
    final res = await http.get(Uri.parse(ApiConfig.connectionsUrl), headers: await _headers());
    if (res.statusCode == 200) return jsonDecode(res.body) as List;
    return [];
  }

  static Future<List<dynamic>> getPendingRequests() async {
    final res = await http.get(Uri.parse('${ApiConfig.connectionsUrl}/pending'), headers: await _headers());
    if (res.statusCode == 200) return jsonDecode(res.body) as List;
    return [];
  }

  static Future<bool> sendRequest(int receiverId) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.connectionsUrl}/request'),
      headers: await _headers(),
      body: jsonEncode({'receiverId': receiverId}),
    );
    return res.statusCode == 201;
  }

  static Future<bool> respond(int connectionId, bool accept) async {
    final res = await http.post(
      Uri.parse('${ApiConfig.connectionsUrl}/$connectionId/respond'),
      headers: await _headers(),
      body: jsonEncode({'accept': accept}),
    );
    return res.statusCode == 200;
  }

  static Future<bool> remove(int connectionId) async {
    final res = await http.delete(
      Uri.parse('${ApiConfig.connectionsUrl}/$connectionId'),
      headers: await _headers(),
    );
    return res.statusCode == 200;
  }
}
