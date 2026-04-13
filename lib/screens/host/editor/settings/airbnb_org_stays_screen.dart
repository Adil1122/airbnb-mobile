import 'package:flutter/material.dart';

class AirbnbOrgStaysScreen extends StatefulWidget {
  const AirbnbOrgStaysScreen({super.key});

  @override
  State<AirbnbOrgStaysScreen> createState() => _AirbnbOrgStaysScreenState();
}

class _AirbnbOrgStaysScreenState extends State<AirbnbOrgStaysScreen> {
  bool _isEnabled = false;

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
        title: const Text(
          'Airbnb.org stays',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  
                  // Branded Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        // Branded Logo text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'airbnb',
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFFF385C)),
                            ),
                            Text(
                              '.org',
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Available for Airbnb.org guests for free or at a discount',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, height: 1.4),
                        ),
                        const SizedBox(height: 32),
                        
                        // Large Toggle
                        GestureDetector(
                          onTap: () => setState(() => _isEnabled = !_isEnabled),
                          child: Container(
                            width: 80,
                            height: 44,
                            decoration: BoxDecoration(
                              color: _isEnabled ? Colors.black : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 200),
                              alignment: _isEnabled ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  const Text(
                    'How Airbnb.org stays work',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  
                  _buildBullet('When hosting for free or at a discount, you review each request before accepting, and declining a request won\'t affect your Superhost status.'),
                  _buildBullet('Airbnb.org or its partner checks guests\' eligibility.'),
                  _buildBullet('Airbnb.org\'s partners may send requests on behalf of their clients.'),
                  _buildBullet('Stays can vary in length from a few days to a few weeks.'),
                  
                  const SizedBox(height: 32),
                  const Text(
                    'Learn more about Airbnb.org >',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // Sticky Footer
          Container(
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
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
