import 'package:flutter/material.dart';

class PreBookingMessageScreen extends StatefulWidget {
  final String initialValue;

  const PreBookingMessageScreen({
    super.key,
    this.initialValue = '',
  });

  @override
  State<PreBookingMessageScreen> createState() => _PreBookingMessageScreenState();
}

class _PreBookingMessageScreenState extends State<PreBookingMessageScreen> {
  late TextEditingController _controller;
  int _currentLength = 0;
  final int _maxLength = 400;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _currentLength = _controller.text.length;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool canDone = _controller.text.isNotEmpty && _controller.text != widget.initialValue;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Pre-booking message', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    'Ex: Hello! Please let me know a little about your trip and when you plan to check in.',
                    style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _controller,
                    maxLines: null,
                    maxLength: _maxLength,
                    onChanged: (val) => setState(() => _currentLength = val.length),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_maxLength - _currentLength} characters available',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
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
                  onPressed: canDone ? () => Navigator.pop(context) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canDone ? const Color(0xFF222222) : const Color(0xFFE0E0E0),
                    foregroundColor: canDone ? Colors.white : Colors.white.withOpacity(0.8),
                    minimumSize: const Size(120, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
