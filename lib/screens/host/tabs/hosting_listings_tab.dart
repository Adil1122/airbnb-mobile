import 'package:flutter/material.dart';
import '../required_actions_screen.dart';
import '../menu/create_listing_screen.dart';
import '../edit_listings_screen.dart';
import '../listing_editor_screen.dart';
import '../editor/your_space/property_type_editor_screen.dart';
import '../identity_verification_screen.dart';
import '../../profile/host/step1_screens.dart';
import '../../../services/host_service.dart';
import '../../../services/property_service.dart';
import '../../../models/listing.dart';

class HostingListingsTab extends StatefulWidget {
  const HostingListingsTab({super.key});

  @override
  State<HostingListingsTab> createState() => _HostingListingsTabState();
}

class _HostingListingsTabState extends State<HostingListingsTab> {
  bool _isGrid = false;
  bool _isSearching = false;
  bool _isEditing = false;
  final Set<String> _selectedIds = {};
  final TextEditingController _searchController = TextEditingController();
  final HostService _hostService = HostService();
  
  List<Listing> _listings = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchListings();
  }

  Future<void> _fetchListings() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final data = await _hostService.getListings();
      setState(() {
        _listings = data;
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_errorMessage'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchListings,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final filteredListings = _listings.where((l) {
      final query = _searchController.text.toLowerCase();
      return l.title.toLowerCase().contains(query) || 
             l.subtitle.toLowerCase().contains(query);
    }).toList();

    final draftListings = filteredListings.where((l) => l.status == 'DRAFT' || l.title.isEmpty || l.title == 'Untitiled Listing').toList();
    final activeListings = filteredListings.where((l) => !draftListings.contains(l)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: _isSearching ? 80 : 100,
        title: Padding(
          padding: EdgeInsets.only(top: _isSearching ? 0.0 : 10.0),
          child: _isSearching 
            ? Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: 'Search listings by name or location',
                          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                          prefixIcon: Icon(Icons.search, color: Colors.black),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSearching = false;
                        _searchController.clear();
                      });
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Listings',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      _buildHeaderIcon(Icons.search, onTap: () => setState(() => _isSearching = true)),
                      const SizedBox(width: 12),
                      _buildHeaderIcon(Icons.add, onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateListingScreen(),
                          ),
                        );
                      }),
                      const SizedBox(width: 12),
                      _buildHeaderIcon(
                        _isEditing ? Icons.close : Icons.edit_outlined,
                        isActive: _isEditing,
                        onTap: () {
                          setState(() {
                            _isEditing = !_isEditing;
                            if (!_isEditing) _selectedIds.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchListings,
        color: Colors.black,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              if (!_isSearching && !_isEditing) ...[
                const SizedBox(height: 16),
              ],
              if (activeListings.isNotEmpty) ...[
                _buildSectionHeader('${activeListings.length} active listings'),
                const SizedBox(height: 16),
                _buildListView(activeListings),
                const SizedBox(height: 32),
              ],
              if (draftListings.isNotEmpty) ...[
                _buildSectionHeader('${draftListings.length} draft listings'),
                const SizedBox(height: 16),
                _buildListView(draftListings),
                const SizedBox(height: 32),
              ],
              if (filteredListings.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80.0),
                    child: Text('No listings found', style: TextStyle(color: Colors.grey)),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _isEditing ? _buildEditBar() : _buildActionBanner(),
    );
  }


  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildActionRequiredModule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Action required',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildActionItem(
          icon: Icons.verified_user_outlined,
          title: 'Verify your identity',
          subtitle: 'Required to start hosting and receiving payments.',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const IdentityVerificationScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.black, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBanner() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RequiredActionsScreen(
              propertyTitle: _listings.isNotEmpty ? _listings.first.title : null,
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
        child: SafeArea(
           top: false,
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
    );
  }

  Widget _buildEditBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isEditing = false;
                  _selectedIds.clear();
                });
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _selectedIds.isEmpty 
                ? null 
                : () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => EditListingsScreen(
                        selectedCount: _selectedIds.length,
                      ),
                    );
                  },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              child: Text(
                'Edit ${_selectedIds.length} listing${_selectedIds.length == 1 ? '' : 's'}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(List<Listing> listings) {
    return Column(
      children: listings.map((listing) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: _buildListingCard(
            listing: listing,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildListView(List<Listing> listings) {
    // For now, we can still group by status or just show them in order
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listings.map((l) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: _buildListRow(
          listing: l,
        ),
      )).toList(),
    );
  }

  Widget _buildListRow({
    required Listing listing,
  }) {
    bool isSelected = _selectedIds.contains(listing.id);
    bool isPlaceholder = listing.imageUrl.contains('placeholder') || listing.imageUrl.isEmpty;
    
    return GestureDetector(
      onTap: _isEditing 
        ? () => setState(() => isSelected ? _selectedIds.remove(listing.id) : _selectedIds.add(listing.id))
        : isPlaceholder 
            ? () => _showInProgressBottomSheet(context, listing)
            : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListingEditorScreen(listing: listing),
                ),
              ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Row(
          children: [
            if (_isEditing) ...[
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade400,
                    width: 1.5,
                  ),
                ),
                child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
              ),
              const SizedBox(width: 16),
            ],
            Stack(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: isPlaceholder ? const Color(0xFFF2F2F2) : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    image: listing.imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(listing.imageUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: listing.imageUrl.isEmpty
                      ? const Center(
                          child: Icon(
                            Icons.camera_alt_outlined, 
                            color: Color(0xFFB0B0B0), 
                            size: 32,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green, // Default to green for now
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    listing.subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListingCard({
    required Listing listing,
  }) {
    bool isSelected = _selectedIds.contains(listing.id);
    bool isPlaceholder = listing.imageUrl.contains('placeholder') || listing.imageUrl.isEmpty;
    
    return GestureDetector(
      onTap: _isEditing 
        ? () => setState(() => isSelected ? _selectedIds.remove(listing.id) : _selectedIds.add(listing.id))
        : isPlaceholder 
            ? () => _showInProgressBottomSheet(context, listing)
            : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListingEditorScreen(listing: listing),
                ),
              ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: isPlaceholder ? const Color(0xFFEBEBEB) : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    image: listing.imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(listing.imageUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: listing.imageUrl.isEmpty
                      ? const Center(
                          child: Icon(
                            Icons.camera_alt_outlined, 
                            color: Color(0xFFB0B0B0), 
                            size: 100,
                          ),
                        )
                      : null,
                ),
              ),
              // Floating Status Tag
              if (!_isEditing)
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Published', // Dynamic status could be added here
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Selection Checkbox
              if (_isEditing)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey.shade400,
                        width: 1.5,
                      ),
                    ),
                    child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            listing.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            listing.subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }


  void _showInProgressBottomSheet(BuildContext context, Listing listing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFEBEBEB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.camera_alt_outlined, color: Color(0xFFB0B0B0), size: 64),
            ),
            const SizedBox(height: 24),
            Text(
              listing.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              listing.subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Open category selection as per latest screenshot
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PropertyTypeEditorScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text('Edit listing', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Remove listing?'),
                    content: const Text('This will permanently delete your listing from Airbnb. This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Close bottom sheet
                          _removeListing(listing.id);
                        },
                        child: const Text('Remove', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                'Remove listing',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _removeListing(String id) async {
    try {
      await _hostService.deleteListing(id);
      if (mounted) {
        setState(() {
          _listings.removeWhere((listing) => listing.id == id);
        });
        PropertyService.triggerRefresh(); // Refresh the main Explore screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing removed permanently')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing listing: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildHeaderIcon(IconData icon, {VoidCallback? onTap, bool isActive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : Colors.black,
          size: 20,
        ),
      ),
    );
  }
}
