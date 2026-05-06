import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_config.dart';

class MessagesService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Map<String, String> _authHeaders(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<List<dynamic>> getConversations() async {
    final token = await _getToken();
    if (token == null) return [];
    final res = await http.get(
      Uri.parse(ApiConfig.conversationsUrl),
      headers: _authHeaders(token),
    );
    if (res.statusCode == 200) return jsonDecode(res.body) as List;
    return [];
  }

  Future<List<dynamic>> getMessages(int conversationId) async {
    final token = await _getToken();
    if (token == null) return [];
    final res = await http.get(
      Uri.parse(ApiConfig.conversationUrl(conversationId)),
      headers: _authHeaders(token),
    );
    if (res.statusCode == 200) return jsonDecode(res.body) as List;
    return [];
  }

  Future<Map<String, dynamic>?> startConversation({
    required int listingId,
    required int hostId,
    required String initialMessage,
    int? bookingId,
  }) async {
    final token = await _getToken();
    if (token == null) return null;
    final body = {
      'listingId': listingId,
      'hostId': hostId,
      'initialMessage': initialMessage,
      if (bookingId != null) 'bookingId': bookingId,
    };
    final res = await http.post(
      Uri.parse(ApiConfig.conversationsUrl),
      headers: _authHeaders(token),
      body: jsonEncode(body),
    );
    if (res.statusCode == 201) return jsonDecode(res.body) as Map<String, dynamic>;
    return null;
  }

  Future<Map<String, dynamic>?> sendMessage(int conversationId, String body) async {
    final token = await _getToken();
    if (token == null) return null;
    final res = await http.post(
      Uri.parse(ApiConfig.sendMessageUrl(conversationId)),
      headers: _authHeaders(token),
      body: jsonEncode({'body': body}),
    );
    if (res.statusCode == 201) return jsonDecode(res.body) as Map<String, dynamic>;
    return null;
  }

  Future<void> markRead(int conversationId) async {
    final token = await _getToken();
    if (token == null) return;
    await http.post(
      Uri.parse(ApiConfig.markReadUrl(conversationId)),
      headers: _authHeaders(token),
    );
  }

  Future<int> getUnreadCount() async {
    final token = await _getToken();
    if (token == null) return 0;
    final res = await http.get(
      Uri.parse(ApiConfig.unreadMessagesCountUrl),
      headers: _authHeaders(token),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data is int ? data : 0;
    }
    return 0;
  }
}
