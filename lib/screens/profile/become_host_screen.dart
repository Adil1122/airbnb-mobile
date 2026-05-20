import 'package:flutter/material.dart';
import 'host/step1_screens.dart';

import '../../services/host_service.dart';
import '../../models/listing.dart';

class BecomeHostScreen extends StatefulWidget {
  const BecomeHostScreen({super.key});

  @override
  State<BecomeHostScreen> createState() => _BecomeHostScreenState();
}

class _BecomeHostScreenState extends State<BecomeHostScreen> {
  bool _isLoading = false;
  final HostService _hostService = HostService();

  Future<void> _handleGetStarted() async {
    setState(() => _isLoading = true);
    try {
      final listing = await _hostService.initiateListing();
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HostStep1IntroScreen(listing: listing)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting host flow: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'It\'s easy to get started\non Airbnb',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.0,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 56),
            
            // Step 1
            _buildStepRow(
              '1',
              'Tell us about your place',
              'Share some basic info, like where it is and how many guests can stay.',
              'https://cdn-icons-png.flaticon.com/512/2990/2990554.png',
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
            ),
            
            // Step 2
            _buildStepRow(
              '2',
              'Make it stand out',
              'Add 5 or more photos plus a title and description—we\'ll help you out.',
              'https://cdn-icons-png.flaticon.com/512/3222/3222687.png',
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
            ),
            
            // Step 3
            _buildStepRow(
              '3',
              'Finish up and publish',
              'Choose a starting price, verify a few details, then publish your listing.',
              'https://cdn-icons-png.flaticon.com/512/3061/3061413.png',
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade100, width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: Color(0xFFE31C5F)))
              : ElevatedButton(
                  onPressed: _handleGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE31C5F), // Airbnb Red/Pink
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Get started',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepRow(String number, String title, String description, String imageUrl) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade50,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
