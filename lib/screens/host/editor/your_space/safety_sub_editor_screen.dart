import 'package:flutter/material.dart';

class SafetyItem {
  final String title;
  final String description;
  final bool hasLearnMore;

  SafetyItem({
    required this.title,
    required this.description,
    this.hasLearnMore = true,
  });
}

class SafetySubEditorScreen extends StatefulWidget {
  final String title;
  final List<SafetyItem> items;

  const SafetySubEditorScreen({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  State<SafetySubEditorScreen> createState() => _SafetySubEditorScreenState();
}

class _SafetySubEditorScreenState extends State<SafetySubEditorScreen> {
  late List<bool?> _selections;

  @override
  void initState() {
    super.initState();
    _selections = List<bool?>.filled(widget.items.length, null);
  }

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
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              itemCount: widget.items.length + 1,
              separatorBuilder: (context, index) => const Divider(height: 64, color: Color(0xFFEEEEEE)),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 32),
                    ],
                  );
                }
                
                final safetyItem = widget.items[index - 1];
                final selection = _selections[index - 1];
                
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            safetyItem.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            safetyItem.description,
                            style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
                          ),
                          if (safetyItem.hasLearnMore) ...[
                            const SizedBox(height: 12),
                            const Text(
                              'Learn more',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        _buildToggleButton(
                          icon: Icons.close,
                          isSelected: selection == false,
                          onTap: () => setState(() => _selections[index - 1] = false),
                        ),
                        const SizedBox(width: 12),
                        _buildToggleButton(
                          icon: Icons.check,
                          isSelected: selection == true,
                          onTap: () => setState(() => _selections[index - 1] = true),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          
          // Sticky Footer
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
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
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(140, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildToggleButton({required IconData icon, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
