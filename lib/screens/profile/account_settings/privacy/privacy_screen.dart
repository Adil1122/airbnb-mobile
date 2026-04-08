import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _showReadReceipts = true;
  bool _includeInSearch = false;
  bool _showHomeCity = true;
  bool _showTripType = true;
  bool _showLengthOfStay = true;
  bool _showBookedServices = true;
  bool _improveAI = true;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Control how your information is used and shared with others on Airbnb.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            
            // Messages Section
            const Text('Messages', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildPrivacySwitch(
              title: 'Show people when I\'ve read their messages.',
              subtitle: 'Learn more',
              value: _showReadReceipts,
              onChanged: (val) => setState(() => _showReadReceipts = val),
              underlineSubtitle: true,
            ),
            const Divider(height: 64, thickness: 1, color: Color(0xFFF0F0F0)),
            
            // Listings Section
            const Text('Listings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildPrivacySwitch(
              title: 'Include my listing(s) in search engines',
              subtitle: 'Turning this on means search engines, like Google, will display your listing page(s) in search results.',
              value: _includeInSearch,
              onChanged: (val) => setState(() => _includeInSearch = val),
            ),
            const Divider(height: 64, thickness: 1, color: Color(0xFFF0F0F0)),
            
            // Reviews Section
            const Text('Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
                children: [
                  TextSpan(text: 'Choose what\'s shared when you write a review. Updating this setting will affect both past and future reviews. '),
                  TextSpan(
                    text: 'Learn more',
                    style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildPrivacySwitch(
              title: 'Show my home city and country',
              subtitle: 'Ex: City and country',
              value: _showHomeCity,
              onChanged: (val) => setState(() => _showHomeCity = val),
            ),
            const SizedBox(height: 32),
            _buildPrivacySwitch(
              title: 'Show my trip type',
              subtitle: 'Ex: Stayed with kids or pets',
              value: _showTripType,
              onChanged: (val) => setState(() => _showTripType = val),
            ),
            const SizedBox(height: 32),
            _buildPrivacySwitch(
              title: 'Show my length of stay',
              subtitle: 'Ex: A few nights, about a week, etc.',
              value: _showLengthOfStay,
              onChanged: (val) => setState(() => _showLengthOfStay = val),
            ),
            const SizedBox(height: 32),
            _buildPrivacySwitch(
              title: 'Show my booked services',
              subtitle: 'Ex: Gourmet brunch or tasting menu',
              value: _showBookedServices,
              onChanged: (val) => setState(() => _showBookedServices = val),
            ),
            const Divider(height: 64, thickness: 1, color: Color(0xFFF0F0F0)),
            
            // Data privacy Section
            const Text('Data privacy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            
            _buildActionBox('Request my personal data'),
            const SizedBox(height: 32),
            
            _buildPrivacySwitch(
              title: 'Help improve AI-powered features',
              subtitle: 'When this is on, we use your data to develop and improve AI models that power certain features on Airbnb. Learn more',
              value: _improveAI,
              onChanged: (val) => setState(() => _improveAI = val),
            ),
            const SizedBox(height: 32),
            _buildActionBox('Delete my account'),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySwitch({
    required String title, 
    required String subtitle, 
    required bool value, 
    required ValueChanged<bool> onChanged,
    bool underlineSubtitle = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title, 
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle, 
                style: TextStyle(
                  fontSize: 14, 
                  color: Colors.black54, 
                  height: 1.4,
                  decoration: underlineSubtitle ? TextDecoration.underline : null,
                  fontWeight: underlineSubtitle ? FontWeight.bold : null,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _buildAirbnbSwitch(value, onChanged),
      ],
    );
  }

  Widget _buildAirbnbSwitch(bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: value ? Colors.black : const Color(0xFFB0B0B0),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: value ? 20 : 2,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: value 
                  ? const Icon(Icons.check, size: 16, color: Colors.black)
                  : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBox(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
