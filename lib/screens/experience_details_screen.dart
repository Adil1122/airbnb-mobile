import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../services/experience_service.dart';
import 'experience_reservation_screen.dart';

class ExperienceDetailsScreen extends StatefulWidget {
  final Listing listing;

  const ExperienceDetailsScreen({super.key, required this.listing});

  @override
  State<ExperienceDetailsScreen> createState() => _ExperienceDetailsScreenState();
}

class _ExperienceDetailsScreenState extends State<ExperienceDetailsScreen> {
  late Listing _currentListing;
  bool _isLoading = true;
  List<Listing> _similarExperiences = [];
  final _experienceService = ExperienceService();

  @override
  void initState() {
    super.initState();
    _currentListing = widget.listing;
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final details = await _experienceService.fetchExperienceDetails(_currentListing.id);
    if (details != null && mounted) {
      setState(() {
        _currentListing = details;
        _isLoading = false;
      });
      final similar = await _experienceService.fetchSimilarExperiences(
        details.subtitle,
        details.id,
      );
      if (mounted) setState(() => _similarExperiences = similar);
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<DateTime> _getUpcomingDates() {
    final now = DateTime.now();
    final from = _currentListing.availableFrom;
    final to = _currentListing.availableTo;
    final start = (from != null && from.isAfter(now)) ? from : now.add(const Duration(days: 1));
    final end = to ?? start.add(const Duration(days: 90));
    final dates = <DateTime>[];
    var d = start;
    while (dates.length < 5 && d.isBefore(end)) {
      dates.add(d);
      d = d.add(const Duration(days: 1));
    }
    return dates;
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final isToday = d.day == DateTime.now().day && d.month == DateTime.now().month;
    final isTomorrow = d.difference(DateTime.now()).inDays == 1;
    if (isToday) return 'Today, ${months[d.month - 1]} ${d.day}';
    if (isTomorrow) return 'Tomorrow, ${months[d.month - 1]} ${d.day}';
    return '${days[d.weekday - 1]}, ${months[d.month - 1]} ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFFE31C5F))),
      );
    }

    List<String> gridImages = [];
    if (_currentListing.images.isNotEmpty) {
      gridImages.addAll(_currentListing.images);
    }
    while (gridImages.length < 4) {
      gridImages.add(_currentListing.imageUrl);
    }

    final city = _currentListing.subtitle.split(',').first;

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
          '$city · Experience',
          style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.favorite_border, color: Colors.black), onPressed: () {}),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          _currentListing.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5, height: 1.2),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          _currentListing.description,
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.black),
                          const SizedBox(width: 4),
                          Text(
                            '${_currentListing.rating} · ${_currentListing.reviewsCount} reviews',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.g_translate, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 6),
                          Text('Automatically translated', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                      const SizedBox(height: 24),

                      // Host Info Row — real data
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: _currentListing.hostImageUrl.isNotEmpty
                                  ? NetworkImage(_currentListing.hostImageUrl)
                                  : const NetworkImage('https://cdn-icons-png.flaticon.com/512/149/149071.png'),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hosted by ${_currentListing.hostName}',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Explore $city with a local guide.',
                                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
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
                              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.location_on_outlined, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(city, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  Text(
                                    _currentListing.fullAddress.isNotEmpty ? _currentListing.fullAddress : _currentListing.subtitle,
                                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                      const SizedBox(height: 24),

                      _buildWhatYouWillDoSection(),

                      const SizedBox(height: 24),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                      const SizedBox(height: 24),

                      _buildReviewsSection(),

                      const SizedBox(height: 24),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                      const SizedBox(height: 24),

                      _buildAvailabilitySection(),

                      const SizedBox(height: 24),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                      const SizedBox(height: 24),

                      _buildWhereWellMeetSection(),

                      const SizedBox(height: 24),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                      const SizedBox(height: 32),

                      if (_similarExperiences.isNotEmpty) ...[
                        _buildMoreExperiencesSection(city),
                        const SizedBox(height: 32),
                        const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                        const SizedBox(height: 32),
                      ],

                      _buildMeetTheHostsSection(),

                      const SizedBox(height: 32),

                      _buildHostDescription(),

                      const SizedBox(height: 32),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                      const SizedBox(height: 32),

                      _buildThingsToKnowSection(),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),

                _buildVettedQualitySection(),

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
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, -2), blurRadius: 10)],
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
                              TextSpan(text: '\$${_currentListing.price.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const TextSpan(text: ' / guest'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('Free cancellation', style: TextStyle(color: Colors.black54, fontSize: 14, decoration: TextDecoration.underline)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ExperienceReservationScreen(listing: _currentListing)));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE31C5F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Show dates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      child: Image.network(url, fit: BoxFit.cover),
    );
  }

  // "What you'll do" — uses real description
  Widget _buildWhatYouWillDoSection() {
    final desc = _currentListing.description;
    final category = _currentListing.duration.isNotEmpty ? _currentListing.duration : 'Experience';
    final durationLabel = _currentListing.experienceDurationHours != null
        ? '${_currentListing.category} · ${_currentListing.experienceDurationHours}'
        : _currentListing.category;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('What you\'ll do', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (durationLabel.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(durationLabel, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 16),
          ],
          if (desc.isNotEmpty)
            Text(desc, style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.6))
          else
            Text(
              'Join ${_currentListing.hostName} for an unforgettable experience in ${_currentListing.subtitle.split(',').first}.',
              style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.6),
            ),
          const SizedBox(height: 16),
          Text('This experience is hosted in English.', style: TextStyle(fontSize: 15, color: Colors.black54)),
        ],
      ),
    );
  }

  // Reviews — real data from listing
  Widget _buildReviewsSection() {
    final reviews = _currentListing.reviews;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
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
                      '${_currentListing.rating} · ${_currentListing.reviewsCount} reviews',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (reviews.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                _currentListing.reviewsCount > 0
                    ? 'This experience has ${_currentListing.reviewsCount} reviews.'
                    : 'No reviews yet. Be the first to review this experience.',
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 24),
                  ...reviews.take(5).map((review) => Container(
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
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: (review.userImageUrl?.isNotEmpty ?? false)
                                  ? NetworkImage(review.userImageUrl!)
                                  : null,
                              child: (review.userImageUrl?.isEmpty ?? true)
                                  ? Text(review.userName.isNotEmpty ? review.userName[0].toUpperCase() : '?',
                                      style: const TextStyle(fontWeight: FontWeight.bold))
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 2),
                                Text(_formatReviewDate(review.date), style: TextStyle(color: Colors.black54, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: List.generate(review.rating.round(), (_) => const Icon(Icons.star, size: 14)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          review.comment,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.black87),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: Text(
                'Learn how reviews work',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14, decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatReviewDate(String date) {
    try {
      final d = DateTime.parse(date);
      final now = DateTime.now();
      final diff = now.difference(d).inDays;
      if (diff == 0) return 'Today';
      if (diff == 1) return 'Yesterday';
      if (diff < 7) return '$diff days ago';
      if (diff < 30) return '${diff ~/ 7} week${diff ~/ 7 == 1 ? '' : 's'} ago';
      if (diff < 365) return '${diff ~/ 30} month${diff ~/ 30 == 1 ? '' : 's'} ago';
      return '${diff ~/ 365} year${diff ~/ 365 == 1 ? '' : 's'} ago';
    } catch (_) {
      return date;
    }
  }

  // Availability — generated from real availableFrom/availableTo
  Widget _buildAvailabilitySection() {
    final dates = _getUpcomingDates();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text('Upcoming availability', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
          if (dates.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text('No upcoming dates available.', style: TextStyle(fontSize: 15, color: Colors.black54)),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 24),
                  ...dates.map((date) => _buildAvailabilityCard(
                    _formatDate(date),
                    '${_currentListing.guests} spots available',
                  )),
                  const SizedBox(width: 8),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityCard(String date, String spots) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Text(spots, style: const TextStyle(color: Colors.black54, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildWhereWellMeetSection() {
    final address = _currentListing.fullAddress.isNotEmpty
        ? _currentListing.fullAddress
        : _currentListing.subtitle;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Where we\'ll meet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text(address, style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.4)),
          const SizedBox(height: 24),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
            ),
            child: const Center(
              child: Icon(Icons.map_outlined, size: 64, color: Colors.black26),
            ),
          ),
        ],
      ),
    );
  }

  // More experiences — real data from backend
  Widget _buildMoreExperiencesSection(String city) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'More experiences in $city',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade100),
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
                ..._similarExperiences.map((exp) => _buildExperienceThumbnail(exp)),
                const SizedBox(width: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceThumbnail(Listing exp) {
    final categoryLabel = exp.category.isNotEmpty ? exp.category : 'Experience';
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ExperienceDetailsScreen(listing: exp)),
        );
      },
      child: SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(exp.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exp.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, height: 1.2)),
                  const SizedBox(height: 4),
                  Text(categoryLabel, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    exp.rating > 0
                        ? 'From \$${exp.price.toInt()} / guest · ★ ${exp.rating}'
                        : 'From \$${exp.price.toInt()} / guest',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Meet the hosts — real data
  Widget _buildMeetTheHostsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text('Meet the host', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 24),
                _buildHostCard(_currentListing.hostName, 'Host', _currentListing.hostImageUrl),
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
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 8)),
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 0), spreadRadius: 1),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 56,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: imageUrl.isNotEmpty
                ? NetworkImage(imageUrl)
                : const NetworkImage('https://cdn-icons-png.flaticon.com/512/149/149071.png'),
          ),
          const SizedBox(height: 24),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26, letterSpacing: -0.5)),
          const SizedBox(height: 4),
          Text(role, style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
        ],
      ),
    );
  }

  // Host description — real hostBio
  Widget _buildHostDescription() {
    final bio = _currentListing.hostBio;
    final hostName = _currentListing.hostName;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bio.isNotEmpty
                ? bio
                : 'Hi, I\'m $hostName! I\'m passionate about sharing unique local experiences and look forward to hosting you.',
            style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
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
              child: Text('Message $hostName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

  // Things to know — uses real maxAdults/guests
  Widget _buildThingsToKnowSection() {
    final maxGuests = _currentListing.guests;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Things to know', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildThingsToKnowItem(
            Icons.people_alt_outlined,
            'Guest requirements',
            'Up to $maxGuests guest${maxGuests == 1 ? '' : 's'} can attend.',
          ),
          const SizedBox(height: 24),
          _buildThingsToKnowItem(
            Icons.directions_walk,
            'Activity level',
            'The activity level for this experience is moderate.',
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
        if (arrow) const Icon(Icons.chevron_right, color: Colors.black87),
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
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: const Center(child: Icon(Icons.verified_outlined, size: 40, color: Color(0xFFE31C5F))),
          ),
          const SizedBox(height: 32),
          Text(
            '${_currentListing.category} experiences are vetted for quality',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700, height: 1.5),
              children: const [
                TextSpan(text: 'Experiences are led by verified hosts who showcase what makes their city unique. '),
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
                  style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w600, color: Colors.black87),
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
