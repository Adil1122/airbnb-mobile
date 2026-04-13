import 'package:flutter/material.dart';

class ArrivalPreviewScreen extends StatelessWidget {
  const ArrivalPreviewScreen({super.key});

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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
              child: Text(
                'Your stay in Islamabad',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            
            // Hero Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 300,
                  width: double.infinity,
                  color: const Color(0xFF1A1D2D), // Deep blue from screenshot
                  child: Center(
                    child: Icon(Icons.camera_alt_outlined, size: 64, color: Colors.white.withOpacity(0.3)),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: index == 0 ? Colors.grey.shade400 : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                )),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Check-in / Checkout
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTimeInfo('Check-in', '3:00 PM'),
                  ),
                  Container(height: 48, width: 1, color: Colors.grey.shade100),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildTimeInfo('Checkout', '11:00 AM', crossAxisAlignment: CrossAxisAlignment.end),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            const Divider(height: 1, color: Colors.black12),
            
            // Getting there
            _buildInfoRow(
              icon: Icons.location_on_outlined,
              title: 'Getting there',
              subtitle: 'Address: Islamabad Expressway',
            ),
            
            const Divider(height: 1, color: Colors.black12),
            
            // Things to know
            _buildInfoRow(
              icon: Icons.menu_book_outlined,
              title: 'Things to know',
              subtitle: 'Instructions and house rules',
            ),
            
            const Divider(height: 1, color: Colors.black12),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String label, String time, {CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(time, style: const TextStyle(fontSize: 16, color: Colors.black54)),
      ],
    );
  }

  Widget _buildInfoRow({required IconData icon, required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
