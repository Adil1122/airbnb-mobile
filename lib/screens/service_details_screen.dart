import 'package:flutter/material.dart';
import '../models/listing.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final Listing listing;

  const ServiceDetailsScreen({Key? key, required this.listing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F4),
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
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
                          
                          // Reviews Section
                          _buildReviewsSection(),
                          
                          // Qualifications Section
                          _buildQualificationsSection(),
                          
                          // Host Profile Section
                          _buildHostProfileSection(),
                          
                          // Portfolio Section
                          _buildPortfolioSection(),
                          
                          // Location Section
                          _buildLocationSection(),
                          
                          // Things to Know Section
                          _buildThingsToKnowSection(),
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
                
                // Vetted photographers area replaces the simple SizedBox
                _buildVettedPhotographersSection(),
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
                              const TextSpan(
                                text: 'From ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
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
          const Text(
            'You can message Polina to customize or make changes',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 40),
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

  Widget _buildQualificationsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 32),
          const Text(
            'My qualifications',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          _buildQualificationItem(
            Icons.camera_alt_outlined,
            '7 years of experience',
            '9+ years',
          ),
          const SizedBox(height: 24),
          _buildQualificationItem(
            Icons.star_border,
            'Magazine publications',
            'Featured in several magazines, showcasing my photography and videography skills.',
          ),
          const SizedBox(height: 24),
          _buildQualificationItem(
            Icons.school_outlined,
            'self-taught.',
            'photography course, professional retouching courses and master classes online',
          ),
          const SizedBox(height: 32),
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
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: const [
              Icon(Icons.star, size: 24, color: Colors.black),
              SizedBox(width: 8),
              Text(
                '4.97 · 153 reviews',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReviewCard(
                'Krystal',
                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80',
                'February 2026',
                5,
                'She was so kind and professional.',
              ),
              Container(
                width: 1,
                height: 120,
                color: Colors.grey.shade300,
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              _buildReviewCard(
                'Sarah',
                'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&q=80',
                'January 2026',
                5,
                'Can\'t wait for the photos! She made the shoot so much fun and the locations were perfect.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3F3F3),
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Show all reviews',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'Learn how reviews work',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildReviewCard(String name, String imgUrl, String date, int stars, String text) {
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(imgUrl),
              ),
              const SizedBox(width: 16),
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Row(
                children: List.generate(
                  stars,
                  (index) => const Icon(Icons.star, size: 12, color: Colors.black),
                ),
              ),
              const SizedBox(width: 6),
              const Text('·', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              Text(
                date,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildHostProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
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
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Polina',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  'Photographer',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3F3F3),
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Message Polina',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'To help protect your payment, always use Airbnb to send money and communicate with hosts.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12, height: 1.4),
            ),
          ),
          const SizedBox(height: 32),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPortfolioSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My portfolio',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&q=80',
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&q=80',
                        height: 121,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80',
                        height: 121,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 32),
          const Text(
            'Where you\'ll go',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'New York, New York, 10013, United States',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=400&q=80',
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
                    ],
                  ),
                  child: const Icon(Icons.open_in_full, size: 20),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Polina\'s place',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
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
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 32),
          const Text(
            'Things to know',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          _buildQualificationItem(
            Icons.people_outline,
            'Guest requirements',
            'Guests ages 14 and up can attend, up to 10 guests total.',
          ),
          _buildThingToKnowActionItem(
            Icons.accessible_forward,
            'Accessibility',
            'Message your host for details.',
          ),
          const SizedBox(height: 24),
          _buildQualificationItem(
            Icons.calendar_today_outlined,
            'Cancellation policy',
            'Cancel at least 1 day before the start time for a full refund.',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildThingToKnowActionItem(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 28, color: Colors.black87),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.4),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.black87),
      ],
    );
  }

  Widget _buildVettedPhotographersSection() {
    return Container(
      color: const Color(0xFFF7F7F4),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: const Center(
              child: Icon(Icons.verified, color: Colors.white, size: 48),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Photographers on Airbnb\nare vetted for quality',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.4),
              children: const [
                TextSpan(
                  text: 'Photographers are evaluated for their professional experience, portfolio of strong work, and reputation for excellence. ',
                ),
                TextSpan(
                  text: 'Learn more',
                  style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
          const SizedBox(height: 32),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              children: const [
                TextSpan(text: 'See an issue? '),
                TextSpan(
                  text: 'Report this listing',
                  style: TextStyle(decoration: TextDecoration.underline, color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 120), // Bottom padding for sticky bar!
        ],
      ),
    );
  }
}
