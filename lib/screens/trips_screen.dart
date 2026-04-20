import 'package:flutter/material.dart';
import '../services/payment_service.dart';
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

class _TripsScreenState extends State<TripsScreen> {
  final _paymentService = PaymentService();
  final _propertyService = PropertyService();
  List<Booking> _bookings = [];
  Map<String, Listing> _listingDetails = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    setState(() => _isLoading = true);
    try {
      final bookings = await _paymentService.fetchUserBookings();
      // Fetch property details for each booking to get images/titles
      final properties = await _propertyService.fetchProperties();
      final propertyMap = {for (var p in properties) p.id: p};

      if (mounted) {
        setState(() {
          _bookings = bookings;
          _listingDetails = propertyMap;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Color(0xFFE61E4D))),
      );
    }

    if (_bookings.isEmpty) {
      return _buildEmptyState();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0, top: 16.0),
          child: Text(
            'Trips',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadTrips,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          itemCount: _bookings.length,
          itemBuilder: (context, index) {
            final booking = _bookings[index];
            final listing = _listingDetails[booking.propertyId.toString()];
            return _buildBookingCard(booking, listing);
          },
        ),
      ),
    );
  }

  Widget _buildBookingCard(Booking booking, Listing? listing) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateRange = '${months[booking.checkIn.month - 1]} ${booking.checkIn.day} – ${months[booking.checkOut.month - 1]} ${booking.checkOut.day}';

    return GestureDetector(
      onTap: () {
        if (listing != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingDetailsScreen(booking: booking, listing: listing),
            ),
          ).then((_) => _loadTrips()); // Reload after potential cancellation
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Section
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                child: Image.network(
                  listing?.imageUrl ?? '',
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 100, color: Colors.grey.shade200),
                ),
              ),
              // Info Section
              Expanded(
                child: Padding(
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
                      Text(
                        dateRange,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(booking.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          booking.status.toUpperCase(),
                          style: TextStyle(
                            color: _getStatusColor(booking.status),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Center(child: Padding(padding: EdgeInsets.only(right: 12), child: Icon(Icons.chevron_right, color: Colors.black54))),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed': return const Color(0xFF008A05);
      case 'cancelled': return Colors.red;
      case 'completed': return Colors.blue;
      default: return Colors.orange;
    }
  }

  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0, top: 16.0),
          child: Text(
            'Trips',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          ),
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
                  Text(
                    'Build the perfect trip',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
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
            left: 60,
            top: 20,
            bottom: 20,
            child: CustomPaint(
              size: const Size(2, double.infinity),
              painter: DashedLinePainter(),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIllustrationCard(imageUrl: 'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?w=100&q=80', nodeTop: true, offset: -10),
              const SizedBox(height: 12),
              _buildIllustrationCard(imageUrl: 'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=100&q=80', nodeActive: true, offset: 10),
              const SizedBox(height: 12),
              _buildIllustrationCard(imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=100&q=80', nodeBottom: true, offset: -5),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIllustrationCard({required String imageUrl, bool nodeTop = false, bool nodeActive = false, bool nodeBottom = false, double offset = 0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          alignment: Alignment.center,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: nodeActive ? Colors.grey.shade600 : Colors.grey.shade300,
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
                  child: Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 8, width: double.infinity, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4))),
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

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()..color = Colors.grey.shade200..strokeWidth = 2;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

