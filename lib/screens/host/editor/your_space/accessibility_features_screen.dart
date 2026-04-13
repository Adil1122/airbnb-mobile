import 'package:flutter/material.dart';
import 'accessibility_feature_editor_screen.dart';

class AccessibilityFeaturesScreen extends StatelessWidget {
  const AccessibilityFeaturesScreen({super.key});

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
          'Accessibility features',
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
                _buildAccessibilityItem(
                  context,
                  Icons.directions_car_filled_outlined, 
                  'Disabled parking spot',
                  description: 'There\'s a private parking spot at least 11 feet (3.35 meters) wide. Or, there is public parking spot designated for a person with disabilities that has clear signage or markings.',
                  images: ['https://images.unsplash.com/photo-1590674852885-ca39974528b7?auto=format&fit=crop&q=80&w=600', 'https://images.unsplash.com/photo-1545179605-1296651e9d43?auto=format&fit=crop&q=80&w=600'],
                ),
                _buildAccessibilityItem(
                  context,
                  Icons.lightbulb_outline, 
                  'Lit path to the guest entrance',
                  description: 'The sidewalk or path that leads to the guest entrance is well lit at night.',
                  images: ['https://images.unsplash.com/photo-1564013799919-ab600027ffc6?auto=format&fit=crop&q=80&w=600', 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&q=80&w=600'],
                ),
                _buildAccessibilityItem(
                  context,
                  Icons.stairs_outlined, 
                  'Step-free access',
                  description: 'There are no steps, stairs, or curbs on the entire path from a guest\'s arrival to the listing entrance. Any door thresholds must be less than 2 inches (5 cm) high.',
                  images: ['https://images.unsplash.com/photo-1582268611958-ebaf16156271?auto=format&fit=crop&q=80&w=600', 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&q=80&w=600'],
                ),
                _buildAccessibilityItem(
                  context,
                  Icons.door_front_door_outlined, 
                  'Guest entrance wider than 32 inches',
                  description: 'The guest entryway is at least 32 inches (81 centimeters) wide.',
                  images: ['https://images.unsplash.com/photo-1506332033341-61fb3a2773b1?auto=format&fit=crop&q=80&w=600'],
                ),
                _buildAccessibilityItem(
                  context,
                  Icons.pool_outlined, 
                  'Swimming pool or hot tub hoist',
                  description: 'There\'s a device specifically designed to lift someone in and out of the swimming pool or hot tub.',
                  images: ['https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?auto=format&fit=crop&q=80&w=600'],
                ),
                _buildAccessibilityItem(
                  context,
                  Icons.accessible_outlined, 
                  'Ceiling or mobile hoist',
                  description: 'There\'s a device specifically designed to lift someone in and out of a wheelchair. It\'s either fixed to the ceiling or freestanding.',
                  images: ['https://images.unsplash.com/photo-1516549655169-df83a0774514?auto=format&fit=crop&q=80&w=600'],
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

  Widget _buildAccessibilityItem(BuildContext context, IconData icon, String title, {required String description, required List<String> images}) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccessibilityFeatureEditorScreen(
              title: title,
              description: description,
              imageExamples: images,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.black),
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Icon(Icons.add, size: 20, color: Colors.black),
          ),
        ],
      ),
     ),
    );
  }
}
