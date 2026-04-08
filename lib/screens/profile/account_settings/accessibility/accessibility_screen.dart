import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  bool _mapZoomControls = false;
  bool _mapPanControls = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Accessibility',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 48),
            
            // Map Zoom Controls
            _buildToggleItem(
              title: 'Map zoom controls',
              subtitle: 'Shows dedicated controls to zoom in and out on maps.',
              value: _mapZoomControls,
              onChanged: (val) {
                setState(() {
                  _mapZoomControls = val;
                });
              },
            ),
            
            const SizedBox(height: 32),
            
            // Map Pan Controls
            _buildToggleItem(
              title: 'Map pan controls',
              subtitle: 'Shows directional buttons to pan around maps.',
              value: _mapPanControls,
              onChanged: (val) {
                setState(() {
                  _mapPanControls = val;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        CupertinoSwitch(
          value: value,
          activeTrackColor: Colors.black,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
