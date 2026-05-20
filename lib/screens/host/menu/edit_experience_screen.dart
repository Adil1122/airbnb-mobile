import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/listing.dart';
import '../../../services/experience_service.dart';

class EditExperienceScreen extends StatefulWidget {
  final Listing experience;
  const EditExperienceScreen({super.key, required this.experience});

  @override
  State<EditExperienceScreen> createState() => _EditExperienceScreenState();
}

class _EditExperienceScreenState extends State<EditExperienceScreen> {
  final ExperienceService _service = ExperienceService();
  bool _isSaving = false;
  bool _hasChanges = false;

  late TextEditingController _titleCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _descriptionCtrl;
  late TextEditingController _priceCtrl;
  late String _selectedCategory;
  late String _selectedDuration;
  late int _maxAdults;
  late int _maxChildren;
  late int _maxInfants;
  late DateTime _availableFrom;
  late DateTime _availableTo;

  Uint8List? _newImageBytes;
  String? _currentImageUrl;

  final List<String> _categories = [
    'Outdoor', 'Food & Drink', 'Art & Culture', 'Sports',
    'Entertainment', 'Wellness', 'Education', 'Music',
  ];
  final List<String> _durations = [
    '30 min', '1 hour', '1.5 hours', '2 hours', '3 hours',
    '4 hours', 'Half day', 'Full day',
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.experience;
    _titleCtrl = TextEditingController(text: e.title);
    _locationCtrl = TextEditingController(text: e.subtitle);
    _descriptionCtrl = TextEditingController(text: e.description);
    _priceCtrl = TextEditingController(text: e.price.toStringAsFixed(0));
    _selectedCategory = _categories.contains(e.category) ? e.category : _categories.first;
    _selectedDuration = _durations.contains(e.experienceDurationHours) ? e.experienceDurationHours! : _durations[1];
    _maxAdults = e.guests > 0 ? e.guests : 6;
    _maxChildren = 0;
    _maxInfants = 0;
    _currentImageUrl = e.imageUrl;
    _availableFrom = e.availableFrom ?? DateTime.now();
    _availableTo = e.availableTo ?? DateTime.now().add(const Duration(days: 90));

    for (final ctrl in [_titleCtrl, _locationCtrl, _descriptionCtrl, _priceCtrl]) {
      ctrl.addListener(() => setState(() => _hasChanges = true));
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _markChanged() => setState(() => _hasChanges = true);

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() { _newImageBytes = bytes; _hasChanges = true; });
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) { _snack('Title is required'); return; }
    if (_locationCtrl.text.trim().isEmpty) { _snack('Location is required'); return; }
    if ((double.tryParse(_priceCtrl.text) ?? 0) <= 0) { _snack('Enter a valid price'); return; }

