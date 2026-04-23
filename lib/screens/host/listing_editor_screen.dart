import 'package:flutter/material.dart';
import '../../models/listing.dart';
import '../../services/host_service.dart';
import 'editor/settings/finish_up_publish_screen.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import 'editor/your_space/photo_tour_manager_screen.dart';
import 'editor/your_space/edit_title_screen.dart';
import 'editor/your_space/property_type_editor_screen.dart';
import 'editor/your_space/pricing_editor_screen.dart';
import 'editor/your_space/availability_editor_screen.dart';
import 'editor/your_space/guest_counter_editor_screen.dart';
import 'editor/your_space/edit_description_screen.dart';
import 'editor/your_space/amenities_management_screen.dart';
import 'editor/your_space/accessibility_features_screen.dart';
import 'editor/your_space/co_host_invitation_screen.dart';
import 'editor/your_space/booking_settings_editor_screen.dart';
import 'editor/your_space/house_rules_editor_screen.dart';
import 'editor/your_space/guest_safety_editor_screen.dart';
import 'editor/your_space/cancellation_policy_editor_screen.dart';
import 'editor/your_space/custom_link_editor_screen.dart';
import 'editor/arrival_guide/check_in_checkout_editor_screen.dart';
import 'editor/arrival_guide/directions_editor_screen.dart';
import 'editor/arrival_guide/check_in_method_editor_screen.dart';
import 'editor/arrival_guide/arrival_guide_placeholders.dart';
import 'editor/settings/edit_preferences_screen.dart';
import 'listing_preview_screen.dart';
import 'arrival_preview_screen.dart';
import '../profile/account_settings/personal_info/profile_edit_screen.dart';

class ListingEditorScreen extends StatefulWidget {
  final Listing listing;

  const ListingEditorScreen({
    super.key,
    required this.listing,
  });

  @override
  State<ListingEditorScreen> createState() => _ListingEditorScreenState();
}

