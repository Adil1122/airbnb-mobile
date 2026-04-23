import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/listing.dart';
import '../models/hosting_dashboard_model.dart';
import '../utils/api_config.dart';
import 'auth_service.dart';

class HostService {
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<HostDashboardData> getDashboard() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.hostDashboardUrl),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return HostDashboardData.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        await _authService.logout();
        throw Exception('Session expired. Please log in again.');
      } else {
        throw Exception('Failed to load dashboard: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching host dashboard: $e');
      rethrow;
    }
  }

  Future<Listing> initiateListing() async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/host/listings/initiate'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Listing.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to initiate listing: ${response.statusCode}');
      }
    } catch (e) {
      print('Error initiating listing: $e');
      rethrow;
    }
  }

  Future<Listing> getListingById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/host/listings/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return Listing.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load listing: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching listing: $e');
      rethrow;
    }
  }

  Future<List<Listing>> getListings() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.hostListingsUrl),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Listing.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        await _authService.logout();
        throw Exception('Session expired. Please log in again.');
      } else {
        throw Exception('Failed to load listings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching host listings: $e');
      rethrow;
    }
  }

  Future<Listing> updateArrivalGuide(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/host/listings/$id/arrival-guide'),
        headers: await _getHeaders(),
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return Listing.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update arrival guide: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating arrival guide: $e');
      rethrow;
    }
  }

  Future<void> updateCalendar(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/host/listings/$id/calendar'),
        headers: await _getHeaders(),
        body: json.encode(data),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update calendar: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating calendar: $e');
      rethrow;
    }
  }

  Future<Listing> updateContent(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/host/listings/$id/content'),
        headers: await _getHeaders(),
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return Listing.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update content: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating content: $e');
      rethrow;
    }
  }

  Future<Listing> updatePricing(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/host/listings/$id/pricing'),
        headers: await _getHeaders(),
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return Listing.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update pricing: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating pricing: $e');
      rethrow;
    }
  }

  Future<Listing> updateBasics(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/host/listings/$id/basics'),
        headers: await _getHeaders(),
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return Listing.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update basics: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating basics: $e');
      rethrow;
    }
  }

  Future<void> deleteListing(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/host/listings/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete listing: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting listing: $e');
      rethrow;
    }
  }

  Future<void> verifyIdentity() async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/host/listings/verify-identity'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to verify identity: ${response.statusCode}');
      }
    } catch (e) {
      print('Error verifying identity: $e');
      rethrow;
    }
  }

  Future<void> verifyPhone() async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/host/listings/verify-phone'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to verify phone: ${response.statusCode}');
      }
    } catch (e) {
      print('Error verifying phone: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> sendOtp(String phone) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/host/listings/send-otp'),
        headers: await _getHeaders(),
        body: json.encode({'phone': phone}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to send OTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending OTP: $e');
      rethrow;
    }
  }

  Future<void> publishListing(String id) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/host/listings/$id/publish'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to publish listing: ${response.statusCode}');
      }
    } catch (e) {
      print('Error publishing listing: $e');
      rethrow;
    }
  }

  Future<Listing> updateFloorPlan(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/host/listings/$id/floor-plan'),
        headers: await _getHeaders(),
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return Listing.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update floor plan: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating floor plan: $e');
      rethrow;
    }
  }

  Future<Listing> updateAmenities(String id, List<String> amenities) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/host/listings/$id/amenities'),
        headers: await _getHeaders(),
        body: json.encode({'amenities': amenities}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update amenities: ${response.statusCode}');
      }
      
      // Since backend returns void, we fetch the updated listing
      return await getListingById(id);
    } catch (e) {
      rethrow;
    }
  }


  Future<void> uploadImage(String id, String filePath) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/host/listings/$id/images'),
      );
      
      final headers = await _getHeaders();
      request.headers.addAll(headers);
      
      request.files.add(await http.MultipartFile.fromPath('image', filePath));
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 201) {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }
}
