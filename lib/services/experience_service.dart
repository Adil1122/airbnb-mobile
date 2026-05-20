import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/listing.dart';
import '../utils/api_config.dart';
import '../services/auth_service.dart';
import 'dart:convert';

// ignore_for_file: avoid_print

class ExperienceService {
  static String get baseUrl => ApiConfig.experiencesUrl;
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _authHeaders() async {
    final token = await _authService.getToken();
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
  }

  Future<String> uploadImage(Uint8List bytes) async {
    final token = await _authService.getToken();
    final request = http.MultipartRequest('POST', Uri.parse(ApiConfig.uploadImageUrl));
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: 'exp_${DateTime.now().millisecondsSinceEpoch}.jpg',
      contentType: MediaType('image', 'jpeg'),
    ));
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['url']?.toString() ?? '';
    }
    throw Exception('Image upload failed: ${response.statusCode}');
  }

  Future<Listing> createExperience(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: await _authHeaders(),
      body: jsonEncode(data),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      final json = jsonDecode(response.body);
      json['id'] = 'e${json['id']}';
      return Listing.fromJson(json);
    }
    throw Exception('Failed to create experience: ${response.statusCode} ${response.body}');
  }

  Future<List<Listing>> getMyExperiences() async {
    final response = await http.get(
      Uri.parse('$baseUrl/mine'),
      headers: await _authHeaders(),
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) {
        json['id'] = 'e${json['id']}';
        return Listing.fromJson(json as Map<String, dynamic>);
      }).toList();
    }
    throw Exception('Failed to load experiences: ${response.statusCode}');
  }

  Future<Listing> updateExperience(String id, Map<String, dynamic> data) async {
    final cleanId = id.startsWith('e') ? id.substring(1) : id;
    final response = await http.patch(
      Uri.parse('$baseUrl/$cleanId'),
      headers: await _authHeaders(),
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      json['id'] = 'e${json['id']}';
      return Listing.fromJson(json);
    }
    throw Exception('Failed to update experience: ${response.statusCode} ${response.body}');
  }

  Future<void> deleteExperience(String id) async {
    final cleanId = id.startsWith('e') ? id.substring(1) : id;
    final response = await http.delete(
      Uri.parse('$baseUrl/$cleanId'),
      headers: await _authHeaders(),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete experience: ${response.statusCode}');
    }
  }

  Future<List<Listing>> fetchExperiences() async {
    return await _fetchFromUrl(baseUrl);
  }

  Future<List<Listing>> searchExperiences({String? location, int? adults, int? children, int? infants, int? pets, String? startDate, String? endDate}) async {
    try {
      final queryParams = <String, String>{};
      if (location != null && location.isNotEmpty) queryParams['location'] = location;
      if (adults != null && adults > 0) queryParams['adults'] = adults.toString();
      if (children != null && children > 0) queryParams['children'] = children.toString();
      if (infants != null && infants > 0) queryParams['infants'] = infants.toString();
      if (pets != null && pets > 0) queryParams['pets'] = 'true';
      if (startDate != null && startDate.isNotEmpty) queryParams['startDate'] = startDate;
      if (endDate != null && endDate.isNotEmpty) queryParams['endDate'] = endDate;
      
      final uri = Uri.parse('$baseUrl/search').replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);
      print('DEBUG: Experience search URL: $uri');
      return await _fetchFromUrl(uri.toString());
    } catch (e) {
      print('DEBUG: Exception in searchExperiences: $e');
      return [];
    }
  }

  Future<List<Listing>> _fetchFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        List<dynamic> data = [];
        
        if (decoded is Map && decoded.containsKey('results')) {
          data = decoded['results'] as List<dynamic>;
        } else if (decoded is List) {
          data = decoded;
        }

        return data.map((json) {
          try {
            json['id'] = 'e${json['id']}';
            return Listing.fromJson(json);
          } catch (e) {
            print('Error parsing experience: $e');
            return null;
          }
        }).where((item) => item != null).cast<Listing>().toList();
      } else {
        throw Exception('Failed to load experiences from $url: ${response.statusCode}');
      }
    } catch (e) {
      print('DEBUG: Exception in experience _fetchFromUrl: $e');
      rethrow;
    }
  }

  Future<List<Listing>> fetchSimilarExperiences(String location, String excludeId) async {
    try {
      final cleanId = excludeId.startsWith('e') ? excludeId.substring(1) : excludeId;
      final uri = Uri.parse('$baseUrl/similar').replace(queryParameters: {
        'location': location,
        'excludeId': cleanId,
      });
      return await _fetchFromUrl(uri.toString());
    } catch (e) {
      print('Error fetching similar experiences: $e');
      return [];
    }
  }

  Future<Listing?> fetchExperienceDetails(String id) async {
    try {
      final cleanId = id.startsWith('e') ? id.substring(1) : id;
      final response = await http.get(Uri.parse('$baseUrl/$cleanId')).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        data['id'] = 'e${data['id']}';
        return Listing.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching experience details: $e');
      return null;
    }
  }
}
