import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class BecomeHostScreen extends StatelessWidget {
  const BecomeHostScreen({Key? key}) : super(key: key);

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
              'C:/Users/Computer Arena/.gemini/antigravity/brain/890973fe-bc41-4cc2-99b8-3adbdbd4a355/airbnb_host_step1_bed_1775206460702.png',
              kIsWeb ? 'https://cdn-icons-png.flaticon.com/512/2990/2990554.png' : null,
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
              'C:/Users/Computer Arena/.gemini/antigravity/brain/890973fe-bc41-4cc2-99b8-3adbdbd4a355/airbnb_host_step2_living_room_1775206485626.png',
              kIsWeb ? 'https://cdn-icons-png.flaticon.com/512/3222/3222687.png' : null,
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
              'C:/Users/Computer Arena/.gemini/antigravity/brain/890973fe-bc41-4cc2-99b8-3adbdbd4a355/airbnb_host_step3_door_1775206507009.png',
              kIsWeb ? 'https://cdn-icons-png.flaticon.com/512/3061/3061413.png' : null,
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
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
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

  Widget _buildStepRow(String number, String title, String description, String localPath, String? webPath) {
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
            child: (kIsWeb && webPath != null)
                ? Image.network(webPath, fit: BoxFit.cover)
                : Image.file(File(localPath), fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }
}
