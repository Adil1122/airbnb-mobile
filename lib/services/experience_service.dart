import 'package:http/http.dart' as http;
import '../models/listing.dart';
import '../utils/api_config.dart';
import 'dart:convert';

// ignore_for_file: avoid_print

class ExperienceService {
  static String get baseUrl => ApiConfig.experiencesUrl;

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
