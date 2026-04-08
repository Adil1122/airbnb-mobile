import 'package:flutter/material.dart';
import '../models/listing.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final Listing listing;

  const PropertyDetailsScreen({super.key, required this.listing});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  int _currentImageIndex = 0;
  int _currentReviewIndex = 0;
  late PageController _pageController;
  late PageController _reviewPageController;
  late ScrollController _mentionScrollController;
  bool _showLeftMentionBtn = false;
  bool _showRightMentionBtn = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _reviewPageController = PageController(viewportFraction: 0.85);
    _mentionScrollController = ScrollController();
    _mentionScrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {
      _showLeftMentionBtn = _mentionScrollController.offset > 0;
      _showRightMentionBtn = _mentionScrollController.offset < (_mentionScrollController.position.maxScrollExtent - 10);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _reviewPageController.dispose();
    _mentionScrollController.removeListener(_scrollListener);
    _mentionScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.listing.images.isNotEmpty ? widget.listing.images : [widget.listing.imageUrl];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Image Section with PageView
              SliverAppBar(
                expandedHeight: 320,
                elevation: 0,
                leadingWidth: 0,
                leading: const SizedBox.shrink(),
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            images[index],
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      // Gradient overlay
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.3),
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.1),
                              ],
                              stops: const [0.0, 0.2, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Top Buttons
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 10,
                        left: 16,
                        right: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _circleIconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icons.arrow_back_ios_new,
                            ),
                            Row(
                              children: [
                                _circleIconButton(
                                  onPressed: () {},
                                  icon: Icons.ios_share,
                                ),
                                const SizedBox(width: 12),
                                _circleIconButton(
                                  onPressed: () {},
                                  icon: Icons.favorite_border,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Image Navigation Buttons
                      if (_currentImageIndex > 0)
                        Positioned(
                          left: 16,
                          top: 148, // (ExpandedHeight 320 / 2) - (Button size 24 / 2)
                          child: _circleIconButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            icon: Icons.chevron_left,
                            size: 24,
                          ),
                        ),
                      if (_currentImageIndex < images.length - 1)
                        Positioned(
                          right: 16,
                          top: 148,
                          child: _circleIconButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            icon: Icons.chevron_right,
                            size: 24,
                          ),
                        ),

                      // Index counter
                      Positioned(
                        bottom: 20,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${_currentImageIndex + 1} / ${images.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content Sections
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // Centralize items
                    children: [
                      // --- Section 1: Title & Stats (Centralized) ---
                      Text(
                        widget.listing.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          height: 1.2,
                          color: Color(0xFF222222),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.listing.subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF484848),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.listing.guests} guests · ${widget.listing.bedrooms} bedroom · ${widget.listing.beds} bed · ${widget.listing.baths} bath',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF717171),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // --- Three-Column Ratings row (Centralized) ---
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Rating column
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    widget.listing.rating.toString(),
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (index) => const Icon(Icons.star, size: 12, color: Colors.black)),
                                  ),
                                ],
                              ),
                            ),
                            Container(width: 1, color: const Color(0xFFDDDDDD)), // Divider
                            // Guest Favorite column
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.eco, color: Color(0xFF91734F), size: 24),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'Guest\nfavorite',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          height: 1.1,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Transform.scale(
                                        scaleX: -1,
                                        child: const Icon(Icons.eco, color: Color(0xFF91734F), size: 24),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(width: 1, color: const Color(0xFFDDDDDD)), // Divider
                            // Reviews column
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '${widget.listing.reviewsCount}',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Reviews',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Divider(thickness: 0.8),
                      const SizedBox(height: 24),

                      // --- Section 2: Hosted By (Moved above highlights) ---
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=200&q=80'),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hosted by ${widget.listing.hostName}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                widget.listing.hostDuration,
                                style: const TextStyle(color: Color(0xFF717171), fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Divider(thickness: 0.8),
                      const SizedBox(height: 24),

                      // --- Section 3: Highlights (Trophy, Key, Location) ---
                      _buildHighlightItem(
                        icon: Icons.emoji_events_outlined,
                        title: 'Top 10% of homes',
                        subtitle: 'This home is highly ranked based on ratings, reviews, and reliability.',
                        iconColor: const Color(0xFF91734F),
                      ),
                      const SizedBox(height: 24),
                      _buildHighlightItem(
                        icon: Icons.key_outlined,
                        title: 'Exceptional check-in experience',
                        subtitle: 'Recent guests gave the check-in process a 5-star rating.',
                      ),
                      const SizedBox(height: 24),
                      _buildHighlightItem(
                        icon: Icons.location_on_outlined,
                        title: 'Unbeatable location',
                        subtitle: '100% of guests in the past year gave this location a 5-star rating.',
                      ),
                      
                      const SizedBox(height: 24),
                      const Divider(thickness: 0.8),
                      const SizedBox(height: 24),

                      // --- Section 4: Description ---
                      Text(
                        widget.listing.description,
                        style: const TextStyle(fontSize: 16, color: Color(0xFF222222), height: 1.5),
                      ),

                      const SizedBox(height: 24),
                      const Divider(thickness: 0.8),
                      const SizedBox(height: 24),

                      // --- Section 5: Guest Favorite (The "Image proper details" requested bellow Host) ---
                      if (widget.listing.isGuestFavorite) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.eco, color: Color(0xFF91734F), size: 40),
                            const SizedBox(width: 12),
                            Text(
                              widget.listing.rating.toString(),
                              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, height: 1),
                            ),
                            const SizedBox(width: 12),
                            Transform.scale(
                              scaleX: -1,
                              child: const Icon(Icons.eco, color: Color(0xFF91734F), size: 40),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'Guest favorite',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'This home is in the top 10% of eligible listings based on ratings, reviews, and reliability',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14, color: Color(0xFF717171)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            'How reviews work',
                            style: TextStyle(fontSize: 14, decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                      
                      // --- Section 6: Guest reviews mention (NEW) ---
                      if (widget.listing.mentions.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            'Guest reviews mention',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildReviewMentions(),
                        const SizedBox(height: 24),
                        const Divider(thickness: 0.8),
                      ],

                      // --- Section 7: User Reviews Carousel (NEW) ---
                      if (widget.listing.reviews.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        _buildReviewsCarousel(),
                        const SizedBox(height: 24),
                        // Show all reviews button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Color(0xFF222222)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              backgroundColor: const Color(0xFFF7F7F7),
                            ),
                            child: Text(
                              'Show all ${widget.listing.reviewsCount} reviews',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),
                      const Divider(thickness: 0.8),
                      const SizedBox(height: 32),

                      // --- Section 8: What this place offers (NEW) ---
                      const Text(
                        'What this place offers',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 24),
                      ...widget.listing.amenities.take(5).map((amenity) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Icon(_getAmenityIcon(amenity), size: 28, color: Colors.black87),
                            const SizedBox(width: 16),
                            Text(
                              amenity,
                              style: const TextStyle(fontSize: 16, color: Color(0xFF222222)),
                            ),
                          ],
                        ),
                      )),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFF222222)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(
                            'Show all ${widget.listing.amenities.length} amenities',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                      const Divider(thickness: 0.8),
                      const SizedBox(height: 32),

                      // --- Section 9: Where you'll be (Updated with realistic Map) ---
                      const Text(
                        "Where you'll be",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.listing.fullAddress,
                        style: const TextStyle(fontSize: 16, color: Color(0xFF222222)),
                      ),
                      const SizedBox(height: 24),
                      // Realistic Map Section
                      Container(
                        height: 240,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800&q=80', // High-quality architectural/map-like placeholder
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: const Color(0xFFF7F7F7),
                                    child: const Center(
                                      child: Icon(Icons.map_outlined, size: 48, color: Color(0xFF717171)),
                                    ),
                                  );
                                },
                              ),
                              // Expand Button overlay
                              Positioned(
                                top: 12,
                                right: 12,
                                child: _circleIconButton(
                                  onPressed: () {},
                                  icon: Icons.open_in_full,
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                      const Divider(thickness: 0.8),
                      const SizedBox(height: 32),

                      // --- Section 10: Meet your host (RE-DESIGNED) ---
                      const Text(
                        "Meet your host",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                // Left Side: Profile Info
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          const CircleAvatar(
                                            radius: 54,
                                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=400&q=80'),
                                          ),
                                          Positioned(
                                            bottom: 4,
                                            right: 4,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFE31C5F),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.verified, color: Colors.white, size: 20),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        widget.listing.hostName,
                                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                                      ),
                                      const Text(
                                        'Host',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Divider
                                const SizedBox(width: 24),

                                // Right Side: Stats
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '6',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const Text(
                                        'Reviews',
                                        style: TextStyle(fontSize: 12, color: Color(0xFF222222)),
                                      ),
                                      const SizedBox(height: 12),
                                      const Divider(height: 1),
                                      const SizedBox(height: 12),
                                      const Row(
                                        children: [
                                          Text(
                                            '5.0',
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 4),
                                          Icon(Icons.star, size: 14, color: Colors.black),
                                        ],
                                      ),
                                      const Text(
                                        'Rating',
                                        style: TextStyle(fontSize: 12, color: Color(0xFF222222)),
                                      ),
                                      const SizedBox(height: 12),
                                      const Divider(height: 1),
                                      const SizedBox(height: 12),
                                      const Text(
                                        '1',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      const Text(
                                        'Month hosting',
                                        style: TextStyle(fontSize: 12, color: Color(0xFF222222)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      if (widget.listing.hostSchool.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(Icons.school_outlined, color: Colors.black, size: 28),
                            const SizedBox(width: 16),
                            Text(
                              'Where I went to school: ${widget.listing.hostSchool}',
                              style: const TextStyle(fontSize: 16, color: Color(0xFF222222)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (widget.listing.hostWork.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(Icons.business_center_outlined, color: Colors.black, size: 28),
                            const SizedBox(width: 16),
                            Text(
                              'My work: ${widget.listing.hostWork}',
                              style: const TextStyle(fontSize: 16, color: Color(0xFF222222)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                      
                      if (widget.listing.hostBio.isNotEmpty) ...[
                        Text(
                          widget.listing.hostBio,
                          style: const TextStyle(fontSize: 16, height: 1.5, color: Color(0xFF222222)),
                        ),
                        const SizedBox(height: 32),
                      ],

                      const Text(
                        "Host details",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Response rate: ${widget.listing.hostResponseRate}",
                        style: const TextStyle(fontSize: 16, color: Color(0xFF222222)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Responds ${widget.listing.hostResponseTime}",
                        style: const TextStyle(fontSize: 16, color: Color(0xFF222222)),
                      ),

                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFF222222)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Message host',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.security, color: const Color(0xFFE31C5F).withValues(alpha: 0.5), size: 32),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'To help protect your payment, always use Airbnb to send money and communicate with hosts.',
                              style: TextStyle(fontSize: 12, color: Color(0xFF222222), height: 1.4),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                      const Divider(thickness: 0.8),
                      const SizedBox(height: 32),

                      // Availability Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Availability",
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Apr 3 – 5",
                                style: TextStyle(fontSize: 16, color: Color(0xFF222222)),
                              ),
                            ],
                          ),
                          const Icon(Icons.chevron_right, size: 28),
                        ],
                      ),

                      const SizedBox(height: 32),
                      const Divider(thickness: 0.8),
                      const SizedBox(height: 40),

                      // Things to know
                      const Text(
                        "Things to know",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 24),
                      
                      // Cancellation Policy
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 24),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Cancellation policy",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.listing.cancellationPolicy,
                                  style: const TextStyle(fontSize: 14, color: Color(0xFF717171), height: 1.4),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Color(0xFF717171)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // House Rules
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.vpn_key_outlined, size: 24),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "House rules",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Check-in: ${widget.listing.checkInTime}\nCheckout before ${widget.listing.checkOutTime}\n${widget.listing.guests} guests maximum",
                                  style: const TextStyle(fontSize: 14, color: Color(0xFF717171), height: 1.4),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Color(0xFF717171)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Safety & Property
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.shield_outlined, size: 24),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Safety & property",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.listing.safetyInfo.join('\n'),
                                  style: const TextStyle(fontSize: 14, color: Color(0xFF717171), height: 1.4),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Color(0xFF717171)),
                        ],
                      ),

                      const SizedBox(height: 32),
                      const Divider(thickness: 0.8),
                      const SizedBox(height: 32),

                      // Report Listing
                      Row(
                        children: [
                          const Icon(Icons.flag_outlined, size: 20),
                          const SizedBox(width: 12),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              "Report this listing",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 120), // Bottom padding for reserve bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(top: BorderSide(color: Color(0xFFDDDDDD), width: 1)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, -5)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '\$41',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'For 2 nights · Apr 3 – 5',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE31C5F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 18),
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'Reserve',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
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

  IconData _getAmenityIcon(String name) {
    switch (name.toLowerCase()) {
      case 'kitchen':
        return Icons.kitchen;
      case 'wifi':
        return Icons.wifi;
      case 'dedicated workspace':
        return Icons.desk;
      case 'free parking on premises':
        return Icons.directions_car;
      case 'pets allowed':
        return Icons.pets;
      case 'air conditioning':
        return Icons.ac_unit;
      case 'tv':
        return Icons.tv;
      case 'geyser/heater':
        return Icons.hot_tub;
      case 'washer':
        return Icons.local_laundry_service;
      default:
        return Icons.done;
    }
  }

  Widget _buildReviewMentions() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SingleChildScrollView(
          controller: _mentionScrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.listing.mentions.map((mention) {
              return Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFDDDDDD)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.network(mention.iconImageUrl, width: 24, height: 24),
                    const SizedBox(width: 8),
                    Text(
                      mention.label,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        if (_showLeftMentionBtn)
          Positioned(
            left: -12,
            top: 6,
            child: _circleIconButton(
              onPressed: () {
                _mentionScrollController.animateTo(
                  _mentionScrollController.offset - 100,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: Icons.chevron_left,
              size: 28,
            ),
          ),
        if (_showRightMentionBtn)
          Positioned(
            right: 12,
            top: 6,
            child: _circleIconButton(
              onPressed: () {
                _mentionScrollController.animateTo(
                  _mentionScrollController.offset + 100,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              icon: Icons.chevron_right,
              size: 28,
            ),
          ),
      ],
    );
  }

  Widget _buildReviewsCarousel() {
    final reviews = widget.listing.reviews;
    if (reviews.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 220,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PageView.builder(
            controller: _reviewPageController,
            itemCount: reviews.length,
            onPageChanged: (index) {
              setState(() {
                _currentReviewIndex = index;
              });
            },
            padEnds: false,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFDDDDDD)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(review.userImageUrl),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.userName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              review.userLocation,
                              style: const TextStyle(color: Color(0xFF717171), fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (indexInner) {
                            return Icon(
                              indexInner < review.rating.floor() ? Icons.star : Icons.star_border,
                              size: 14,
                              color: Colors.black,
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '·  ${review.date}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Text(
                        review.comment,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15, height: 1.4),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (_currentReviewIndex > 0)
            Positioned(
              left: -12,
              top: 90,
              child: _circleIconButton(
                onPressed: () {
                  _reviewPageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: Icons.chevron_left,
                size: 28,
              ),
            ),
          if (_currentReviewIndex < reviews.length - 1)
            Positioned(
              right: 12,
              top: 90,
              child: _circleIconButton(
                onPressed: () {
                  _reviewPageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                icon: Icons.chevron_right,
                size: 28,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Color iconColor = Colors.black87,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 32, color: iconColor),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF222222)),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Color(0xFF717171), height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleIconButton({
    required VoidCallback onPressed,
    required IconData icon,
    double size = 32,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        iconSize: size * 0.6,
        icon: Icon(icon, color: Colors.black),
      ),
    );
  }
}
