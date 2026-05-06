import 'package:flutter/material.dart';
import '../required_actions_screen.dart';
import '../calendar_settings_screen.dart';
import '../listing_calendar_screen.dart';
import '../editor/settings/edit_preferences_screen.dart';
import '../../../services/auth_service.dart';
import '../../../services/host_service.dart';
import '../../../models/user_model.dart';
import '../../../models/listing.dart';

class HostingCalendarTab extends StatefulWidget {
  const HostingCalendarTab({super.key});

  @override
  State<HostingCalendarTab> createState() => _HostingCalendarTabState();
}

class _HostingCalendarTabState extends State<HostingCalendarTab> {
  UserModel? _user;
  bool _isLoadingProfile = true;
  bool _isLoadingListings = true;
  List<Listing> _listings = [];
  final AuthService _authService = AuthService();
  final HostService _hostService = HostService();
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadProfile(),
      _loadListings(),
    ]);
  }

  Future<void> _loadListings() async {
    setState(() => _isLoadingListings = true);
    try {
      final listings = await _hostService.getListings();
      if (mounted) {
        setState(() {
          _listings = listings;
          _isLoadingListings = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingListings = false);
      }
    }
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoadingProfile = true);
    try {
      final user = await _authService.getProfile();
      if (mounted) {
        setState(() {
          _user = user;
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingProfile = false);
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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black, size: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalendarSettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          _isLoadingListings && _listings.isEmpty
              ? const Center(child: CircularProgressIndicator(color: Colors.black))
              : RefreshIndicator(
                  onRefresh: _loadListings,
                  color: const Color(0xFFFF385C),
                  child: ListView(
                    padding: const EdgeInsets.all(24.0),
                    children: [
                      const Text(
                        'Calendars',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_listings.isEmpty && !_isLoadingListings)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Text('No listings found', style: TextStyle(color: Colors.grey)),
                          ),
                        )
                      else
                        ..._listings.map((listing) => _buildListingItem(listing)).toList(),
                      const SizedBox(height: 100), // Space for banner
                    ],
                  ),
                ),

          // Shared Bottom Banner (Only show if user NOT verified)
          if (!((_user?.isIdentityVerified ?? false) && (_user?.isPhoneVerified ?? false)))
            _buildSharedBottomBanner(),
        ],
      ),
    );
  }

  Widget _buildListingItem(Listing listing) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListingCalendarScreen(listing: listing),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                listing.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Title and Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    listing.status ?? 'In progress',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Dots Grid Icon (Calendar Preview representation)
            SizedBox(
              width: 60,
              child: Column(
                children: List.generate(4, (rowIndex) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (colIndex) {
                      // Just some dummy logic to color dots like the screenshot
                      bool isRed = rowIndex == 3 && colIndex == 3;
                      bool isBlack = rowIndex == 3 && colIndex == 4;
                      return Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: isRed ? const Color(0xFFFF385C) : (isBlack ? Colors.black : Colors.grey.shade300),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSharedBottomBanner() {
    return Positioned(
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
                    Text('Confirm a few key details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Required to publish', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
