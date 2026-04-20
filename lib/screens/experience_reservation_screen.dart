import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../services/payment_service.dart';
import '../models/booking_model.dart';

class ExperienceReservationScreen extends StatefulWidget {
  final Listing listing;

  const ExperienceReservationScreen({super.key, required this.listing});

  @override
  State<ExperienceReservationScreen> createState() => _ExperienceReservationScreenState();
}

class _ExperienceReservationScreenState extends State<ExperienceReservationScreen> {
  int _currentStep = 0; // 0: Review, 1: Payment, 2: Confirm
  String _selectedPaymentMethod = 'google_pay';
  int _guests = 1;
  late DateTime _selectedDate;
  String _selectedTime = '9:00 AM – 3:00 PM';
  final _paymentService = PaymentService();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 2));
  }

  double get _totalPrice => widget.listing.price * _guests;

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  String get _paymentLabel {
    switch (_selectedPaymentMethod) {
      case 'credit_card': return 'Credit or debit card';
      case 'paypal': return 'PayPal';
      case 'google_pay': return 'Google Pay';
      case 'stripe': return 'Stripe';
      default: return 'Google Pay';
    }
  }

  IconData get _paymentIcon {
    switch (_selectedPaymentMethod) {
      case 'credit_card': return Icons.credit_card;
      case 'paypal': return Icons.account_balance_wallet;
      case 'google_pay': return Icons.g_mobiledata;
      case 'stripe': return Icons.payment;
      default: return Icons.g_mobiledata;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _buildCurrentStep(),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ─── APP BAR ───────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                _buildCircularButton(
                  icon: Icons.chevron_left,
                  onPressed: () => setState(() => _currentStep--),
                )
              else
                const SizedBox(width: 40),
              _buildCircularButton(
                icon: Icons.close,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          if (_currentStep > 0)
            Text(
              _currentStep == 1 ? 'Payment method' : 'Confirm and pay',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: -0.3),
            ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black, size: 20),
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        padding: EdgeInsets.zero,
      ),
    );
  }

  // ─── STEP ROUTER ───────────────────────────────────────────
  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0: return _buildReviewStep();
      case 1: return _buildPaymentStep();
      case 2: return _buildConfirmStep();
      default: return const SizedBox();
    }
  }

  // ═══════════════════════════════════════════════════════════
  // STEP 1: REVIEW AND CONTINUE
  // ═══════════════════════════════════════════════════════════
  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Review and continue',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        const SizedBox(height: 24),

        // Experience info card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.listing.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80, height: 80,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.local_activity_outlined, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.listing.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.black),
                            const SizedBox(width: 2),
                            Text(
                              '${widget.listing.rating} (${widget.listing.reviewsCount})',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 20),

              // Date & Time row
              _buildInfoRow(
                'Date and time',
                '${_formatDate(_selectedDate)}\n$_selectedTime',
                onChangeTap: () => _showDatePicker(),
              ),

              const Divider(height: 32),

              // Guest count row
              _buildInfoRow(
                'Guests',
                '$_guests guest${_guests > 1 ? 's' : ''}',
                onChangeTap: () => _showGuestPicker(),
              ),

              const Divider(height: 32),

              // Total price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total price',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${_totalPrice.toStringAsFixed(2)} USD',
                        style: const TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _showPriceDetails(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      backgroundColor: Colors.grey.shade50,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ],
              ),

              const Divider(height: 32),

              // Cancellation policy
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cancellation policy',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Cancel at least 24 hours before the start time for a full refund.',
                    style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        _buildStepIndicator(),
        const SizedBox(height: 40),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // STEP 2: ADD PAYMENT METHOD
  // ═══════════════════════════════════════════════════════════
  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Add a payment method',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        const SizedBox(height: 24),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildPaymentOption(
                id: 'credit_card',
                title: 'Credit or debit card',
                leading: const Icon(Icons.credit_card, size: 24, color: Color(0xFF1A1F71)),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              _buildPaymentOption(
                id: 'paypal',
                title: 'PayPal',
                leading: const Icon(Icons.account_balance_wallet, size: 24, color: Color(0xFF003087)),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              _buildPaymentOption(
                id: 'google_pay',
                title: 'Google Pay',
                leading: const Icon(Icons.g_mobiledata, size: 28),
              ),
              const Divider(height: 1, indent: 20, endIndent: 20),
              _buildPaymentOption(
                id: 'stripe',
                title: 'Stripe',
                leading: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF635BFF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'S',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        _buildStepIndicator(),
        const SizedBox(height: 40),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // STEP 3: CONFIRM AND PAY
  // ═══════════════════════════════════════════════════════════
  Widget _buildConfirmStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.listing.imageUrl,
                  width: 160,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.listing.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildInfoRow('Date', _formatDate(_selectedDate), onChangeTap: () => _currentStep = 0),
              const Divider(height: 32),
              _buildInfoRow('Time', _selectedTime, onChangeTap: () => _currentStep = 0),
              const Divider(height: 32),
              _buildInfoRow('Guests', '$_guests guest${_guests > 1 ? 's' : ''}', onChangeTap: () => _currentStep = 0),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total price', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('\$${_totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Payment method selection display
        GestureDetector(
          onTap: () => setState(() => _currentStep = 1),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(_paymentIcon, color: Colors.black87),
                const SizedBox(width: 16),
                Expanded(child: Text(_paymentLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.grey.shade50, shape: BoxShape.circle),
                  child: const Icon(Icons.chevron_right, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  // ─── BOTTOM BAR ────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFFE61E4D), Color(0xFFD70466)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE61E4D).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _currentStep == 2 ? _processBooking : () => setState(() => _currentStep++),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: Text(
            _currentStep == 2 ? 'Confirm and pay' : 'Review reservation',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.2),
          ),
        ),
      ),
    );
  }

  // ─── HELPERS ───────────────────────────────────────────────

  Widget _buildInfoRow(String label, String value, {VoidCallback? onChangeTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 15, color: Colors.black87)),
            ],
          ),
        ),
        if (onChangeTap != null)
          TextButton(
            onPressed: onChangeTap,
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              backgroundColor: Colors.grey.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Change', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
      ],
    );
  }

  Widget _buildPaymentOption({required String id, required String title, required Widget leading}) {
    final isSelected = _selectedPaymentMethod == id;
    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade400, width: isSelected ? 7 : 2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: Container(
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: index <= _currentStep ? Colors.black : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }

  void _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFFE31C5F))),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _showGuestPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Guests', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: _guests > 1 ? () => setModalState(() => _guests--) : null, icon: const Icon(Icons.remove_circle_outline)),
                  const SizedBox(width: 16),
                  Text('$_guests', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  IconButton(onPressed: () => setModalState(() => _guests++), icon: const Icon(Icons.add_circle_outline)),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () { setState(() {}); Navigator.pop(context); },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPriceDetails() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Price details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('\$${widget.listing.price.toInt()} x $_guests guest${_guests > 1 ? 's' : ''}'), Text('\$${_totalPrice.toInt()}')]),
            const Divider(height: 32),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total (USD)', style: TextStyle(fontWeight: FontWeight.bold)), Text('\$${_totalPrice.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold))]),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _processBooking() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFFE61E4D))),
    );

    try {
      final intentData = await _paymentService.createPaymentIntent(
        amount: _totalPrice,
        propertyId: int.tryParse(widget.listing.id) ?? 0, // Using listing ID as propertyId for simplicity
        checkIn: _selectedDate.toIso8601String(),
        checkOut: _selectedDate.add(const Duration(hours: 6)).toIso8601String(),
        guests: _guests,
      );

      if (intentData == null) throw Exception('Failed to create payment intent');

      final booking = await _paymentService.confirmBooking(
        paymentIntentId: intentData['paymentIntentId']!,
        propertyId: int.tryParse(widget.listing.id) ?? 0,
        checkIn: _selectedDate.toIso8601String(),
        checkOut: _selectedDate.add(const Duration(hours: 6)).toIso8601String(),
        guests: _guests,
        totalPrice: _totalPrice,
        serviceFee: _totalPrice * 0.1,
        cleaningFee: 0,
        propertyPrice: _totalPrice * 0.9,
        nights: 1, // Experiences are usually 1 day
        messageToHost: 'Booked via mobile app',
      );

      if (!mounted) return;
      Navigator.pop(context); // Close loading

      if (booking != null) {
        _showSuccessDialog();
      } else {
        _showErrorSnackBar('Booking confirmation failed');
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading
      _showErrorSnackBar('Payment failed: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 16),
            const Text('Booking Confirmed!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('You are booked for "${widget.listing.title}" on ${_formatDate(_selectedDate)}.', textAlign: TextAlign.center),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close success dialog
                  Navigator.pop(context); // Close reservation screen
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
