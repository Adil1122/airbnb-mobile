import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_config.dart';

class ReviewsService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Map<String, String> _authHeaders(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<List<dynamic>> getListingReviews(int propertyId) async {
    final res = await http.get(Uri.parse(ApiConfig.reviewsByListingUrl(propertyId)));
    if (res.statusCode == 200) return jsonDecode(res.body) as List;
    return [];
  }

  Future<Map<String, dynamic>> getReviewSummary(int propertyId) async {
    final res = await http.get(Uri.parse(ApiConfig.reviewSummaryUrl(propertyId)));
    if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    return {};
  }

  Future<List<dynamic>> getMyReviews() async {
    final token = await _getToken();
    if (token == null) return [];
    final res = await http.get(
      Uri.parse(ApiConfig.myReviewsUrl),
      headers: _authHeaders(token),
    );
    if (res.statusCode == 200) return jsonDecode(res.body) as List;
    return [];
  }

  Future<Map<String, dynamic>?> createReview({
    required int propertyId,
    required String reviewText,
    required double rating,
    int? bookingId,
    double? cleanlinessRating,
    double? accuracyRating,
    double? checkinRating,
    double? communicationRating,
    double? locationRating,
    double? valueRating,
    String? privateFeedback,
  }) async {
    final token = await _getToken();
    if (token == null) return null;
    final body = {
      'propertyId': propertyId,
      'reviewText': reviewText,
      'rating': rating,
      if (bookingId != null) 'bookingId': bookingId,
      if (cleanlinessRating != null) 'cleanlinessRating': cleanlinessRating,
      if (accuracyRating != null) 'accuracyRating': accuracyRating,
      if (checkinRating != null) 'checkinRating': checkinRating,
      if (communicationRating != null) 'communicationRating': communicationRating,
      if (locationRating != null) 'locationRating': locationRating,
      if (valueRating != null) 'valueRating': valueRating,
      if (privateFeedback != null) 'privateFeedback': privateFeedback,
    };
    final res = await http.post(
      Uri.parse(ApiConfig.reviewsUrl),
      headers: _authHeaders(token),
      body: jsonEncode(body),
    );
    if (res.statusCode == 201) return jsonDecode(res.body) as Map<String, dynamic>;
    return null;
  }

  Future<bool> respondToReview(int reviewId, String response) async {
    final token = await _getToken();
    if (token == null) return false;
    final res = await http.put(
      Uri.parse(ApiConfig.reviewResponseUrl(reviewId)),
      headers: _authHeaders(token),
      body: jsonEncode({'response': response}),
    );
    return res.statusCode == 200;
  }
}
