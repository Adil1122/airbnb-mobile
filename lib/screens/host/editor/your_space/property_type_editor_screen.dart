import 'package:flutter/material.dart';

class PropertyTypeEditorScreen extends StatefulWidget {
  const PropertyTypeEditorScreen({super.key});

  @override
  State<PropertyTypeEditorScreen> createState() => _PropertyTypeEditorScreenState();
}

class _PropertyTypeEditorScreenState extends State<PropertyTypeEditorScreen> {
  int _floorsCount = 1;
  int _listingFloor = 1;

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
        title: const Text(
          'Property type',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSelector(
              label: 'Which is most like your place?',
              value: 'Apartment',
            ),
            const SizedBox(height: 16),
            _buildSelector(
              label: 'Property type',
              value: 'Rental unit',
              helperText: 'A rented place within a multi-unit residential building or complex.',
            ),
            const SizedBox(height: 16),
            _buildSelector(
              label: 'Listing type',
              value: 'Entire place',
              helperText: 'Guests have the whole place to themselves. This usually includes a bedroom, a bathroom, and a kitchen.',
            ),
            
            const SizedBox(height: 32),
            
            _buildCounter('How many floors in the building?', _floorsCount, (val) => setState(() => _floorsCount = val)),
            const SizedBox(height: 24),
            _buildCounter('Which floor is the listing on?', _listingFloor, (val) => setState(() => _listingFloor = val)),
            
            const SizedBox(height: 32),
            
            _buildTextField('Year built'),
            const SizedBox(height: 16),
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildTextField('Property size')),
                const SizedBox(width: 0), // They are joined in screenshot
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    height: 64,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Unit', style: TextStyle(color: Colors.black, fontSize: 16)),
                        Icon(Icons.keyboard_arrow_down, color: Colors.black),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'The amount of indoor space that\'s available to guests.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            
            const SizedBox(height: 48),
            
            const Text(
              'Your category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                children: [
                  const TextSpan(text: 'Categories help guests find unique places to stay. To be included in a category, a listing has to meet some requirements. '),
                  TextSpan(
                    text: 'Learn more',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Your listing isn\'t part of a category yet.',
                  style: TextStyle(color: Colors.black87, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
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
                onPressed: () => Navigator.pop(context),
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

  Widget _buildSelector({required String label, required String value, String? helperText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black45),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(value, style: const TextStyle(fontSize: 16, color: Colors.black)),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                ],
              ),
            ],
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 8),
          Text(helperText, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        ],
      ],
    );
  }

  Widget _buildCounter(String label, int value, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.black87)),
        Row(
          children: [
            _counterButton(Icons.remove, () => value > 1 ? onChanged(value - 1) : null),
            const SizedBox(width: 16),
            Text('$value', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 16),
            _counterButton(Icons.add, () => onChanged(value + 1)),
          ],
        ),
      ],
    );
  }

  Widget _counterButton(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12),
        ),
        child: Icon(icon, size: 18, color: onTap == null ? Colors.black12 : Colors.black),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
