import 'package:flutter/material.dart';
import 'restricted_days_editor_screen.dart';
import 'availability_options_screens.dart';
import 'calendar_sync_screens.dart';

class AvailabilityEditorScreen extends StatelessWidget {
  const AvailabilityEditorScreen({super.key});

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
              'Availability',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'These settings apply to all nights, unless you customize them by date.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            
            const SizedBox(height: 32),
            const Text(
              'Trip length',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildTripLengthCard(),
            
            const SizedBox(height: 40),
            const Text(
              'Availability',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildSettingsItem(
              'Advance notice', 
              'Same day',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdvanceNoticeScreen())),
            ),
            const SizedBox(height: 12),
            _buildSettingsItem(
              'Same day advance notice', 
              '12:00 AM',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SameDayNoticeEditorScreen())),
            ),
            const SizedBox(height: 12),
            _buildSettingsItem(
              'Preparation time', 
              'None',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PreparationTimeScreen())),
            ),
            const SizedBox(height: 12),
            _buildSettingsItem(
              'Availability window', 
              '12 months in advance',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AvailabilityWindowScreen())),
            ),
            const SizedBox(height: 12),
            _buildSettingsItem(
              'More availability settings', 
              'Restrict check-in and checkout days',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RestrictedDaysEditorScreen())),
            ),
            
            const SizedBox(height: 48),
            const Text(
              'Connect calendars',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sync all of your hosting calendars so they automatically stay up to date.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            
            _buildCalendarItem(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ConnectCalendarScreen())),
            ),
            
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildTripLengthCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildLengthItem('Minimum nights', '1'),
          const Divider(height: 1, indent: 24, endIndent: 24),
          _buildLengthItem('Maximum nights', '365'),
        ],
      ),
    );
  }

  Widget _buildLengthItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(String title, String subtitle, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black, size: 24),
        ],
      ),
      ),
    );
  }

  Widget _buildCalendarItem({VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: const Row(
          children: [
            Icon(Icons.link, color: Colors.black, size: 24),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'Connect to another website',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.black, size: 24),
          ],
        ),
      ),
    );
  }
}
