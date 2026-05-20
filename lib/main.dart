import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'screens/main_screen.dart';
import 'auth/login_signup_screen.dart';
import 'utils/api_config.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp();
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(alert: true, badge: true, sound: true);

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message) {
      // Foreground notifications — handled via in-app SnackBar/dialog in each screen
    });

    final token = await messaging.getToken();
    if (token != null) {
      _registerFcmToken(token);
    }

    messaging.onTokenRefresh.listen(_registerFcmToken);
  } catch (_) {
    // Firebase not configured yet — continue without push notifications
  }
}

Future<void> _registerFcmToken(String token) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('auth_token');
    if (authToken == null) return;

    await http.post(
      Uri.parse('${ApiConfig.notificationsUrl}/device-token'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $authToken'},
      body: jsonEncode({'token': token, 'platform': defaultTargetPlatform.name}),
    );
  } catch (_) {}
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Run the app immediately to show the splash/loading screen
  runApp(const AirbnbApp());

  // Initialize heavy services in the background to avoid black screen stalls
  _initBackgroundServices();
}

Future<void> _initBackgroundServices() async {
  if (!kIsWeb) {
    try {
      Stripe.publishableKey = const String.fromEnvironment(
        'STRIPE_PK',
        defaultValue: 'pk_test_JOTEYdyZzn9N4VPvuAVQYBty00Opd7riRE',
      );
      debugPrint('Stripe initialized with: ${Stripe.publishableKey}');
      await Stripe.instance.applySettings();
    } catch (e) {
      debugPrint('Stripe initialization failed: $e');
    }
  }

  try {
    await _initFirebase().timeout(const Duration(seconds: 5));
  } catch (e) {
    debugPrint('Firebase initialization timed out or failed (likely missing google-services.json): $e');
  }
}

class AirbnbApp extends StatelessWidget {
  const AirbnbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airbnb Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE61E4D),
          primary: const Color(0xFFE61E4D),
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFE61E4D)),
            ),
          );
        }
        
        // If token exists, go to MainScreen, else go to LoginSignupScreen
        if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
          return const MainScreen();
        }
        
        return const LoginSignupScreen();
      },
    );
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
