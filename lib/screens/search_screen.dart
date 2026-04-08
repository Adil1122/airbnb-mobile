import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _selectedCategoryIndex = 0;
  final List<Map<String, dynamic>> _categories = [
    {'label': 'Homes', 'icon': Icons.home_outlined},
    {'label': 'Experiences', 'icon': Icons.wb_sunny_outlined},
    {'label': 'Services', 'icon': Icons.notifications_none_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation & Close
            _buildTopNav(),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // "Where?" Section (Expanded)
                    _buildExpandedWhereSection(),
                    
                    const SizedBox(height: 16),
                    // "When" Card (Collapsed)
                    _buildCollapsedCard('When', 'Add dates'),
                    
                    const SizedBox(height: 16),
                    // "Who" Card (Collapsed)
                    _buildCollapsedCard('Who', 'Add guests'),
                    
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
            
            // Bottom Action Bar
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48), // Spacer to balance Close button
          Row(
            children: List.generate(_categories.length, (index) {
              final isSelected = _selectedCategoryIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategoryIndex = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _categories[index]['icon'],
                        color: isSelected ? Colors.black : Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _categories[index]['label'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black12),
              ),
              child: const Icon(Icons.close, size: 20, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedWhereSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Where?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Search Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.black87),
                SizedBox(width: 12),
                Text(
                  'Search destinations',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Suggested destinations',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSuggestionItem(Icons.near_me_outlined, 'Nearby', 'Find what\'s around you', Colors.blue.shade50, Colors.blue),
          _buildSuggestionItem(Icons.location_city_outlined, 'Islamabad', 'For sights like Faisal Mosque', Colors.orange.shade50, Colors.orange),
          _buildSuggestionItem(Icons.apartment_outlined, 'Lahore', 'Popular with travelers near you', Colors.green.shade50, Colors.green),
          _buildSuggestionItem(Icons.terrain_outlined, 'Rawalpindi', 'Near you', Colors.deepOrange.shade50, Colors.deepOrange),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(IconData icon, String title, String subtitle, Color bgColor, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedCard(String title, String action) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          Text(
            action,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Clear all',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE31C5F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Row(
              children: [
                Icon(Icons.search, size: 20),
                SizedBox(width: 8),
                Text(
                  'Search',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
