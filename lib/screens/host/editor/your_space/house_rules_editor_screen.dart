import 'package:flutter/material.dart';
import '../arrival_guide/check_in_checkout_editor_screen.dart';

class HouseRulesEditorScreen extends StatefulWidget {
  const HouseRulesEditorScreen({super.key});

  @override
  State<HouseRulesEditorScreen> createState() => _HouseRulesEditorScreenState();
}

class _HouseRulesEditorScreenState extends State<HouseRulesEditorScreen> {
  int _guests = 4;
  
  // States for toggles (true = allowed, false = not allowed, null = not set)
  final Map<String, bool?> _rules = {
    'Pets allowed': false,
    'Events allowed': false,
    'Smoking allowed': false,
    'Quiet hours': false,
    'Photography allowed': false,
  };

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
              'House rules',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Guests are expected to follow your rules, and can be removed from Airbnb if they cause issues.',
              style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
            ),
            const SizedBox(height: 32),
            
            _buildRuleToggle(
              'Pets allowed',
              'You can refuse pets, but must reasonably accommodate service animals. Learn more',
            ),
            _buildRuleToggle('Events allowed', null),
            _buildRuleToggle('Smoking, vaping, e-cigarettes allowed', null),
            _buildRuleToggle('Quiet hours', null),
            _buildRuleToggle('Commercial photography and filming allowed', null),
            
            const SizedBox(height: 12),
            _buildGuestCounter(),
            
            const SizedBox(height: 12),
            const Divider(height: 1, color: Colors.black12),
            _buildNavLink(
              'Check-in and checkout times', 'Add details',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckInCheckoutEditorScreen())),
            ),
            const Divider(height: 1, color: Colors.black12),
            _buildNavLink('Additional rules', 'Share anything else you expect from guests.'),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade100, width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
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
                  backgroundColor: const Color(0xFFF7F7F7),
                  foregroundColor: Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
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
    );
  }

  Widget _buildRuleToggle(String title, String? subtitle) {
    String stateKey = title.contains('Smoking') ? 'Smoking allowed' : title.contains('Photography') ? 'Photography allowed' : title;
    bool? allowed = _rules[stateKey];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
              Row(
                children: [
                  _toggleButton(Icons.close, allowed == false, () => setState(() => _rules[stateKey] = false)),
                  const SizedBox(width: 12),
                  _toggleButton(Icons.check, allowed == true, () => setState(() => _rules[stateKey] = true)),
                ],
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.4),
                children: [
                  TextSpan(text: subtitle.split('Learn more').first),
                  const TextSpan(
                    text: 'Learn more',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _toggleButton(IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: isActive ? Colors.black : Colors.black12, width: isActive ? 2 : 1),
          color: Colors.white,
        ),
        child: Icon(icon, size: 20, color: isActive ? Colors.black : Colors.black54),
      ),
    );
  }

  Widget _buildGuestCounter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Number of guests',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Row(
            children: [
              _counterBtn(Icons.remove, () {
                if (_guests > 1) {
                  setState(() {
                    _guests--;
                  });
                }
              }),
              const SizedBox(width: 20),
              Text('$_guests', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 20),
              _counterBtn(Icons.add, () => setState(() => _guests++)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12),
        ),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }

  Widget _buildNavLink(String title, String subtitle, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
