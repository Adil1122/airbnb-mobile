import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Traveling', 'Support'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: _buildCircularIcon(Icons.search),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: _buildCircularIcon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Messages',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),
            
            // Filter Chips Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_filters.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildFilterChip(index),
                  );
                }),
              ),
            ),
            
            const Spacer(),
            
            // Empty State
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 64,
                    color: Colors.black87,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "You don't have any messages",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "When you receive a new message, it will appear here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black12),
      ),
      child: Icon(icon, color: Colors.black, size: 24),
    );
  }

  Widget _buildFilterChip(int index) {
    final isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF222222) : const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.black12,
            width: 1,
          ),
        ),
        child: Text(
          _filters[index],
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
