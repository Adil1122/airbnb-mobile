import 'package:flutter/material.dart';
import 'safety_sub_editor_screen.dart';

class GuestSafetyEditorScreen extends StatelessWidget {
  const GuestSafetyEditorScreen({super.key});

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
              'Guest safety',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'The safety details you share will appear on your listing, along with information like your House Rules.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            _buildSafetyItem(
              'Safety considerations', 
              'Add details',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SafetySubEditorScreen(
                title: 'Safety considerations',
                items: [
                  SafetyItem(title: 'Not a good fit for children 2 – 12', description: 'This property has features that may not be safe for kids.'),
                  SafetyItem(title: 'Not a good fit for infants under 2', description: 'This property has features that may not be safe for babies or toddlers this age.'),
                  SafetyItem(title: 'Pool or hot tub doesn\'t have a gate or lock', description: 'Guests have access to an unsecured swimming pool or hot tub. Check your local laws for specific requirements.'),
                  SafetyItem(title: 'Nearby water, like a lake or river', description: 'Guests have unrestricted access to a body of water, like an ocean, pond, creek, or wetlands, directly on or next to the property.'),
                  SafetyItem(title: 'Climbing or play structure(s) on the property', description: 'Guests will have access to structures like a playset, slide, swings, or climbing ropes.'),
                  SafetyItem(title: 'There are heights without rails or protection', description: 'Guests have access to an area higher than 30 inches (76 centimeters), like a balcony, roof, terrace, or cliff, that doesn\'t have a rail or other protection.'),
                  SafetyItem(title: 'Potentially dangerous animal(s) on the property', description: 'Guests and their pets will be around animals, like a horse, mountain lion, or farm animal, that could cause harm.'),
                ],
              ))),
            ),
            _buildSafetyItem(
              'Safety devices', 
              'Add details',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SafetySubEditorScreen(
                title: 'Safety devices',
                items: [
                  SafetyItem(title: 'Exterior security camera present', description: 'This property has one or more exterior cameras that record or transmit video, images, or audio. You must disclose them if they\'re turned off.'),
                  SafetyItem(title: 'Carbon monoxide alarm', description: 'A device that alerts if it detects unsafe levels of carbon monoxide (Check your local laws, which may require a working carbon monoxide detector in your listing)'),
                  SafetyItem(title: 'Smoke alarm', description: 'A device that alerts when it detects smoke (Check your local laws, which may require a working smoke detector in your listing)'),
                  SafetyItem(title: 'Noise decibel monitor present', description: 'This property has one or more devices that can assess sound level but don\'t record audio.'),
                ],
              ))),
            ),
            _buildSafetyItem(
              'Property info', 
              'Add details',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SafetySubEditorScreen(
                title: 'Property info',
                items: [
                  SafetyItem(title: 'Guests must climb stairs', description: 'Guests should expect to walk up and down stairs during their stay.', hasLearnMore: false),
                  SafetyItem(title: 'Potential noise during stays', description: 'Guests should expect to hear some noise during their stay. For example, traffic, construction, or nearby businesses.', hasLearnMore: false),
                  SafetyItem(title: 'Pet(s) live on the property', description: 'Guests may meet or interact with pets during their stay.', hasLearnMore: false),
                  SafetyItem(title: 'No parking on the property', description: 'This property doesn\'t have dedicated parking spots for guests.', hasLearnMore: false),
                  SafetyItem(title: 'Property has shared spaces', description: 'Guests should expect to share spaces, like a kitchen, bathroom, or patio, with other people during their stay.', hasLearnMore: false),
                  SafetyItem(title: 'Limited essential amenities', description: 'Some common essentials are not included on this property. For example, wifi, running water, indoor shower.', hasLearnMore: false),
                  SafetyItem(title: 'Weapon(s) on the property', description: 'There\'s at least one weapon stored on this property. Check your local laws for specific requirements.'),
                ],
              ))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyItem(String title, String subtitle, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
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
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
