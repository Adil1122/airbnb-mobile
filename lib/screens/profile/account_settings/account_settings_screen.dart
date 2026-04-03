import 'package:flutter/material.dart';
import 'personal_info/personal_info_screen.dart';
import 'login_security/login_security_screen.dart';
import 'privacy/privacy_screen.dart';
import 'notifications/notifications_screen.dart';
import 'payments/payments_payouts_screen.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({Key? key}) : super(key: key);

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
            const Text(
              'Account Settings',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 32),
            
            _buildSettingItem(
              Icons.person_outline, 
              'Personal information',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
                );
              },
            ),
            _buildSettingItem(
              Icons.shield_outlined, 
              'Login & security',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginSecurityScreen()),
                );
              },
            ),
            _buildSettingItem(
              Icons.back_hand_outlined, 
              'Privacy',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyScreen()),
                );
              },
            ),
            _buildSettingItem(
              Icons.notifications_none_outlined, 
              'Notifications',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                );
              },
            ),
            _buildSettingItem(
              Icons.payments_outlined, 
              'Payments',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentsPayoutsScreen()),
                );
              },
            ),
            _buildSettingItem(Icons.calculate_outlined, 'Taxes'),
            _buildSettingItem(Icons.language_outlined, 'Translation'),
            _buildSettingItem(Icons.card_travel_outlined, 'Travel for work'),
            _buildSettingItem(Icons.settings_accessibility_outlined, 'Accessibility'),
            
            const SizedBox(height: 32),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 32),
            
            const Text(
              'Version 26.13 (28021224)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.black87),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
