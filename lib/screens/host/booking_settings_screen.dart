import 'package:flutter/material.dart';

class BookingSettingsScreen extends StatefulWidget {
  const BookingSettingsScreen({super.key});

  @override
  State<BookingSettingsScreen> createState() => _BookingSettingsScreenState();
}

class _BookingSettingsScreenState extends State<BookingSettingsScreen> {
  bool _useInstantBook = true;
  bool _requireTrackRecord = false;

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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking settings',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Instant Book Card
                  _buildSelectionCard(
                    title: 'Use Instant Book',
                    description: 'Let guests book automatically, which can help you get more bookings.',
                    icon: Icons.flash_on,
                    isSelected: _useInstantBook,
                    onTap: () => setState(() => _useInstantBook = true),
                    child: _useInstantBook ? _buildInstantBookOptions() : null,
                  ),

                  const SizedBox(height: 16),

                  // Approve All Card
                  _buildSelectionCard(
                    title: 'Approve all bookings',
                    description: 'Always review reservation requests.',
                    icon: Icons.chat_bubble_outline,
                    isSelected: !_useInstantBook,
                    onTap: () => setState(() => _useInstantBook = false),
                  ),
                ],
              ),
            ),
          ),
          
          // Sticky Footer
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    Widget? child,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(icon, size: 32, color: Colors.black),
                ],
              ),
            ),
            if (child != null) ...[
              const Divider(height: 1),
              child,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInstantBookOptions() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Require a good track record',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
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
            style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add a custom message',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Guests must read this before booking.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
