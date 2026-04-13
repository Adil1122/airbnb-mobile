import 'package:flutter/material.dart';

class SameDayNoticeEditorScreen extends StatefulWidget {
  const SameDayNoticeEditorScreen({super.key});

  @override
  State<SameDayNoticeEditorScreen> createState() => _SameDayNoticeEditorScreenState();
}

class _SameDayNoticeEditorScreenState extends State<SameDayNoticeEditorScreen> {
  String _selectedTime = '12:00 PM';
  
  final List<String> _times = [
    '6:00 AM', '7:00 AM', '8:00 AM', '9:00 AM', '10:00 AM',
    '11:00 AM', '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM',
    '4:00 PM', '5:00 PM', '6:00 PM', '7:00 PM', '8:00 PM',
    '9:00 PM', '10:00 PM', '11:00 PM'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Same day advance notice',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Guests can book on the same day as check-in until this time.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
            ),
            const SizedBox(height: 32),
            ..._times.map((time) => _buildRadioItem(time)),
            const SizedBox(height: 48),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade100))),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF222222),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildRadioItem(String title) {
    bool isSelected = _selectedTime == title;
    return InkWell(
      onTap: () => setState(() => _selectedTime = title),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey.shade400,
                  width: isSelected ? 8 : 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConnectCalendarScreen extends StatelessWidget {
  const ConnectCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connect to another website',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
                children: [
                  TextSpan(text: 'This two-way connection will update both calendars when a night is booked. If this is your first time doing this, get detailed instructions in our '),
                  TextSpan(text: 'Help Center', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                  TextSpan(text: '.'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            const Text('Step 1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Add this link to the other website.', style: TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Airbnb calendar link', style: TextStyle(fontSize: 12, color: Colors.black54)),
                        SizedBox(height: 4),
                        Text('https://www.airbnb.com/calen...', style: TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF222222),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Copy'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            
            const Text('Step 2', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Get a link ending in .ics from the other website and add it below.', style: TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 16),
            
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: const Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Other website link',
                      contentPadding: EdgeInsets.all(20),
                      border: InputBorder.none,
                    ),
                  ),
                  Divider(height: 1),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Calendar name',
                      contentPadding: EdgeInsets.all(20),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade100))),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF7F7F7),
            foregroundColor: Colors.grey.shade400,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: const Text('Add calendar', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
