import 'package:flutter/material.dart';

class HostingResourcesScreen extends StatelessWidget {
  const HostingResourcesScreen({super.key});

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
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Hosting resources',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildResourceCard(
              'Resource Center',
              'Discover hosting tips, news, and best practices.',
              'https://cdn-icons-png.flaticon.com/512/3394/3394017.png', // Stacked images icon placeholder
            ),
            _buildResourceCard(
              'Community Center',
              'Chat online with hosts from around the globe.',
              'https://cdn-icons-png.flaticon.com/512/2190/2190552.png', // Chat bubbles icon placeholder
            ),
            _buildResourceCard(
              'Host Clubs',
              'Meet and connect with other hosts in your area.',
              'https://cdn-icons-png.flaticon.com/512/3135/3135810.png', // Group of people icon placeholder
            ),
            _buildResourceCard(
              'Hosting classes',
              'Join a free hosting webinar led by top-performing Superhosts.',
              'https://cdn-icons-png.flaticon.com/512/3061/3061413.png', // Book/Journal icon placeholder
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(String title, String description, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 56,
                height: 56,
                color: Colors.grey.shade100,
                child: const Icon(Icons.image_outlined, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
