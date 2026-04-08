import 'package:flutter/material.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

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
                'Legal',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildLegalItem(Icons.menu_book_outlined, 'Terms of Service'),
            _buildLegalItem(Icons.menu_book_outlined, 'Privacy Policy'),
            _buildLegalItem(Icons.menu_book_outlined, 'Open source licenses'),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalItem(IconData icon, String title) {
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
