import 'package:flutter/material.dart';
import 'guest_requirements_screen.dart';
import 'airbnb_org_stays_screen.dart';
import 'languages_editor_screen.dart';
import 'local_laws_screen.dart';
import 'unlisting_reason_screen.dart';

class EditPreferencesScreen extends StatelessWidget {
  const EditPreferencesScreen({super.key});

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
        title: const Text(
          'Edit preferences',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: [
          const SizedBox(height: 24),
          _buildPreferenceItem(
            context,
            'Listing status',
            '●  Unlisted',
            onTap: () {}, // Status logic would go here
          ),
          _buildPreferenceItem(
            context,
            'Languages',
            'English',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguagesEditorScreen())),
          ),
          _buildPreferenceItem(
            context,
            'Guest requirements',
            'Profile photo not required',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GuestRequirementsScreen())),
          ),
          _buildPreferenceItem(
            context,
            'Local laws',
            'Review your local laws',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LocalLawsScreen())),
          ),
          _buildPreferenceItem(
            context,
            'Airbnb.org stays',
            'Learn how you can help',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AirbnbOrgStaysScreen())),
          ),
          _buildPreferenceItem(
            context,
            'Remove listing',
            'Permanently remove your listing from Airbnb.',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UnlistingReasonScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem(BuildContext context, String title, String subtitle, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
