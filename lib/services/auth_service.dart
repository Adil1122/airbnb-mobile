import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

import 'package:flutter/foundation.dart';

class AuthService {
  // Use localhost for Web/iOS, 10.0.2.2 for Android emulator, or a fixed IP for physical devices
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:3001/auth';
    return 'http://192.168.1.12:3001/auth';
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final token = data['auth_token'];
        final userData = UserModel.fromJson(data['user']);
        
        await _saveToken(token);
        await _saveUser(userData);

        return {'success': true, 'user': userData};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final token = data['auth_token'];
        final userData = UserModel.fromJson(data['user']);
        
        await _saveToken(token);
        await _saveUser(userData);

        return {'success': true, 'user': userData};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Registration failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/google/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        await _saveToken(data['accessToken']);
        final user = UserModel.fromJson(data['user']);
        await _saveUser(user);
        return {'success': true, 'user': user};
      }
      return {'success': false, 'message': data['message'] ?? 'Google login failed'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('user');
    if (userStr != null) {
      return UserModel.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  Future<UserModel?> getProfile() async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = UserModel.fromJson(data);
        await _saveUser(user);
        return user;
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
    return null;
  }

  Future<UserModel?> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final response = await http.post(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(profileData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = UserModel.fromJson(data);
        await _saveUser(user);
        return user;
      }
    } catch (e) {
      print('Error updating profile: $e');
    }
    return null;
  }

  Future<UserModel?> uploadAvatar({String? path, Uint8List? bytes}) async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final uri = Uri.parse('$baseUrl/profile/avatar');
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      if (kIsWeb && bytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: 'avatar.jpg',
        ));
      } else if (path != null) {
        request.files.add(await http.MultipartFile.fromPath('file', path));
      } else {
        return null;
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = UserModel.fromJson(data);
        await _saveUser(user);
        return user;
      }
    } catch (e) {
      print('Error uploading avatar: $e');
    }
    return null;
  }

  Future<UserModel?> uploadIDCard({String? path, Uint8List? bytes}) async {
    try {
      final token = await getToken();
      if (token == null) return null;

      final uri = Uri.parse('$baseUrl/profile/id-card');
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      if (kIsWeb && bytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: 'id_card.jpg',
        ));
      } else if (path != null) {
        request.files.add(await http.MultipartFile.fromPath('file', path));
      } else {
        return null;
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = UserModel.fromJson(data);
        await _saveUser(user);
        return user;
      }
    } catch (e) {
      print('Error uploading ID card: $e');
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user');
  }
}
