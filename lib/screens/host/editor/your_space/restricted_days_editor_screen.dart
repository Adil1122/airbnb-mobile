import 'package:flutter/material.dart';

class RestrictedDaysEditorScreen extends StatefulWidget {
  const RestrictedDaysEditorScreen({super.key});

  @override
  State<RestrictedDaysEditorScreen> createState() => _RestrictedDaysEditorScreenState();
}

class _RestrictedDaysEditorScreenState extends State<RestrictedDaysEditorScreen> {
  final List<String> _days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  final Set<String> _restrictedCheckIn = {};
  final Set<String> _restrictedCheckout = {};

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
              'Restricted check-in',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Guests won\'t be able to book your place if their stay starts on these days.',
              style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: _days.map((day) => _buildDayChip(day, _restrictedCheckIn)).toList(),
            ),
            
            const SizedBox(height: 32),
            const Divider(height: 1),
            const SizedBox(height: 32),
            
            const Text(
              'Restricted checkout',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Guests won\'t be able to book your place if their stay ends on these days.',
              style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 12,
              children: _days.map((day) => _buildDayChip(day, _restrictedCheckout)).toList(),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
        ),
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

  Widget _buildDayChip(String day, Set<String> selectionSet) {
    bool isSelected = selectionSet.contains(day);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectionSet.remove(day);
          } else {
            selectionSet.add(day);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300, width: isSelected ? 2 : 1),
        ),
        child: Text(
          day,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
