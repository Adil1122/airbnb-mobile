import 'package:flutter/material.dart';

class LocalLawsScreen extends StatelessWidget {
  const LocalLawsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Local laws',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Take a moment to review the local laws that apply to your listing. We want to make sure you have everything you need to get off to a great start.',
              style: TextStyle(fontSize: 16, color: Colors.black, height: 1.4),
            ),
            const SizedBox(height: 32),
            
            // Regulation Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1541746972996-4e0b0f43e02a?q=80&w=200&h=200&auto=format&fit=crop'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '2 min read',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'What hosting regulations apply to you?',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.black),
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            
            _buildInfoParagraph('Most cities have rules covering homesharing, and the specific codes and ordinances can appear in many places (such as zoning, building, licensing or tax codes). In most places, you must register, get a permit, or obtain a license before you list your property or accept guests. You may also be responsible for collecting and remitting certain taxes. In some places, short-term rentals could be prohibited altogether.'),
            
            _buildInfoParagraph('Since you are responsible for your own decision to list or book, you should get comfortable with the applicable rules before listing on Airbnb. To get you started, we offer some helpful resources under "Your City Laws."'),
            
            const Text(
              'Learn more about responsible hosting',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
            ),
            const SizedBox(height: 24),
            
            const Text(
              'By accepting our Terms of Service and listing your space, you certify that you will follow applicable laws and regulations.',
              style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.6),
      ),
    );
  }
}
