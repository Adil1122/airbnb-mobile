import 'package:flutter/material.dart';
import 'account_settings/personal_info/profile_edit_screen.dart';
import 'past_trips_screen.dart';
import 'connections_screen.dart';
import 'become_host_screen.dart';
import 'account_settings/account_settings_screen.dart';
import '../host/hosting_main_screen.dart';
import '../../services/auth_service.dart';
import '../../auth/login_signup_screen.dart';
import '../../models/user_model.dart';
import '../host_payouts_screen.dart';
import '../../services/host_service.dart';
import '../../utils/api_config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;
  bool _hasListings = false;
  final AuthService _authService = AuthService();
  final HostService _hostService = HostService();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final user = await _authService.getProfile();
    final listings = await _hostService.getListings();
    
    if (mounted) {
      setState(() {
        _user = user;
        _hasListings = listings.isNotEmpty;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0, top: 8.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black12),
              ),
              child: const Icon(Icons.notifications_none, color: Colors.black, size: 28),
            ),
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.black))
        : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 24),

                // User Info Card
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
                    );
                    _loadProfile();
                  },
                  child: _buildInfoCard(),
                ),
                const SizedBox(height: 24),

                // Past trips & Connections Row
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PastTripsScreen()),
                          );
                        },
                        child: _buildSubCard(
                          title: 'Past trips',
                          isNew: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ConnectionsScreen()),
                          );
                        },
                        child: _buildSubCard(
                          title: 'Connections',
                          isNew: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Become a Host Card
                GestureDetector(
                  onTap: () {
                    if (_user?.role == 'HOST') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HostingMainScreen()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BecomeHostScreen()),
                      );
                    }
                  },
                  child: _buildBecomeHostCard(),
                ),
                const SizedBox(height: 32),

                // Settings Items
                _buildSettingsRow(
                  Icons.settings_outlined, 
                  'Account settings',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AccountSettingsScreen()),
                    );
                  },
                ),
                const SizedBox(height: 24),
                if (_user?.role == 'HOST') ...[
                  _buildSettingsRow(
                    Icons.account_balance_wallet_outlined, 
                    'Payouts & Payments',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HostPayoutsScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
                _buildSettingsRow(Icons.help_outline, 'Get help'),
                const SizedBox(height: 24),
                _buildSettingsRow(Icons.person_outline, 'View profile'),
                const SizedBox(height: 24),
                _buildSettingsRow(Icons.back_hand_outlined, 'Privacy'),
                const SizedBox(height: 32),

                const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 32),

                if (_user?.role == 'HOST') ...[
                  _buildSettingsRow(Icons.people_outline, 'Refer a host'),
                  const SizedBox(height: 24),
                  _buildSettingsRow(Icons.person_search_outlined, 'Find a co-host'),
                  const SizedBox(height: 24),
                ],
                _buildSettingsRow(Icons.description_outlined, 'Legal'),
                const SizedBox(height: 24),
                _buildSettingsRow(
                  Icons.meeting_room_outlined, 
                  'Log out', 
                  hasChevron: false,
                  onTap: () async {
                    await _authService.logout();
                    if (mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginSignupScreen()),
                        (route) => false,
                      );
                    }
                  },
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
      floatingActionButton: _isLoading ? null : FloatingActionButton.extended(
        onPressed: () {
          if (_user?.role == 'HOST' || _hasListings) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HostingMainScreen()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BecomeHostScreen()),
            );
          }
        },
        backgroundColor: Colors.black,
        elevation: 4,
        label: Text(
          (_user?.role == 'HOST' || _hasListings) ? 'Switch to hosting' : 'Become a host',
          style: const TextStyle(
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

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF222222),
              shape: BoxShape.circle,
              image: (_user?.avatar != null && _user!.avatar!.isNotEmpty)
                  ? DecorationImage(
                      image: NetworkImage(
                        _user!.avatar!.startsWith('http')
                            ? _user!.avatar!
                            : '${ApiConfig.baseUrl.replaceAll('/auth', '')}${_user!.avatar}',
                      ),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (_user?.avatar == null || _user!.avatar!.isEmpty)
                ? Center(
                    child: Text(
                      _user?.name.isNotEmpty == true ? _user!.name.substring(0, 1).toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            _user?.name ?? 'Guest',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Guest',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubCard({required String title, bool isNew = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                title == 'Past trips'
                    ? 'https://cdn-icons-png.flaticon.com/512/2921/2921501.png'
                    : 'https://cdn-icons-png.flaticon.com/512/3468/3468192.png',
                height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (isNew)
            Positioned(
              top: -10,
              right: -10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A5F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBecomeHostCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.network(
            'https://cdn-icons-png.flaticon.com/512/3014/3014569.png',
            height: 60,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (_user?.role == 'HOST' || _hasListings) ? 'Switch to hosting' : 'Become a host',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  (_user?.role == 'HOST' || _hasListings)
                    ? 'Manage your listings and reservations.'
                    : "It's easy to start hosting and earn extra income.",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow(IconData icon, String title, {bool hasChevron = true, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
          if (hasChevron)
            const Icon(Icons.chevron_right, color: Colors.black54),
        ],
      ),
    );
  }
}
