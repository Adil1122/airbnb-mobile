import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_config.dart';

class WishlistService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Map<String, String> _authHeaders(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<List<dynamic>> getWishlists() async {
    final token = await _getToken();
    if (token == null) return [];
    final res = await http.get(
      Uri.parse(ApiConfig.wishlistsUrl),
      headers: _authHeaders(token),
    );
    if (res.statusCode == 200) return jsonDecode(res.body) as List;
    return [];
  }

  Future<Map<String, dynamic>?> createWishlist(String name, {bool isPrivate = true}) async {
    final token = await _getToken();
    if (token == null) return null;
    final res = await http.post(
      Uri.parse(ApiConfig.wishlistsUrl),
      headers: _authHeaders(token),
      body: jsonEncode({'name': name, 'isPrivate': isPrivate}),
    );
    if (res.statusCode == 201) return jsonDecode(res.body) as Map<String, dynamic>;
    return null;
  }

  Future<bool> deleteWishlist(int wishlistId) async {
    final token = await _getToken();
    if (token == null) return false;
    final res = await http.delete(
      Uri.parse(ApiConfig.wishlistByIdUrl(wishlistId)),
      headers: _authHeaders(token),
    );
    return res.statusCode == 200;
  }

  Future<bool> addToWishlist(int wishlistId, int propertyId, {String? note}) async {
    final token = await _getToken();
    if (token == null) return false;
    final res = await http.post(
      Uri.parse(ApiConfig.wishlistItemsUrl(wishlistId)),
      headers: _authHeaders(token),
      body: jsonEncode({'propertyId': propertyId, if (note != null) 'note': note}),
    );
    return res.statusCode == 201;
  }

  Future<bool> removeFromWishlist(int wishlistId, int itemId) async {
    final token = await _getToken();
    if (token == null) return false;
    final res = await http.delete(
      Uri.parse(ApiConfig.wishlistItemUrl(wishlistId, itemId)),
      headers: _authHeaders(token),
    );
    return res.statusCode == 200;
  }

  Future<Map<String, dynamic>> checkPropertySaved(int propertyId) async {
    final token = await _getToken();
    if (token == null) return {'isSaved': false, 'wishlistIds': []};
    final res = await http.get(
      Uri.parse(ApiConfig.wishlistCheckUrl(propertyId)),
      headers: _authHeaders(token),
    );
    if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    return {'isSaved': false, 'wishlistIds': []};
  }
}
