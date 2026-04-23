import 'package:flutter/material.dart';
import '../../identity_verification_screen.dart';
import '../../phone_verification_screen.dart';
import 'package:airbnb_mobile/services/auth_service.dart';
import 'package:airbnb_mobile/services/host_service.dart';
import 'package:airbnb_mobile/models/user_model.dart';
import 'package:airbnb_mobile/models/listing.dart';

class FinishUpPublishScreen extends StatefulWidget {
  final Listing? listing;
  const FinishUpPublishScreen({super.key, this.listing});

  @override
  State<FinishUpPublishScreen> createState() => _FinishUpPublishScreenState();
}

class _FinishUpPublishScreenState extends State<FinishUpPublishScreen> {
  final AuthService _authService = AuthService();
  final HostService _hostService = HostService();
  UserModel? _user;
  bool _isLoading = true;
  bool _isPublishing = false;

  @override
  void initState() {
    super.initState();
    _loadUserStatus();
  }

  Future<void> _loadUserStatus() async {
    setState(() => _isLoading = true);
    final user = await _authService.getProfile();
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  Future<void> _publishListing() async {
    if (widget.listing == null) return;
    
    setState(() => _isPublishing = true);
    try {
      await _hostService.publishListing(widget.listing!.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Listing published successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to publish: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool canPublish = (_user?.isIdentityVerified ?? false) && (_user?.isPhoneVerified ?? false);

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
        : Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadUserStatus,
                  color: Colors.black,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Finish up and publish',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Complete these final steps so you can start getting booked.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 48),
                        
                        _buildStatusItem(
                          title: 'Verify your identity',
                          subtitle: "We'll gather some information to help confirm you're you.",
                          statusText: (_user?.isIdentityVerified ?? false) ? 'Completed' : 'Required',
                          statusColor: (_user?.isIdentityVerified ?? false) ? Colors.green : const Color(0xFFFF385C),
                          showChevron: !(_user?.isIdentityVerified ?? false),
                          onTap: (_user?.isIdentityVerified ?? false) ? null : () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => const IdentityVerificationScreen()));
                            _loadUserStatus();
                          },
                        ),
                        
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Divider(height: 1),
                        ),
                        
                        _buildStatusItem(
                          title: 'Confirm your phone number',
                          subtitle: "We'll call or text to confirm your number. Standard messaging rates apply.",
                          statusText: (_user?.isPhoneVerified ?? false) ? 'Completed' : 'Required',
                          statusColor: (_user?.isPhoneVerified ?? false) ? Colors.green : const Color(0xFFFF385C),
                          showChevron: !(_user?.isPhoneVerified ?? false),
                          onTap: (_user?.isPhoneVerified ?? false) ? null : () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => const PhoneVerificationScreen()));
                            _loadUserStatus();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Bottom Publish Button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (canPublish && !_isPublishing) ? _publishListing : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                      disabledBackgroundColor: Colors.grey.shade200,
                    ),
                    child: _isPublishing
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Publish Listing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildStatusItem({
    required String title,
    required String subtitle,
    required String statusText,
    required Color statusColor,
    required bool showChevron,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 14,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showChevron)
            const Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Icon(Icons.chevron_right, color: Colors.black, size: 24),
            ),
        ],
      ),
    );
  }
}
