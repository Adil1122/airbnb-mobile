import 'package:flutter/material.dart';

class ReferHostScreen extends StatefulWidget {
  const ReferHostScreen({super.key});

  @override
  State<ReferHostScreen> createState() => _ReferHostScreenState();
}

class _ReferHostScreenState extends State<ReferHostScreen> {
  int _selectedIndex = 0;

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8, bottom: 8),
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF0F0F0),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text('Your referrals', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                const Text(
                  'Refer a host,\nearn a cash reward',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'What type of host are you referring?',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Selection Cards
                _buildSelectionCard(0, 'Home', '', 'https://cdn-icons-png.flaticon.com/512/619/619153.png'),
                _buildSelectionCard(1, 'Experience', 'You\'ll earn \$50.', 'https://cdn-icons-png.flaticon.com/512/3222/3222687.png'),
                _buildSelectionCard(2, 'Service', 'You\'ll earn \$100.', 'https://cdn-icons-png.flaticon.com/512/1066/1066371.png'),
                
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'How host referrals work',
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 180), // Space for sticky button and footer
              ],
            ),
          ),
          
          // Sticky Bottom Section
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                border: Border(top: BorderSide(color: Colors.grey.shade100)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE31C5F), // Airbnb Red
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Copy referral link',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Eligible locations and listing types only. Amounts expire Jun. 21, 2026. Terms apply',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard(int index, String title, String subtitle, String iconUrl) {
    bool isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
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
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Image.network(iconUrl, width: 48, height: 48),
          ],
        ),
      ),
    );
  }
}
