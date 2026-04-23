import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/listing.dart';
import '../utils/api_config.dart';

// ignore_for_file: avoid_print

class ServiceService {
  static String get baseUrl => ApiConfig.servicesUrl;

  Future<List<Listing>> fetchServices() async {
    return await _fetchFromUrl(baseUrl);
  }

  Future<List<String>> fetchServiceCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories')).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<String>();
      }
      return [];
    } catch (e) {
      print('DEBUG: Exception in fetchServiceCategories: $e');
      return [];
    }
  }

  Future<List<Listing>> searchServices({String? location, int? adults, int? children, int? infants, int? pets, String? startDate, String? endDate, String? category}) async {
    try {
      final queryParams = <String, String>{};
      if (location != null && location.isNotEmpty) queryParams['location'] = location;
      if (adults != null && adults > 0) queryParams['adults'] = adults.toString();
      if (children != null && children > 0) queryParams['children'] = children.toString();
      if (infants != null && infants > 0) queryParams['infants'] = infants.toString();
      if (pets != null && pets > 0) queryParams['pets'] = 'true';
      if (startDate != null && startDate.isNotEmpty) queryParams['startDate'] = startDate;
      if (endDate != null && endDate.isNotEmpty) queryParams['endDate'] = endDate;
      if (category != null && category.isNotEmpty) queryParams['category'] = category;

      final uri = Uri.parse('$baseUrl/search').replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);
      print('DEBUG: Service search URL: $uri');
      return await _fetchFromUrl(uri.toString());
    } catch (e) {
      print('DEBUG: Exception in searchServices: $e');
      return [];
    }
  }

  Future<List<Listing>> _fetchFromUrl(String url) async {
    try {
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
            json['id'] = 's${json['id']}';
            return Listing.fromJson(json);
          } catch (e) {
            print('DEBUG: Error parsing individual service: $e');
            return null;
          }
        }).where((item) => item != null).cast<Listing>().toList();
      } else {
        print('DEBUG: Services fetch failed with status ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('DEBUG: Exception in service _fetchFromUrl: $e');
      return [];
    }
  }

  Future<Listing?> fetchServiceDetails(String id) async {
    try {
      final numericId = id.replaceAll(RegExp(r'[^0-9]'), '');
      final response = await http.get(Uri.parse('$baseUrl/$numericId')).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        data['id'] = 's${data['id']}';
        return Listing.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching service details: $e');
      return null;
    }
  }
}
