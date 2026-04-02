import 'package:flutter/material.dart';
import '../models/listing.dart';

class ExperienceDetailsScreen extends StatelessWidget {
  final Listing listing;

  const ExperienceDetailsScreen({Key? key, required this.listing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Generate a fallback list of 4 images for the 2x2 grid
    // If the listing doesn't have 4 images, we repeat available ones or use the main one.
    List<String> gridImages = [];
    if (listing.images.isNotEmpty) {
      gridImages.addAll(listing.images);
    }
    while (gridImages.length < 4) {
      gridImages.add(listing.imageUrl);
    }

    final city = listing.fullAddress.split(',').first;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F5F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '$city · Landmarks',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 2x2 Image Grid
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: _buildGridImage(gridImages[0], true, false, false, false)),
                              const SizedBox(width: 4),
                              Expanded(child: _buildGridImage(gridImages[1], false, true, false, false)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: _buildGridImage(gridImages[2], false, false, true, false)),
                              const SizedBox(width: 4),
                              Expanded(child: _buildGridImage(gridImages[3], false, false, false, true)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Centered Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    listing.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Centered Description Snippet
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    listing.description,
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Centered Rating & Reviews
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.black),
                    const SizedBox(width: 4),
                    Text(
                      '${listing.rating} · ${listing.reviewsCount} reviews',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Translation disclaimer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.g_translate, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      'Automatically translated',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 24),
                
                // Host Info Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: const NetworkImage('https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&q=80'), // Placeholder for host
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hosted by ${listing.hostName}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Dive into $city with a community.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Location Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.location_on_outlined, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              city,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              listing.fullAddress,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 24),
                
                // What you'll do Action Timeline
                _buildWhatYouWillDoSection(),
                
