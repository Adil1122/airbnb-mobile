import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'step3_screens.dart';

// --- Shared Models ---

class AmenityItem {
  final String label;
  final IconData icon;

  const AmenityItem({required this.label, required this.icon});
}

class HighlightItem {
  final String label;
  final IconData icon;

  const HighlightItem({required this.label, required this.icon});
}

// --- Screen 1: Intro ---

class HostStep2IntroScreen extends StatelessWidget {
  const HostStep2IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0, top: 8.0),
            child: OutlinedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Save & exit',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Illustration
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: kIsWeb
                          ? Container(
                              height: 300,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.home_outlined, size: 64, color: Colors.black26),
                            )
                          : Image.file(
                              File('C:/Users/Computer Arena/.gemini/antigravity/brain/7d4a128d-57c1-4474-a7df-7a99dd1c5a54/airbnb_host_step2_house_illustration_1775466445849.png'),
                              height: 300,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  
                  // Text Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Step 2',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Make your place stand out',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.0,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'In this step, you’ll add some of the amenities your place offers, plus 5 or more photos. Then, you’ll create a title and description.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // Progress Bar and Bottom Nav
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade100, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.16, // Step 2, Screen 1/6
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AmenitiesSelectionScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Screen 2: Amenities ---

class AmenitiesSelectionScreen extends StatefulWidget {
  const AmenitiesSelectionScreen({super.key});

  @override
  State<AmenitiesSelectionScreen> createState() => _AmenitiesSelectionScreenState();
}

class _AmenitiesSelectionScreenState extends State<AmenitiesSelectionScreen> {
  final Set<String> _selectedAmenities = {};

  final List<AmenityItem> _favorites = [
    const AmenityItem(label: 'Wifi', icon: Icons.wifi),
    const AmenityItem(label: 'TV', icon: Icons.tv),
    const AmenityItem(label: 'Kitchen', icon: Icons.kitchen),
    const AmenityItem(label: 'Washer', icon: Icons.local_laundry_service),
    const AmenityItem(label: 'Free parking on premises', icon: Icons.directions_car),
    const AmenityItem(label: 'Paid parking on premises', icon: Icons.local_parking),
    const AmenityItem(label: 'Air conditioning', icon: Icons.ac_unit),
    const AmenityItem(label: 'Dedicated workspace', icon: Icons.desk),
  ];

  final List<AmenityItem> _standouts = [
    const AmenityItem(label: 'Pool', icon: Icons.pool),
    const AmenityItem(label: 'Hot tub', icon: Icons.hot_tub),
    const AmenityItem(label: 'Patio', icon: Icons.deck),
    const AmenityItem(label: 'BBQ grill', icon: Icons.outdoor_grill),
    const AmenityItem(label: 'Outdoor dining area', icon: Icons.chair_alt),
    const AmenityItem(label: 'Fire pit', icon: Icons.local_fire_department),
    const AmenityItem(label: 'Pool table', icon: Icons.table_restaurant_outlined),
    const AmenityItem(label: 'Indoor fireplace', icon: Icons.fireplace),
    const AmenityItem(label: 'Piano', icon: Icons.piano),
    const AmenityItem(label: 'Exercise equipment', icon: Icons.fitness_center),
    const AmenityItem(label: 'Lake access', icon: Icons.water),
    const AmenityItem(label: 'Beach access', icon: Icons.beach_access),
    const AmenityItem(label: 'Ski-in/Ski-out', icon: Icons.downhill_skiing),
    const AmenityItem(label: 'Outdoor shower', icon: Icons.shower),
  ];

  final List<AmenityItem> _safety = [
    const AmenityItem(label: 'Smoke alarm', icon: Icons.sensors),
    const AmenityItem(label: 'First aid kit', icon: Icons.medical_services),
    const AmenityItem(label: 'Fire extinguisher', icon: Icons.fire_extinguisher),
    const AmenityItem(label: 'Carbon monoxide alarm', icon: Icons.warning_amber),
  ];

  void _toggleAmenity(String label) {
    setState(() {
      if (_selectedAmenities.contains(label)) {
        _selectedAmenities.remove(label);
      } else {
        _selectedAmenities.add(label);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 12.0),
          child: OutlinedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Save & exit',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 12.0),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Questions?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Tell guests what your place has to offer',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'You can add more amenities after you publish your listing.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  _buildSection('What about these guest favorites?', _favorites),
                  const SizedBox(height: 48),
                  _buildSection('Do you have any standout amenities?', _standouts),
                  const SizedBox(height: 48),
                  _buildSection('Do you have any of these safety items?', _safety),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // Progress Bar and Bottom Nav
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade100, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.33, // Part 1/3 of Step 2
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PhotoUploadScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<AmenityItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = _selectedAmenities.contains(item.label);
            
            return GestureDetector(
              onTap: () => _toggleAmenity(item.label),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.black12,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected ? const Color(0xFFF7F7F7) : Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      item.icon,
                      size: 32,
                      color: isSelected ? Colors.black : Colors.black87,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.black : Colors.black87,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// --- Screen 3: Photos ---

class PhotoUploadScreen extends StatelessWidget {
  const PhotoUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 12.0),
          child: OutlinedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Save & exit',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 12.0),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Questions?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Your photos',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Drag to reorder',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Photo Grid
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0,
                    ),
                    children: [
                      _buildPhotoCard(
                        context,
                        'C:/Users/Computer Arena/.gemini/antigravity/brain/7d4a128d-57c1-4474-a7df-7a99dd1c5a54/airbnb_host_step1_house_illustration_1775465541270.png',
                        isCover: true,
                      ),
                      _buildPhotoCard(
                        context,
                        'C:/Users/Computer Arena/.gemini/antigravity/brain/7d4a128d-57c1-4474-a7df-7a99dd1c5a54/airbnb_host_step2_house_illustration_1775466445849.png',
                      ),
                      _buildPhotoPlaceholder(context),
                      _buildAddMoreButton(context),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Progress Bar and Bottom Nav
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade100, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                           FractionallySizedBox(
                            widthFactor: 0.5, // Step 2, Screen 3/6
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ListingTitleScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoCard(BuildContext context, String path, {bool isCover = false}) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: kIsWeb
              ? Container(
                  color: Colors.grey.shade100,
                  child: const Center(child: Icon(Icons.image, color: Colors.black26)),
                )
              : Image.file(
                  File(path),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
        ),
        if (isCover)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Text(
                'Cover',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.more_horiz, size: 20),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoPlaceholder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: const Center(
        child: Icon(Icons.image_outlined, color: Colors.black12, size: 40),
      ),
    );
  }

  Widget _buildAddMoreButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add, size: 32, color: Colors.black),
          const SizedBox(height: 8),
          const Text(
            'Add more',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Screen 4: Title ---

class ListingTitleScreen extends StatefulWidget {
  const ListingTitleScreen({super.key});

  @override
  State<ListingTitleScreen> createState() => _ListingTitleScreenState();
}

class _ListingTitleScreenState extends State<ListingTitleScreen> {
  final TextEditingController _controller = TextEditingController();
  final int _maxLength = 50;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 12.0),
          child: OutlinedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Save & exit',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 12.0),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Questions?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Now, let\'s give your apartment a title',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Short titles work best. Have fun with it—you can always change it later.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Title Input Area
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: 5,
                      maxLength: _maxLength,
                      onChanged: (val) => setState(() {}),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        hintText: 'Enter your title here...',
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_maxLength - _controller.text.length} characters available',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Progress Bar and Bottom Nav
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade100, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.66, // Step 2, Screen 4/6
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _controller.text.trim().isEmpty ? null : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ListingHighlightsScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _controller.text.trim().isEmpty ? const Color(0xFFF0F0F0) : const Color(0xFF222222),
                        foregroundColor: _controller.text.trim().isEmpty ? Colors.black26 : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        disabledBackgroundColor: const Color(0xFFF7F7F7),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Screen 5: Highlights ---

class ListingHighlightsScreen extends StatefulWidget {
  const ListingHighlightsScreen({super.key});

  @override
  State<ListingHighlightsScreen> createState() => _ListingHighlightsScreenState();
}

class _ListingHighlightsScreenState extends State<ListingHighlightsScreen> {
  final Set<String> _selectedHighlights = {};

  final List<HighlightItem> _highlights = [
    const HighlightItem(label: 'Peaceful', icon: Icons.spa_outlined),
    const HighlightItem(label: 'Unique', icon: Icons.lightbulb_outlined),
    const HighlightItem(label: 'Family-friendly', icon: Icons.child_care),
    const HighlightItem(label: 'Stylish', icon: Icons.architecture),
    const HighlightItem(label: 'Central', icon: Icons.location_on_outlined),
    const HighlightItem(label: 'Spacious', icon: Icons.groups_outlined),
  ];

  void _toggleHighlight(String label) {
    setState(() {
      if (_selectedHighlights.contains(label)) {
        _selectedHighlights.remove(label);
      } else {
        if (_selectedHighlights.length < 2) {
          _selectedHighlights.add(label);
        } else {
          // If 2 are already selected, remove the oldest (first in set) and add new
          final first = _selectedHighlights.first;
          _selectedHighlightsRemoveAndAdd(first, label);
        }
      }
    });
  }

  void _selectedHighlightsRemoveAndAdd(String oldLabel, String newLabel) {
    _selectedHighlights.remove(oldLabel);
    _selectedHighlights.add(newLabel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 12.0),
          child: OutlinedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Save & exit',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 12.0),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Questions?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Next, let\'s describe your apartment',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Choose up to 2 highlights. We\'ll use these to get your description started.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Highlights Wrap
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _highlights.map((highlight) {
                      final isSelected = _selectedHighlights.contains(highlight.label);
                      return GestureDetector(
                        onTap: () => _toggleHighlight(highlight.label),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? Colors.black : Colors.black12,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            color: isSelected ? const Color(0xFFF7F7F7) : Colors.white,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                highlight.icon,
                                size: 20,
                                color: isSelected ? Colors.black : Colors.black87,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                highlight.label,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.black : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          
          // Progress Bar and Bottom Nav
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade100, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.83, // Step 2, Screen 5/6
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ListingDescriptionScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Screen 6: Description ---

class ListingDescriptionScreen extends StatefulWidget {
  const ListingDescriptionScreen({super.key});

  @override
  State<ListingDescriptionScreen> createState() => _ListingDescriptionScreenState();
}

class _ListingDescriptionScreenState extends State<ListingDescriptionScreen> {
  final TextEditingController _controller = TextEditingController(
    text: 'You\'ll have a great time at this comfortable place to stay.',
  );
  final int _maxLength = 500;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 12.0),
          child: OutlinedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Save & exit',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 12.0),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Questions?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Create your description',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Share what makes your place special.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Description Input Area
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: 10,
                      maxLength: _maxLength,
                      onChanged: (val) => setState(() {}),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_maxLength - _controller.text.length} characters available',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Progress Bar and Bottom Nav
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade100, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black, // Step 2 Completed
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _controller.text.trim().isEmpty ? null : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HostStep3IntroScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _controller.text.trim().isEmpty ? const Color(0xFFF0F0F0) : const Color(0xFF222222),
                        foregroundColor: _controller.text.trim().isEmpty ? Colors.black26 : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        disabledBackgroundColor: const Color(0xFFF7F7F7),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
