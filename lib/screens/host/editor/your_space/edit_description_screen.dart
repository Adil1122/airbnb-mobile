import 'package:flutter/material.dart';
import 'description_field_editor_screen.dart';
import '../../../../models/listing.dart';

class EditDescriptionScreen extends StatelessWidget {
  final Listing listing;

  const EditDescriptionScreen(this.listing, {super.key});

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
        title: const Text(
          'Description',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildNavItem(
                  context,
                  'Listing description',
                  listing.description.isEmpty ? 'Add details' : listing.description,
                  description: 'Write a quick summary of your place. You can highlight what\'s special about your space, your neighborhood, and how you\'ll interact with guests.',
                ),
                _buildNavItem(
                  context,
                  'Your property', 
                  'Add details',
                  description: 'Share a general description of your property\'s rooms and spaces so guests know what to expect.',
                ),
                _buildNavItem(
                  context,
                  'Guest access', 
                  'Add details',
                  description: 'Let guests know which parts of the space they can use.',
                ),
                _buildNavItem(
                  context,
                  'Interaction with guests', 
                  'Add details',
                  description: 'Let guests know how to get in touch if they need help during their stay.',
                ),
                _buildNavItem(
                  context,
                  'Other details to note', 
                  'Add details',
                  description: 'Include any other info you\'d like guests to know before booking your place.',
                ),
              ],
            ),
          ),
          
          // Lightbulb icon
          Positioned(
            right: 24,
            bottom: 48,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.lightbulb_outline, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, String subtitle, {required String description}) {
    bool isPlaceholder = subtitle == 'Add details';
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DescriptionFieldEditorScreen(
              listing: listing,
              title: title,
              description: description,
              initialValue: isPlaceholder ? '' : subtitle,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isPlaceholder ? Colors.black54 : Colors.grey.shade600,
                      height: 1.4,
                    ),
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
