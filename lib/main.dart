import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:airbnb_mobile/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (!kIsWeb) {
    // Replace with your actual publishable key from Stripe Dashboard
    Stripe.publishableKey = "pk_test_placeholder";
    await Stripe.instance.applySettings();
  }
  
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
