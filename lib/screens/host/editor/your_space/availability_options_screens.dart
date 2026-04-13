import 'package:flutter/material.dart';

// Reusable radio item widget
class _RadioItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _RadioItem({required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey.shade400,
                  width: isSelected ? 8 : 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AvailabilityWindowScreen extends StatefulWidget {
  const AvailabilityWindowScreen({super.key});
  @override
  State<AvailabilityWindowScreen> createState() => _AvailabilityWindowScreenState();
}

class _AvailabilityWindowScreenState extends State<AvailabilityWindowScreen> {
  String _selected = '12 months';
  final List<String> _options = ['24 months', '12 months', '9 months', '6 months', '3 months', 'Dates unavailable by default'];

  @override
  Widget build(BuildContext context) {
    return _BaseRadioScreen(
      title: 'Availability window',
      question: 'How far in advance can guests book?',
      options: _options,
      selected: _selected,
      onSelect: (val) => setState(() => _selected = val),
    );
  }
}

class PreparationTimeScreen extends StatefulWidget {
  const PreparationTimeScreen({super.key});
  @override
  State<PreparationTimeScreen> createState() => _PreparationTimeScreenState();
}

class _PreparationTimeScreenState extends State<PreparationTimeScreen> {
  String _selected = 'None';
  final List<String> _options = ['None', '1 night before and after each reservation', '2 nights before and after each reservation'];

  @override
  Widget build(BuildContext context) {
    return _BaseRadioScreen(
      title: 'Preparation time',
      question: 'How many nights before and after each reservation do you need to block off?',
      options: _options,
      selected: _selected,
      onSelect: (val) => setState(() => _selected = val),
    );
  }
}

class AdvanceNoticeScreen extends StatefulWidget {
  const AdvanceNoticeScreen({super.key});
  @override
  State<AdvanceNoticeScreen> createState() => _AdvanceNoticeScreenState();
}

class _AdvanceNoticeScreenState extends State<AdvanceNoticeScreen> {
  String _selected = 'Same day';
  bool _allowSameDay = true;
  final List<String> _options = ['Same day', '1 day', '2 days', '3 days', '7 days'];

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Advance notice', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            const Text('How much notice do you need between a guest\'s booking and their arrival?', 
                style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4)),
            const SizedBox(height: 32),
            ..._options.map((opt) => _RadioItem(
              title: opt,
              isSelected: _selected == opt,
              onTap: () => setState(() => _selected = opt),
            )),
            
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Allow requests for the same day', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Switch(
                        value: _allowSameDay,
                        onChanged: (val) => setState(() => _allowSameDay = val),
                        activeColor: Colors.black,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('You\'ll review and approve each reservation request.', 
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildSaveFooter(context),
    );
  }
}

class _BaseRadioScreen extends StatelessWidget {
  final String title;
  final String question;
  final List<String> options;
  final String selected;
  final Function(String) onSelect;

  const _BaseRadioScreen({required this.title, required this.question, required this.options, required this.selected, required this.onSelect});

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            Text(question, style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.4)),
            const SizedBox(height: 32),
            ...options.map((opt) => _RadioItem(
              title: opt,
              isSelected: selected == opt,
              onTap: () => onSelect(opt),
            )),
          ],
        ),
      ),
      bottomNavigationBar: _buildSaveFooter(context),
    );
  }
}

Widget _buildSaveFooter(BuildContext context) {
  return Container(
    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
    decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade100))),
    child: ElevatedButton(
      onPressed: () => Navigator.pop(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF222222),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
    ),
  );
}
