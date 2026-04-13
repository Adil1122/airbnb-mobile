import 'package:flutter/material.dart';
import 'discounts_promotion_screens.dart';
import 'fees_editor_screen.dart';

class PricingEditorScreen extends StatelessWidget {
  const PricingEditorScreen({super.key});

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
              'Adjust your pricing to attract more guests.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            
            _buildDiscountCard(
              title: 'Weekly',
              subtitle: 'For 7 nights or more',
              percentage: '10%',
              average: 'Weekly average is \$167',
            ),
            
            const SizedBox(height: 16),
            
            _buildDiscountCard(
              title: 'Monthly',
              subtitle: 'For 28 nights or more',
              percentage: '20%',
              average: 'Monthly average is \$630',
            ),
            
            const SizedBox(height: 16),
            
            _buildActionItem(
              title: 'Set up discounts',
              subtitle: 'Early bird, last-minute',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DiscountsEditorScreen())),
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'Promotions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Set short-term discounts to get new bookings.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            
            _buildActionItem(
              title: 'Add new listing promotion',
              subtitle: 'Get your first guests in the door',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NewListingPromotionScreen())),
            ),
            
            const SizedBox(height: 48),
            
            const Text(
              'Additional charges',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            _buildActionItem(
              title: 'Fees',
              subtitle: 'Cleaning, pets, extra guests',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FeesEditorScreen())),
            ),
            
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountCard({
    required String title,
    required String subtitle,
    required String percentage,
    required String average,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                percentage,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                average,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black, size: 24),
        ],
      ),
     ),
    );
  }
}
