import 'package:flutter/material.dart';
import '../../profile/become_host_screen.dart';

class CreateListingScreen extends StatelessWidget {
  const CreateListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: const Text('Exit', style: TextStyle(fontSize: 14)),
          ),
        ),
        leadingWidth: 80,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
              child: Text(
                'Welcome back, Ahmad',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Finish your listing',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildDraftCard(context, 'Your House listing'),
            _buildDraftCard(context, 'Your House listing'),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
              child: Divider(),
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Start a new listing',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildNewListingItem(context, Icons.add_home_outlined, 'Create a new listing'),
            _buildNewListingItem(context, Icons.copy_outlined, 'Create from an existing listing'),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildDraftCard(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BecomeHostScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.home, color: Colors.black, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildNewListingItem(BuildContext context, IconData icon, String title) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          leading: Icon(icon, color: Colors.black87, size: 28),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 24),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BecomeHostScreen()),
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Divider(height: 1),
        ),
      ],
    );
  }
}
