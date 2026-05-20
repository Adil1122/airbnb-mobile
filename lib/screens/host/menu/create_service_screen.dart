import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../../../services/service_service.dart';

class CreateServiceScreen extends StatefulWidget {
  const CreateServiceScreen({super.key});

  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final PageController _pageController = PageController();
  final ServiceService _service = ServiceService();
  int _currentStep = 0;
  bool _isLoading = false;

  // Step 1
  String? _selectedCategory;
  final TextEditingController _titleCtrl = TextEditingController();

  // Step 2
  final TextEditingController _locationCtrl = TextEditingController();
  final TextEditingController _descriptionCtrl = TextEditingController();
  String _selectedDuration = '1 hour';
  int _maxAdults = 4;
  final TextEditingController _priceCtrl = TextEditingController();

  // Step 3
  Uint8List? _imageBytes;
  DateTime _availableFrom = DateTime.now();
  DateTime _availableTo = DateTime.now().add(const Duration(days: 90));

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Photography', 'icon': Icons.camera_alt_outlined},
    {'label': 'Personal Chef', 'icon': Icons.soup_kitchen_outlined},
    {'label': 'Fitness', 'icon': Icons.fitness_center_outlined},
    {'label': 'Music Lessons', 'icon': Icons.music_note_outlined},
    {'label': 'Home Cleaning', 'icon': Icons.cleaning_services_outlined},
    {'label': 'Pet Care', 'icon': Icons.pets_outlined},
    {'label': 'Tutoring', 'icon': Icons.menu_book_outlined},
    {'label': 'Massage', 'icon': Icons.spa_outlined},
  ];

  final List<String> _durations = [
    '30 min', '1 hour', '1.5 hours', '2 hours', '3 hours',
    '4 hours', 'Half day', 'Full day', 'Per session',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentStep == 0) {
      if (_selectedCategory == null) {
        _showError('Please select a service type');
        return;
      }
      if (_titleCtrl.text.trim().isEmpty) {
        _showError('Please enter a title');
        return;
      }
    } else if (_currentStep == 1) {
      if (_locationCtrl.text.trim().isEmpty) {
        _showError('Please enter a location');
        return;
      }
      if (_priceCtrl.text.trim().isEmpty || (double.tryParse(_priceCtrl.text) ?? 0) <= 0) {
        _showError('Please enter a valid price');
        return;
      }
    }
    _pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    setState(() => _currentStep++);
  }

  void _back() {
    _pageController.previousPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    setState(() => _currentStep--);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.black87, behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() => _imageBytes = bytes);
  }

  Future<void> _publish() async {
    if (_imageBytes == null) {
      _showError('Please add a cover photo');
      return;
    }
    setState(() => _isLoading = true);
    try {
      final uploadedUrl = await _service.uploadImage(_imageBytes!);

      await _service.createService({
        'title': _titleCtrl.text.trim(),
        'category': _selectedCategory,
        'location': _locationCtrl.text.trim(),
        'description': _descriptionCtrl.text.trim(),
        'duration': _selectedDuration,
        'maxAdults': _maxAdults,
        'price': double.parse(_priceCtrl.text.trim()),
        'imageUrl': uploadedUrl,
        'availableFrom': _availableFrom.toIso8601String().split('T')[0],
        'availableTo': _availableTo.toIso8601String().split('T')[0],
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service published successfully!'),
            backgroundColor: Colors.black,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) _showError('Failed to publish: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Step ${_currentStep + 1} of 3',
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: Colors.grey.shade200,
            color: Colors.black,
            minHeight: 3,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [_buildStep1(), _buildStep2(), _buildStep3()],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('What service will\nyou offer?',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2)),
          const SizedBox(height: 8),
          const Text('Choose the type that best describes your service.',
              style: TextStyle(fontSize: 15, color: Colors.black54)),
          const SizedBox(height: 32),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: _categories.map((cat) {
              final selected = _selectedCategory == cat['label'];
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat['label']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selected ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: selected ? Colors.black : Colors.grey.shade200, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Icon(cat['icon'] as IconData,
                          size: 22, color: selected ? Colors.white : Colors.black),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(cat['label'],
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: selected ? Colors.white : Colors.black)),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 36),
          const Text('Title', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          TextField(
            controller: _titleCtrl,
            maxLength: 60,
            textCapitalization: TextCapitalization.sentences,
            decoration: _inputDecoration('e.g. Professional wedding photography'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Describe your\nservice',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2)),
          const SizedBox(height: 32),
          _buildLabel('Location'),
          const SizedBox(height: 10),
          _buildTextField(_locationCtrl, 'e.g. Lahore, Pakistan'),
          const SizedBox(height: 24),
          _buildLabel('Description (optional)'),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionCtrl,
            maxLines: 4,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            decoration: _inputDecoration('Describe what\'s included, your experience, and what guests can expect.'),
          ),
          const SizedBox(height: 16),
          _buildLabel('Duration'),
          const SizedBox(height: 10),
          _buildDropdown(_selectedDuration, _durations, (v) => setState(() => _selectedDuration = v!)),
          const SizedBox(height: 24),
          _buildLabel('Max participants'),
          const SizedBox(height: 16),
          _buildGuestRow('Adults', _maxAdults,
              onDec: () { if (_maxAdults > 1) setState(() => _maxAdults--); },
              onInc: () { if (_maxAdults < 50) setState(() => _maxAdults++); }),
          const SizedBox(height: 24),
          _buildLabel('Price per person (USD)'),
          const SizedBox(height: 10),
          TextField(
            controller: _priceCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
            decoration: _inputDecoration('0.00').copyWith(prefixText: '\$ '),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add a photo &\nset availability',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.2)),
          const SizedBox(height: 8),
          const Text('Help guests picture what you offer.',
              style: TextStyle(fontSize: 15, color: Colors.black54)),
          const SizedBox(height: 32),

          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: _imageBytes != null ? Colors.black : Colors.grey.shade300,
                    width: 1.5),
              ),
              child: _buildPhotoPreview(),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.add_photo_alternate_outlined, color: Colors.black),
              label: const Text('Choose photo', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),

          const SizedBox(height: 32),
          _buildLabel('Available from'),
          const SizedBox(height: 10),
          _buildDatePicker(
            date: _availableFrom,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _availableFrom,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 730)),
              );
              if (picked != null) setState(() => _availableFrom = picked);
            },
          ),
          const SizedBox(height: 16),
          _buildLabel('Available until'),
          const SizedBox(height: 10),
          _buildDatePicker(
            date: _availableTo,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _availableTo,
                firstDate: _availableFrom,
                lastDate: DateTime.now().add(const Duration(days: 730)),
              );
              if (picked != null) setState(() => _availableTo = picked);
            },
          ),

          const SizedBox(height: 36),
          _buildSummaryCard(),
        ],
      ),
    );
  }

  Widget _buildPhotoPreview() {
    if (_imageBytes != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.memory(_imageBytes!, fit: BoxFit.cover, width: double.infinity, height: 200),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_photo_alternate_outlined, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 8),
        Text('Tap to add cover photo', style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _summaryRow('Type', _selectedCategory ?? '—'),
          _summaryRow('Title', _titleCtrl.text.isEmpty ? '—' : _titleCtrl.text),
          _summaryRow('Location', _locationCtrl.text.isEmpty ? '—' : _locationCtrl.text),
          _summaryRow('Duration', _selectedDuration),
          _summaryRow('Max participants', '$_maxAdults'),
          _summaryRow('Price', _priceCtrl.text.isEmpty ? '—' : '\$${_priceCtrl.text}/person'),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: _back,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Back', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isLoading ? null : (_currentStep < 2 ? _next : _publish),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(_currentStep < 2 ? 'Next' : 'Publish service',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) =>
      Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold));

  Widget _buildTextField(TextEditingController ctrl, String hint) => TextField(
        controller: ctrl,
        textCapitalization: TextCapitalization.sentences,
        decoration: _inputDecoration(hint),
      );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.black, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );

  Widget _buildDropdown(String value, List<String> items, ValueChanged<String?> onChanged) =>
      DropdownButtonFormField<String>(
        value: value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        decoration: _inputDecoration(''),
      );

  Widget _buildGuestRow(String label, int count, {required VoidCallback onDec, required VoidCallback onInc}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Row(
            children: [
              _counterButton(Icons.remove, onDec),
              SizedBox(width: 36, child: Text('$count', textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
              _counterButton(Icons.add, onInc),
            ],
          ),
        ],
      );

  Widget _counterButton(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Icon(icon, size: 18, color: Colors.black),
        ),
      );

  Widget _buildDatePicker({required DateTime date, required VoidCallback onTap}) {
    final label = '${date.day} ${_monthName(date.month)} ${date.year}';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 15)),
            const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  String _monthName(int m) => const ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][m];
}
