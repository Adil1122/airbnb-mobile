import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_config.dart';
import '../services/auth_service.dart';
import '../models/booking_model.dart';
import '../models/payment_method_model.dart';

class PaymentService {
  final String _baseUrl = '${ApiConfig.baseUrl}/payment';
  final _authService = AuthService();

  Future<Map<String, String>?> createPaymentIntent({
    required double amount,
    required int propertyId,
    required String checkIn,
    required String checkOut,
    required int guests,
  }) async {
    final token = await _authService.getToken();
    if (token == null) return null;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/create-payment-intent'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'amount': amount,
          'propertyId': propertyId,
          'checkIn': checkIn,
          'checkOut': checkOut,
          'guests': guests,
        }),
      );

      print('DEBUG: createPaymentIntent status: ${response.statusCode}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('DEBUG: createPaymentIntent response: $data');
        return {
          'clientSecret': data['clientSecret'],
          'paymentIntentId': data['id'],
        };
      }
      print('DEBUG: createPaymentIntent failed: ${response.body}');
      return null;
    } catch (e) {
      print('DEBUG: Error in createPaymentIntent: $e');
      return null;
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
      print('DEBUG: confirmBooking for intent: $paymentIntentId');
      final response = await http.post(
        Uri.parse('$_baseUrl/confirm-booking'),
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

      print('DEBUG: confirmBooking status: ${response.statusCode}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('DEBUG: confirmBooking response: $data');
        if (data['success'] == true) {
          return Booking.fromJson(data['booking']);
        }
      }
      print('DEBUG: confirmBooking failed: ${response.body}');
      return null;
    } catch (e) {
      print('DEBUG: Error in confirmBooking: $e');
      return null;
    }
  }

  Future<List<Booking>> fetchUserBookings() async {
    final token = await _authService.getToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/bookings'),
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

  Future<bool> cancelBooking(int bookingId) async {
    final token = await _authService.getToken();
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/cancel/$bookingId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('DEBUG: Error in cancelBooking: $e');
      return false;
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
}
