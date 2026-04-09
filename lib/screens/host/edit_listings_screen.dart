import 'package:flutter/material.dart';
import 'amenities_management_screen.dart';
import 'booking_settings_screen.dart';
import 'check_in_out_times_screen.dart';

class EditListingsScreen extends StatelessWidget {
  final int selectedCount;

  const EditListingsScreen({
    super.key,
    required this.selectedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Close Icon
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Edit $selectedCount listing${selectedCount == 1 ? '' : 's'}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ),

          const SizedBox(height: 32),

          _buildMenuItem(context, 'Amenities', onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AmenitiesManagementScreen()),
            );
          }),
          _buildMenuItem(context, 'Booking Settings', onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookingSettingsScreen()),
            );
          }),
          _buildMenuItem(context, 'Check-in & checkout times', onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CheckInOutTimesScreen()),
            );
          }),

          const SizedBox(height: 48), // Padding at bottom
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, {VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.black54),
          onTap: onTap,
        ),
        // No divider here based on screenshot, but adding subtle padding
        const SizedBox(height: 8),
      ],
    );
  }
}
