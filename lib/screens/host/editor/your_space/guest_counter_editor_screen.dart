import 'package:flutter/material.dart';

class GuestCounterEditorScreen extends StatefulWidget {
  final int initialCount;
  const GuestCounterEditorScreen({super.key, this.initialCount = 4});

  @override
  State<GuestCounterEditorScreen> createState() => _GuestCounterEditorScreenState();
}

class _GuestCounterEditorScreenState extends State<GuestCounterEditorScreen> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;
  }

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
      body: Column(
        children: [
          const SizedBox(height: 48),
          // Illustration Placeholder
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _characterIcon(height: 30),
                const SizedBox(width: 4),
                _characterIcon(height: 40),
                const SizedBox(width: 4),
                _characterIcon(height: 50),
                const SizedBox(width: 4),
                _characterIcon(height: 45),
              ],
            ),
          ),
          const SizedBox(height: 48),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48.0),
            child: Text(
              'How many guests can fit comfortably in your space?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _counterButton(Icons.remove, () {
                  if (_count > 1) {
                    setState(() {
                      _count--;
                    });
                  }
                }),
                Text(
                  '$_count',
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _counterButton(Icons.add, () => setState(() => _count++)),
              ],
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade100, width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, _count),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF222222),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _characterIcon({required double height}) {
    return Container(
      width: 20,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const SizedBox(height: 4),
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFFD0D0D0),
              shape: BoxShape.circle,
            ),
          ),
          const Spacer(),
          Container(
            width: 14,
            height: height * 0.6,
            decoration: BoxDecoration(
              color: const Color(0xFFD0D0D0),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _counterButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, color: Colors.black, size: 24),
      ),
    );
  }
}
