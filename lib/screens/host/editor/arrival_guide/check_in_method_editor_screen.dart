import 'package:flutter/material.dart';

class CheckInMethodEditorScreen extends StatefulWidget {
  const CheckInMethodEditorScreen({super.key});

  @override
  State<CheckInMethodEditorScreen> createState() => _CheckInMethodEditorScreenState();
}

class _CheckInMethodEditorScreenState extends State<CheckInMethodEditorScreen> {
  int _selectedIndex = -1;

  final List<Map<String, dynamic>> _methods = [
    {
      'title': 'Smart lock',
      'subtitle': 'Guests will use a code or app to open a wifi-connected lock.',
      'icon': Icons.lock_outline,
    },
    {
      'title': 'Keypad',
      'subtitle': 'Guests will use the code you provide to open an electronic lock.',
      'icon': Icons.keyboard_alt_outlined,
    },
    {
      'title': 'Lockbox',
      'subtitle': 'Guests will use a code you provide to open a small safe that has a key inside.',
      'icon': Icons.inventory_2_outlined,
    },
    {
      'title': 'Building staff',
      'subtitle': 'Someone will be available 24 hours a day to let guests in.',
      'icon': Icons.person_outline,
    },
    {
      'title': 'In-person greeting',
      'subtitle': 'Guests will meet you or your co-host to pick up keys.',
      'icon': Icons.vpn_key_outlined,
    },
    {
      'title': 'Other',
      'subtitle': 'Guests will use a different method not listed here.',
      'icon': Icons.more_horiz_outlined,
    },
  ];

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
              'Choose a check-in method',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            
            ...List.generate(_methods.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildMethodCard(index),
              );
            }),
            
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodCard(int index) {
    bool isSelected = _selectedIndex == index;
    var method = _methods[index];
    
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(method['icon'], size: 32, color: Colors.black),
            const SizedBox(height: 16),
            Text(
              method['title'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              method['subtitle'],
              style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
