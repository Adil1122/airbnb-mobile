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
  bool _isSuccess = false;
  String _errorMessage = '';
  
  XFile? _idFront;
  XFile? _idBack;
  XFile? _selfie;

  final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage(String type) async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: type == 'selfie' ? CameraDevice.front : CameraDevice.rear,
      imageQuality: 85,
    );

    if (photo != null) {
      setState(() {
        if (type == 'front') _idFront = photo;
        if (type == 'back') _idBack = photo;
        if (type == 'selfie') _selfie = photo;
      });
      _nextStep();
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
        leading: _currentStep < 4 ? IconButton(
          icon: Icon(_currentStep == 0 ? Icons.close : Icons.arrow_back, color: Colors.black),
          onPressed: () => _currentStep == 0 ? Navigator.pop(context) : _previousStep(),
        ) : null,
        title: _currentStep > 0 && _currentStep < 4 ? Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: index < _currentStep ? Colors.black : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(2),
            ),
          )),
        ) : null,
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _buildCurrentStep(),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _buildIntro(key: const ValueKey(0));
      case 1: return _buildCaptureStep(
        key: const ValueKey(1),
        title: 'Capture ID front',
        subtitle: 'Position the front of your ID card in the frame. Make sure it\'s clear and readable.',
        image: _idFront,
        onCapture: () => _captureImage('front'),
        icon: Icons.badge_outlined,
      );
      case 2: return _buildCaptureStep(
        key: const ValueKey(2),
        title: 'Capture ID back',
        subtitle: 'Now, flip your card over and capture the back side.',
        image: _idBack,
        onCapture: () => _captureImage('back'),
        icon: Icons.flip_to_back_outlined,
      );
      case 3: return _buildCaptureStep(
        key: const ValueKey(3),
        title: 'Capture selfie',
        subtitle: 'We\'ll compare this with your ID photo. Please remove glasses or hats.',
        image: _selfie,
        onCapture: () => _captureImage('selfie'),
        icon: Icons.face_outlined,
        isSelfie: true,
      );
      case 4: return _buildProcessing(key: const ValueKey(4));
      case 5: return _buildResult(key: const ValueKey(5));
      default: return _buildIntro();
    }
  }

  Widget _buildIntro({Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Identity\nverification', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, height: 1.1)),
          const SizedBox(height: 20),
          const Text('Secure your host account by verifying your identity with a valid ID card and a quick selfie.', 
            style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5)),
          const SizedBox(height: 40),
          _buildInfoRow(Icons.security, 'Your data is encrypted', 'We use bank-level security to protect your sensitive information.'),
          const SizedBox(height: 24),
          _buildInfoRow(Icons.bolt, 'Fast & Automatic', 'Our AI verifies your documents in seconds.'),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Start verification', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text('Trusted by millions of hosts', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: Colors.black87),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCaptureStep({
    required Key key,
    required String title,
    required String subtitle,
    required XFile? image,
    required VoidCallback onCapture,
    required IconData icon,
    bool isSelfie = false,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(subtitle, style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.4)),
          const SizedBox(height: 40),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (image != null)
                      kIsWeb 
                        ? Image.network(image.path, width: double.infinity, height: double.infinity, fit: BoxFit.cover)
                        : Image.file(File(image.path), width: double.infinity, height: double.infinity, fit: BoxFit.cover)
                    else
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, size: 80, color: Colors.black12),
                          const SizedBox(height: 24),
                          Text('Ready to capture', style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    
                    // Guides
                    if (image == null)
                    CustomPaint(
                      size: Size.infinite,
                      painter: isSelfie ? SelfieGuidePainter() : IDGuidePainter(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onCapture,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(image == null ? 'Capture now' : 'Retake photo', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          if (image != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: _nextStep,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Looks good', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProcessing({Key? key}) {
    if (!_isLoading) {
      _startVerification();
    }
    return Center(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 8,
                backgroundColor: Color(0xFFF0F0F0),
              ),
            ),
            const SizedBox(height: 48),
            const Text('Verifying Identity', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Uploading documents and running AI liveness checks. Please don\'t close the app.', 
              textAlign: TextAlign.center, 
              style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5)),
            const SizedBox(height: 32),
            _buildProcessStep('Uploading files...', true),
            _buildProcessStep('Scanning document data...', true),
            _buildProcessStep('Performing facial match...', false),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessStep(String text, bool isDone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked, 
            color: isDone ? Colors.green : Colors.grey.shade300, size: 20),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(
            color: isDone ? Colors.black : Colors.grey,
            fontWeight: isDone ? FontWeight.w500 : FontWeight.normal,
          )),
        ],
      ),
    );
  }

  Widget _buildResult({Key? key}) {
    return Padding(
      key: key,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: _isSuccess ? Colors.green.shade50 : Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isSuccess ? Icons.verified_user : Icons.error_outline, 
              size: 56, 
              color: _isSuccess ? Colors.green : Colors.red
            ),
          ),
          const SizedBox(height: 32),
          Text(
            _isSuccess ? 'Verification successful!' : 'Verification failed', 
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 16),
          Text(
            _isSuccess 
              ? 'Your identity has been confirmed. You\'re now ready to publish your listings and welcome guests!' 
              : _errorMessage.isNotEmpty ? _errorMessage : 'We couldn\'t verify your identity. Please ensure your ID is clear and your selfie matches.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 64),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, _isSuccess),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(_isSuccess ? 'Continue to dashboard' : 'Back', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          if (!_isSuccess) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => setState(() {
                _currentStep = 0;
                _isLoading = false;
              }),
              child: const Text('Try again', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _startVerification() async {
    setState(() => _isLoading = true);
    
    // Artificial delay for premium feel
    await Future.delayed(const Duration(seconds: 4));
    
    try {
      await HostService().verifyIdentity();
      PropertyService.triggerRefresh();
      if (mounted) {
        setState(() {
          _isSuccess = true;
          _isLoading = false;
          _currentStep = 5;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSuccess = false;
          _errorMessage = e.toString();
          _isLoading = false;
          _currentStep = 5;
        });
      }
    }
  }
}

class IDGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final rect = RRect.fromLTRBR(
      size.width * 0.1,
      size.height * 0.3,
      size.width * 0.9,
      size.height * 0.7,
      const Radius.circular(16),
    );
    
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SelfieGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * 0.7,
        height: size.height * 0.6,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
