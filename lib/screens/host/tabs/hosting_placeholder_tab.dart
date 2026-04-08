import 'package:flutter/material.dart';

class HostingPlaceholderTab extends StatelessWidget {
  final String title;
  const HostingPlaceholderTab({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text('$title screen coming soon', style: TextStyle(color: Colors.grey.shade600, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
