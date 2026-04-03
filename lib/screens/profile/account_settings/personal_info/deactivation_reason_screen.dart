import 'package:flutter/material.dart';

class DeactivationReasonScreen extends StatefulWidget {
  const DeactivationReasonScreen({Key? key}) : super(key: key);

  @override
  _DeactivationReasonScreenState createState() => _DeactivationReasonScreenState();
}

class _DeactivationReasonScreenState extends State<DeactivationReasonScreen> {
  int? _selectedReasonIndex;

  final List<String> _reasons = [
    'I no longer use Airbnb.',
    'I can\'t host anymore.',
    'I use a different Airbnb account.',
    'Other',
  ];

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
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'Why are you choosing to deactivate?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Selection List
                  ...List.generate(_reasons.length, (index) {
                    final bool isSelected = _selectedReasonIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedReasonIndex = index;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? Colors.black : Colors.black12,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _reasons[index],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
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
                onPressed: _selectedReasonIndex == null ? null : () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedReasonIndex == null 
                      ? const Color(0xFFF0F0F0) 
                      : const Color(0xFF222222),
                  foregroundColor: _selectedReasonIndex == null 
                      ? Colors.black26 
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  disabledBackgroundColor: const Color(0xFFF0F0F0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
