import 'package:flutter/material.dart';

class ServiceFeeSettingsScreen extends StatefulWidget {
  const ServiceFeeSettingsScreen({super.key});

  @override
  State<ServiceFeeSettingsScreen> createState() => _ServiceFeeSettingsScreenState();
}

class _ServiceFeeSettingsScreenState extends State<ServiceFeeSettingsScreen> {
  String _selectedFee = 'split'; // Default as per screenshot

  final Color _tealColor = const Color(0xFF008489);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service fee settings',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Choose a service fee pricing option for all of your listings.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Single Fee Option
                _buildFeeOption(
                  'single',
                  'Single fee',
                  'Airbnb will deduct 15.5% from each payout. Guests won\'t be charged a service fee—the price you set is the price guests get.',
                  hasBadge: true,
                ),
                
                const Divider(height: 48, thickness: 1, color: Color(0xFFF0F0F0)),
                
                // Split Fee Option
                _buildFeeOption(
                  'split',
                  'Split fee',
                  'Airbnb deducts 3% from your earnings, and guests pay a 14.1%-16.5% service fee on top of all host charges, including nightly prices, cleaning fees, and pet fees.',
                ),
                
                const SizedBox(height: 48),
                
                // Guidance Info Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.home_outlined, color: _tealColor, size: 32),
                          const SizedBox(width: 8),
                          Icon(Icons.monetization_on_outlined, color: _tealColor, size: 24),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Same payout, simpler pricing',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'You can make the same amount of money and your guests won\'t pay more. Just choose simplified pricing and adjust your prices accordingly.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          'Check out an example',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _tealColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 120), // Spacing for bottom bar
              ],
            ),
          ),
          
          // Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFF0F0F0), width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _tealColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _tealColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildFeeOption(String type, String title, String description, {bool hasBadge = false}) {
    bool isSelected = _selectedFee == type;
    
    return InkWell(
      onTap: () => setState(() => _selectedFee = type),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (hasBadge) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'RECOMMENDED',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? _tealColor : Colors.white,
              border: Border.all(
                color: isSelected ? _tealColor : const Color(0xFFDDDDDD),
                width: 2,
              ),
            ),
            child: isSelected 
              ? const Icon(Icons.check, color: Colors.white, size: 20)
              : null,
          ),
        ],
      ),
    );
  }
}
