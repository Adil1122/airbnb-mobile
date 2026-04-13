import 'package:flutter/material.dart';
import 'pre_booking_message_screen.dart';

class BookingSettingsEditorScreen extends StatefulWidget {
  const BookingSettingsEditorScreen({super.key});

  @override
  State<BookingSettingsEditorScreen> createState() => _BookingSettingsEditorScreenState();
}

class _BookingSettingsEditorScreenState extends State<BookingSettingsEditorScreen> {
  int _selectedIndex = 1; // Default to Instant Book as in screenshot
  bool _requireTrackRecord = true;

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
              'Booking settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            
            // 1. Approve first 3
            _buildSelectionCard(
              index: 0,
              title: 'Approve your first 3 bookings',
              status: '0 of 3 approved',
              subtitle: 'Start by reviewing reservation requests, then switch to Instant Book so guests can book automatically.',
              icon: Icons.calendar_today_outlined,
            ),
            
            const SizedBox(height: 16),
            
            // 2. Use Instant Book (with nested options)
            _buildSelectionCard(
              index: 1,
              title: 'Use Instant Book',
              subtitle: 'Let guests book automatically, which can help you get more bookings.',
              icon: Icons.bolt,
              isExpanded: _selectedIndex == 1,
              nestedContent: Column(
                children: [
                   const Divider(height: 32),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       const Expanded(
                         child: Text('Require a good track record', style: TextStyle(fontSize: 16)),
                       ),
                       Switch(
                         value: _requireTrackRecord,
                         onChanged: (val) => setState(() => _requireTrackRecord = val),
                         activeColor: Colors.black,
                       ),
                     ],
                   ),
                   const SizedBox(height: 8),
                   const Text(
                     'Only allow guests who have stayed on Airbnb without issues. Learn more',
                     style: TextStyle(fontSize: 14, color: Colors.black54, decoration: TextDecoration.underline),
                   ),
                   const SizedBox(height: 24),
                   InkWell(
                     onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PreBookingMessageScreen()),
                        );
                     },
                     child: Padding(
                       padding: const EdgeInsets.symmetric(vertical: 8.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               const Text('Add a custom message', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                               const SizedBox(height: 4),
                               Text('Guests must read this before booking.', style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.5))),
                             ],
                           ),
                           const Icon(Icons.chevron_right, size: 24),
                         ],
                       ),
                     ),
                   ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 3. Approve all bookings
            _buildSelectionCard(
              index: 2,
              title: 'Approve all bookings',
              subtitle: 'Always review reservation requests.',
              icon: Icons.forum_outlined,
            ),
            
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(140, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionCard({
    required int index,
    required String title,
    String? status,
    required String subtitle,
    required IconData icon,
    bool isExpanded = false,
    Widget? nestedContent,
  }) {
    bool isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : null,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      if (status != null) ...[
                        const SizedBox(height: 4),
                        Text(status, style: const TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                      const SizedBox(height: 8),
                      Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(icon, size: 32, color: Colors.black),
              ],
            ),
            if (isExpanded && nestedContent != null) nestedContent,
          ],
        ),
      ),
    );
  }
}

