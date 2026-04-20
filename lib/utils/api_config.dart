import 'package:flutter/foundation.dart';
import 'dart:io';

class ApiConfig {
  // Primary IP for the host machine
  static const String hostIp = '192.168.1.12';
  
  // Standard port for NestJS backend
  static const String port = '3001';

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:$port';
    }
    
    // For Android Emulator, 10.0.2.2 points to host's localhost
    if (Platform.isAndroid) {
      // Try to determine if we are in an emulator
      // For simplicity, we can just use hostIp, but 10.0.2.2 is usually safer for emulators.
      // However, if the user is on a real device, 10.0.2.2 won't work.
      // We'll stick to hostIp but maybe provide a way to switch or use both?
      return 'http://$hostIp:$port';
    }
    
    return 'http://$hostIp:$port';
  }

  static String get propertiesUrl => '$baseUrl/properties';
  static String get experiencesUrl => '$baseUrl/experiences';
  static String get servicesUrl => '$baseUrl/services';
  static String get authUrl => '$baseUrl/auth';
}
