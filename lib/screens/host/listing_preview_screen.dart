import 'package:flutter/material.dart';

class ListingPreviewScreen extends StatelessWidget {
  const ListingPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image
                Stack(
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      color: const Color(0xFF222222),
                      child: const Center(
                        child: Icon(Icons.image_outlined, color: Colors.white38, size: 80),
                      ),
                    ),
                    Positioned(
                      top: 48,
                      left: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 48,
                      right: 16,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(Icons.share_outlined, color: Colors.black, size: 20),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(Icons.favorite_border, color: Colors.black, size: 20),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '1 / 5',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'apartment in islamabad',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Entire rental unit in Islamabad, Pakistan',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        '4 guests · 1 bedroom · 1 bed · 1 bath',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Icon(Icons.star, size: 14),
                          SizedBox(width: 4),
                          Text('No reviews yet', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),
                      
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFF222222),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'Hosted by Ahmad',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),
                      
                      const Text(
                        'You\'ll have a great time at this comfortable place to stay.',
                        style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                      ),
                      
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 24),
                      
                      const Text(
                        'What this place offers',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      _buildOfferItem(Icons.no_photography_outlined, 'Carbon monoxide alarm'),
                      _buildOfferItem(Icons.smoke_free_outlined, 'Smoke alarm'),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: const BorderSide(color: Colors.black),
                        ),
                        child: const Text('Show all amenity details', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                      
                      const SizedBox(height: 48),
                      const Divider(),
                      const SizedBox(height: 48),
                      
                      const Text(
                        'Where you\'ll be',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const Text('Islamabad, Islamabad Capital Territory, Pakistan', style: TextStyle(fontSize: 16, color: Colors.black54)),
                      const SizedBox(height: 24),
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=Islamabad&zoom=13&size=600x300&key=YOUR_API_KEY'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.home, color: Colors.white, size: 30),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      const Divider(),
                      const SizedBox(height: 48),
                      
                      const Text(
                        'Things to know',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      _buildKnowItem(Icons.calendar_today_outlined, 'Cancellation policy', 'Add your trip dates to get the cancellation details for this stay.'),
                      _buildKnowItem(Icons.menu_book_outlined, 'House rules', '4 guests maximum'),
                      _buildKnowItem(Icons.shield_outlined, 'Safety & property', 'Carbon monoxide alarm not reported\nSmoke alarm not reported'),
                      
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Sticky Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add dates', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      Text('for pricing', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF385C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Check availability', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildKnowItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.4)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black54),
        ],
      ),
    );
  }
}
