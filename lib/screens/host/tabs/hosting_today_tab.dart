import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import '../required_actions_screen.dart';
import '../hosting_main_screen.dart';
import '../../../services/host_service.dart';
import '../../../models/hosting_dashboard_model.dart';
import '../../../auth/login_signup_screen.dart';

class HostingTodayTab extends StatefulWidget {
  const HostingTodayTab({super.key});

  @override
  State<HostingTodayTab> createState() => _HostingTodayTabState();
}

class _HostingTodayTabState extends State<HostingTodayTab> {
  bool _isTodaySelected = true;
  final HostService _hostService = HostService();
  HostDashboardData? _dashboardData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await _hostService.getDashboard();
      setState(() {
        _dashboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    if (_errorMessage != null) {
      final isSessionExpired = _errorMessage!.contains('Session expired');
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_errorMessage'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isSessionExpired 
                  ? () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginSignupScreen()))
                  : _fetchDashboard,
                child: Text(isSessionExpired ? 'Log in' : 'Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final hasReservations = _isTodaySelected 
        ? (_dashboardData?.checkingIn ?? 0) > 0 || (_dashboardData?.checkingOut ?? 0) > 0
        : (_dashboardData?.upcoming ?? 0) > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: Center(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildToggleButton('Today', isSelected: _isTodaySelected),
                _buildToggleButton('Upcoming', isSelected: !_isTodaySelected),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchDashboard,
        color: Colors.black,
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    if (!hasReservations) ...[
                      // Illustration - Stylized Book
                      Center(
                        child: kIsWeb
                            ? Icon(Icons.menu_book, size: 200, color: Colors.grey.shade300)
                            : Image.network(
                                'https://cdn-icons-png.flaticon.com/512/3394/3394017.png',
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                      ),
                      const SizedBox(height: 48),
                      
                      // Text Content
                      Text(
                        _isTodaySelected 
                            ? 'You don’t have any\nreservations today'
                            : 'You don’t have any\nupcoming reservations',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'To get booked, you’ll need to complete and publish\nyour listing.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                    ] else ...[
                      // If has reservations, show them here (simplified for now)
                      Text(
                        _isTodaySelected 
                            ? '${_dashboardData?.checkingIn} checking in\n${_dashboardData?.checkingOut} checking out'
                            : '${_dashboardData?.upcoming} upcoming reservations',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    const SizedBox(height: 48),
                    
                    // CTA Button
                    ElevatedButton(
                      onPressed: () {
                        final mainState = HostingMainScreen.of(context);
                        if (mainState != null) {
                          mainState.setIndex(2); // Index for HostingListingsTab
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF7F7F7),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: const Text(
                        'Complete your listing',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 120), // Space for the bottom banner
                  ],
                ),
              ),
            ),
            
            // Bottom Banner - Show dynamic action if available
            if (_dashboardData != null && _dashboardData!.actions.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildActionBanner(_dashboardData!.actions.first),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBanner(HostAction action) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RequiredActionsScreen(
              action: _dashboardData?.actions.first,
            ),
          ),
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    action.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    action.description ?? 'Required to publish',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String label, {required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTodaySelected = (label == 'Today');
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF222222) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

