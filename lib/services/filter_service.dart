import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_config.dart';

class PropertyFilters {
  final List<dynamic> guestCategories;
  final PriceRange priceRange;
  final List<String> propertyTypes;

  PropertyFilters({
    required this.guestCategories,
    required this.priceRange,
    required this.propertyTypes,
  });

  factory PropertyFilters.fromJson(Map<String, dynamic> json) {
    return PropertyFilters(
      guestCategories: json['guestCategories'] ?? [],
      priceRange: PriceRange.fromJson(json['priceRange']),
      propertyTypes: List<String>.from(json['propertyTypes'] ?? []),
    );
  }
}

class PriceRange {
  final double min;
  final double max;

  PriceRange({required this.min, required this.max});

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      min: (json['min'] ?? 0).toDouble(),
      max: (json['max'] ?? 1000).toDouble(),
    );
  }
}

class FilterService {
  final String _baseUrl = ApiConfig.baseUrl;

  Future<PropertyFilters?> fetchFilters() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/filters'));
      if (response.statusCode == 200) {
        return PropertyFilters.fromJson(json.decode(response.body));
      }
      return null;
    } catch (e) {
      print('Error fetching filters: $e');
      return null;
    }
  }
}
