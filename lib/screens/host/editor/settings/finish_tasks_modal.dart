import 'package:flutter/material.dart';

class FinishTasksModal extends StatelessWidget {
  const FinishTasksModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          
          // Illustration Placeholder
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=400&h=300&auto=format&fit=crop'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          const Text(
            'Finish up some final tasks',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Before you can publish your listing, you\'ll need to complete a few required steps.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.6), height: 1.4),
          ),
          
          const SizedBox(height: 32),
          
          // Let's go button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Let\'s go', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// Helper to show the modal
void showFinishTasksModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const FinishTasksModal(),
  );
}
