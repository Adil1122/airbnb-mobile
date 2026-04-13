import 'package:flutter/material.dart';

class UnlistingReasonScreen extends StatefulWidget {
  const UnlistingReasonScreen({super.key});

  @override
  State<UnlistingReasonScreen> createState() => _UnlistingReasonScreenState();
}

class _UnlistingReasonScreenState extends State<UnlistingReasonScreen> {
  int? _expandedIndex;
  final Set<String> _selectedReasons = {};

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
                  const Text(
                    'Let us know why you changed your mind about hosting',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Choose all that apply',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 32),
                  
                  _buildAccordion(0, 'I expected things to go more smoothly with guests.', [
                    'Guests didn\'t follow my house rules.',
                    'Guests stole or damaged my property.',
                    'Guests cancelled their reservations too often.',
                    'Guests were rude or demanding.',
                    'Guests left unfair reviews.',
                    'Another reason',
                  ]),
                  _buildAccordion(1, 'I\'m not ready to host right now.', [
                    'I only host occasionally.',
                    'I\'ve created my listing, but need to get my property ready to host guests.',
                    'I\'m renovating my place or making improvements.',
                    'Another reason',
                  ]),
                  _buildAccordion(2, 'I was hoping to make more money.', [
                    'Managing the property was more work than I anticipated.',
                    'Dealing with taxes was too much work.',
                    'The local registration process was too much work.',
                    'I hoped to get more bookings.',
                    'I expected to make more money.',
                    'Another reason',
                  ]),
                  _buildAccordion(3, 'I expected more from Airbnb.', [
                    'I was hoping for better customer support from Airbnb as a Host.',
                    'I no longer trust Airbnb to treat hosts fairly.',
                    'I wanted more supportive resources from Airbnb.',
                    'I think Airbnb can improve its policies.',
                    'Another reason',
                  ]),
                  _buildAccordion(4, 'I\'m no longer able to host.', [
                    'I don\'t currently have a property to list.',
                    'Legally, I\'m no longer able to host.',
                    'My neighbors made it hard for me to host.',
                    'Hosting no longer fits my lifestyle.',
                    'Another reason',
                  ]),
                  _buildAccordion(5, 'This is a duplicate listing.', [
                    'This is a duplicate listing.',
                  ]),
                  
                  const SizedBox(height: 100), // Space for footer
                ],
              ),
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
                  onPressed: _selectedReasons.isEmpty ? null : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedReasons.isEmpty ? const Color(0xFFF7F7F7) : Colors.black,
                    foregroundColor: _selectedReasons.isEmpty ? Colors.grey.shade400 : Colors.white,
                    minimumSize: const Size(140, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccordion(int index, String title, List<String> items) {
    final isExpanded = _expandedIndex == index;
    
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expandedIndex = isExpanded ? null : index),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Column(
            children: items.map((item) => _buildSelectionItem(item)).toList(),
          ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildSelectionItem(String label) {
    final isSelected = _selectedReasons.contains(label);
    
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedReasons.remove(label);
          } else {
            _selectedReasons.add(label);
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade400, width: 1),
              ),
              child: isSelected ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
