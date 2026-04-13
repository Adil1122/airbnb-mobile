import 'package:flutter/material.dart';

class DiscountsEditorScreen extends StatelessWidget {
  const DiscountsEditorScreen({super.key});

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
              'Early bird discounts',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Attract early bookings by offering discounts when guests book far in advance.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
            ),
            const SizedBox(height: 24),
            _buildActionButton('Add a discount'),
            
            const SizedBox(height: 32),
            const Divider(height: 1),
            const SizedBox(height: 32),
            
            const Text(
              'Last-minute discounts',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fill your calendar by offering discounts when guests book close to their arrival date.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
            ),
            const SizedBox(height: 24),
            
            // Existing Discount Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('4% off', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  const Text('0 – 14 days before arrival', style: TextStyle(fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 16),
                  const Text(
                    'Remove',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            _buildActionButton('Add another'),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class NewListingPromotionScreen extends StatelessWidget {
  const NewListingPromotionScreen({super.key});

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
        title: const Text('New listing promotion', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const Spacer(),
            const Text(
              '20% off',
              style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
            ),
            const Text(
              'For next 3 bookings',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 48),
            const Text(
              'Need a jumpstart? Use this promotion to grab guests’ attention and get your first bookings.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
            ),
            const SizedBox(height: 48),
            
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text('What you get', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 16),
                   _buildBenefitItem('Highlighted in emails'),
                   const SizedBox(height: 12),
                   _buildBenefitItem('Discount banner on listing'),
                ],
              ),
            ),
            const Spacer(flex: 2),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF222222),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Apply promotion', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Row(
      children: [
        const Icon(Icons.check, size: 20),
        const SizedBox(width: 12),
        Text(text, style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.8))),
      ],
    );
  }
}
