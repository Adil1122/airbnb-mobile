import 'package:flutter/material.dart';

class GetHelpScreen extends StatelessWidget {
  const GetHelpScreen({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
              child: Text(
                'Get help',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildHelpItem(Icons.help_outline, 'Visit the Help Center'),
            _buildHelpItem(Icons.security_outlined, 'Get help with a safety issue'),
            _buildHelpItem(Icons.flag_outlined, 'Report a neighborhood concern'),
            _buildHelpItem(Icons.feedback_outlined, 'Give us feedback'),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(IconData icon, String title) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          leading: Icon(icon, color: Colors.black87, size: 28),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 24),
          onTap: () {},
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Divider(height: 1),
        ),
      ],
    );
  }
}
