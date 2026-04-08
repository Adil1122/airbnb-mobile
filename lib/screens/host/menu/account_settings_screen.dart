import 'package:flutter/material.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

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
                'Account Settings',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSettingItem(Icons.person_outline, 'Personal information'),
            _buildSettingItem(Icons.security_outlined, 'Login & security'),
            _buildSettingItem(Icons.back_hand_outlined, 'Privacy'),
            _buildSettingItem(Icons.notifications_outlined, 'Notifications'),
            _buildSettingItem(Icons.payments_outlined, 'Payments'),
            _buildSettingItem(Icons.language_outlined, 'Translation'),
            _buildSettingItem(Icons.work_outline, 'Travel for work'),
            _buildSettingItem(Icons.settings_accessibility_outlined, 'Accessibility'),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Divider(),
            ),
            
            _buildSettingItem(Icons.calculate_outlined, 'Taxes'),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Divider(),
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
              child: Text(
                'Version 26.13 (28021224)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
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
