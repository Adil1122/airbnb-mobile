import 'package:flutter/material.dart';

class IdentityVerificationScreen extends StatelessWidget {
  const IdentityVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Identity verification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    'Let\'s add your ID',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'This helps us check that you\'re really you. Identity verification is one of the ways we keep Airbnb secure.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87, // Using a soft black for readability
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'How identity verification works',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Info Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                        children: [
                          TextSpan(text: 'Your info is handled according to our '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: '. Learn more about '),
                          TextSpan(
                            text: 'identity verification',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Sticky Footer
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // This would normally proceed to the camera or file picker
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF222222),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Add an ID',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
