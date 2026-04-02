import 'package:flutter/material.dart';
import '../models/listing.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final Listing listing;

  const ServiceDetailsScreen({Key? key, required this.listing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 380,
            child: Image.network(
              listing.imageUrl,
              fit: BoxFit.cover,
            ),
          ),

          // Scrollable Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 280), // Transparent space for the header image
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 40),
                      padding: const EdgeInsets.only(top: 64, bottom: 40),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              listing.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              listing.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              children: [
                                const Icon(Icons.star, size: 16, color: Colors.black),
                                Text(
                                  '${listing.rating}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Text('·'),
                                Text(
                                  '${listing.reviewsCount} reviews',
                                  style: const TextStyle(decoration: TextDecoration.underline),
                                ),
                                const Text('·'),
                                Text(
                                  listing.hostName, // E.g., 'Photographer in New York'
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('Provided on location', style: TextStyle(color: Colors.black54)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.translate, size: 16, color: Colors.grey.shade500),
                              const SizedBox(width: 8),
                              Text('Automatically translated', style: TextStyle(color: Colors.grey.shade500)),
                            ],
                          ),
                          const SizedBox(height: 32),
                          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                          const SizedBox(height: 32),
                          
                          // Service Packages List
                          _buildServicePackages(),

                          // Customize message
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              'You can message Polina to customize or make changes.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                            ),
                          ),

                          const SizedBox(height: 32),
                          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                          const SizedBox(height: 32),

                          // Reviews Section
                          _buildServiceReviewsSection(),

                          const SizedBox(height: 32),
                          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                          const SizedBox(height: 32),

                          // My Qualifications Section
                          _buildQualificationsSection(),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                    
                    // Floating Avatar
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&q=80'), // Placeholder avatar
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Bottom padding to avoid sticky bar collision
                const SizedBox(height: 120),
              ],
            ),
          ),
          
          // Header Floating Buttons
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFloatingButton(Icons.arrow_back, () => Navigator.pop(context)),
                    Row(
                      children: [
                        _buildFloatingButton(Icons.share_outlined, () {}),
                        const SizedBox(width: 12),
                        _buildFloatingButton(Icons.favorite_border, () {}),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Sticky Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -2),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black, fontSize: 16),
                            children: [
                              const TextSpan(text: 'From '),
                              TextSpan(
                                text: '\$${listing.price.toInt()}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: ' / group'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Free cancellation',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE31C5F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Show dates',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
          ],
        ),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }

  Widget _buildServicePackages() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          _buildPackageCard(
            'https://images.unsplash.com/photo-1606791422814-b32c705e3e2f?w=200&q=80',
            'Private shoot 30 min',
            '• 30 minutes\n• All originals...',
            '\$150 / group · 30 mins',
          ),
          const SizedBox(height: 16),
          _buildPackageCard(
            'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=200&q=80',
            'Private shoot 1h - 3 locations',
            '• 1 hour\n• 35 professionally edited photos of your choi...',
            '\$250 / group · 1 hr',
          ),
          const SizedBox(height: 16),
          _buildPackageCard(
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80',
            'Private session 1.5 hours',
            '• 90 mins\n• 50 professionally edited photos...',
            '\$325 / group · 1 hr 30 mins',
          ),
          const SizedBox(height: 16),
          _buildPackageCard(
            'https://images.unsplash.com/photo-1488161628813-04466f872be2?w=200&q=80',
            'Private shoot 2h',
            '• 2 hours\n• Multiple cinematic NYC locations...',
            '\$400 / group · 2 hrs',
          ),
          const SizedBox(height: 16),
          _buildPackageCard(
            'https://images.unsplash.com/photo-1616530940355-351fabd9524b?w=200&q=80',
            'Private photoshoot 3h',
            '• 3 hours\n• 4-5 iconic NYC locations...',
            '\$500 / group · 3 hrs',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPackageCard(String imgUrl, String title, String bullets, String price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imgUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bullets,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      children: [
                        TextSpan(
                          text: price.split(' /')[0],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' /${price.split(' /')[1]}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}\n
  Widget _buildServiceReviewsSection() {
    final reviews = [
      {'name': 'Krystal', 'date': 'February 2026', 'stars': 5, 'text': 'She was so kind and professional. Highly recommended!', 'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&q=80'},
      {'name': 'Marcus', 'date': 'January 2026', 'stars': 4, 'text': "Can't wait to see the final shots! The session was great and the duration of the photoshoot was perfect.", 'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80'},
      {'name': 'Sophie', 'date': 'December 2025', 'stars': 5, 'text': 'Absolutely amazing experience. The photos turned out stunning and very natural.', 'avatar': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&q=80'},
      {'name': 'Jake', 'date': 'November 2025', 'stars': 5, 'text': 'Very professional, knew the best spots in the city! Highly recommend.', 'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&q=80'},
      {'name': 'Amara', 'date': 'October 2025', 'stars': 4, 'text': 'Lovely person, creative energy, and the lighting was perfect for our outdoor shoot.', 'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&q=80'},
      {'name': 'Lena', 'date': 'September 2025', 'stars': 5, 'text': 'Exceeded all expectations. Will definitely book again for my next trip to NYC!', 'avatar': 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=100&q=80'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, size: 22, color: Colors.black),
                  const SizedBox(width: 8),
                  Text(
                    '${listing.rating} \u00b7 ${listing.reviewsCount} reviews',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  _circleNavButton(Icons.chevron_left),
                  const SizedBox(width: 8),
                  _circleNavButton(Icons.chevron_right),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: reviews.length,
            itemBuilder: (context, i) {
              final r = reviews[i];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(r['avatar'] as String),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(r['date'] as String, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: List.generate(r['stars'] as int, (_) => const Icon(Icons.star, size: 14, color: Colors.black)),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        r['text'] as String,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Show all reviews', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Learn how reviews work',
                style: TextStyle(fontSize: 14, decoration: TextDecoration.underline, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleNavButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Icon(icon, size: 18, color: Colors.black87),
    );
  }

  Widget _buildQualificationsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My qualifications',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildQualificationItem(
            Icons.camera_alt_outlined,
            '7 years of experience',
            '9+ years behind the lens',
          ),
          const SizedBox(height: 24),
          _buildQualificationItem(
            Icons.star_border,
            'Magazine publications',
            'Featured in several magazines, showcasing my photography and videography skills.',
          ),
          const SizedBox(height: 24),
          _buildQualificationItem(
            Icons.people_outline,
            '500+ clients served',
            'Worked with individuals, couples, and professional brands worldwide.',
          ),
        ],
      ),
    );
  }

  Widget _buildQualificationItem(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 28, color: Colors.black87),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

