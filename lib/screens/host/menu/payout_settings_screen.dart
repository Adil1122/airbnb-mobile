import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../../utils/api_config.dart';

class PayoutSettingsScreen extends StatefulWidget {
  const PayoutSettingsScreen({super.key});

  @override
  State<PayoutSettingsScreen> createState() => _PayoutSettingsScreenState();
}

class _PayoutSettingsScreenState extends State<PayoutSettingsScreen> {
  bool _isLoading = true;
  bool _isConnecting = false;
  bool _isConnected = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  String getBaseUrl() => ApiConfig.baseUrl;

  Future<void> _checkStatus() async {
    setState(() => _isLoading = true);
    try {
      final token = await _authService.getToken();
      final response = await http.get(
        Uri.parse('${getBaseUrl()}/payment/host/status'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _isConnected = data['isConnected'] ?? false;
        });
      }
    } catch (e) {
      debugPrint('Error checking stripe status: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _startOnboarding() async {
    setState(() => _isConnecting = true);
    try {
      final token = await _authService.getToken();
      
      // 1. Create account
      final createAccResponse = await http.post(
        Uri.parse('${getBaseUrl()}/payment/host/create-account'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (createAccResponse.statusCode == 201 || createAccResponse.statusCode == 200) {
        // 2. Create link
        final createLinkResponse = await http.post(
          Uri.parse('${getBaseUrl()}/payment/host/create-onboarding-link'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (createLinkResponse.statusCode == 201 || createLinkResponse.statusCode == 200) {
          final linkData = json.decode(createLinkResponse.body);
          final url = Uri.parse(linkData['url']);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
            
            // Show instructions to user
            if (mounted) {
              _showOnboardingInstructions();
            }
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isConnecting = false);
    }
  }

  void _showOnboardingInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stripe Onboarding'),
        content: const Text('Please complete the onboarding in your browser. Once done, return here to refresh your status.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _checkStatus();
            },
            child: const Text('Refresh Status'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
        ],
      ),
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
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.black))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How you\'ll get paid',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Add at least one payout method so we know where to send your money.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                
                if (!_isConnected)
                  ElevatedButton(
                    onPressed: _isConnecting ? null : _startOnboarding,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF222222),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: _isConnecting 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text(
                          'Set up payouts',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green.shade200),
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Your payout method is set up and ready.',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextButton(
                          onPressed: _startOnboarding,
                          child: const Text('Edit', style: TextStyle(color: Colors.black, decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 64),
                
                // Need Help Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Need help?',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      _buildHelpRow('When you\'ll get your payout'),
                      const Divider(height: 32),
                      _buildHelpRow('How payouts work'),
                      const Divider(height: 32),
                      _buildHelpRow('Go to your transaction history'),
                    ],
                  ),
                ),
                
                const SizedBox(height: 48),
              ],
            ),
          ),
    );
  }

  Widget _buildHelpRow(String title) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black, size: 24),
        ],
      ),
    );
  }
}
