import 'package:flutter/material.dart';

class AccessibilityFeatureEditorScreen extends StatefulWidget {
  final String title;
  final String description;
  final List<String> imageExamples;

  const AccessibilityFeatureEditorScreen({
    super.key,
    required this.title,
    required this.description,
    required this.imageExamples,
  });

  @override
  State<AccessibilityFeatureEditorScreen> createState() => _AccessibilityFeatureEditorScreenState();
}

class _AccessibilityFeatureEditorScreenState extends State<AccessibilityFeatureEditorScreen> {
  int _selectedIndex = 0; // 0 for "Don't have", 1 for "Have"

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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
                  ),
                  const SizedBox(height: 32),
                  const Text('Examples:', style: TextStyle(fontSize: 16, color: Colors.black54)),
                  const SizedBox(height: 16),
                  
                  // Image Carousel
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.imageExamples.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(widget.imageExamples[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  const Text(
                    'Review photo guidelines',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Confirmation Cards
                  _buildStatusCard(0, 'I don\'t have this feature'),
                  const SizedBox(height: 16),
                  _buildStatusCard(1, 'I have this feature'),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          
          // Sticky Footer
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade100)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE0E0E0), // Light grey matching screenshot
                    foregroundColor: Colors.white,
                    minimumSize: const Size(120, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(int index, String text) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300, width: isSelected ? 2 : 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300, width: isSelected ? 8 : 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
