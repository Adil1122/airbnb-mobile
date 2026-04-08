import 'package:flutter/material.dart';

class TravelForWorkScreen extends StatefulWidget {
  const TravelForWorkScreen({super.key});

  @override
  State<TravelForWorkScreen> createState() => _TravelForWorkScreenState();
}

class _TravelForWorkScreenState extends State<TravelForWorkScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateButtonState);
    _emailController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final text = _emailController.text;
    final isEnabled = text.isNotEmpty && text.contains('@');
    if (isEnabled != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isEnabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Travel for work',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Try Airbnb for Work',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Add your work email to unlock extra perks for business trips.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Label
                  const Text(
                    'Work email',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // TextField with Clear button
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Enter email address',
                      hintStyle: const TextStyle(color: Colors.black38),
                      suffixIcon: _emailController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.black54, size: 20),
                              onPressed: () {
                                _emailController.clear();
                              },
                            )
                          : null,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          
          // Sticky Bottom Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isButtonEnabled ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled ? const Color(0xFF222222) : const Color(0xFFF0F0F0),
                    foregroundColor: _isButtonEnabled ? Colors.white : Colors.black26,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: const Color(0xFFF7F7F7),
                  ),
                  child: Text(
                    'Add Work Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isButtonEnabled ? Colors.white : Colors.black26,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
