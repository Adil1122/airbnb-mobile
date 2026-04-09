import 'package:flutter/material.dart';

class CheckInOutTimesScreen extends StatefulWidget {
  const CheckInOutTimesScreen({super.key});

  @override
  State<CheckInOutTimesScreen> createState() => _CheckInOutTimesScreenState();
}

class _CheckInOutTimesScreenState extends State<CheckInOutTimesScreen> {
  String _startTime = '12:00 PM';
  String _endTime = '2:00 PM';
  String _checkoutTime = '12:00 AM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
        ],
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
                    'Check-in & checkout times',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Check-in section
                  const Text(
                    'Check-in window',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField('Check in start time', _startTime, (val) {
                          if (val != null) setState(() => _startTime = val);
                        }),
                      ),
                      const SizedBox(width: 1), // Minimal gap to match border style
                      Expanded(
                        child: _buildDropdownField('Check in end time', _endTime, (val) {
                          if (val != null) setState(() => _endTime = val);
                        }),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Checkout section
                  const Text(
                    'Checkout time',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownField('Checkout select time', _checkoutTime, (val) {
                    if (val != null) setState(() => _checkoutTime = val);
                  }),
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

  Widget _buildDropdownField(String label, String value, ValueChanged<String?> onChanged) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              items: _generateTimeItems().map((String time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time, style: const TextStyle(fontSize: 16, color: Colors.black)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  List<String> _generateTimeItems() {
    return [
      '12:00 AM', '1:00 AM', '2:00 AM', '3:00 AM', '4:00 AM', '5:00 AM',
      '6:00 AM', '7:00 AM', '8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM',
      '12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM',
      '6:00 PM', '7:00 PM', '8:00 PM', '9:00 PM', '10:00 PM', '11:00 PM',
    ];
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
