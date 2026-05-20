import 'package:flutter/material.dart';
import '../required_actions_screen.dart';
import '../menu/account_settings_screen.dart';
import '../menu/hosting_resources_screen.dart';
import '../menu/find_cohost_screen.dart';
import '../menu/get_help_screen.dart';
import '../menu/create_listing_screen.dart';
import '../menu/create_experience_screen.dart';
import '../menu/create_service_screen.dart';
import '../menu/my_experiences_screen.dart';
import '../menu/my_services_screen.dart';
import '../menu/refer_host_screen.dart';
import '../menu/legal_screen.dart';
import '../menu/host_profile_screen.dart';
import '../menu/payout_settings_screen.dart';
import '../../../services/auth_service.dart';
import '../../../models/user_model.dart';
import '../../../auth/login_signup_screen.dart';
import '../../main_screen.dart';
import 'package:flutter/foundation.dart';
import '../../../utils/api_config.dart';

class HostingMenuTab extends StatefulWidget {
  const HostingMenuTab({super.key});

  @override
  State<HostingMenuTab> createState() => _HostingMenuTabState();
}

class _HostingMenuTabState extends State<HostingMenuTab> {
  UserModel? _user;
  bool _isLoading = true;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authService.getProfile();
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String getBaseUrl() => ApiConfig.baseUrl;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Menu',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              Row(
                children: [
                  _buildHeaderIcon(Icons.notifications_outlined),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HostProfileScreen()),
                      );
                    },
                    child: _buildAvatarIcon(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                // Promotional Card
                _buildPromoCard(context),
                const SizedBox(height: 48),
                
                // Menu List
                _buildMenuItem(context, Icons.settings_outlined, 'Account settings', 
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountSettingsScreen()))),
                _buildMenuItem(context, Icons.menu_book_outlined, 'Hosting resources', 
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HostingResourcesScreen()))),
                _buildMenuItem(context, Icons.help_outline, 'Get help', 
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GetHelpScreen()))),
                _buildMenuItem(context, Icons.emoji_people_outlined, 'Find a co-host', 
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FindCohostScreen()))),
                _buildMenuItem(context, Icons.add_home_outlined, 'Create a new listing',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateListingScreen()))),
                _buildMenuItem(context, Icons.explore_outlined, 'Host an experience',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateExperienceScreen()))),
                _buildMenuItem(context, Icons.list_alt_outlined, 'My experiences',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyExperiencesScreen()))),
                _buildMenuItem(context, Icons.handyman_outlined, 'Offer a service',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateServiceScreen()))),
                _buildMenuItem(context, Icons.home_repair_service_outlined, 'My services',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyServicesScreen()))),
                _buildMenuItem(context, Icons.people_outline, 'Refer a host',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReferHostScreen()))),
                _buildMenuItem(context, Icons.payments_outlined, 'Payout settings',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PayoutSettingsScreen()))),
                _buildMenuItem(context, Icons.auto_stories_outlined, 'Legal',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LegalScreen()))),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(),
                ),
                _buildMenuItem(context, Icons.logout, 'Log out', isLast: true, 
                  onTap: () async {
                    await _authService.logout();
                    if (mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginSignupScreen()),
                        (route) => false,
                      );
                    }
                  }),
                
                const SizedBox(height: 120), // Banner space
              ],
            ),
          ),
          
          // Bottom Banner
          if (!((_user?.isIdentityVerified ?? false) && (_user?.isPhoneVerified ?? false)))
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RequiredActionsScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, -4),
                      ),
                    ],
                    border: Border(top: BorderSide(color: Colors.grey.shade100)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Confirm a few key details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Required to publish',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: Colors.grey.shade400),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (route) => false,
          );
        },
        backgroundColor: Colors.black,
        elevation: 4,
        label: const Text(
          'Switch to traveling',
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        icon: const Icon(Icons.swap_horiz, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Icon(icon, size: 20, color: Colors.black),
    );
  }

  Widget _buildAvatarIcon() {
    final avatarUrl = _user?.avatar != null ? '${getBaseUrl()}${_user!.avatar}' : null;

    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xFF222222),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: avatarUrl != null 
          ? Image.network(
              avatarUrl, 
              fit: BoxFit.cover, 
              errorBuilder: (c, e, s) => Center(child: Text(_user?.name.substring(0, 1).toUpperCase() ?? '?', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))
          : Center(
              child: Text(
                _user?.name.isNotEmpty == true ? _user!.name.substring(0, 1).toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildPromoCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F0), // Light cream/beige
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Stylized image stack
          Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(width: 250, height: 160), // Space for tilted images
              _buildTiltedImage('https://cdn-icons-png.flaticon.com/512/3222/3222687.png', -0.15, -40),
              _buildTiltedImage('https://cdn-icons-png.flaticon.com/512/3394/3394017.png', 0.1, 40),
              _buildTiltedImage('https://cdn-icons-png.flaticon.com/512/3135/3135715.png', 0, 0),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'New to Airbnb?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Discover tips and best practices shared by top-rated hosts.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Button
          Container(
            width: 200,
            margin: const EdgeInsets.only(bottom: 40),
                        child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateListingScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Get started',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTiltedImage(String url, double rotate, double shiftX) {
    return Transform.translate(
      offset: Offset(shiftX, 0),
      child: Transform.rotate(
        angle: rotate,
        child: Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, {bool isLast = false, VoidCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: Colors.black, size: 28),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          trailing: isLast ? null : Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 24),
          onTap: onTap ?? () {},
        ),
        if (!isLast) const Divider(height: 1),
      ],
    );
  }
}
