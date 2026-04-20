import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_config.dart';

class Destination {
  final int id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String type;

  Destination({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.type,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'],
      title: json['name'] ?? '',
      subtitle: json['region'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      type: json['type'] ?? 'suggested',
    );
  }
}

class DestinationService {
  final String _baseUrl = ApiConfig.baseUrl;

  Future<List<Destination>> fetchDestinations() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/destinations'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Destination.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching destinations: $e');
      return [];
    }
  }
}
