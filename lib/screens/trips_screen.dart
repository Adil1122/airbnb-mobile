import 'package:flutter/material.dart';
import '../services/bookings_service.dart';
import '../services/reviews_service.dart';
import '../models/booking_model.dart';
import '../models/listing.dart';
import '../services/property_service.dart';
import 'booking_details_screen.dart';

class TripsScreen extends StatefulWidget {
  final VoidCallback? onGetStarted;
  const TripsScreen({super.key, this.onGetStarted});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> with SingleTickerProviderStateMixin {
  final _bookingsService = BookingsService();
  final _propertyService = PropertyService();

  late TabController _tabController;

  List<Booking> _upcoming = [];
  List<Booking> _completed = [];
  List<Booking> _cancelled = [];
  Map<String, Listing> _listingMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTrips();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTrips() async {
    setState(() => _isLoading = true);
    try {
      final raw = await _bookingsService.getMyBookings();
      final bookings = raw
          .map((j) => Booking.fromJson(j as Map<String, dynamic>))
          .toList();

      // Fetch all properties once to build an image/title map
      final properties = await _propertyService.fetchProperties();
      final propMap = <String, Listing>{for (final p in properties) p.id: p};

      if (!mounted) return;
      setState(() {
        _listingMap = propMap;
        _upcoming  = bookings.where((b) => b.isUpcoming).toList()
          ..sort((a, b) => a.checkIn.compareTo(b.checkIn));
        _completed = bookings.where((b) => b.isCompleted).toList()
          ..sort((a, b) => b.checkOut.compareTo(a.checkOut));
        _cancelled = bookings.where((b) => b.isCancelled).toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = _upcoming.length + _completed.length + _cancelled.length;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Color(0xFFE61E4D))),
      );
    }

    if (totalCount == 0) return _buildEmptyState();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 8, top: 16),
          child: Text('Trips', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black45,
          indicatorColor: const Color(0xFFE61E4D),
          indicatorWeight: 2,
          labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          tabs: [
            Tab(text: 'Upcoming (${_upcoming.length})'),
            Tab(text: 'Completed (${_completed.length})'),
            Tab(text: 'Cancelled (${_cancelled.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(_upcoming, showCountdown: true),
          _buildList(_completed, showReviewButton: true),
          _buildList(_cancelled, showCancelInfo: true),
        ],
      ),
    );
  }

  // ── List builder ────────────────────────────────────────────────────────────

  Widget _buildList(
    List<Booking> bookings, {
    bool showCountdown = false,
    bool showReviewButton = false,
    bool showCancelInfo = false,
  }) {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              showReviewButton
                  ? Icons.check_circle_outline
                  : showCancelInfo
                      ? Icons.cancel_outlined
                      : Icons.calendar_today_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              showReviewButton
                  ? 'No completed trips yet'
                  : showCancelInfo
                      ? 'No cancelled bookings'
                      : 'No upcoming trips',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTrips,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          final listing = _listingMap[booking.propertyId.toString()];
          return _BookingCard(
            booking: booking,
            listing: listing,
            showCountdown: showCountdown,
            showReviewButton: showReviewButton,
            showCancelInfo: showCancelInfo,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookingDetailsScreen(booking: booking, listing: listing!),
              ),
            ).then((_) => _loadTrips()),
          );
        },
      ),
    );
  }

  // ── Empty state ──────────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 8, top: 16),
          child: Text('Trips', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 48),
            _buildTimelineIllustration(),
            const SizedBox(height: 64),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                children: [
                  Text('Build the perfect trip', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text(
                    'Explore homes, experiences, and services. When you book, your reservations will show up here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: SizedBox(
                width: 200,
                height: 56,
                child: ElevatedButton(
                  onPressed: widget.onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE31C5F),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Get started', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineIllustration() {
    return SizedBox(
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 60, top: 20, bottom: 20,
            child: CustomPaint(size: const Size(2, double.infinity), painter: _DashedLinePainter()),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _illustrationCard('https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?w=100&q=80', offset: -10),
              const SizedBox(height: 12),
              _illustrationCard('https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=100&q=80', active: true, offset: 10),
              const SizedBox(height: 12),
              _illustrationCard('https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=100&q=80', offset: -5),
            ],
          ),
        ],
      ),
    );
  }

  Widget _illustrationCard(String url, {bool active = false, double offset = 0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          alignment: Alignment.center,
          child: Container(
            width: 12, height: 12,
            decoration: BoxDecoration(
              color: active ? Colors.grey.shade600 : Colors.grey.shade300,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(offset, 0),
          child: Container(
            width: 240,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(url, width: 60, height: 60, fit: BoxFit.cover),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 8, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4))),
                      const SizedBox(height: 8),
                      Container(height: 8, width: 80, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Booking Card ─────────────────────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final Listing? listing;
  final bool showCountdown;
  final bool showReviewButton;
  final bool showCancelInfo;
  final VoidCallback onTap;

  const _BookingCard({
    required this.booking,
    required this.listing,
    required this.showCountdown,
    required this.showReviewButton,
    required this.showCancelInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final checkInStr  = '${months[booking.checkIn.month - 1]}  ${booking.checkIn.day}';
    final checkOutStr = '${months[booking.checkOut.month - 1]} ${booking.checkOut.day}, ${booking.checkOut.year}';
    final dateRange = '$checkInStr – $checkOutStr';

    return GestureDetector(
      onTap: listing != null ? onTap : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero image ──────────────────────────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  Image.network(
                    listing?.imageUrl ?? '',
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(height: 160, color: Colors.grey.shade200, child: const Icon(Icons.home, size: 48, color: Colors.white)),
                  ),
                  // Status badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _StatusBadge(status: booking.status, isCompleted: booking.isCompleted),
                  ),
                  // Countdown badge for upcoming
                  if (showCountdown && booking.daysUntilCheckIn >= 0)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          booking.daysUntilCheckIn == 0
                              ? 'Today!'
                              : booking.daysUntilCheckIn == 1
                                  ? 'Tomorrow'
                                  : '${booking.daysUntilCheckIn}d away',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Info section ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing?.title ?? 'Property #${booking.propertyId}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(dateRange, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    '${booking.nights} night${booking.nights > 1 ? 's' : ''}  ·  ${booking.guests} guest${booking.guests > 1 ? 's' : ''}',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                  const SizedBox(height: 12),

                  // ── Divider ────────────────────────────────────────────────
                  Divider(color: Colors.grey.shade100),
                  const SizedBox(height: 8),

                  // ── Price row ──────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${booking.totalPrice.toStringAsFixed(0)} total', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const Icon(Icons.chevron_right, color: Colors.black38),
                    ],
                  ),

                  // ── Cancellation reason ────────────────────────────────────
                  if (showCancelInfo && booking.cancellationReason != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        'Reason: ${booking.cancellationReason}',
                        style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                      ),
                    ),
                  ],

                  // ── Review button for completed bookings ────────────────────
                  if (showReviewButton) ...[
                    const SizedBox(height: 12),
                    _ReviewButton(booking: booking, listing: listing),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Status Badge ─────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  final bool isCompleted;
  const _StatusBadge({required this.status, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    Color bg;
    String label;

    if (isCompleted || status == 'completed') {
      bg = const Color(0xFF008A05);
      label = 'Completed';
    } else {
      switch (status.toLowerCase()) {
        case 'confirmed':
          bg = const Color(0xFF006AFF);
          label = 'Confirmed';
          break;
        case 'pending':
          bg = const Color(0xFFF5A623);
          label = 'Pending';
          break;
        case 'cancelled':
          bg = Colors.red;
          label = 'Cancelled';
          break;
        case 'declined':
          bg = Colors.red.shade700;
          label = 'Declined';
          break;
        default:
          bg = Colors.grey;
          label = status;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

// ── Review Button ─────────────────────────────────────────────────────────────

class _ReviewButton extends StatefulWidget {
  final Booking booking;
  final Listing? listing;
  const _ReviewButton({required this.booking, required this.listing});

  @override
  State<_ReviewButton> createState() => _ReviewButtonState();
}

class _ReviewButtonState extends State<_ReviewButton> {
  final _reviewsService = ReviewsService();
  bool _reviewed = false;
  bool _submitting = false;

  void _openReviewSheet() {
    double rating = 5;
    double cleanliness = 5, accuracy = 5, checkin = 5, communication = 5, location = 5, value = 5;
    final textCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Rate your stay', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(widget.listing?.title ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                const SizedBox(height: 20),

                // Overall stars
                const Text('Overall', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 8),
                _StarRow(rating: rating, onChanged: (v) => setSheet(() => rating = v)),
                const SizedBox(height: 16),

                // Category sliders
                _CategoryRatingRow(label: 'Cleanliness',   rating: cleanliness,   onChanged: (v) => setSheet(() => cleanliness = v)),
                _CategoryRatingRow(label: 'Accuracy',      rating: accuracy,      onChanged: (v) => setSheet(() => accuracy = v)),
                _CategoryRatingRow(label: 'Check-in',      rating: checkin,       onChanged: (v) => setSheet(() => checkin = v)),
                _CategoryRatingRow(label: 'Communication', rating: communication, onChanged: (v) => setSheet(() => communication = v)),
                _CategoryRatingRow(label: 'Location',      rating: location,      onChanged: (v) => setSheet(() => location = v)),
                _CategoryRatingRow(label: 'Value',         rating: value,         onChanged: (v) => setSheet(() => value = v)),

                const SizedBox(height: 12),
                TextField(
                  controller: textCtrl,
                  maxLines: 4,
                  onChanged: (_) => setSheet(() {}),
                  decoration: InputDecoration(
                    hintText: 'Share your experience...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE61E4D))),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE61E4D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    onPressed: textCtrl.text.trim().isEmpty || _submitting
                        ? null
                        : () async {
                            setSheet(() => _submitting = true);
                            final ok = await _reviewsService.createReview(
                              propertyId: widget.booking.propertyId,
                              reviewText: textCtrl.text.trim(),
                              rating: rating,
                              bookingId: widget.booking.id,
                              cleanlinessRating: cleanliness,
                              accuracyRating: accuracy,
                              checkinRating: checkin,
                              communicationRating: communication,
                              locationRating: location,
                              valueRating: value,
                            );
                            if (!mounted) return;
                            Navigator.pop(ctx);
                            setState(() { _reviewed = ok != null; _submitting = false; });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(ok != null ? 'Review submitted — thank you!' : 'Failed to submit review'),
                              backgroundColor: ok != null ? const Color(0xFF008A05) : Colors.red,
                            ));
                          },
                    child: _submitting
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Submit review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_reviewed) {
      return Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF008A05), size: 18),
          const SizedBox(width: 6),
          Text('Review submitted', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton(
        onPressed: _openReviewSheet,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          side: const BorderSide(color: Colors.black, width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text('Leave a review', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      ),
    );
  }
}

// ── Star Row ──────────────────────────────────────────────────────────────────

class _StarRow extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onChanged;
  const _StarRow({required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final filled = i < rating;
        return GestureDetector(
          onTap: () => onChanged((i + 1).toDouble()),
          child: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(filled ? Icons.star : Icons.star_border, size: 36, color: const Color(0xFFE61E4D)),
          ),
        );
      }),
    );
  }
}

// ── Category Rating Row ───────────────────────────────────────────────────────

class _CategoryRatingRow extends StatelessWidget {
  final String label;
  final double rating;
  final ValueChanged<double> onChanged;
  const _CategoryRatingRow({required this.label, required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: 13))),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFE61E4D),
              thumbColor: const Color(0xFFE61E4D),
              inactiveTrackColor: Colors.grey.shade200,
              overlayColor: const Color(0x22E61E4D),
              trackHeight: 3,
            ),
            child: Slider(value: rating, min: 1, max: 5, divisions: 4, onChanged: onChanged),
          ),
        ),
        SizedBox(width: 24, child: Text(rating.toStringAsFixed(0), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
      ],
    );
  }
}

// ── Dashed line painter ───────────────────────────────────────────────────────

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashH = 5, dashSpace = 3, y = 0;
    final paint = Paint()..color = Colors.grey.shade200..strokeWidth = 2;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dashH), paint);
      y += dashH + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter _) => false;
}
