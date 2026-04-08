import 'package:flutter/material.dart';

class AddEmergencyContactScreen extends StatefulWidget {
  const AddEmergencyContactScreen({super.key});

  @override
  State<AddEmergencyContactScreen> createState() => _AddEmergencyContactScreenState();
}

class _AddEmergencyContactScreenState extends State<AddEmergencyContactScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _relationshipController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(text: '+92');

  @override
  void dispose() {
    _nameController.dispose();
    _relationshipController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  
                  // Name Field
                  _buildInputField(
                    label: 'Name', 
                    controller: _nameController,
                    helperText: 'Legal name is preferred (required)',
                  ),
                  
                  // Relationship Field
                  _buildInputField(
                    label: 'Relationship', 
                    controller: _relationshipController,
                    helperText: 'Ex: mom, partner, friend (required)',
                  ),
                  
                  // Email Field
                  _buildInputField(
                    label: 'Email', 
                    controller: _emailController,
                    helperText: 'Enter email address (optional)',
                  ),
                  
                  // Country & Phone Section
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Country selector
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Country/Region',
                                    style: TextStyle(fontSize: 12, color: Colors.black54),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Pakistan ( +92 )',
                                    style: TextStyle(fontSize: 16, color: Colors.black87),
                                  ),
                                ],
                              ),
                              const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                            ],
                          ),
                        ),
                        const Divider(height: 1, thickness: 1, color: Colors.black26),
                        // Phone number
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Phone',
                                      style: TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                    const SizedBox(height: 4),
                                    TextField(
                                      controller: _phoneController,
                                      enabled: false, // For now, just as per mock
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      style: const TextStyle(fontSize: 16, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.check, color: Colors.black, size: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 24.0),
                    child: Text(
                      'Enter phone number (required)',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ),
                  
                  // Preferred Language
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Preferred language',
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                        Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 48),
                    child: Text(
                      'Select from the list (optional)',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Sticky Footer
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF222222),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label, 
    required TextEditingController controller,
    required String helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black38, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 16, color: Colors.black54)),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                ),
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
          child: Text(
            helperText,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
