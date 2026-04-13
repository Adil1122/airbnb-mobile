import 'package:flutter/material.dart';
import '../required_actions_screen.dart';
import '../menu/create_listing_screen.dart';
import '../edit_listings_screen.dart';
import '../listing_editor_screen.dart';
import '../../profile/host/step1_screens.dart';

class HostingListingsTab extends StatefulWidget {
  const HostingListingsTab({super.key});

  @override
  State<HostingListingsTab> createState() => _HostingListingsTabState();
}

class _HostingListingsTabState extends State<HostingListingsTab> {
  bool _isGrid = false; // Default to List view as per latest screenshot
  bool _isSearching = false;
  bool _isEditing = false;
  final Set<int> _selectedIndices = {};
  final TextEditingController _searchController = TextEditingController();
  
  // Dynamic listings list
  late List<Map<String, dynamic>> _listings;

  @override
  void initState() {
    super.initState();
    _listings = [
      {
        'id': 0,
        'title': 'apartment in islamabad',
        'location': 'Home in Islamabad, Islamabad Capital Territory',
        'status': 'Action required',
        'statusColor': const Color(0xFFFF385C),
        'image': null,
        'isPlaceholder': false,
      },
      {
        'id': 1,
        'title': 'Your House listing',
        'location': 'Home',
        'status': 'In progress',
        'statusColor': Colors.orange,
        'image': null,
        'isPlaceholder': true,
      },
      {
        'id': 2,
        'title': 'Your House listing',
        'location': 'Home',
        'status': 'In progress',
        'statusColor': Colors.orange,
        'image': null,
        'isPlaceholder': true,
      },
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    'Your listings',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: -0.8,
                    ),
                  ),
                  Row(
                    children: [
                      _buildHeaderIcon(
                        Icons.search,
                        onTap: () => setState(() => _isSearching = true),
                      ),
                      const SizedBox(width: 12),
                      _buildHeaderIcon(
                        _isGrid ? Icons.format_list_bulleted : Icons.grid_view_sharp,
                        onTap: () => setState(() => _isGrid = !_isGrid),
                      ),
                      const SizedBox(width: 12),
                      _buildHeaderIcon(
                        Icons.add,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateListingScreen())),
                      ),
                      const SizedBox(width: 12),
                      _buildHeaderIcon(
                        Icons.edit_note_outlined,
                        isActive: _isEditing,
                        onTap: () {
                          setState(() {
                            _isEditing = !_isEditing;
                            if (!_isEditing) _selectedIndices.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            if (_isGrid)
              _buildGridView()
            else
              _buildListView(),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: _isEditing ? _buildEditBar() : _buildActionBanner(),
    );
  }

  Widget _buildActionBanner() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RequiredActionsScreen()),
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
                  _selectedIndices.clear();
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
              onPressed: _selectedIndices.isEmpty 
                ? null 
                : () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => EditListingsScreen(
                        selectedCount: _selectedIndices.length,
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
                'Edit ${_selectedIndices.length} listing${_selectedIndices.length == 1 ? '' : 's'}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return Column(
      children: _listings.map((listing) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: _buildListingCard(
            index: listing['id'],
            title: listing['title'],
            location: listing['location'],
            status: listing['status'],
            statusColor: listing['statusColor'],
            image: listing['image'],
            isPlaceholder: listing['isPlaceholder'],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildListView() {
    final actionRequired = _listings.where((l) => l['status'] == 'Action required').toList();
    final inProgress = _listings.where((l) => l['status'] == 'In progress').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (actionRequired.isNotEmpty) ...[
          const Text(
            'Action required',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...actionRequired.map((l) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildListRow(
              index: l['id'],
              title: l['title'],
              location: l['location'],
              statusColor: l['statusColor'],
              image: l['image'],
              isPlaceholder: l['isPlaceholder'],
            ),
          )),
          const SizedBox(height: 16),
        ],
        
        if (inProgress.isNotEmpty) ...[
          const Text(
            'In progress',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...inProgress.map((l) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildListRow(
              index: l['id'],
              title: l['title'],
              location: l['location'],
              statusColor: l['statusColor'],
              image: l['image'],
              isPlaceholder: l['isPlaceholder'],
            ),
          )),
        ],
      ],
    );
  }

  Widget _buildListRow({
    required int index,
    required String title,
    required String location,
    required Color statusColor,
    String? image,
    bool isPlaceholder = false,
  }) {
    bool isSelected = _selectedIndices.contains(index);
    return GestureDetector(
      onTap: _isEditing 
        ? () => setState(() => isSelected ? _selectedIndices.remove(index) : _selectedIndices.add(index))
        : isPlaceholder 
            ? () => _showInProgressBottomSheet(context, index, title, location)
            : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListingEditorScreen(listingTitle: title),
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
                    color: isPlaceholder ? const Color(0xFFF2F2F2) : const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(8),
                    image: image != null
                        ? DecorationImage(
                            image: NetworkImage(image),
                            fit: BoxFit.cover,
                            opacity: 0.2,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.camera_alt_outlined, 
                      color: isPlaceholder ? const Color(0xFFB0B0B0) : Colors.white24, 
                      size: 32,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: statusColor,
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
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
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

  Widget _buildHeaderIcon(IconData icon, {VoidCallback? onTap, bool isActive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : const Color(0xFFF7F7F7),
          shape: BoxShape.circle,
          border: Border.all(color: isActive ? Colors.black : Colors.grey.shade200),
        ),
        child: Icon(icon, size: 20, color: isActive ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildListingCard({
    required int index,
    required String title,
    required String location,
    required String status,
    required Color statusColor,
    String? image,
    bool isPlaceholder = false,
  }) {
    bool isSelected = _selectedIndices.contains(index);
    return GestureDetector(
      onTap: _isEditing 
        ? () => setState(() => isSelected ? _selectedIndices.remove(index) : _selectedIndices.add(index))
        : isPlaceholder 
            ? () => _showInProgressBottomSheet(context, index, title, location)
            : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListingEditorScreen(listingTitle: title),
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
                    color: isPlaceholder ? const Color(0xFFEBEBEB) : const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    image: image != null
                        ? DecorationImage(
                            image: NetworkImage(image),
                            fit: BoxFit.cover,
                            opacity: 0.1, // Style for placeholder icons
                          )
                        : null,
                  ),
                  child: isPlaceholder 
                      ? const Center(child: Icon(Icons.camera_alt_outlined, color: Color(0xFFB0B0B0), size: 100))
                      : const Center(child: Icon(Icons.camera_alt_outlined, color: Colors.white24, size: 100)),
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
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          status,
                          style: const TextStyle(
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
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            location,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _showInProgressBottomSheet(BuildContext context, int id, String title, String location) {
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
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              location,
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
                      builder: (context) => const PropertyTypeSelectionScreen(),
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
                _removeListing(id);
                Navigator.pop(context);
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

  void _removeListing(int id) {
    setState(() {
      _listings.removeWhere((listing) => listing['id'] == id);
    });
  }
}