                const SizedBox(height: 24),
                const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 24),
                
                // Reviews Section
                _buildReviewsSection(),

                const SizedBox(height: 24),
                const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 24),

                // Upcoming Availability Section
                _buildAvailabilitySection(),

                const SizedBox(height: 24),
                const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 24),

                // Where we'll meet Section
                _buildWhereWellMeetSection(),

                const SizedBox(height: 24),
                const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 32),

                // More experiences in Kuala Lumpur
                _buildMoreExperiencesSection(),
                
                const SizedBox(height: 32),
                const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 32),

                // Meet the hosts Section
                _buildMeetTheHostsSection(),

                const SizedBox(height: 32),
                
                // Embedded host description and message button
                _buildHostDescription(),

                const SizedBox(height: 32),
                const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 32),

                // Things to know
                _buildThingsToKnowSection(),
                
                const SizedBox(height: 32),
              ],
            ),
          ),

          // Vetted Quality Section
          _buildVettedQualitySection(),

          // Bottom padding to avoid sticky bar collision
          const SizedBox(height: 120),
        ],
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
                    Column(
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
                              const TextSpan(text: ' / guest'),
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

  Widget _buildGridImage(String url, bool tl, bool tr, bool bl, bool br) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(tl ? 16 : 0),
        topRight: Radius.circular(tr ? 16 : 0),
        bottomLeft: Radius.circular(bl ? 16 : 0),
        bottomRight: Radius.circular(br ? 16 : 0),
      ),
      child: Image.network(
        url,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildWhatYouWillDoSection() {
    final items = [
      {
        'title': 'Hotel Pick Up',
        'desc': 'We offer pick up within Kuala Lumpur City Center. If your accommodation is outside of the City Center, we can coordinate a pick up point with you',
        'image': 'https://images.unsplash.com/photo-1596422846543-75c6ef08b739?w=100&q=80',
      },
      {
        'title': 'Visit Batu Caves',
        'desc': 'Explore this iconic site.',
        'image': 'https://images.unsplash.com/photo-1583417657209-d3e8cac30962?w=100&q=80',
      },
      {
        'title': 'Enjoy Local Food',
        'desc': 'Taste authentic Malaysian dishes for brunch',
        'image': 'https://images.unsplash.com/photo-1555126634-323283e090fa?w=100&q=80',
      },
      {
        'title': 'Monkey God Temple',
        'desc': 'Will be given full explanation of the temple insides.',
        'image': 'https://images.unsplash.com/photo-1542640244-7e672d6cb461?w=100&q=80',
      },
      {
        'title': 'Quick King\'s Palace Visit',
        'desc': 'We make a quick stop to visit the King\'s Palace',
        'image': 'https://images.unsplash.com/photo-1548013146-5e2694b2a3fa?w=100&q=80',
      },
      {
        'title': 'Thean Hou Temple Stop',
        'desc': 'Experience serene beauty.',
        'image': 'https://images.unsplash.com/photo-1590050762110-4ed3a91e5e65?w=100&q=80',
      },
      {
        'title': 'Savor Chinatown',
        'desc': 'Sample local cuisine on a mini food tour.',
        'image': 'https://images.unsplash.com/photo-1555507036-ab1d4075c6f1?w=100&q=80',
      },
      {
        'title': 'Walk Merdeka Square',
        'desc': 'See historical landmarks.',
        'image': 'https://images.unsplash.com/photo-1596422846543-75c6ef08b739?w=100&q=80',
      },
      {
        'title': 'Little India Tour',
        'desc': 'Touring little india, Buddhist temple, stop over for dessert',
        'image': 'https://images.unsplash.com/photo-1514214246283-d427a95c5d2f?w=100&q=80',
      },
      {
        'title': 'Central Market',
        'desc': 'Mall with 100 % malaysian product, cultural and artistic',
        'image': 'https://images.unsplash.com/photo-1533900298318-6b8da08a523e?w=100&q=80',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What you\'ll do',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              // The central vertical connecting line for the timeline
              Positioned(
                left: 31, // Align with the center of the 64x64 image
                top: 32,
                bottom: 32,
                child: Container(
                  width: 1,
                  color: Colors.grey.shade300,
                ),
              ),
              Column(
                children: items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: NetworkImage(item['image']!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title']!,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black87),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['desc']!,
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'This experience is hosted in English.',
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
        ],
      ),
    );

  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0), // Full width for scrolling list
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, size: 24, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      '${listing.rating} · ${listing.reviewsCount} reviews',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(Icons.chevron_left, size: 20, color: Colors.black87),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(Icons.chevron_right, size: 20, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 24),
                ...List.generate(5, (index) {
                  return Container(
                    width: 300,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&q=80'),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Yuliya', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 2),
                                Text('2 weeks ago', style: TextStyle(color: Colors.black54, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: List.generate(5, (_) => const Icon(Icons.star, size: 14)),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Uncle Jagan is a very welcoming host. He is also very knowledgeable about the Malaysian way of life. The locations he took us to were all special. My companion and I both wished though he...',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 15, height: 1.4, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        const Text('Show more', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, decoration: TextDecoration.underline)),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
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
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Learn how reviews work', 
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14, decoration: TextDecoration.underline)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilitySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Upcoming availability',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 24),
                _buildAvailabilityCard('Tomorrow, April 3', '9:00 AM – 3:00 PM', '6 spots available'),
                _buildAvailabilityCard('Saturday, April 4', '11:00 AM – 5:00 PM', '4 spots available'),
                _buildAvailabilityCard('Sunday, April 5', '10:00 AM – 4:00 PM', '2 spots available'),
                _buildAvailabilityCard('Monday, April 6', '9:00 AM – 3:00 PM', '1 spot available'),
                _buildAvailabilityCard('Tuesday, April 7', '11:00 AM – 5:00 PM', '8 spots available'),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityCard(String date, String time, String spots) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(time, style: const TextStyle(color: Colors.black87, fontSize: 15)),
          const SizedBox(height: 16),
          Text(spots, style: const TextStyle(color: Colors.black54, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildWhereWellMeetSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Where we\'ll meet',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text(
            'WE DO HOTEL PICKUP! as long as the accommodation is within the City Centre',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            '57000, Kuala Lumpur, Federal Territory of Kuala Lumpur, Malaysia',
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.4),
          ),
          const SizedBox(height: 24),
          Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800&q=80'), // map-like top-down satellite proxy
                fit: BoxFit.cover,
                opacity: 0.8,
              ),
            ),
            child: Stack(
              children: [
                // Meeting Point Center Marker
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.circle, size: 10, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: const Text('Meeting point', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                      ),
                    ],
                  ),
                ),
                // Expand Icon FAB
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)],
                    ),
                    child: const Icon(Icons.open_in_full, size: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreExperiencesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0), // full width
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'More experiences in Kuala Lumpur',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade100,
                  ),
                  child: const Icon(Icons.arrow_forward, size: 20, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 24),
                _buildExperienceThumbnail(
                  'https://images.unsplash.com/photo-1542640244-7e672d6cb461?w=200&q=80',
                  'Learn authentic Malaysian vegan cooking',
                  'Cooking · 2.5 hours',
                  'From \$55 / guest · ★ 4.93'
                ),
                const SizedBox(width: 16),
                _buildExperienceThumbnail(
                  'https://images.unsplash.com/photo-1596422846543-75c6ef08b739?w=200&q=80',
                  'Admire KL\'s skyline from above',
                  'Landmarks · 5.5 hours',
                  'From \$38 / guest'
                ),
                const SizedBox(width: 16),
                _buildExperienceThumbnail(
                  'https://images.unsplash.com/photo-1583417657209-d3e8cac30962?w=200&q=80',
                  'KL City Evening Tour',
                  'City Tour · 4 hours',
                  'From \$30 / guest · ★ 4.8'
                ),
                const SizedBox(width: 16),
                _buildExperienceThumbnail(
                  'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?w=200&q=80',
                  'Deep Jungle Trekking',
                  'Nature · 5 hours',
                  'From \$45 / guest · ★ 5.0'
                ),
                const SizedBox(width: 16),
                _buildExperienceThumbnail(
                  'https://images.unsplash.com/photo-1460518451285-8f6412140bbd?w=200&q=80',
                  'Traditional Batik Painting',
                  'Arts & Crafts · 3 hours',
                  'From \$25 / guest · ★ 4.9'
                ),
                const SizedBox(width: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceThumbnail(String url, String title, String subtitle, String priceInfo) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: NetworkImage(url),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, height: 1.2),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
          const SizedBox(height: 4),
          Text(priceInfo, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildMeetTheHostsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0), // Full width scrolling
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Meet the hosts',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 70, // Width for overlapping avatars
                  child: Stack(
                    children: [
                      const Align(
                        alignment: Alignment.centerRight,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100&q=80'),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&q=80'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 24),
                _buildHostCard('Leon Lee', 'Host', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&q=80'),
                _buildHostCard('Pritika', 'Co-Host', 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300&q=80'),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostCard(String name, String role, String imageUrl) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16, bottom: 16),
      padding: const EdgeInsets.only(top: 32, bottom: 32, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04), // soft outline effect
            blurRadius: 4,
            offset: const Offset(0, 0),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 56,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(height: 24),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26, letterSpacing: -0.5)),
          const SizedBox(height: 4),
          Text(role, style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildHostDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hellooo, I'm Leon. You can think of me as Uncle Jagan's Tech Support.\n\nUncle Jagan, having to grow up in Kuala Lumpur and seeing its development and changes over his 60+ years truly knows the in's and out's of our beautiful cities and its cultural and historical stories and has seen the city grow and expand. He will be able to tell all the stories of all the places and sights you will vist. Giving vivid explations and answering all your questions with warth and care. It will be good exprience.",
            style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
          ),
          const SizedBox(height: 32),
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
              child: const Text('Message Leon Lee\'s team', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'To help protect your payment, always use Airbnb to send money and communicate with hosts.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThingsToKnowSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Things to know',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildThingsToKnowItem(
            Icons.people_alt_outlined,
            'Guest requirements',
            'Guests ages 2 and up can attend, up to 6 guests total.',
          ),
          const SizedBox(height: 24),
          _buildThingsToKnowItem(
            Icons.directions_walk,
            'Activity level',
            'The activity level for this experience is moderate and the skill level is beginner.',
          ),
          const SizedBox(height: 24),
          _buildThingsToKnowItem(
            Icons.accessible,
            'Accessibility',
            'Step-free bathroom available, Entrances wider than 32 inches, No extreme sensory stimuli',
            arrow: true,
          ),
          const SizedBox(height: 24),
          _buildThingsToKnowItem(
            Icons.backpack_outlined,
            'What to bring',
            'Drinking Water, Umbrella if needed optionl., ladies to be dressed below the knee',
          ),
          const SizedBox(height: 24),
          _buildThingsToKnowItem(
            Icons.event_busy_outlined,
            'Cancellation policy',
            'Cancel at least 1 day before the start time for a full refund.',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildThingsToKnowItem(IconData icon, String title, String description, {bool arrow = false}) {
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
              Text(description, style: TextStyle(color: Colors.grey.shade700, fontSize: 15, height: 1.4)),
            ],
          ),
        ),
        if (arrow)
          const Icon(Icons.chevron_right, color: Colors.black87),
      ],
    );
  }

  Widget _buildVettedQualitySection() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF6F5F2),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 64.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Seal Image Placeholder
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10)),
              ],
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=300&q=80'), // proxy for a wax seal/award
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Landmark tours are vetted for quality',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.5),
              children: const [
                TextSpan(text: 'Landmark tours are led by historians, archaeologists, and other hosts who showcase what makes the city unique. '),
                TextSpan(text: 'Learn more', style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w600, color: Colors.black)),
              ],
            ),
          ),
          const SizedBox(height: 48),
          const Divider(thickness: 1, color: Color(0xFFDDDDDD)),
          const SizedBox(height: 24),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              children: const [
                TextSpan(text: 'See an issue? '),
                TextSpan(
                  text: 'Report this listing',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}



