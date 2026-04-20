import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../models/listing.dart';
import '../services/payment_service.dart';

class BookingDetailsScreen extends StatefulWidget {
  final Booking booking;
  final Listing listing;

  const BookingDetailsScreen({super.key, required this.booking, required this.listing});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  final _paymentService = PaymentService();
  bool _isCancelling = false;

  void _confirmCancellation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel reservation?'),
        content: const Text('Are you sure you want to cancel this reservation? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go back', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelBooking();
            },
            child: const Text('Confirm cancellation', style: TextStyle(color: Color(0xFFE61E4D), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelBooking() async {
    setState(() => _isCancelling = true);
    final success = await _paymentService.cancelBooking(widget.booking.id);
    if (mounted) {
      setState(() => _isCancelling = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reservation cancelled successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to cancel reservation. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateRange = '${months[widget.booking.checkIn.month - 1]} ${widget.booking.checkIn.day} – ${months[widget.booking.checkOut.month - 1]} ${widget.booking.checkOut.day}, ${widget.booking.checkOut.year}';

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.listing.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back, color: Colors.black, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    widget.listing.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.listing.fullAddress,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const Divider(height: 48),
                  
                  const Text('Reservation details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  _buildDetailRow('Status', widget.booking.status.toUpperCase(), isStatus: true),
                  _buildDetailRow('Dates', dateRange),
                  _buildDetailRow('Guests', '${widget.booking.guests} guest${widget.booking.guests > 1 ? 's' : ''}'),
                  _buildDetailRow('Stay', '${widget.booking.nights} night${widget.booking.nights > 1 ? 's' : ''}'),
                  
                  const Divider(height: 48),
                  
                  const Text('Price details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  _buildDetailRow('Total Price', '\$${widget.booking.totalPrice.toStringAsFixed(2)}'),
                  _buildDetailRow('Accommodation', '\$${widget.booking.propertyPrice.toStringAsFixed(2)}'),
                  _buildDetailRow('Cleaning fee', '\$${widget.booking.cleaningFee.toStringAsFixed(2)}'),
                  _buildDetailRow('Service fee', '\$${widget.booking.serviceFee.toStringAsFixed(2)}'),
                  
                  const SizedBox(height: 48),
                  
                  if (widget.booking.status.toLowerCase() == 'confirmed')
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: _isCancelling ? null : _confirmCancellation,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isCancelling 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                          : const Text('Cancel reservation', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.black87)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isStatus ? _getStatusColor(value) : Colors.black,
            ),
          ),
        ],
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
}
