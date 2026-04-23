import 'package:flutter/material.dart';
import '../../../../models/listing.dart';
import '../../../../services/host_service.dart';

class AmenityGroup {
  final String category;
  final List<AmenityItem> items;

  AmenityGroup(this.category, this.items);
}

class AmenityItem {
  final String label;
  final IconData icon;

  const AmenityItem(this.label, this.icon);
}

class AmenitiesManagementScreen extends StatefulWidget {
  final Listing listing;
  const AmenitiesManagementScreen({super.key, required this.listing});

  @override
  State<AmenitiesManagementScreen> createState() => _AmenitiesManagementScreenState();
}

class _AmenitiesManagementScreenState extends State<AmenitiesManagementScreen> {
  String _selectedCategory = 'All';
  final Set<String> _selectedAmenities = {};
  bool _isSaving = false;
  final HostService _hostService = HostService();

  final List<String> _categories = [
    'All', 'Basics', 'Bathroom', 'Bedroom and laundry', 'Entertainment', 
    'Family', 'Heating and cooling', 'Home safety', 'Internet and office', 
    'Kitchen and dining', 'Location features', 'Outdoor', 'Parking and facilities', 'Services'
  ];

  final List<AmenityGroup> _amenityGroups = [
    AmenityGroup('Basics', [
      const AmenityItem('Air conditioning', Icons.ac_unit),
      const AmenityItem('Cleaning products', Icons.cleaning_services),
      const AmenityItem('Cooking basics', Icons.soup_kitchen),
      const AmenityItem('Dedicated workspace', Icons.desk),
    ]),
    AmenityGroup('Bathroom', [
      const AmenityItem('Body soap', Icons.dry_cleaning),
      const AmenityItem('Conditioner', Icons.sanitizer),
      const AmenityItem('Hot water', Icons.hot_tub),
      const AmenityItem('Shower gel', Icons.shower),
    ]),
    AmenityGroup('Entertainment', [
      const AmenityItem('Arcade games', Icons.videogame_asset),
      const AmenityItem('Board games', Icons.casino),
      const AmenityItem('Books and reading material', Icons.menu_book),
      const AmenityItem('TV', Icons.tv),
    ]),
    AmenityGroup('Outdoor', [
      const AmenityItem('BBQ grill', Icons.outdoor_grill),
      const AmenityItem('Backyard', Icons.park),
      const AmenityItem('Beach access', Icons.beach_access),
      const AmenityItem('Outdoor dining area', Icons.deck),
      const AmenityItem('Patio or balcony', Icons.balcony),
    ]),
  ];

  @override
  void initState() {
    super.initState();
    // Pre-populate if listing has amenities (assuming they are strings in listing.amenities if it existed)
    // For now we start fresh or from a mock list if we had one
  }

  List<AmenityItem> get _filteredAmenities {
    if (_selectedCategory == 'All') {
      return _amenityGroups.expand((g) => g.items).toList();
    }
    return _amenityGroups
        .firstWhere((g) => g.category == _selectedCategory, orElse: () => AmenityGroup('', []))
        .items;
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    try {
      await _hostService.updateAmenities(widget.listing.id, _selectedAmenities.toList());
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Amenities', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: _filteredAmenities.length,
              itemBuilder: (context, index) {
                final amenity = _filteredAmenities[index];
                final isSelected = _selectedAmenities.contains(amenity.label);
                return _buildAmenityRow(amenity, isSelected);
              },
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = category);
              },
              backgroundColor: Colors.white,
              selectedColor: Colors.black,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: isSelected ? Colors.black : Colors.grey.shade300),
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildAmenityRow(AmenityItem amenity, bool isSelected) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Icon(amenity.icon, size: 32, color: Colors.black),
      title: Text(
        amenity.label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
      trailing: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedAmenities.remove(amenity.label);
            } else {
              _selectedAmenities.add(amenity.label);
            }
          });
        },
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
            color: isSelected ? Colors.black : Colors.white,
          ),
          child: Icon(
            isSelected ? Icons.check : Icons.add,
            size: 18,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _isSaving ? null : _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _isSaving 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