class _ListingEditorScreenState extends State<ListingEditorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Listing _listing;
  bool _isLoading = false;
  UserModel? _user;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _listing = widget.listing;
    _loadUserStatus();
  }

  Future<void> _loadUserStatus() async {
    final user = await _authService.getProfile();
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  Future<void> _refreshListing() async {
    // In a real app, we would fetch the single listing by ID
    // For now, we'll fetch all listings and find this one
    setState(() => _isLoading = true);
    try {
      final hostService = HostService();
      final listings = await hostService.getListings();
      final updated = listings.firstWhere((l) => l.id == _listing.id);
      setState(() {
        _listing = updated;
      });
    } catch (e) {
      print('Error refreshing listing: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        title: const Text(
          'Listing editor',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditPreferencesScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
            child: Container(
              height: 56,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(32),
              ),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: -0.2,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: -0.2,
                ),
                tabs: const [
                  Tab(text: 'Your space'),
                  Tab(text: 'Arrival guide'),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildYourSpaceTab(),
                _buildArrivalGuideTab(),
              ],
            ),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 48,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
          onTap: () {
            if (_tabController.index == 0) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ListingPreviewScreen(listing: _listing)));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ArrivalPreviewScreen()));
            }
          },
          borderRadius: BorderRadius.circular(24),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.visibility_outlined, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'View',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildYourSpaceTab() {
    final listing = _listing;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Complete required steps card
          if (!(_user?.isIdentityVerified ?? false) || !(_user?.isPhoneVerified ?? false) || _listing.status != 'PUBLISHED')
          _buildActionCard(
            title: 'Complete required steps',
            subtitle: 'Finish these final tasks to publish your listing and start getting booked.',
            showIndicator: true,
            onTap: () async {
              final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => FinishUpPublishScreen(listing: _listing)));
              if (result == true) {
                _refreshListing();
                _loadUserStatus();
              }
            },
          ),
          
          if (!(_user?.isIdentityVerified ?? false) || !(_user?.isPhoneVerified ?? false) || _listing.status != 'PUBLISHED')
          const SizedBox(height: 24),
          
          // Photo tour card
          _buildCard(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PhotoTourManagerScreen())),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Photo tour',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${listing.bedrooms} bedroom · ${listing.beds} bed · ${listing.baths} bath',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${listing.images.length} photos',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(12),
                        image: listing.imageUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(listing.imageUrl),
                                fit: BoxFit.cover,
                                opacity: 0.5,
                              )
                            : null,
                      ),
                      child: listing.imageUrl.isEmpty 
                        ? Center(child: Icon(Icons.camera_alt_outlined, color: Colors.white.withOpacity(0.2), size: 48))
                        : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Title card
          _buildInfoCard(
            'Title', _listing.title,
            onTap: () async {
              final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditTitleScreen(listing: _listing)));
              if (result == true) _refreshListing();
            },
          ),
          
          const SizedBox(height: 12),
          
          // Property type card
          _buildInfoCard(
            'Property type', listing.subtitle,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyTypeEditorScreen())),
          ),
          
          const SizedBox(height: 12),
          
          // Pricing card
          _buildInfoCard(
            'Pricing',
            '\$${_listing.price.toInt()} per night\n${_listing.weekendPrice != null ? '\$${_listing.weekendPrice!.toInt()} weekend price' : 'No weekend price set'}\n${_listing.weeklyDiscount}% weekly discount',
            isMultiline: true,
            onTap: () async {
              final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => PricingEditorScreen(listing: _listing)));
              if (result == true) _refreshListing();
            },
          ),
          
          const SizedBox(height: 12),
          
          // Availability card
          _buildInfoCard(
            'Availability',
            '1 – 365 night stays\nSame day advance notice',
            isMultiline: true,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AvailabilityEditorScreen())),
          ),
          
          const SizedBox(height: 12),
          
          // Number of guests card
          _buildInfoCard(
            'Number of guests', '${listing.guests} guests',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GuestCounterEditorScreen())),
          ),
          
          const SizedBox(height: 12),
          
          // Description card
          _buildInfoCard(
            'Description', _listing.description.isEmpty ? 'Add details' : _listing.description,
            onTap: () async {
              final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditDescriptionScreen(_listing)));
              if (result == true) _refreshListing();
            },
          ),
          
          const SizedBox(height: 12),
          
          // Amenities card
          _buildInfoCard(
            'Amenities', _listing.amenities.isEmpty ? 'Add details' : _listing.amenities.join(', '),
            onTap: () async {
              final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AmenitiesManagementScreen(listing: _listing)));
              if (result == true) _refreshListing();
            },
          ),
          
          const SizedBox(height: 12),
          
          // Accessibility features card
          _buildInfoCard(
            'Accessibility features', 'Add details',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AccessibilityFeaturesScreen())),
          ),
          
          const SizedBox(height: 12),
          
          // Location card
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBEBEB),
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=${listing.fullAddress}&zoom=13&size=600x300&key=YOUR_API_KEY'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.home, color: Colors.white, size: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  listing.fullAddress,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // About the host card
          _buildCard(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileEditScreen())),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About the host',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xFF222222),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            listing.hostName.isNotEmpty ? listing.hostName[0] : 'H',
                            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        listing.hostName,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        listing.hostDuration,
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Co-hosts card
          _buildInfoCard(
            'Co-hosts', 'Add details',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CoHostInvitationScreen())),
          ),
          
          const SizedBox(height: 12),
          
          // Booking settings card
          _buildInfoCard(
            'Booking settings',
            listing.bookingType == 'instant' 
                ? "Instant Book: Guests can book without approval" 
                : "Request to Book: You'll approve each reservation",
            isMultiline: true,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingSettingsEditorScreen())),
          ),
          
          const SizedBox(height: 12),
          
          // House rules card
          _buildCard(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HouseRulesEditorScreen())),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'House rules',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.group_outlined, size: 20),
                    const SizedBox(width: 12),
                    Text('${listing.guests} guests maximum', style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Guest safety card
          _buildCard(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GuestSafetyEditorScreen())),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Guest safety',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildSafetyItem(Icons.no_photography_outlined, 'Carbon monoxide alarm not reported'),
                const SizedBox(height: 12),
                _buildSafetyItem(Icons.smoke_free_outlined, 'Smoke alarm not reported'),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Cancellation policy card
          _buildInfoCard(
            'Cancellation policy', listing.cancellationPolicy,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CancellationPolicyEditorScreen())),
          ),
          
          const SizedBox(height: 12),
          
          // Custom link card
          _buildInfoCard(
            'Custom link', 'Add details',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomLinkEditorScreen())),
          ),
          
          const SizedBox(height: 100), // Space for floating button
        ],
      ),
    );
  }

  Widget _buildArrivalGuideTab() {
    final listing = _listing;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Complete required steps card
          _buildActionCard(
            title: 'Complete required steps',
            subtitle: 'Finish these final tasks to publish your listing and start getting booked.',
            showIndicator: true,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FinishUpPublishScreen(listing: _listing))),
          ),
          
          const SizedBox(height: 24),
          
          // Check-in & Checkout split card
          _buildSplitInfoCard(
            'Check-in', listing.checkInTime,
            'Checkout', listing.checkOutTime,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CheckInCheckoutEditorScreen())),
          ),
          
          const SizedBox(height: 12),
          
          // Directions
          _buildInfoCard(
            'Directions', listing.checkInInstructions ?? 'Add details',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DirectionsEditorScreen())),
          ),
          
          const SizedBox(height: 12),
          
          // Check-in method
          _buildInfoCard(
            'Check-in method', listing.checkInMethod ?? 'Add details',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckInMethodEditorScreen())),
          ),
          
          const SizedBox(height: 12),
          
          // Wifi details
          _buildInfoCard(
            'Wifi details', 
            listing.wifiNetwork != null ? 'Network: ${listing.wifiNetwork}' : 'Add details',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WifiDetailsEditorScreen())),
          ),
          
          const SizedBox(height: 12),
          
          // House manual
          _buildInfoCard(
            'House manual', listing.houseManual ?? 'Add details',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HouseManualEditorScreen())),
          ),
          
          const SizedBox(height: 12),
          
          // House rules
          _buildCard(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HouseRulesEditorScreen())),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'House rules',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.group_outlined, size: 20),
                    const SizedBox(width: 12),
                    Text('${listing.guests} guests maximum', style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Checkout instructions
          _buildInfoCard(
            'Checkout instructions', listing.checkoutInstructions ?? 'Add details',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutInstructionsEditorScreen())),
          ),
          
          const SizedBox(height: 12),
          
          // Guidebooks
          _buildInfoCard(
            'Guidebooks', 'Add details',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GuidebooksEditorScreen())),
          ),
          
          const SizedBox(height: 12),
          
          // Interaction preferences
          _buildInfoCard(
            'Interaction preferences', listing.interactionPreference ?? 'Add details',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InteractionPreferencesEditorScreen())),
          ),
          
          const SizedBox(height: 100), // Space for floating button
        ],
      ),
    );
  }


  Widget _buildSplitInfoCard(String title1, String value1, String title2, String value2, {VoidCallback? onTap}) {
    return _buildCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title1, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(value1, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            height: 48,
            width: 1,
            color: Colors.grey.shade200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title2, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(value2, style: const TextStyle(fontSize: 14, color: Colors.grey), textAlign: TextAlign.right),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: child,
      ),
    );
  }

  Widget _buildActionCard({required String title, required String subtitle, bool showIndicator = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showIndicator)
              Container(
                margin: const EdgeInsets.only(top: 6, right: 12),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF385C),
                  shape: BoxShape.circle,
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, {bool isMultiline = false, VoidCallback? onTap}) {
    return _buildCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: value == 'Add details' ? Colors.grey : Colors.black87,
              height: isMultiline ? 1.5 : 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
