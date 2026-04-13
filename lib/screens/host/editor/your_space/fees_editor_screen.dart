import 'package:flutter/material.dart';

class FeesEditorScreen extends StatelessWidget {
  const FeesEditorScreen({super.key});

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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Cleaning fee',
              items: [
                _buildFeeItem(label: 'Per stay', value: '\$0'),
                _buildActionItem(label: 'Amount for short stays', detail: 'Attract guests booking 1 or 2 nights by setting a lower cleaning fee.'),
              ],
            ),
            const Divider(height: 1, thickness: 8, color: Color(0xFFF7F7F7)),
            _buildSection(
              title: 'Pet fee',
              items: [
                _buildFeeItem(label: 'Per stay', value: '\$0'),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Service animals stay for free. Learn more',
                    style: TextStyle(fontSize: 12, color: Colors.black54, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            const Divider(height: 1, thickness: 8, color: Color(0xFFF7F7F7)),
            _buildSection(
              title: 'Extra guest fee',
              items: [
                _buildFeeItem(label: 'After 1 guest, per night', value: '\$0'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ...items,
        ],
      ),
    );
  }

  Widget _buildFeeItem({required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionItem({required String label, required String detail}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
              const Text('Add', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
            ],
          ),
          const SizedBox(height: 4),
          Text(detail, style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.4)),
        ],
      ),
    );
  }
}
