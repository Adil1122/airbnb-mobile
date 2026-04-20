import 'package:flutter/material.dart';
import 'account_settings/personal_info/profile_edit_screen.dart';
import 'past_trips_screen.dart';
import 'connections_screen.dart';
import 'become_host_screen.dart';
import 'account_settings/account_settings_screen.dart';
import '../host/hosting_main_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0, top: 8.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black12),
              ),
              child: const Icon(Icons.notifications_none, color: Colors.black, size: 28),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),

            // User Info Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
                );
              },
              child: _buildInfoCard(),
            ),
            const SizedBox(height: 24),

            // Past trips & Connections Row
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PastTripsScreen()),
                      );
                    },
                    child: _buildSubCard(
                      title: 'Past trips',
                      imagePath: 'C:\\Users\\Computer Arena\\.gemini\\antigravity\\brain\\81fcd7ad-8900-4a3e-b0d4-241b5d143fb1\\profile_suitcase_icon_1775037872147.png',
                      isNew: true,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ConnectionsScreen()),
                      );
                    },
                    child: _buildSubCard(
                      title: 'Connections',
                      imagePath: 'C:\\Users\\Computer Arena\\.gemini\\antigravity\\brain\\81fcd7ad-8900-4a3e-b0d4-241b5d143fb1\\profile_connections_icon_1775038024146.png',
                      isNew: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Become a Host Card
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HostingMainScreen()),
                );
              },
              child: _buildBecomeHostCard(),
            ),
            const SizedBox(height: 32),

            // Settings Items
            _buildSettingsRow(
              Icons.settings_outlined, 
              'Account settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildSettingsRow(Icons.help_outline, 'Get help'),
            const SizedBox(height: 24),
            _buildSettingsRow(Icons.person_outline, 'View profile'),
            const SizedBox(height: 24),
            _buildSettingsRow(Icons.back_hand_outlined, 'Privacy'),
            const SizedBox(height: 32),

            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 32),

            _buildSettingsRow(Icons.people_outline, 'Refer a host'),
            const SizedBox(height: 24),
            _buildSettingsRow(Icons.person_search_outlined, 'Find a co-host'),
            const SizedBox(height: 24),
            _buildSettingsRow(Icons.description_outlined, 'Legal'),
            const SizedBox(height: 24),
            _buildSettingsRow(Icons.meeting_room_outlined, 'Log out', hasChevron: false),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFF222222),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'A',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ahmad',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Guest',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubCard({required String title, required String imagePath, bool isNew = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                title == 'Past trips'
                    ? 'https://cdn-icons-png.flaticon.com/512/2921/2921501.png' // Stylized Suitcase
                    : 'https://cdn-icons-png.flaticon.com/512/3468/3468192.png', // Stylized People
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (isNew)
            Positioned(
              top: -10,
              right: -10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A5F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBecomeHostCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.network(
            'https://cdn-icons-png.flaticon.com/512/3014/3014569.png', // Stylized Host
            height: 60,
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Become a host',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "It's easy to start hosting and earn extra income.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow(IconData icon, String title, {bool hasChevron = true, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
          if (hasChevron)
            const Icon(Icons.chevron_right, color: Colors.black54),
        ],
      ),
    );
  }
}
