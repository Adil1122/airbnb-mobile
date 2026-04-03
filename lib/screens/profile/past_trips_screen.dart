import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../main_screen.dart';

class PastTripsScreen extends StatelessWidget {
  const PastTripsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Past trips',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 64),
              
              // Suitcase Image
              Center(
                child: kIsWeb 
                  ? Image.network(
                      'https://cdn-icons-png.flaticon.com/512/2921/2921501.png',
                      height: 280,
                      fit: BoxFit.contain,
                    )
                  : Image.file(
                      File('C:/Users/Computer Arena/.gemini/antigravity/brain/890973fe-bc41-4cc2-99b8-3adbdbd4a355/airbnb_past_trips_suitcase_1775205860025.png'),
                      height: 280,
                      fit: BoxFit.contain,
                    ),
              ),
              
              const SizedBox(height: 48),
              
              const Text(
                'You\'ll find your past reservations here after you\'ve taken your first trip on Airbnb.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Book a trip button
              SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the Explore/Home screen (MainScreen tab 0)
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE31C5F), // Airbnb Red/Pink
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Book a trip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 64),
            ],
          ),
        ),
      ),
    );
  }
}
