import 'package:flutter/material.dart';
import 'discounts_promotion_screens.dart';
import 'fees_editor_screen.dart';
import '../../../../models/listing.dart';
import '../../../../services/host_service.dart';

class PricingEditorScreen extends StatefulWidget {
  final Listing listing;
  const PricingEditorScreen({super.key, required this.listing});

  @override
  State<PricingEditorScreen> createState() => _PricingEditorScreenState();
}

class _PricingEditorScreenState extends State<PricingEditorScreen> {
  late TextEditingController _priceController;
  bool _isSaving = false;
  final HostService _hostService = HostService();

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: widget.listing.price.toInt().toString());
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    try {
      double newPrice = double.tryParse(_priceController.text) ?? widget.listing.price;
      await _hostService.updatePricing(widget.listing.id, {'price': newPrice});
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasChanged = _priceController.text != widget.listing.price.toInt().toString() && !_isSaving;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Pricing', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        actions: [
          if (hasChanged)
            TextButton(
              onPressed: _handleSave,
              child: const Text('Save', style: TextStyle(color: Color(0xFFE31C5F), fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text(
              'Nightly price',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text('\$', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
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
              percentage: '${widget.listing.weeklyDiscount}%',
              average: 'Weekly average is \$${(double.tryParse(_priceController.text) ?? 0) * 0.9 * 7}',
            ),
            
            const SizedBox(height: 16),
            
            _buildDiscountCard(
              title: 'Monthly',
              subtitle: 'For 28 nights or more',
              percentage: '20%',
              average: 'Monthly average is \$${(double.tryParse(_priceController.text) ?? 0) * 0.8 * 28}',
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
