import 'package:http/http.dart' as http;
import '../models/listing.dart';
import '../utils/api_config.dart';
import 'dart:convert';

// ignore_for_file: avoid_print

class PropertyService {
  static String get baseUrl => ApiConfig.propertiesUrl;

  Future<List<Listing>> fetchProperties({int? categoryId}) async {
    try {
      final url = categoryId != null 
          ? '$baseUrl?categoryId=$categoryId' 
          : baseUrl;
      
      return await _fetchFromUrl(url);
    } catch (e) {
      print('DEBUG: Exception in fetchProperties: $e');
      rethrow;
    }
  }

  Future<List<Listing>> searchProperties({String? location, int? adults, int? children, String? startDate, String? endDate}) async {
    try {
      final queryParams = <String, String>{};
      if (location != null && location.isNotEmpty) queryParams['location'] = location;
      if (adults != null && adults > 0) queryParams['adults'] = adults.toString();
      if (children != null && children > 0) queryParams['children'] = children.toString();
      if (startDate != null && startDate.isNotEmpty) queryParams['startDate'] = startDate;
      if (endDate != null && endDate.isNotEmpty) queryParams['endDate'] = endDate;
      
      final uri = Uri.parse('$baseUrl/search').replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);
      print('DEBUG: Property search URL: $uri');
      return await _fetchFromUrl(uri.toString());
    } catch (e) {
      print('DEBUG: Exception in searchProperties: $e');
      return [];
    }
  }

  Future<List<Listing>> _fetchFromUrl(String url) async {
    final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final dynamic decoded = jsonDecode(response.body);
      List<dynamic> data;
      
      if (decoded is Map && decoded.containsKey('results')) {
        data = decoded['results'] as List<dynamic>;
      } else if (decoded is List) {
        data = decoded;
      } else {
        data = [];
      }

      return data.map((json) {
          try {
            return Listing.fromJson(json);
          } catch (e) {
            print('DEBUG: Error parsing individual property: $e');
            return null;
          }
      }).where((item) => item != null).cast<Listing>().toList();
    } else {
      throw Exception('Failed to load from $url: ${response.statusCode}');
    }
  }

  Future<Listing?> fetchPropertyDetails(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return Listing.fromJson(jsonDecode(response.body));
      } else {
        print('DEBUG: Property details failed with status ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('ERROR: Exception in fetchPropertyDetails: $e');
      return null;
    }
  }
}
