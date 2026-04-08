import 'package:flutter/material.dart';

class FindCohostScreen extends StatelessWidget {
  const FindCohostScreen({super.key});

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
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Co-hosts near',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Awan Colony, Haripur, Pakistan',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Stylized Map Illustration
              _buildMapIllustration(),
              const SizedBox(height: 48),
              const Text(
                'No co-hosts nearby',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Sign up to be notified if one becomes available.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 40),
              // Notify me button
              SizedBox(
                width: 140,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF222222),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Notify me',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Placeholder map tiles
        Container(
          width: 250,
          height: 180,
          child: Image.network(
            'https://cdn-icons-png.flaticon.com/512/854/854878.png', // Illustrative map icon placeholder
            fit: BoxFit.contain,
          ),
        ),
        // Stylized car placeholder (mimicking the image)
        Positioned(
          bottom: 20,
          child: Icon(Icons.drive_eta, color: Colors.orange.shade800, size: 48),
        ),
        // Pin placeholder
        Positioned(
          top: 30,
          right: 80,
          child: Icon(Icons.location_on, color: const Color(0xFFFF385C), size: 40),
        ),
      ],
    );
  }
}
