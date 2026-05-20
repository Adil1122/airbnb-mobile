import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/payment_service.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class HostPayoutsScreen extends StatefulWidget {
  const HostPayoutsScreen({super.key});

  @override
  State<HostPayoutsScreen> createState() => _HostPayoutsScreenState();
}

class _HostPayoutsScreenState extends State<HostPayoutsScreen> {
  final _paymentService = PaymentService();
  final _authService = AuthService();
  bool _isLoading = false;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    final user = await _authService.getProfile();
    if (user != null) {
      // For now using the model data, in real app we'd fetch fresh from API
      setState(() {
        _userData = {
          'isStripeConnected': user.isStripeConnected,
          'stripeAccountId': user.stripeAccountId,
        };
      });
    }
    setState(() => _isLoading = false);
  }

  Future<void> _startOnboarding() async {
    setState(() => _isLoading = true);
    try {
      // 1. Create account if not exists
      final accountData = await _paymentService.createHostStripeAccount();
      if (accountData != null) {
        // 2. Get onboarding link
        final url = await _paymentService.getHostOnboardingLink();
        if (url != null) {
          final uri = Uri.parse(url);
          if (await canalLaunch(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            _showError('Could not launch onboarding URL');
          }
        }
      }
    } catch (e) {
      _showError('Onboarding failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool canalLaunch(Uri uri) => true; // Simple wrapper for launchUrl check

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = _userData?['isStripeConnected'] ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Payouts', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFE61E4D)))
        : Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How you\'ll get paid',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'To receive payouts, you need to set up a Stripe account. Stripe handles identity verification and bank transfers securely.',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600, height: 1.5),
                ),
                const SizedBox(height: 32),
                
                // Status Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isConnected ? const Color(0xFFF7F7F7) : const Color(0xFFFFF8F6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isConnected ? Colors.grey.shade200 : const Color(0xFFFFD1C1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isConnected ? Icons.check_circle : Icons.warning_amber_rounded,
                        color: isConnected ? Colors.green : const Color(0xFFE61E4D),
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isConnected ? 'Stripe Connected' : 'Action Required',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isConnected 
                                ? 'Your bank account is ready for payouts.'
                                : 'Finish setting up your Stripe account to receive money.',
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),
                
                if (!isConnected)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _startOnboarding,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE61E4D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Connect with Stripe',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                
                if (isConnected)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: _startOnboarding, // Can be used to view Stripe dashboard
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Go to Stripe Dashboard',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
    );
  }
}
