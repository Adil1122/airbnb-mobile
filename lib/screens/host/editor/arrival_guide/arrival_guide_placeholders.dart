import 'package:flutter/material.dart';

// Wifi Details
class WifiDetailsEditorScreen extends StatefulWidget {
  const WifiDetailsEditorScreen({super.key});

  @override
  State<WifiDetailsEditorScreen> createState() => _WifiDetailsEditorScreenState();
}

class _WifiDetailsEditorScreenState extends State<WifiDetailsEditorScreen> {
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
        title: const Text('Wifi details', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            _buildTextField('Wifi network name'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF222222),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Use "Aquilas Tech"', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 32),
            _buildTextField('Wifi password'),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.access_time, size: 20, color: Colors.grey.shade600),
                const SizedBox(width: 12),
                Text('Shared 24 - 48 hours before check-in', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildTextField(String hint) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black45),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
      ),
    );
  }
}

// House Manual
class HouseManualEditorScreen extends StatelessWidget {
  const HouseManualEditorScreen({super.key});
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
        title: const Text('House manual', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              'Give guests tips about your space, like how to access the internet and use the TV.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
            ),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.access_time, size: 20, color: Colors.grey.shade600),
                const SizedBox(width: 12),
                Text('Shared 24 - 48 hours before check-in', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }
}

// Checkout Instructions
class CheckoutInstructionsEditorScreen extends StatelessWidget {
  const CheckoutInstructionsEditorScreen({super.key});
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Checkout instructions',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
                    children: [
                      TextSpan(text: 'Explain what\'s essential for guests to do before they leave. Anyone can read these before they book. '),
                      TextSpan(text: 'Learn more', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7F7F7),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 8),
                      Text('Add instructions', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 24,
            bottom: 32,
            child: _buildLightbulb(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }
}

// Guidebooks
class GuidebooksEditorScreen extends StatelessWidget {
  const GuidebooksEditorScreen({super.key});
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black, size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Guidebooks',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
                children: [
                  TextSpan(text: 'Create a guidebook to easily share local tips with guests. '),
                  TextSpan(text: 'Read our content policy', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: _buildGuideImage('https://images.unsplash.com/photo-1518780664697-55e3ad937233?auto=format&fit=crop&q=80&w=400')),
                const SizedBox(width: 16),
                Expanded(child: _buildGuideImage('https://images.unsplash.com/photo-1555392859-79c09c657d0a?auto=format&fit=crop&q=80&w=400')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideImage(String url) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
    );
  }
}

// Interaction Preferences
class InteractionPreferencesEditorScreen extends StatefulWidget {
  const InteractionPreferencesEditorScreen({super.key});

  @override
  State<InteractionPreferencesEditorScreen> createState() => _InteractionPreferencesEditorScreenState();
}

class _InteractionPreferencesEditorScreenState extends State<InteractionPreferencesEditorScreen> {
  int _selectedIndex = -1;

  final List<String> _options = [
    'I won\'t be available in person, and prefer communicating through the app.',
    'I like to say hello in person, but keep to myself otherwise.',
    'I like socializing and spending time with guests.',
    'No preference — I follow my guests\' lead.'
  ];

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interaction with guests',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Let guests know if you enjoy spending time with them or prefer a hands-off approach.',
              style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
            ),
            const SizedBox(height: 32),
            
            ...List.generate(_options.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildChoiceCard(index),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildChoiceCard(int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade400, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _options[index],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.4),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade400, width: isSelected ? 8 : 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BaseArrivalEditor extends StatelessWidget {
  final String title;
  final String hint;

  const _BaseArrivalEditor({required this.title, required this.hint});

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
        title: Text(title, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Text(hint, style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.4)),
        ],
      ),
     ),
    );
  }
}

Widget _buildBottomBar(BuildContext context) {
  return Container(
    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
    decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade100))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF7F7F7),
            foregroundColor: Colors.grey.shade400,
            minimumSize: const Size(120, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}

Widget _buildLightbulb() {
  return Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
    ),
    child: const Icon(Icons.lightbulb_outline),
  );
}
