import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_config.dart';
import '../services/auth_service.dart';
import '../models/booking_model.dart';
import '../models/payment_method_model.dart';

class PaymentService {
  final String _baseUrl = '${ApiConfig.baseUrl}/payment';
  final _authService = AuthService();

  Future<bool> cancelBooking(int bookingId) async {
    final token = await _authService.getToken();
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/bookings/cancel/$bookingId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('DEBUG: Error in cancelBooking: $e');
      return false;
    }
  }

  Future<Booking?> confirmBooking({
    required String paymentIntentId,
    required int propertyId,
    required String checkIn,
    required String checkOut,
    required int guests,
    required double totalPrice,
    required double serviceFee,
    required double cleaningFee,
    required double propertyPrice,
    required int nights,
    String? messageToHost,
  }) async {
    final token = await _authService.getToken();
    if (token == null) return null;

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/bookings/confirm'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'paymentIntentId': paymentIntentId,
          'propertyId': propertyId,
          'checkIn': checkIn,
          'checkOut': checkOut,
          'guests': guests,
          'totalPrice': totalPrice,
          'serviceFee': serviceFee,
          'cleaningFee': cleaningFee,
          'propertyPrice': propertyPrice,
          'nights': nights,
          'messageToHost': messageToHost,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Booking.fromJson(data['booking'] ?? data);
      }
      return null;
    } catch (e) {
      print('DEBUG: Error in confirmBooking: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent({
    required double amount,
    double? serviceFee,
    int? propertyId,
    int? hostId,
    String? checkIn,
    String? checkOut,
    int? guests,
    String currency = 'usd',
  }) async {
    final token = await _authService.getToken();
    if (token == null) return null;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/create-intent'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'amount': amount,
          'serviceFee': serviceFee ?? (amount * 0.1),
          'propertyId': propertyId,
          'hostId': hostId ?? 0,
          'checkIn': checkIn,
          'checkOut': checkOut,
          'guests': guests,
          'currency': currency,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'clientSecret': data['clientSecret'],
          'paymentIntentId': data['id'],
          ...data
        };
      }
      return null;
    } catch (e) {
      print('DEBUG: Error in createPaymentIntent: $e');
      return null;
    }
  }

  Future<bool> capturePayment(int bookingId) async {
    final token = await _authService.getToken();
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/capture'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'bookingId': bookingId}),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('DEBUG: Error in capturePayment: $e');
      return false;
    }
  }

  Future<bool> refundPayment(int bookingId, {double? amount}) async {
    final token = await _authService.getToken();
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/refund'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'bookingId': bookingId,
          if (amount != null) 'amount': amount,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('DEBUG: Error in refundPayment: $e');
      return false;
    }
  }

  Future<List<Booking>> fetchUserBookings() async {
    final token = await _authService.getToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/bookings/user'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Booking.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('DEBUG: Error in fetchUserBookings: $e');
      return [];
    }
  }

  Future<List<PaymentMethod>> fetchPaymentMethods() async {
    final token = await _authService.getToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/methods'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => PaymentMethod.fromStripeJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('DEBUG: Error in fetchPaymentMethods: $e');
      return [];
    }
  }

  Future<Map<String, String>?> createHostStripeAccount() async {
    final token = await _authService.getToken();
    if (token == null) return null;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/host/create-account'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'accountId': data['accountId']};
      }
      return null;
    } catch (e) {
      print('DEBUG: Error in createHostStripeAccount: $e');
      return null;
    }
  }

  Future<String?> getHostOnboardingLink() async {
    final token = await _authService.getToken();
    if (token == null) return null;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/host/onboarding-link'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['url'];
      }
      return null;
    } catch (e) {
      print('DEBUG: Error in getHostOnboardingLink: $e');
      return null;
    }
  }
}

