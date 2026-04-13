import 'package:flutter/material.dart';

class CancellationPolicyEditorScreen extends StatefulWidget {
  const CancellationPolicyEditorScreen({super.key});

  @override
  State<CancellationPolicyEditorScreen> createState() => _CancellationPolicyEditorScreenState();
}

class _CancellationPolicyEditorScreenState extends State<CancellationPolicyEditorScreen> {
  bool _nonRefundable = false;

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
              'Cancellation policies',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
                children: [
                  TextSpan(text: 'Review the full policies in the '),
                  TextSpan(
                    text: 'Help Center',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(text: '.'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            const Text(
              'Short-term stays',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Applies to stays under 28 nights. All standard stay policies include a 24-hour free cancellation period.',
              style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
            ),
            const SizedBox(height: 24),
            
            _buildPolicySelector('Your policy', 'Flexible'),
            const SizedBox(height: 12),
            _buildNonRefundableSwitch(),
            
            const SizedBox(height: 48),
            const Text(
              'Long-term stays',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Applies to stays 28 nights or longer.',
              style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
            ),
            const SizedBox(height: 24),
            
            _buildPolicySelector('Your policy', 'Firm Long Term'),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySelector(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildNonRefundableSwitch() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Non-refundable option',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Switch(
                value: _nonRefundable,
                onChanged: (val) => setState(() => _nonRefundable = val),
                activeColor: Colors.black,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Guests can pay 10% less in exchange for you keeping your full payout if they cancel.',
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 4),
          const Text(
            'Learn more',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
