import 'package:flutter/material.dart';

class GuestRequirementsScreen extends StatefulWidget {
  const GuestRequirementsScreen({super.key});

  @override
  State<GuestRequirementsScreen> createState() => _GuestRequirementsScreenState();
}

class _GuestRequirementsScreenState extends State<GuestRequirementsScreen> {
  bool _requirePhoto = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox.shrink(),
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Guest requirements',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  
                  // Featured Toggle Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Require a profile photo',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.6), height: 1.5),
                            children: [
                              const TextSpan(text: 'When turned on, guests who book your listing need a profile photo. You\'ll only see it after their booking is confirmed. '),
                              TextSpan(
                                text: 'Learn more',
                                style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Custom Large Toggle
                        GestureDetector(
                          onTap: () => setState(() => _requirePhoto = !_requirePhoto),
                          child: Container(
                            width: 80,
                            height: 44,
                            decoration: BoxDecoration(
                              color: _requirePhoto ? Colors.black : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 200),
                              alignment: _requirePhoto ? Alignment.centerRight : Alignment.centerLeft,
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
                    'All Airbnb guests are required to:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  
                  _buildRequirementBullet('Provide a confirmed email address and phone number'),
                  _buildRequirementBullet('Provide payment information'),
                  _buildRequirementBullet('Agree to your house rules'),
                  
                  const SizedBox(height: 32),
                  const Row(
                    children: [
                      Text(
                        'Learn more',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 20),
                    ],
                  ),
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

  Widget _buildRequirementBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: Colors.grey.shade600, shape: BoxShape.circle),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
