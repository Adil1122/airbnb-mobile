import 'package:flutter/material.dart';

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
  const AmenitiesManagementScreen({super.key});

  @override
  State<AmenitiesManagementScreen> createState() => _AmenitiesManagementScreenState();
}

class _AmenitiesManagementScreenState extends State<AmenitiesManagementScreen> {
  String _selectedCategory = 'All';
  final Set<String> _selectedAmenities = {};

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
    AmenityGroup('Family', [
      const AmenityItem('Baby bath', Icons.bathtub),
      const AmenityItem('Baby monitor', Icons.videocam_outlined), // Better placeholder
      const AmenityItem('Baby safety gates', Icons.security), // Fixed: Icons.gate doesn't exist
      const AmenityItem('Children\'s bikes', Icons.directions_bike),
      const AmenityItem('Crib', Icons.crib),
    ]),
    // Adding more based on screenshots
    AmenityGroup('Outdoor', [
      const AmenityItem('BBQ grill', Icons.outdoor_grill),
      const AmenityItem('Backyard', Icons.park),
      const AmenityItem('Beach access', Icons.beach_access),
      const AmenityItem('Outdoor dining area', Icons.deck),
      const AmenityItem('Patio or balcony', Icons.balcony),
    ]),
  ];

  List<AmenityItem> get _filteredAmenities {
    if (_selectedCategory == 'All') {
      return _amenityGroups.expand((g) => g.items).toList();
    }
    return _amenityGroups
        .firstWhere((g) => g.category == _selectedCategory, orElse: () => AmenityGroup('', []))
        .items;
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
      ),
      body: Column(
        children: [
          // Category Chips
          _buildCategoryFilter(),
          
          const Divider(height: 1),

          // Scrollable Amenities List
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

          // Sticky Footer
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
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
