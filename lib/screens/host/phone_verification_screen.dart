import 'package:flutter/material.dart';
import 'dart:async';
import '../../services/host_service.dart';
import '../../services/property_service.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({super.key});

  @override
  State<PhoneVerificationScreen> createState() => _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  int _currentStep = 0; // 0: Input, 1: OTP, 2: Processing
  bool _isLoading = false;
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  
  Timer? _timer;
  int _resendSeconds = 59;

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _resendSeconds = 59;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  void _nextStep() {
    setState(() => _currentStep++);
    if (_currentStep == 1) {
      _startTimer();
      // Auto focus first OTP field
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) _focusNodes[0].requestFocus();
      });
    }
  }

  bool _isOtpComplete() {
    return _otpControllers.every((c) => c.text.isNotEmpty);
  }

  Future<void> _handleSendCode() async {
    if (_phoneController.text.length < 7) return;

    setState(() => _isLoading = true);
    try {
      final response = await HostService().sendOtp('+92 ${_phoneController.text}');
      final otp = response['otp'].toString();
      
      if (mounted) {
        setState(() => _isLoading = false);
        _nextStep();
        
        // Show simulated OTP in snackbar for testing
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Simulated SMS: Your Airbnb code is $otp'),
            duration: const Duration(seconds: 10),
            backgroundColor: const Color(0xFF222222),
            action: SnackBarAction(
              label: 'COPY',
              textColor: Colors.white,
              onPressed: () {
                // You could copy to clipboard here
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
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
          icon: Icon(_currentStep == 1 ? Icons.arrow_back : Icons.close, color: Colors.black),
          onPressed: () {
            if (_currentStep == 1) {
              setState(() => _currentStep = 0);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildCurrentStep(),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _buildPhoneInput();
      case 1: return _buildOtpVerification();
      case 2: return _buildProcessing();
      default: return _buildPhoneInput();
    }
  }

  Widget _buildPhoneInput() {
    return Padding(
      key: const ValueKey('phone_input'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enter phone number', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
          const SizedBox(height: 16),
          const Text('We\'ll send a code to verify your phone number.', style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4)),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('+92', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                Container(width: 1, height: 24, color: Colors.black12),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: '300 1234567',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    onChanged: (val) => setState(() {}),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _buildButton('Send code', _phoneController.text.length >= 7 ? _handleSendCode : null),
        ],
      ),
    );
  }

  Widget _buildOtpVerification() {
    return Padding(
      key: const ValueKey('otp_verification'),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enter the code', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
          const SizedBox(height: 16),
          Text('We sent it to +92 ${_phoneController.text}', style: const TextStyle(fontSize: 16, color: Colors.black54)),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 48,
                height: 56,
                child: TextField(
                  controller: _otpControllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  decoration: InputDecoration(
                    counterText: '',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    if (value.isNotEmpty && index < 5) {
                      _focusNodes[index + 1].requestFocus();
                    } else if (value.isEmpty && index > 0) {
                      _focusNodes[index - 1].requestFocus();
                    }
                    setState(() {});
                    if (_isOtpComplete()) {
                      _nextStep();
                    }
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: _resendSeconds == 0 ? _startTimer : null,
            child: Text(
              _resendSeconds > 0 
                  ? 'Didn\'t get a code? Resend in 0:${_resendSeconds.toString().padLeft(2, '0')}'
                  : 'Didn\'t get a code? Resend now',
              style: TextStyle(
                fontSize: 16, 
                decoration: TextDecoration.underline, 
                fontWeight: FontWeight.bold,
                color: _resendSeconds == 0 ? Colors.black : Colors.black45,
              ),
            ),
          ),
          const Spacer(),
          _buildButton('Verify', _isOtpComplete() ? _nextStep : null),
        ],
      ),
    );
  }

  Widget _buildProcessing() {
    if (!_isLoading) {
      _startVerification();
    }
    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.black),
            const SizedBox(height: 32),
            const Text('Verifying number...', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text(
              'This usually takes a few seconds.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startVerification() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      await HostService().verifyPhone();
      PropertyService.triggerRefresh();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number verified successfully!'), 
            backgroundColor: Color(0xFF222222),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentStep = 0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: $e'), backgroundColor: const Color(0xFFFF385C)),
        );
      }
    }
  }

  Widget _buildButton(String label, VoidCallback? onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
          disabledBackgroundColor: Colors.grey.shade200,
          disabledForegroundColor: Colors.grey.shade400,
        ),
        child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
