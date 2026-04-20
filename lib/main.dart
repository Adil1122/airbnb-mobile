import 'package:flutter/material.dart';
import 'package:airbnb_mobile/auth/login_signup_screen.dart';
import 'package:airbnb_mobile/screens/main_screen.dart';

void main() {
  runApp(const AirbnbApp());
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
      home: const MainScreen(),
    );
  }
}
