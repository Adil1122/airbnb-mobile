import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_config.dart';

class BookingsService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Map<String, String> _authHeaders(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  /// Guest: fetch my bookings
  Future<List<dynamic>> getMyBookings() async {
    final token = await _getToken();
    if (token == null) return [];
    final res = await http.get(
      Uri.parse(ApiConfig.bookingsUrl),
      headers: _authHeaders(token),
    );
    if (res.statusCode == 200) return jsonDecode(res.body) as List;
    return [];
  }

  /// Host: fetch bookings for my properties
  Future<List<dynamic>> getHostBookings() async {
    final token = await _getToken();
    if (token == null) return [];
    final res = await http.get(
      Uri.parse(ApiConfig.hostBookingsUrl),
      headers: _authHeaders(token),
    );
    if (res.statusCode == 200) return jsonDecode(res.body) as List;
    return [];
  }

  Future<Map<String, dynamic>?> getBooking(int id) async {
    final token = await _getToken();
    if (token == null) return null;
    final res = await http.get(
      Uri.parse(ApiConfig.bookingByIdUrl(id)),
      headers: _authHeaders(token),
    );
    if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    return null;
  }

  Future<Map<String, dynamic>?> createBooking({
    required int propertyId,
    required int hostId,
    required String checkIn,
    required String checkOut,
    required int guests,
    required double propertyPrice,
    required double totalPrice,
    double cleaningFee = 0,
    double serviceFee = 0,
    double taxAmount = 0,
    double discountAmount = 0,
    int numChildren = 0,
    int numInfants = 0,
    int numPets = 0,
    String currency = 'USD',
    String? messageToHost,
    String? stripePaymentIntentId,
    String? promoCode,
    String? cancellationPolicy,
  }) async {
    final token = await _getToken();
    if (token == null) return null;
    final body = {
      'propertyId': propertyId,
      'hostId': hostId,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'guests': guests,
      'numChildren': numChildren,
      'numInfants': numInfants,
      'numPets': numPets,
      'propertyPrice': propertyPrice,
      'cleaningFee': cleaningFee,
      'serviceFee': serviceFee,
      'taxAmount': taxAmount,
      'discountAmount': discountAmount,
      'totalPrice': totalPrice,
      'currency': currency,
      if (messageToHost != null) 'messageToHost': messageToHost,
      if (stripePaymentIntentId != null) 'stripePaymentIntentId': stripePaymentIntentId,
      if (promoCode != null) 'promoCode': promoCode,
      if (cancellationPolicy != null) 'cancellationPolicy': cancellationPolicy,
    };
    final res = await http.post(
      Uri.parse(ApiConfig.bookingsUrl),
      headers: _authHeaders(token),
      body: jsonEncode(body),
    );
    if (res.statusCode == 201) return jsonDecode(res.body) as Map<String, dynamic>;
    
    debugPrint('DEBUG: Booking failed with status ${res.statusCode}');
    debugPrint('DEBUG: Server Error Body: ${res.body}');
    return null;
  }

  Future<bool> cancelBooking(int id, {String? reason}) async {
    final token = await _getToken();
    if (token == null) return false;
    final res = await http.put(
      Uri.parse(ApiConfig.cancelBookingUrl(id)),
      headers: _authHeaders(token),
      body: jsonEncode({if (reason != null) 'reason': reason}),
    );
    return res.statusCode == 200;
  }

  Future<bool> confirmBooking(int id) async {
    final token = await _getToken();
    if (token == null) return false;
    final res = await http.put(
      Uri.parse(ApiConfig.confirmBookingUrl(id)),
      headers: _authHeaders(token),
    );
    return res.statusCode == 200;
  }

  Future<bool> declineBooking(int id) async {
    final token = await _getToken();
    if (token == null) return false;
    final res = await http.put(
      Uri.parse(ApiConfig.declineBookingUrl(id)),
      headers: _authHeaders(token),
    );
    return res.statusCode == 200;
  }

  Future<bool> checkAvailability(int propertyId, String checkIn, String checkOut) async {
    final uri = Uri.parse(ApiConfig.bookingAvailabilityUrl).replace(queryParameters: {
      'propertyId': propertyId.toString(),
      'checkIn': checkIn,
      'checkOut': checkOut,
    });
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return data['available'] as bool? ?? false;
    }
    return false;
  }

  Future<Map<String, dynamic>?> validatePromo({
    required String code,
    required double amount,
    required int nights,
  }) async {
    final token = await _getToken();
    if (token == null) return null;
    final res = await http.post(
      Uri.parse(ApiConfig.validatePromoUrl),
      headers: _authHeaders(token),
      body: jsonEncode({'code': code, 'amount': amount, 'nights': nights}),
    );
    if (res.statusCode == 201) return jsonDecode(res.body) as Map<String, dynamic>;
    return null;
  }

  Future<List<String>> getReservedDates(dynamic propertyId) async {
    final token = await _getToken();
    if (token == null) return [];
    
    // Convert to string for URL if needed
    final id = propertyId.toString();
    
    final res = await http.get(
      Uri.parse(ApiConfig.reservedDatesUrl(int.parse(id))),
      headers: _authHeaders(token),
    );
    
    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((e) => e.toString()).toList();
    }
    return [];
  }
}
