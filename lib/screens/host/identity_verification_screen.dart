import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../services/host_service.dart';
import '../../services/property_service.dart';

class IdentityVerificationScreen extends StatefulWidget {
  const IdentityVerificationScreen({super.key});

  @override
  State<IdentityVerificationScreen> createState() => _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState extends State<IdentityVerificationScreen> {
  int _currentStep = 0;
  bool _isLoading = false;
  
  // Data
  final TextEditingController _nameController = TextEditingController();
  String _selectedIdType = 'Passport';
  XFile? _idFront;
  XFile? _idBack;
  XFile? _selfie;

  final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage(String type) async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: type == 'selfie' ? CameraDevice.front : CameraDevice.rear,
    );

    if (photo != null) {
      setState(() {
        if (type == 'front') _idFront = photo;
        if (type == 'back') _idBack = photo;
        if (type == 'selfie') _selfie = photo;
      });
    }
  }

  void _nextStep() {
    if (_currentStep < 5) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
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
          icon: Icon(_currentStep == 0 ? Icons.close : Icons.arrow_back, color: Colors.black),
          onPressed: () => _currentStep == 0 ? Navigator.pop(context) : _previousStep(),
        ),
        title: _currentStep > 0 ? Text('Step $_currentStep of 4', style: const TextStyle(color: Colors.black, fontSize: 16)) : null,
        centerTitle: true,
      ),
      body: _buildCurrentStep(),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _buildIntro();
      case 1: return _buildNameAndIdType();
      case 2: return _buildIdFront();
      case 3: return _buildIdBack();
      case 4: return _buildSelfie();
      case 5: return _buildProcessing();
      default: return _buildIntro();
    }
  }

  Widget _buildIntro() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Identity verification', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text('Before you can host, we need to verify your identity. This helps keep our community safe.', style: TextStyle(fontSize: 16, color: Colors.black87)),
          const SizedBox(height: 48),
          _buildStepRow(Icons.badge_outlined, 'Upload a photo of your ID', 'Passport or CNIC', onTap: _nextStep),
          const SizedBox(height: 32),
          _buildStepRow(Icons.face_outlined, 'Take a selfie', 'We\'ll compare it to your ID.', 
            onTap: () => setState(() => _currentStep = 4)),
          const Spacer(),
          _buildButton('Get started', _nextStep),
        ],
      ),
    );
  }

  Widget _buildStepRow(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.black),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
          ),
          if (onTap != null) const Icon(Icons.chevron_right, color: Colors.black26),
        ],
      ),
    );
  }

  Widget _buildNameAndIdType() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your information', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 32),
          const Text('Select ID type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildIdOption('Passport'),
          const SizedBox(height: 12),
          _buildIdOption('CNIC (National ID)'),
          const Spacer(),
          _buildButton('Next', () {
            if (_nameController.text.isNotEmpty) _nextStep();
          }),
        ],
      ),
    );
  }

  Widget _buildIdOption(String type) {
    bool isSelected = _selectedIdType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedIdType = type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(type, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildIdFront() {
    return _buildCameraStep(
      title: 'Front of ID card',
      description: 'Position the front of your $_selectedIdType in the frame.',
      image: _idFront,
      onCapture: () => _captureImage('front'),
    );
  }

  Widget _buildIdBack() {
    return _buildCameraStep(
      title: 'Back of ID card',
      description: 'Now, take a photo of the back side.',
      image: _idBack,
      onCapture: () => _captureImage('back'),
    );
  }

  Widget _buildSelfie() {
    return _buildCameraStep(
      title: 'Take a selfie',
      description: 'Look straight at the camera and make sure your face is well-lit.',
      image: _selfie,
      onCapture: () => _captureImage('selfie'),
      isSelfie: true,
      buttonText: 'Take a selfie',
    );
  }

  Widget _buildCameraStep({
    required String title, 
    required String description, 
    XFile? image, 
    required VoidCallback onCapture, 
    bool isSelfie = false,
    String? buttonText,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 32),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: image != null 
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(24), 
                    child: kIsWeb 
                      ? Image.network(image.path, fit: BoxFit.cover)
                      : Image.file(File(image.path), fit: BoxFit.cover)
                  )
                : Center(child: Icon(isSelfie ? Icons.face : Icons.camera_alt, size: 64, color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 32),
          _buildButton(image == null ? (buttonText ?? 'Take photo') : 'Retake photo', onCapture, isOutline: image != null),
          if (image != null) ...[
            const SizedBox(height: 12),
            _buildButton('Use this photo', _nextStep),
          ],
        ],
      ),
    );
  }

  Widget _buildProcessing() {
    if (!_isLoading) {
      _startVerification();
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.black),
            const SizedBox(height: 32),
            const Text('Processing verification...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Our AI is comparing your selfie with your ID card. This usually takes a few seconds.', 
              textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Future<void> _startVerification() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 4));
    
    try {
      await HostService().verifyIdentity();
      PropertyService.triggerRefresh();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Identity verified! Faces matched successfully.')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentStep = 0; // Reset
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildButton(String label, VoidCallback onPressed, {bool isOutline = false}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: isOutline 
        ? OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
    );
  }
}
