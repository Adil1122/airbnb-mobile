import 'package:flutter/material.dart';
import '../../profile/account_settings/personal_info/personal_info_screen.dart';
import '../../profile/account_settings/login_security/login_security_screen.dart';
import '../../profile/account_settings/privacy/privacy_screen.dart';
import '../../profile/account_settings/accessibility/accessibility_screen.dart';
import '../../profile/account_settings/notifications/notifications_screen.dart';
import '../../profile/account_settings/payments/payments_payouts_screen.dart';
import '../../profile/account_settings/taxes/taxes_screen.dart';
import '../../profile/account_settings/translation/translation_screen.dart';
import '../../profile/account_settings/travel_for_work/travel_for_work_screen.dart';

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
            _buildSettingItem(
              Icons.person_outline, 
              'Personal information',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalInfoScreen())),
            ),
            _buildSettingItem(
              Icons.security_outlined, 
              'Login & security',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginSecurityScreen())),
            ),
            _buildSettingItem(
              Icons.back_hand_outlined, 
              'Privacy',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyScreen())),
            ),
            _buildSettingItem(
              Icons.notifications_outlined, 
              'Notifications',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
            ),
            _buildSettingItem(
              Icons.payments_outlined, 
              'Payments',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentsPayoutsScreen())),
            ),
            _buildSettingItem(
              Icons.language_outlined, 
              'Translation',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TranslationScreen())),
            ),
            _buildSettingItem(
              Icons.work_outline, 
              'Travel for work',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TravelForWorkScreen())),
            ),
            _buildSettingItem(
              Icons.settings_accessibility_outlined, 
              'Accessibility',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AccessibilityScreen())),
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Divider(),
            ),
            
            _buildSettingItem(
              Icons.calculate_outlined, 
              'Taxes',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TaxesScreen())),
            ),
            
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

  Widget _buildSettingItem(IconData icon, String title, {VoidCallback? onTap}) {
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
          onTap: onTap,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Divider(height: 1),
        ),
      ],
    );
  }
}
