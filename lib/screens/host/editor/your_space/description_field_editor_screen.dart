import 'package:flutter/material.dart';

class DescriptionFieldEditorScreen extends StatefulWidget {
  final String title;
  final String description;
  final String initialValue;
  final int maxLength;

  const DescriptionFieldEditorScreen({
    super.key,
    required this.title,
    required this.description,
    this.initialValue = '',
    this.maxLength = 500,
  });

  @override
  State<DescriptionFieldEditorScreen> createState() => _DescriptionFieldEditorScreenState();
}

class _DescriptionFieldEditorScreenState extends State<DescriptionFieldEditorScreen> {
  late TextEditingController _controller;
  int _currentLength = 0;

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
    bool canSave = _controller.text.isNotEmpty && _controller.text != widget.initialValue;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
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
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _controller,
                    maxLines: null,
                    maxLength: widget.maxLength,
                    onChanged: (val) => setState(() => _currentLength = val.length),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.maxLength - _currentLength} characters available',
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
                  onPressed: canSave ? () => Navigator.pop(context) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canSave ? const Color(0xFF222222) : const Color(0xFFF7F7F7),
                    foregroundColor: canSave ? Colors.white : Colors.grey.shade400,
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
}