    setState(() => _isSaving = true);
    try {
      String imageUrl = _currentImageUrl ?? '';
      if (_newImageBytes != null) {
        imageUrl = await _service.uploadImage(_newImageBytes!);
      }

      final updated = await _service.updateExperience(widget.experience.id, {
        'title': _titleCtrl.text.trim(),
        'location': _locationCtrl.text.trim(),
        'description': _descriptionCtrl.text.trim(),
        'price': double.parse(_priceCtrl.text.trim()),
        'category': _selectedCategory,
        'durationHours': _selectedDuration,
        'maxAdults': _maxAdults,
        'maxChildren': _maxChildren,
        'maxInfants': _maxInfants,
        'imageUrl': imageUrl,
        'availableFrom': _availableFrom.toIso8601String().split('T')[0],
        'availableTo': _availableTo.toIso8601String().split('T')[0],
      });

      if (mounted) {
        _snack('Experience updated successfully!');
        Navigator.pop(context, updated);
      }
    } catch (e) {
      if (mounted) _snack('Failed to save: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating, backgroundColor: Colors.black87),
    );
  }

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
        title: const Text('Edit Experience', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          if (_hasChanges)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: TextButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                    : const Text('Save', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPhotoSection(),
            const Divider(height: 1),
            _buildSection('Basic Info', [
              _buildDropdownField('Category', _selectedCategory, _categories,
                  (v) { setState(() { _selectedCategory = v!; _hasChanges = true; }); }),
              _buildTextField('Title', _titleCtrl, hint: 'e.g. Sunset kayaking tour', maxLength: 60),
              _buildTextField('Location', _locationCtrl, hint: 'e.g. Lahore, Pakistan'),
            ]),
            const Divider(height: 1),
            _buildSection('About', [
              _buildTextField('Description', _descriptionCtrl,
                  hint: 'Describe what guests will experience...', maxLines: 5, maxLength: 500),
              _buildDropdownField('Duration', _selectedDuration, _durations,
                  (v) { setState(() { _selectedDuration = v!; _hasChanges = true; }); }),
            ]),
            const Divider(height: 1),
            _buildSection('Guests', [
              _buildStepperRow('Max adults', _maxAdults,
                  onDec: () { if (_maxAdults > 1) { setState(() { _maxAdults--; _hasChanges = true; }); } },
                  onInc: () { if (_maxAdults < 50) { setState(() { _maxAdults++; _hasChanges = true; }); } }),
              const SizedBox(height: 16),
              _buildStepperRow('Max children', _maxChildren,
                  onDec: () { if (_maxChildren > 0) { setState(() { _maxChildren--; _hasChanges = true; }); } },
                  onInc: () { if (_maxChildren < 50) { setState(() { _maxChildren++; _hasChanges = true; }); } }),
              const SizedBox(height: 16),
              _buildStepperRow('Max infants', _maxInfants,
                  onDec: () { if (_maxInfants > 0) { setState(() { _maxInfants--; _hasChanges = true; }); } },
                  onInc: () { if (_maxInfants < 20) { setState(() { _maxInfants++; _hasChanges = true; }); } }),
            ]),
            const Divider(height: 1),
            _buildSection('Pricing', [
              _buildNumberField('Price per guest (USD)', _priceCtrl, prefix: '\$ '),
            ]),
            const Divider(height: 1),
            _buildSection('Availability', [
              _buildDateRow('Available from', _availableFrom, () async {
                final picked = await showDatePicker(context: context,
                    initialDate: _availableFrom, firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 730)));
                if (picked != null) setState(() { _availableFrom = picked; _hasChanges = true; });
              }),
              const SizedBox(height: 16),
              _buildDateRow('Available until', _availableTo, () async {
                final picked = await showDatePicker(context: context,
                    initialDate: _availableTo, firstDate: _availableFrom,
                    lastDate: DateTime.now().add(const Duration(days: 730)));
                if (picked != null) setState(() { _availableTo = picked; _hasChanges = true; });
              }),
            ]),
            const SizedBox(height: 32),
            if (_hasChanges)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? const SizedBox(height: 20, width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Save changes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          SizedBox(
            height: 220,
            width: double.infinity,
            child: _newImageBytes != null
                ? Image.memory(_newImageBytes!, fit: BoxFit.cover)
                : CachedNetworkImage(
                    imageUrl: _currentImageUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.grey.shade100),
                    errorWidget: (_, __, ___) => Container(color: Colors.grey.shade100,
                        child: const Icon(Icons.image_outlined, size: 48, color: Colors.grey)),
                  ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_camera, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text('Change photo', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl,
      {String? hint, int maxLines = 1, int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54)),
          const SizedBox(height: 8),
          TextField(
            controller: ctrl,
            maxLines: maxLines,
            maxLength: maxLength,
            textCapitalization: TextCapitalization.sentences,
            decoration: _inputDec(hint ?? ''),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController ctrl, {String prefix = ''}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54)),
          const SizedBox(height: 8),
          TextField(
            controller: ctrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
            decoration: _inputDec('0.00').copyWith(prefixText: prefix),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
            decoration: _inputDec(''),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperRow(String label, int value, {required VoidCallback onDec, required VoidCallback onInc}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 15)),
        Row(children: [
          _stepBtn(Icons.remove, onDec),
          SizedBox(width: 36, child: Text('$value', textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
          _stepBtn(Icons.add, onInc),
        ]),
      ],
    );
  }

  Widget _stepBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade400)),
          child: Icon(icon, size: 18),
        ),
      );

  Widget _buildDateRow(String label, DateTime date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black54)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${date.day} ${_mon(date.month)} ${date.year}',
                    style: const TextStyle(fontSize: 15)),
                const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.black54),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black, width: 1.5)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      );

  String _mon(int m) => const ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][m];
}
