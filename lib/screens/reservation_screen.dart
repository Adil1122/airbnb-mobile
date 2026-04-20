import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../services/payment_service.dart';
import '../models/booking_model.dart';

class ReservationScreen extends StatefulWidget {
  final Listing listing;

  const ReservationScreen({super.key, required this.listing});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  int _currentStep = 0; // 0: Review, 1: Payment, 2: Confirm
  String _selectedPaymentMethod = 'google_pay';
  int _nights = 2;
  int _guests = 1;
  late DateTime _checkIn;
  late DateTime _checkOut;
  final _paymentService = PaymentService();

  @override
  void initState() {
    super.initState();
    _checkIn = DateTime.now().add(const Duration(days: 2));
    _checkOut = _checkIn.add(Duration(days: _nights));
  }

  double get _totalPrice => widget.listing.price * _nights;

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  String get _dateRange => '${_formatDate(_checkIn)} – ${_formatDate(_checkOut)}, ${_checkOut.year}';

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
      backgroundColor: const Color(0xFFFCFCFC), // Ultra-clean background
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

        // Property card
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
              // Property info row
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
                        child: const Icon(Icons.home, color: Colors.grey),
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: Colors.black),
                            const SizedBox(width: 2),
                            Text(
                              '${widget.listing.rating} (${widget.listing.reviewsCount})',
                              style: const TextStyle(fontSize: 13, color: Colors.black87),
                            ),
                            if (widget.listing.isGuestFavorite) ...[
                              const SizedBox(width: 8),
                              const Text('꧁', style: TextStyle(fontSize: 10)),
                              const SizedBox(width: 4),
                              const Text(
                                'Guest favorite',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
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

              // Dates row
              _buildInfoRow(
                'Dates',
                _dateRange,
                isRareFind: true,
                onChangeTap: () => _showDatePicker(),
              ),

              const Divider(height: 32),

              // Guests row
              _buildInfoRow(
                'Guests',
                '$_guests adult${_guests > 1 ? 's' : ''}',
                onChangeTap: () => _showGuestPicker(),
              ),

              const Divider(height: 32),

              // Total price row
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
                    child: const Text(
                      'Details',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ),
                ],
              ),

              const Divider(height: 32),

              // Cancellation policy
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Free cancellation',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF008A05)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cancel before 12:00 PM on ${_formatDate(_checkIn.subtract(const Duration(days: 1)))} for a full refund.',
                    style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Full policy',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Step indicators
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
              // Credit / Debit Card
              _buildPaymentOption(
                id: 'credit_card',
                title: 'Credit or debit card',
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1F71),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.credit_card, color: Colors.white, size: 18),
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    _buildCardBrand('VISA', const Color(0xFF1A1F71)),
                    const SizedBox(width: 4),
                    _buildCardBrand('MC', Colors.red),
                    const SizedBox(width: 4),
                    _buildCardBrand('AMEX', Colors.blue),
                    const SizedBox(width: 4),
                    _buildCardBrand('DISC', Colors.orange),
                    const SizedBox(width: 4),
                    _buildCardBrand('JCB', Colors.green),
                  ],
                ),
              ),

              const Divider(height: 1, indent: 20, endIndent: 20),

              // PayPal
              _buildPaymentOption(
                id: 'paypal',
                title: 'PayPal',
                leading: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF003087),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'P',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),

              const Divider(height: 1, indent: 20, endIndent: 20),

              // Google Pay
              _buildPaymentOption(
                id: 'google_pay',
                title: 'Google Pay',
                leading: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'G Pay',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),

              const Divider(height: 1, indent: 20, endIndent: 20),

              // Stripe
              _buildPaymentOption(
                id: 'stripe',
                title: 'Stripe',
                leading: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF635BFF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'S',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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

        // Property image + info (centered)
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
                  errorBuilder: (_, __, ___) => Container(
                    width: 160, height: 120,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.home, color: Colors.grey, size: 40),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.listing.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.black),
                  const SizedBox(width: 2),
                  Text(
                    '${widget.listing.rating} (${widget.listing.reviewsCount})',
                    style: const TextStyle(fontSize: 13),
                  ),
                  if (widget.listing.isGuestFavorite) ...[
                    const SizedBox(width: 8),
                    const Text('꧁', style: TextStyle(fontSize: 10)),
                    const SizedBox(width: 4),
                    const Text('Guest favorite', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  ],
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Booking details card
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
              _buildInfoRow('Dates', _dateRange, isRareFind: true, onChangeTap: () => _showDatePicker()),
              const Divider(height: 36),
              _buildInfoRow('Guests', '$_guests adult${_guests > 1 ? 's' : ''}', onChangeTap: () => _showGuestPicker()),
              const Divider(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total price', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('\$${_totalPrice.toStringAsFixed(2)} USD', style: const TextStyle(fontSize: 15, color: Colors.black87)),
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
              const Divider(height: 36),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Free cancellation',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF008A05)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Cancel before 12:00 PM on ${_formatDate(_checkIn.subtract(const Duration(days: 1)))} for a full refund.',
                    style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Payment method
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment method',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(_paymentIcon, size: 18, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Text(
                            _paymentLabel,
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_right, size: 24, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 20),

        // Price details
        const Text(
          'Price details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$_nights night${_nights > 1 ? 's' : ''} x \$${widget.listing.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            Text(
              '\$${_totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total USD',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
            ),
            Text(
              '\$${_totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showPriceDetails(),
          child: const Text(
            'Price breakdown',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
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
              onPressed: _currentStep == 2 ? _processPayment : () => setState(() => _currentStep++),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_currentStep == 2) ...[
                    Icon(
                      _selectedPaymentMethod == 'google_pay' ? Icons.g_mobiledata : Icons.payment,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    _currentStep == 2 
                        ? (_selectedPaymentMethod == 'google_pay' ? 'Pay' : 'Confirm & pay')
                        : 'Review reservation',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.2),
                  ),
                ],
              ),
            ),
          ),
          if (_currentStep == 2) ...[
            const SizedBox(height: 16),
            const Text(
              'Agreement to terms is required before booking.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w500),
            ),
          ],
        ],
      ),
    );
  }

  // ─── HELPER WIDGETS ────────────────────────────────────────

  Widget _buildInfoRow(String label, String value, {bool isRareFind = false, VoidCallback? onChangeTap}) {
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
              if (isRareFind) ...[
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Text('💎', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 4),
                    Text(
                      'Rare find',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFE31C5F)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (onChangeTap != null)
          TextButton(
            onPressed: onChangeTap,
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              backgroundColor: Colors.grey.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text(
              'Change',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required Widget leading,
    Widget? subtitle,
  }) {
    final isSelected = _selectedPaymentMethod == id;
    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    subtitle,
                  ],
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey.shade400,
                  width: isSelected ? 7 : 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBrand(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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

  // ─── DIALOGS / ACTIONS ─────────────────────────────────────

  void _showDatePicker() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _checkIn, end: _checkOut),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE31C5F),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _checkIn = picked.start;
        _checkOut = picked.end;
        _nights = picked.end.difference(picked.start).inDays;
        if (_nights < 1) _nights = 1;
      });
    }
  }

  void _showGuestPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        int tempGuests = _guests;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Guests', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: tempGuests > 1
                            ? () => setModalState(() => tempGuests--)
                            : null,
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: tempGuests > 1 ? Colors.black : Colors.grey.shade300),
                          ),
                          child: Icon(Icons.remove, color: tempGuests > 1 ? Colors.black : Colors.grey.shade300),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Text('$tempGuests', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 24),
                      IconButton(
                        onPressed: tempGuests < widget.listing.guests
                            ? () => setModalState(() => tempGuests++)
                            : null,
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: tempGuests < widget.listing.guests ? Colors.black : Colors.grey.shade300),
                          ),
                          child: Icon(Icons.add, color: tempGuests < widget.listing.guests ? Colors.black : Colors.grey.shade300),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Maximum ${widget.listing.guests} guests',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _guests = tempGuests);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPriceDetails() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Price breakdown', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$_nights night${_nights > 1 ? 's' : ''} x \$${widget.listing.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text('\$${_totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total (USD)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    '\$${_totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Future<void> _processPayment() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFFE31C5F)),
                SizedBox(height: 20),
                Text('Processing payment...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        );
      },
    );

    try {
      final intentData = await _paymentService.createPaymentIntent(
        amount: _totalPrice,
        propertyId: int.tryParse(widget.listing.id) ?? 0,
        checkIn: _checkIn.toIso8601String(),
        checkOut: _checkOut.toIso8601String(),
        guests: _guests,
      );

      if (intentData == null) {
        throw Exception('Failed to create payment intent');
      }

      final booking = await _paymentService.confirmBooking(
        paymentIntentId: intentData['paymentIntentId']!,
        propertyId: int.tryParse(widget.listing.id) ?? 0,
        checkIn: _checkIn.toIso8601String(),
        checkOut: _checkOut.toIso8601String(),
        guests: _guests,
        totalPrice: _totalPrice,
        serviceFee: _totalPrice * 0.1, // Example backend calculation
        cleaningFee: 0, // Example
        propertyPrice: _totalPrice * 0.9, // Example
        nights: _nights,
      );

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (booking != null) {
        _showSuccessDialog();
      } else {
        _showErrorSnackBar('Booking confirmation failed');
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
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
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Color(0xFF2E7D32), size: 48),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Booking confirmed!',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your stay at "${widget.listing.title}" is booked for $_dateRange.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close success dialog
                      Navigator.pop(context); // Close reservation screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE31C5F),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Done', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
