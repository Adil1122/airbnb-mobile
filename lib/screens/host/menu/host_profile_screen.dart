import 'package:flutter/material.dart';
import 'edit_host_profile_screen.dart';
import '../../../services/auth_service.dart';
import '../../../models/user_model.dart';
import 'package:flutter/foundation.dart';

class HostProfileScreen extends StatefulWidget {
  const HostProfileScreen({super.key});

  @override
  State<HostProfileScreen> createState() => _HostProfileScreenState();
}

class _HostProfileScreenState extends State<HostProfileScreen> {
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
    final user = await _authService.getProfile();
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.black)));
    }

    String getBaseUrl() {
      if (kIsWeb) return 'http://localhost:3001';
      return 'http://192.168.1.12:3001';
    }

    final avatarUrl = _user?.avatar != null ? '${getBaseUrl()}${_user!.avatar}' : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0, top: 8, bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TextButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditHostProfileScreen(),
                      fullscreenDialog: true,
                    ),
                  );
                  _loadProfile();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // Profile Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 48),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Large Avatar
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Color(0xFF222222),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: avatarUrl != null 
                          ? Image.network(avatarUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => Center(child: Text(_user?.name.substring(0, 1).toUpperCase() ?? '?', style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold))))
                          : Center(
                              child: Text(
                                _user?.name.isNotEmpty == true ? _user!.name.substring(0, 1).toUpperCase() : '?',
                                style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _user?.name ?? 'Ahmad',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Host',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              
              // Completion Section
              const Text(
                'Complete your profile',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Your Airbnb profile is an important part of every reservation. Complete yours to help other hosts and guests get to know you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // CTA Button
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditHostProfileScreen(),
                        fullscreenDialog: true,
                      ),
                    );
                    _loadProfile();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE31C5F), // Airbnb Pink
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 18),
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
        ),
      ),
    );
  }
}
